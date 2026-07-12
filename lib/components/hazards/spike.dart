import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import 'hazard.dart';

class Spike extends PolygonComponent with Hazard {
  Spike({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          [
            Vector2(size.x / 2, 0),
            Vector2(0, size.y),
            Vector2(size.x, size.y),
          ],
          position: position,
          size: size,
          paint: Paint()..color = Colors.transparent,
        );

  @override
  Future<void> onLoad() async {
    add(PolygonHitbox([
      Vector2(size.x / 2, 0),
      Vector2(0, size.y),
      Vector2(size.x, size.y),
    ]));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(0, size.y)
      ..lineTo(size.x, size.y)
      ..close();

    // 1. Dark glass fill
    final fillPaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 2. Wide glow
    final glowPaint1 = Paint()
      ..color = const Color(0xFFF97316).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, glowPaint1);

    // 3. Bright core
    final glowPaint2 = Paint()
      ..color = const Color(0xFFFB923C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, glowPaint2);
  }
}
