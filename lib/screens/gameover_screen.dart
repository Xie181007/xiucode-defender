// lib/screens/gameover_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../utils/game_state.dart';
import '../widgets/cyber_background.dart';
import '../widgets/xiu_mascot.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final level = game.currentLevel;

    return Stack(
      fit: StackFit.expand,
      children: [
        const CyberBackground(),
        Container(color: const Color(0xFF1a0000).withValues(alpha: 0.65)),

        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // GAME OVER banner
              Column(
                children: [
                  Text(
                    'OPERASI GAGAL',
                    style: const TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF2222),
                      letterSpacing: 4,
                      shadows: [
                        Shadow(color: Color(0xFFFF2222), blurRadius: 30),
                      ],
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shimmer(
                          duration: 800.ms,
                          color: const Color(0xFFFF6666)),

                  const SizedBox(height: 6),

                  Text(
                    game.secondsRemaining <= 0
                        ? 'WAKTU HABIS — SISTEM DIKUNCI'
                        : 'TERLALU BANYAK KESALAHAN',
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 13,
                      color: const Color(0xFFFF4444).withValues(alpha: 0.7),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // XIU Fail mascot
              const XiuMascot(state: XiuState.fail, size: 190)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms),

              const SizedBox(height: 20),

              // Level info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color(0xFFFF4444).withValues(alpha: 0.4)),
                  color: const Color(0xFFFF4444).withValues(alpha: 0.05),
                ),
                child: Column(
                  children: [
                    Text(
                      'LEVEL ${level.id}: ${level.name.toUpperCase()}',
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 13,
                        color: Color(0xFFFF4444),
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statBox('ERRORS', '${game.wrongCount}',
                            const Color(0xFFFF4444)),
                        _statBox('SCORE', '${game.totalScore}',
                            const Color(0xFF00b4d8)),
                        _statBox('TIME LEFT', '${game.secondsRemaining}s',
                            const Color(0xFFFF4444)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"${_failQuote()}"',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.4),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

              const SizedBox(height: 28),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _actionButton(
                    Icons.refresh,
                    'COBA LAGI',
                    const Color(0xFFFF4444),
                    () => game.retryLevel(),
                  ),
                  const SizedBox(width: 14),
                  _actionButton(
                    Icons.home,
                    'MENU',
                    const Color(0xFF00b4d8),
                    () => game.goToMenu(),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ],
    );
  }

  String _failQuote() {
    final quotes = [
      'Intrusi gagal. Jejak ditemukan. Mundur!',
      'Firewall lebih kuat dari perkiraanmu.',
      'Terlalu lambat. Server sudah dikunci.',
      'Syntax error membunuh operasimu.',
      'XIU: Kamu harus lebih cepat dariku!',
    ];
    return quotes[DateTime.now().millisecond % quotes.length];
  }

  Widget _statBox(String label, String value, Color color) {
    return Column(
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color)),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color, width: 2),
          color: color.withValues(alpha: 0.1),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 16)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
