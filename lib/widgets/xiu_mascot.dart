// lib/widgets/xiu_mascot.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/game_state.dart';

class XiuMascot extends StatelessWidget {
  final XiuState state;
  final double size;

  const XiuMascot({super.key, required this.state, this.size = 180});

  String get _imagePath {
    switch (state) {
      case XiuState.success:
        return 'assets/images/xiu_success.png';
      case XiuState.fail:
        return 'assets/images/xiu_fail.png';
      case XiuState.normal:
        return 'assets/images/xiu_normal.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mascot = Image.asset(
      _imagePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      errorBuilder: (ctx, e, s) => _fallbackMascot(),
    );

    // Floating animation: ±10px vertical
    mascot = mascot
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -10, duration: 1500.ms, curve: Curves.easeInOut);

    // Additional shake on fail state
    if (state == XiuState.fail) {
      mascot = mascot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shake(duration: 300.ms, hz: 8, offset: const Offset(3, 0));
    }

    return mascot;
  }

  Widget _fallbackMascot() {
    final color = state == XiuState.success
        ? const Color(0xFF00ff41)
        : state == XiuState.fail
            ? const Color(0xFFff2222)
            : const Color(0xFF00b4d8);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          state == XiuState.success
              ? '😄'
              : state == XiuState.fail
                  ? '😨'
                  : '😎',
          style: TextStyle(fontSize: size * 0.45),
        ),
      ),
    );
  }
}
