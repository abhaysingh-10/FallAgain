import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import '../players/player.dart';
import '../../game/fall_again_game.dart';

class FinishFlag extends RectangleComponent with CollisionCallbacks, HasGameRef<FallAgainGame> {
  FinishFlag({
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
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));

    // 1. Dark portal background
    final bgPaint = Paint()
      ..color = const Color(0xFF0F172A).withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bgPaint);

    // 2. Holographic lines
    final linePaint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(0.2)
      ..strokeWidth = 2.0;
    for (double i = 0; i < size.x; i += 10) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.y), linePaint);
    }
    for (double j = 0; j < size.y; j += 10) {
      canvas.drawLine(Offset(0, j), Offset(size.x, j), linePaint);
    }

    // 3. Faint portal glow
    final glowPaint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawRRect(rrect, glowPaint);

    // 4. Bright cyan border core
    final borderPaint = Paint()
      ..color = const Color(0xFF00F5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      game.completeLevel();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
