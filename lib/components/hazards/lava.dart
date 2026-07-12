import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import 'hazard.dart';

class Lava extends RectangleComponent with Hazard {
  double time = 0.0;

  Lava({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          paint: Paint()..color = Colors.transparent,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final path = Path();
    path.moveTo(0, size.y);
    path.lineTo(0, 0); // start of wave
    
    // Draw wave path using sine function
    for (double x = 0; x <= size.x; x += 8) {
      final y = sin(time * 4 + x * 0.04) * 4;
      path.lineTo(x, y);
    }
    path.lineTo(size.x, size.y);
    path.close();

    // 1. Draw glowing lava gradient
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFF97316), Color(0xFFF59E0B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawPath(path, fillPaint);

    // Create wave path for lines
    final waveLinePath = Path();
    waveLinePath.moveTo(0, sin(time * 4) * 4);
    for (double x = 0; x <= size.x; x += 8) {
      final y = sin(time * 4 + x * 0.04) * 4;
      waveLinePath.lineTo(x, y);
    }

    // 2. Faint wide glow on the surface line
    final glowPaint = Paint()
      ..color = const Color(0xFFF97316).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawPath(waveLinePath, glowPaint);

    // 3. Bright neon top surface line
    final linePaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(waveLinePath, linePaint);
  }
}
