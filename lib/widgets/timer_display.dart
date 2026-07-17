// lib/widgets/timer_display.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TimerDisplay extends StatelessWidget {
  final int secondsRemaining;

  const TimerDisplay({super.key, required this.secondsRemaining});

  String get _formatted {
    final m = secondsRemaining ~/ 60;
    final s = secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _isDanger => secondsRemaining <= 60;
  bool get _isCritical => secondsRemaining <= 30;

  @override
  Widget build(BuildContext context) {
    final color = _isDanger
        ? (_isCritical ? const Color(0xFFFF0000) : const Color(0xFFFF4444))
        : const Color(0xFF00ff41);

    Widget timerText = Text(
      _formatted,
      style: TextStyle(
        fontFamily: 'Courier New',
        fontSize: 38,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 4,
        shadows: [
          Shadow(color: color.withValues(alpha: 0.8), blurRadius: 12),
          Shadow(color: color.withValues(alpha: 0.4), blurRadius: 24),
        ],
      ),
    );

    if (_isDanger) {
      timerText = timerText
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .fadeIn(duration: 400.ms)
          .then()
          .fadeOut(duration: 400.ms);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        color: color.withValues(alpha: 0.07),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 16),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '⏱ TIME REMAINING',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 10,
              color: color.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          timerText,
        ],
      ),
    );
  }
}
