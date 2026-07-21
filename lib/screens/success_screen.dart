// lib/screens/success_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../utils/game_state.dart';
import '../widgets/cyber_background.dart';
import '../widgets/xiu_mascot.dart';
import '../data/levels_data.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final level = game.currentLevel;
    final isLastLevel = game.currentLevelIndex >= gameLevels.length - 1;
    final timeBonus = game.secondsRemaining * 10;
    final levelScore = level.baseScore + timeBonus;

    return Stack(
      fit: StackFit.expand,
      children: [
        const CyberBackground(),
        Container(color: const Color(0xFF000d00).withValues(alpha: 0.65)),

        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SUCCESS banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00ff41), width: 2),
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xFF00ff41).withValues(alpha: 0.1),
                  boxShadow: const [
                    BoxShadow(color: Color(0xFF00ff41), blurRadius: 30),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline, color: Color(0xFF00ff41), size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'BREACH SUCCESSFUL',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00ff41),
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8)),

              const SizedBox(height: 24),

              // XIU Success mascot
              const XiuMascot(state: XiuState.success, size: 180)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms),

              const SizedBox(height: 20),

              // Score breakdown card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color(0xFF00ff41).withValues(alpha: 0.3)),
                  color: const Color(0xFF00ff41).withValues(alpha: 0.04),
                ),
                child: Column(
                  children: [
                    Text(
                      'LEVEL ${level.id}: ${level.name.toUpperCase()}',
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 14,
                        color: Color(0xFF00b4d8),
                        letterSpacing: 2,
                      ),
                    ),
                    const Divider(color: Color(0xFF333333), height: 20),
                    _scoreLine('BASE SCORE', '+${level.baseScore}',
                        const Color(0xFF00ff41)),
                    _scoreLine('TIME BONUS (${game.secondsRemaining}s × 10)',
                        '+$timeBonus', const Color(0xFFFFAA00)),
                    _scoreLine('ERRORS PENALTY (${game.wrongCount} × 100)',
                        '-${game.wrongCount * 100}',
                        const Color(0xFFFF4444)),
                    const Divider(color: Color(0xFF333333), height: 20),
                    _scoreLine('LEVEL SCORE', '${levelScore - game.wrongCount * 100}',
                        const Color(0xFF00ff41),
                        large: true),
                    const SizedBox(height: 8),
                    _scoreLine('TOTAL SCORE', '${game.totalScore}',
                        const Color(0xFF00b4d8),
                        large: true),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

              const SizedBox(height: 28),

              // Action button
              GestureDetector(
                onTap: () {
                  if (isLastLevel) {
                    _showNameDialog(context, game);
                  } else {
                    game.nextLevel();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: const Color(0xFF00ff41), width: 2),
                    color: const Color(0xFF00ff41).withValues(alpha: 0.1),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xFF00ff41), blurRadius: 20),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLastLevel ? Icons.emoji_events_outlined : Icons.play_arrow,
                        color: Color(0xFF00ff41),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isLastLevel ? 'SELESAI - LIHAT SKOR' : 'LEVEL BERIKUTNYA',
                        style: const TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00ff41),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scoreLine(String label, String value, Color color,
      {bool large = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: large ? 13 : 11,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: large ? 16 : 12,
              fontWeight: large ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showNameDialog(BuildContext context, GameState game) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        title: const Text(
          'MASUKKAN NAMA OPERATOR',
          style: TextStyle(
            fontFamily: 'Courier New',
            color: Color(0xFF00ff41),
            fontSize: 15,
          ),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(
              fontFamily: 'Courier New', color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'nama kamu...',
            hintStyle: TextStyle(color: Color(0xFF444444)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00ff41)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Color(0xFF00ff41), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = ctrl.text.trim().isEmpty
                  ? 'Anonymous'
                  : ctrl.text.trim();
              await game.saveScore(name);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                game.goToMenu();
              }
            },
            child: const Text(
              'SIMPAN SKOR',
              style: TextStyle(
                  fontFamily: 'Courier New',
                  color: Color(0xFF00ff41)),
            ),
          ),
        ],
      ),
    );
  }
}
