// lib/screens/playing_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../utils/game_state.dart';
import '../widgets/xiu_mascot.dart';
import '../widgets/timer_display.dart';

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

  @override
  void initState() {
    super.initState();
    _startTimer();
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

  @override
  void dispose() {
    _gameTimer?.cancel();
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

    return Container(
      color: const Color(0xFF121212),
      child: SafeArea(
        child: Column(
          children: [
            // ── Top HUD ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF00ff41).withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Level badge
                  _hudBadge('LVL', '${level.id}/15',
                      const Color(0xFF00ff41)),
                  const SizedBox(width: 8),
                  _hudBadge('SCORE', '${game.totalScore + game.levelScore}',
                      const Color(0xFF00b4d8)),
                  const SizedBox(width: 8),
                  _hudBadge('ERR', '${game.wrongCount}',
                      isDanger ? const Color(0xFFFF4444) : const Color(0xFFff0066)),
                  const Spacer(),
                  // Timer
                  TimerDisplay(secondsRemaining: game.secondsRemaining),
                ],
              ),
            ),

            // ── Main area: Terminal + XIU ──
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Terminal area ──
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        // Terminal header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          color: const Color(0xFF1a1a1a),
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
                                  'root@xiucorp:~\$ — ${level.targetIP}',
                                  style: const TextStyle(
                                    fontFamily: 'Courier New',
                                    fontSize: 11,
                                    color: Color(0xFF888888),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Command progress
                              Text(
                                'CMD ${game.currentCommandIndex + 1}/${game.commandsInLevel}',
                                style: const TextStyle(
                                  fontFamily: 'Courier New',
                                  fontSize: 10,
                                  color: Color(0xFF00ff41),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Terminal output
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollCtrl,
                            padding: const EdgeInsets.all(10),
                            itemCount: game.terminalLines.length,
                            itemBuilder: (ctx, i) {
                              final line = game.terminalLines[i];
                              return _TerminalLineWidget(line: line);
                            },
                          ),
                        ),

                        // Input field
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: isDanger
                                    ? const Color(0xFFFF4444).withValues(alpha: 0.5)
                                    : const Color(0xFF00ff41).withValues(alpha: 0.2),
                              ),
                            ),
                            color: const Color(0xFF0d0d0d),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'root@xiucorp:\$ ',
                                style: TextStyle(
                                  fontFamily: 'Courier New',
                                  fontSize: 14,
                                  color: isDanger
                                      ? const Color(0xFFFF4444)
                                      : const Color(0xFF00ff41),
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
                                    hintText: 'ketik command...',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 13,
                                      color: Color(0xFF444444),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: isDanger
                                        ? const Color(0xFFFF4444)
                                            .withValues(alpha: 0.2)
                                        : const Color(0xFF00ff41)
                                            .withValues(alpha: 0.15),
                                    border: Border.all(
                                      color: isDanger
                                          ? const Color(0xFFFF4444)
                                          : const Color(0xFF00ff41),
                                    ),
                                  ),
                                  child: Text(
                                    'ENTER',
                                    style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 12,
                                      color: isDanger
                                          ? const Color(0xFFFF4444)
                                          : const Color(0xFF00ff41),
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

                  // ── XIU Sidebar ──
                  Container(
                    width: 110,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: const Color(0xFF00ff41).withValues(alpha: 0.15),
                        ),
                      ),
                      color: const Color(0xFF0d1a0d),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        XiuMascot(state: game.xiuState, size: 90),
                        const SizedBox(height: 8),
                        // Status label
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: _xiuStatusColor(game.xiuState)
                                .withValues(alpha: 0.15),
                            border: Border.all(
                              color: _xiuStatusColor(game.xiuState),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            _xiuStatusLabel(game.xiuState),
                            style: TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 9,
                              color: _xiuStatusColor(game.xiuState),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Hint button
                        GestureDetector(
                          onTap: () {
                            _showHint(context, game);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFFFFAA00).withValues(alpha: 0.6),
                              ),
                              color:
                                  const Color(0xFFFFAA00).withValues(alpha: 0.07),
                            ),
                            child: const Center(
                              child: Text(
                                '💡 HINT',
                                style: TextStyle(
                                  fontFamily: 'Courier New',
                                  fontSize: 10,
                                  color: Color(0xFFFFAA00),
                                ),
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
          '💡 ${game.currentCommand.hint}',
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

  Widget _hudBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        color: color.withValues(alpha: 0.06),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 9,
                  color: color.withValues(alpha: 0.6),
                  letterSpacing: 1)),
          Text(value,
              style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  Color _xiuStatusColor(XiuState s) => switch (s) {
        XiuState.success => const Color(0xFF00ff41),
        XiuState.fail => const Color(0xFFFF4444),
        _ => const Color(0xFF00b4d8),
      };

  String _xiuStatusLabel(XiuState s) => switch (s) {
        XiuState.success => 'SUCCESS',
        XiuState.fail => 'ALERT!',
        _ => 'STANDBY',
      };
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
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
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
    );
  }
}
