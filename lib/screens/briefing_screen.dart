// lib/screens/briefing_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../utils/game_state.dart';
import '../widgets/cyber_background.dart';
import '../widgets/xiu_mascot.dart';

class BriefingScreen extends StatefulWidget {
  const BriefingScreen({super.key});

  @override
  State<BriefingScreen> createState() => _BriefingScreenState();
}

class _BriefingScreenState extends State<BriefingScreen> {
  int _countdown = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        if (mounted) {
          context.read<GameState>().startExploitation();
        }
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final level = game.currentLevel;
    final categoryColor = _categoryColor(level.category);

    return Stack(
      fit: StackFit.expand,
      children: [
        const CyberBackground(),
        Container(color: const Color(0xFF121212).withValues(alpha: 0.82)),
        SafeArea(
          child: Column(
            children: [
              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: categoryColor, width: 1.5),
                        borderRadius: BorderRadius.circular(4),
                        color: categoryColor.withValues(alpha: 0.1),
                      ),
                      child: Text(
                        level.category,
                        style: TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 11,
                          color: categoryColor,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'LEVEL ${level.id} / 15',
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 13,
                        color: Color(0xFF00ff41),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Briefing card ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // XIU Mascot
                      const XiuMascot(state: XiuState.normal, size: 160)
                          .animate()
                          .fadeIn(duration: 500.ms),

                      const SizedBox(height: 20),

                      // Level title
                      Text(
                        level.name.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00ff41),
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                                color: Color(0xFF00ff41), blurRadius: 12),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2),

                      const SizedBox(height: 16),

                      // Briefing text bubble
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFF00ff41).withValues(alpha: 0.4),
                              width: 1),
                          color: const Color(0xFF00ff41).withValues(alpha: 0.05),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '[ XIU ] ${level.briefingText}',
                              style: const TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 13,
                                color: Color(0xFF00ff41),
                                height: 1.5,
                              ),
                            ).animate().fadeIn(delay: 400.ms),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color(0xFF00b4d8), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'TARGET IP: ${level.targetIP}',
                                  style: const TextStyle(
                                    fontFamily: 'Courier New',
                                    fontSize: 12,
                                    color: Color(0xFF00b4d8),
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 24),

                      // Objective box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: const Color(0xFFff0066).withValues(alpha: 0.5)),
                          color: const Color(0xFFff0066).withValues(alpha: 0.05),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('⚡ ',
                                style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Text(
                                level.objective,
                                style: const TextStyle(
                                  fontFamily: 'Courier New',
                                  fontSize: 12,
                                  color: Color(0xFFff9999),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 500.ms),
                    ],
                  ),
                ),
              ),

              // ── Auto-start countdown ──
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'OPERASI DIMULAI DALAM',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.4),
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        '$_countdown',
                        key: ValueKey(_countdown),
                        style: const TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFff0066),
                          shadows: [
                            Shadow(
                                color: Color(0xFFff0066), blurRadius: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        _timer?.cancel();
                        context.read<GameState>().startExploitation();
                      },
                      child: const Text(
                        '[ TAP TO START NOW ]',
                        style: TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 12,
                          color: Color(0xFF00b4d8),
                          letterSpacing: 2,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF00b4d8),
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
    );
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'INTERMEDIATE':
        return const Color(0xFFFFAA00);
      case 'ADVANCED':
        return const Color(0xFFff0066);
      default:
        return const Color(0xFF00ff41);
    }
  }
}
