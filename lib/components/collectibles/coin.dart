import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import '../players/player.dart';
import '../../game/fall_again_game.dart';
import '../../managers/audio_manager.dart';

class Coin extends CircleComponent with CollisionCallbacks, HasGameRef<FallAgainGame> {
  Coin({
    required Vector2 position,
  }) : super(
          radius: 15,
          position: position,
          paint: Paint()..color = Colors.transparent,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(radius, radius);

    // 1. Draw gold core gradient
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFDE047), const Color(0xFFEAB308), const Color(0xFFCA8A04)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, fillPaint);

    // 2. Draw gold neon glowing ring
    final glowPaint = Paint()
      ..color = const Color(0xFFFDE047).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, radius, glowPaint);

    // 3. Draw inner ring details
    final detailPaint = Paint()
      ..color = const Color(0xFFFEF08A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius / 2, detailPaint);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      game.incrementCoins();
      AudioManager.playCoin();
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
