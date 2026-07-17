// lib/widgets/cyber_background.dart
import 'dart:math';
import 'package:flutter/material.dart';

/// Animating matrix rain / binary particle background
class CyberBackground extends StatefulWidget {
  const CyberBackground({super.key});

  @override
  State<CyberBackground> createState() => _CyberBackgroundState();
}

class _CyberBackgroundState extends State<CyberBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_MatrixColumn> _columns = [];
  final Random _rnd = Random();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
        _update();
      })
      ..repeat();
  }

  void _initColumns(Size size) {
    if (_initialized) return;
    _initialized = true;
    const colWidth = 18.0;
    final numCols = (size.width / colWidth).ceil();
    for (int i = 0; i < numCols; i++) {
      _columns.add(_MatrixColumn(
        x: i * colWidth,
        y: _rnd.nextDouble() * -size.height,
        speed: 1.5 + _rnd.nextDouble() * 2.5,
        length: 6 + _rnd.nextInt(12),
        maxHeight: size.height,
        rnd: _rnd,
      ));
    }
  }

  void _update() {
    for (final col in _columns) {
      col.update();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _initColumns(Size(constraints.maxWidth, constraints.maxHeight));
      return CustomPaint(
        painter: _MatrixPainter(_columns),
        size: Size(constraints.maxWidth, constraints.maxHeight),
      );
    });
  }
}

class _MatrixColumn {
  double x;
  double y;
  double speed;
  int length;
  double maxHeight;
  Random rnd;
  List<String> chars = [];

  _MatrixColumn({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
    required this.maxHeight,
    required this.rnd,
  }) {
    _randomizeChars();
  }

  void _randomizeChars() {
    const charSet = '01アイウエオカキクケコ01ABCDEFabcdef';
    chars = List.generate(
      length,
      (_) => charSet[rnd.nextInt(charSet.length)],
    );
  }

  void update() {
    y += speed;
    if (y > maxHeight + length * 16) {
      y = -length * 16.0;
      _randomizeChars();
    }
    // Randomly change a char
    if (rnd.nextInt(6) == 0) {
      const charSet = '01アイウエオカキクケコ01ABCDEFabcdef';
      final idx = rnd.nextInt(chars.length);
      chars[idx] = charSet[rnd.nextInt(charSet.length)];
    }
  }
}

class _MatrixPainter extends CustomPainter {
  final List<_MatrixColumn> columns;

  _MatrixPainter(this.columns);

  @override
  void paint(Canvas canvas, Size size) {
    const fontSize = 13.0;
    const charHeight = 16.0;

    for (final col in columns) {
      for (int i = 0; i < col.chars.length; i++) {
        final charY = col.y + i * charHeight;
        if (charY < -charHeight || charY > size.height) continue;

        final opacity = i == col.chars.length - 1
            ? 1.0
            : (i / col.chars.length) * 0.4;

        final color = i == col.chars.length - 1
            ? const Color(0xFFFFFFFF).withValues(alpha: 0.9)
            : const Color(0xFF00ff41).withValues(alpha: opacity.clamp(0.05, 0.6));

        final textPainter = TextPainter(
          text: TextSpan(
            text: col.chars[i],
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: fontSize,
              color: color,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(canvas, Offset(col.x, charY));
      }
    }
  }

  @override
  bool shouldRepaint(_MatrixPainter old) => true;
}
