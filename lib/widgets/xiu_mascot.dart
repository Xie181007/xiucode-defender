// lib/widgets/xiu_mascot.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/game_state.dart';

class XiuMascot extends StatelessWidget {
  final XiuState state;
  final double size;

  const XiuMascot({super.key, required this.state, this.size = 180});

  @override
  Widget build(BuildContext context) {
    Widget mascot = CustomPaint(
      size: Size(size, size),
      painter: _PixelXiuPainter(state: state),
    );

    mascot = mascot
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -10, duration: 1500.ms, curve: Curves.easeInOut);

    if (state == XiuState.fail) {
      mascot = mascot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shake(duration: 300.ms, hz: 8, offset: const Offset(3, 0));
    }

    return mascot;
  }
}

class _PixelXiuPainter extends CustomPainter {
  final XiuState state;
  _PixelXiuPainter({required this.state});

  // Grid: 12 columns x 14 rows
  // . = transparent
  // 1 = primary (body/outline)
  // 2 = secondary (fill)
  // 3 = eye/bright
  // 4 = dark accent
  // 5 = glow highlight

  static const _normalGrid = [
    '....11....',
    '...1551...',
    '...1551...',
    '..155551..',
    '.15222251.',
    '1522322251',
    '1522332251',
    '1522222251',
    '1524444251',
    '.15222251.',
    '..152251..',
    '..152251..',
    '...1551...',
    '....11....',
  ];

  static const _successGrid = [
    '....11....',
    '...1551...',
    '...1551...',
    '..155551..',
    '.15222251.',
    '1522332251',
    '1522332251',
    '1522222251',
    '1522222251',
    '.15244251.',
    '..155551..',
    '..152251..',
    '...1551...',
    '....11....',
  ];

  static const _failGrid = [
    '....11....',
    '...1441...',
    '...1441...',
    '..144441..',
    '.14222241.',
    '1423223241',
    '1422332241',
    '1422222241',
    '1422222241',
    '.14244241.',
    '..145541..',
    '..142241..',
    '...1441...',
    '....11....',
  ];

  List<String> get _grid => switch (state) {
        XiuState.success => _successGrid,
        XiuState.fail => _failGrid,
        _ => _normalGrid,
      };

  Color _colorForChar(String c) {
    final baseColor = switch (state) {
      XiuState.success => const Color(0xFF00ff41),
      XiuState.fail => const Color(0xFFFF4444),
      _ => const Color(0xFF00b4d8),
    };

    return switch (c) {
      '1' => const Color(0xFF1a1a2e),
      '2' => baseColor.withValues(alpha: 0.15),
      '3' => baseColor,
      '4' => const Color(0xFF222233),
      '5' => baseColor.withValues(alpha: 0.5),
      _ => Colors.transparent,
    };
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rows = _grid.length;
    final cols = _grid[0].length;
    final pixelW = size.width / cols;
    final pixelH = size.height / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final ch = _grid[r][c];
        if (ch == '.') continue;
        final color = _colorForChar(ch);
        final paint = Paint()..color = color;
        canvas.drawRect(
          Rect.fromLTWH(c * pixelW, r * pixelH, pixelW, pixelH),
          paint,
        );
      }
    }

    // Glow effect behind the character
    final glowColor = switch (state) {
      XiuState.success => const Color(0xFF00ff41),
      XiuState.fail => const Color(0xFFFF4444),
      _ => const Color(0xFF00b4d8),
    };
    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.15,
        size.width * 0.8,
        size.height * 0.7,
      ),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PixelXiuPainter oldDelegate) =>
      oldDelegate.state != state;
}
