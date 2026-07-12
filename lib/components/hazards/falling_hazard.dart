import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import 'hazard.dart';
import '../../game/fall_again_game.dart';

class FallingHazard extends RectangleComponent with Hazard, CollisionCallbacks, HasGameRef<FallAgainGame> {
  final double triggerDistance = 150.0;
  final double fallSpeed = 600.0;
  bool isFalling = false;
  Vector2 startPos;

  FallingHazard({
    required Vector2 position,
    required Vector2 size,
  }) : startPos = position.clone(),
       super(
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
    if (!isFalling) {
      final player = game.player;
      // Trigger when player is close horizontally and below the trap
      if (player.position.x >= position.x - triggerDistance &&
          player.position.x <= position.x + size.x &&
          player.position.y > position.y) {
        isFalling = true;
      }
    } else {
      position.y += fallSpeed * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));

    // 1. Dark metallic body
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF334155), Color(0xFF1E293B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRRect(rrect, fillPaint);

    // 2. Heavy steel border
    final borderPaint = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(rrect, borderPaint);

    // 3. Glowing neon red core warning indicator
    final Color warningColor = isFalling ? const Color(0xFFEF4444) : const Color(0xFFEF4444).withOpacity(0.4);
    final warningPaint = Paint()
      ..color = warningColor
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.x / 2, size.y / 2);
    
    // Draw glowing center core
    canvas.drawCircle(center, 8, warningPaint);
    
    // Core glow
    final coreGlow = Paint()
      ..color = warningColor.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawCircle(center, 8, coreGlow);
  }

  void reset() {
    position = startPos.clone();
    isFalling = false;
  }
}
