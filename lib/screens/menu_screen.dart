// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../utils/game_state.dart';
import '../widgets/cyber_background.dart';
import '../widgets/xiu_mascot.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    final game = context.read<GameState>();
    _nameCtrl = TextEditingController(text: game.username);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();

    return Stack(
      fit: StackFit.expand,
      children: [
        // Matrix rain background
        const CyberBackground(),
        // Dark overlay
        Container(color: const Color(0xFF121212).withValues(alpha: 0.55)),

        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // ── Title ──
              Column(
                children: [
                  Text(
                    'XIU CODE',
                    style: const TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00ff41),
                      letterSpacing: 8,
                      shadows: [
                        Shadow(
                            color: Color(0xFF00ff41),
                            blurRadius: 20),
                      ],
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shimmer(duration: 2000.ms, color: const Color(0xFF00b4d8)),
                  const Text(
                    'DEFENDER',
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 18,
                      color: Color(0xFF00b4d8),
                      letterSpacing: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFFff0066), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'v0.1  •  TIME ATTACK EDITION',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 11,
                        color: Color(0xFFff0066),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),

              const Spacer(),

              // ── XIU Mascot ──
              const XiuMascot(state: XiuState.normal, size: 180)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms),

              const SizedBox(height: 8),
              Text(
                '"Ready to breach the system, operator?"',
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 13,
                  color: const Color(0xFF00ff41).withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 800.ms),

              // ── Username Input ──
              Container(
                width: 240,
                margin: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚡ CODENAME OPERATOR',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 9,
                        color: const Color(0xFF00b4d8),
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameCtrl,
                      onChanged: (val) => game.setUsername(val),
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color(0xFF00ff41).withValues(alpha: 0.4), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color(0xFF00ff41), width: 2),
                        ),
                        fillColor: Colors.black.withValues(alpha: 0.6),
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 900.ms),

              const Spacer(),

              // ── Buttons ──
              Column(
                children: [
                  _CyberButton(
                    label: '▶  MULAI OPERASI',
                    color: const Color(0xFF00ff41),
                    onTap: () => game.startGame(),
                  ),
                  const SizedBox(height: 14),
                  _CyberButton(
                    label: '🏆  LEADERBOARD',
                    color: const Color(0xFF00b4d8),
                    onTap: () => context.read<GameState>().goToLeaderboard(),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),

              const SizedBox(height: 12),

              // ── Level info ──
              Text(
                '15 LEVELS  •  5 MIN / LEVEL  •  -10s PENALTY',
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.3),
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn(delay: 1000.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

class _CyberButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CyberButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CyberButton> createState() => _CyberButtonState();
}

class _CyberButtonState extends State<_CyberButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 240,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: widget.color, width: 2),
          color: _pressed
              ? widget.color.withValues(alpha: 0.2)
              : widget.color.withValues(alpha: 0.07),
          boxShadow: _pressed
              ? []
              : [BoxShadow(color: widget.color.withValues(alpha: 0.3), blurRadius: 16)],
        ),
        child: Text(
          widget.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Courier New',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: widget.color,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
