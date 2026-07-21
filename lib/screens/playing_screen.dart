// lib/screens/playing_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../utils/game_state.dart';
import '../widgets/xiu_mascot.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();
  Timer? _gameTimer;
  Timer? _inboxTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startInboxTimer();
    // Auto-focus input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        context.read<GameState>().tickTimer();
      }
    });
  }

  void _startInboxTimer() {
    _inboxTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<GameState>().injectInboxMessage();
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _inboxTimer?.cancel();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _inputCtrl.text;
    if (text.trim().isEmpty) return;
    _inputCtrl.clear();

    final game = context.read<GameState>();
    game.submitCommand(text);

    // Scroll to bottom after command
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });

    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();

    // If screen changed (success/gameover), cancel timer
    if (game.screen != GameScreen.playing) {
      _gameTimer?.cancel();
    }

    Widget content = _buildContent(context, game);

    // Screen shake effect
    if (game.screenShake) {
      content = content
          .animate()
          .shake(duration: 500.ms, hz: 10, offset: const Offset(8, 4));
    }

    // Red flash overlay
    return Stack(
      children: [
        content,
        if (game.redFlash)
          IgnorePointer(
            child: Container(
              color: const Color(0xFFFF0000).withValues(alpha: 0.25),
            )
                .animate()
                .fadeIn(duration: 100.ms)
                .then()
                .fadeOut(duration: 300.ms),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, GameState game) {
    final level = game.currentLevel;
    final isDanger = game.isTimeDanger;

    final String timeFormatted =
        '${(game.secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(game.secondsRemaining % 60).toString().padLeft(2, '0')}';

    return Container(
      color: const Color(0xFF121212),
      child: SafeArea(
        child: Column(
          children: [
            // ── Top HUD (2 rows × 3 columns) ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF00ff41).withValues(alpha: 0.15),
                  ),
                ),
                color: const Color(0xFF161616),
              ),
              child: Column(
                children: [
                  // Row 1: OPERATOR | LEVEL | SCORE
                  Row(
                    children: [
                      Expanded(
                        child: _HudBox(
                          label: 'OPERATOR',
                          value: game.username.toUpperCase(),
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _HudBox(
                          label: 'LEVEL',
                          value: '${level.id}/15',
                          color: const Color(0xFF00ff41),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _HudBox(
                          label: 'SCORE',
                          value: '${game.totalScore + game.levelScore}',
                          color: const Color(0xFF00b4d8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Row 2: TIME REMAINING | ERRORS 1 | ERRORS 2
                  Row(
                    children: [
                      Expanded(
                        child: _HudBox(
                          label: 'TIME REMAINING',
                          value: timeFormatted,
                          color: isDanger ? const Color(0xFFFF4444) : const Color(0xFF00ff41),
                          valueFontSize: 22,
                          showClockIcon: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _HudBox(
                          label: 'ERRORS',
                          value: '${game.wrongCount}',
                          color: isDanger ? const Color(0xFFFF4444) : const Color(0xFFff0066),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _HudBox(
                          label: 'ERRORS',
                          value: '${game.wrongCount}',
                          color: isDanger ? const Color(0xFFFF4444) : const Color(0xFFff0066),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Main area: Terminal Viewport with Overlapping Character Circle ──
            Expanded(
              child: Stack(
                children: [
                  // The Terminal Container
                  Column(
                    children: [
                      // Terminal header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        color: const Color(0xFF2d2d2d),
                        child: Row(
                          children: [
                            _dot(const Color(0xFFFF5F57)),
                            const SizedBox(width: 6),
                            _dot(const Color(0xFFFFBD2E)),
                            const SizedBox(width: 6),
                            _dot(const Color(0xFF28CA41)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'root@xiu-defender: ${level.targetIP}',
                                style: const TextStyle(
                                  fontFamily: 'Courier New',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00ff41),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'CMD ${game.currentCommandIndex + 1}/${game.commandsInLevel}',
                              style: const TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 10,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Terminal output log
                      Expanded(
                        child: Container(
                          color: const Color(0xFF0a0a0a),
                          width: double.infinity,
                          child: ListView.builder(
                            controller: _scrollCtrl,
                            padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 120), // Bottom padding for mascot overlap
                            itemCount: game.terminalLines.length,
                            itemBuilder: (ctx, i) {
                              final line = game.terminalLines[i];
                              return _TerminalLineWidget(line: line);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Overlapping Character Circle (mockup bottom right)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => _showHint(context, game),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.85),
                          border: Border.all(
                            color: isDanger ? const Color(0xFFFF4444) : const Color(0xFF00ff41),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isDanger ? const Color(0xFFFF4444) : const Color(0xFF00ff41)).withValues(alpha: 0.5),
                              blurRadius: 16,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Stack(
                            children: [
                              Center(
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: XiuMascot(state: game.xiuState, size: 85),
                                ),
                              ),
                              // Floating text badge for status hint trigger
                              Positioned(
                                bottom: 4,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  color: Colors.black.withValues(alpha: 0.6),
                                  child: const Text(
                                    'TAP FOR HINT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFAA00),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom Area: Input Syntax bar ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDanger
                        ? const Color(0xFFFF4444).withValues(alpha: 0.4)
                        : const Color(0xFF00ff41).withValues(alpha: 0.15),
                  ),
                ),
                color: const Color(0xFF080808),
              ),
              child: Row(
                children: [
                  Text(
                    '${game.username}@xiucode:\$ ',
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 14,
                      color: isDanger ? const Color(0xFFFF4444) : const Color(0xFF00ff41),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _inputCtrl,
                      focusNode: _focusNode,
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'ketikan syntax terminal...',
                        hintStyle: TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                      ),
                      cursorColor: const Color(0xFF00ff41),
                      onSubmitted: (_) => _submit(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  GestureDetector(
                    onTap: _submit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: isDanger
                            ? const Color(0xFFFF4444).withValues(alpha: 0.2)
                            : const Color(0xFF00ff41).withValues(alpha: 0.15),
                        border: Border.all(
                          color: isDanger ? const Color(0xFFFF4444) : const Color(0xFF00ff41),
                        ),
                      ),
                      child: Text(
                        'RUN',
                        style: TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 12,
                          color: isDanger ? const Color(0xFFFF4444) : const Color(0xFF00ff41),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHint(BuildContext context, GameState game) {
    if (game.screen != GameScreen.playing) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1a1a00),
        content: Text(
          game.currentCommand.hint,
          style: const TextStyle(
            fontFamily: 'Courier New',
            color: Color(0xFFFFAA00),
          ),
        ),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

}

class _HudBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double valueFontSize;
  final bool showClockIcon;

  const _HudBox({
    required this.label,
    required this.value,
    required this.color,
    this.valueFontSize = 16,
    this.showClockIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
        color: color.withValues(alpha: 0.06),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 9,
              color: color.withValues(alpha: 0.6),
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showClockIcon) ...[
                Icon(Icons.access_time, size: 14, color: color),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TerminalLineWidget extends StatelessWidget {
  final TerminalLine line;
  const _TerminalLineWidget({required this.line});

  @override
  Widget build(BuildContext context) {
    Color color;
    FontWeight weight = FontWeight.normal;

    switch (line.type) {
      case LineType.input:
        color = Colors.white;
        weight = FontWeight.bold;
        break;
      case LineType.success:
        color = const Color(0xFF00ff41);
        break;
      case LineType.error:
        color = const Color(0xFFFF4444);
        break;
      case LineType.hint:
        color = const Color(0xFFFFAA00);
        break;
      case LineType.system:
        color = const Color(0xFF888888);
        break;
      case LineType.inbox:
        color = const Color(0xFF00b4d8);
        weight = FontWeight.bold;
        break;
    }

    final bool isInboxBody = line.type == LineType.inbox;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Container(
        decoration: isInboxBody
            ? BoxDecoration(
                color: const Color(0xFF00b4d8).withValues(alpha: 0.04),
                border: Border(
                  left: BorderSide(
                    color: const Color(0xFF00b4d8).withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              )
            : null,
        padding: isInboxBody ? const EdgeInsets.only(left: 6) : null,
        child: Text(
          line.text,
          style: TextStyle(
            fontFamily: 'Courier New',
            fontSize: 12,
            color: color,
            fontWeight: weight,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
