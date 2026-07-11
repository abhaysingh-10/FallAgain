import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';

class Platform extends RectangleComponent {
  Platform({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          paint: Paint()..color = Colors.transparent,
        );

  //physical bumper
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));

    // 1. Draw dark glassmorphic background
    final bgPaint = Paint()
      ..color = const Color(0xFF0F172A).withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bgPaint);

    // 2. Draw outer neon glow (wide, faint)
    final glowPaint1 = Paint()
      ..color = const Color(0xFF10B981).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawRRect(rrect, glowPaint1);

    // 3. Draw outer neon glow (sharp, bright core)
    final glowPaint2 = Paint()
      ..color = const Color(0xFF34D399)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rrect, glowPaint2);
  }
}

