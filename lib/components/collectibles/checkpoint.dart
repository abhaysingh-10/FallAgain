import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import '../players/player.dart';
import '../../managers/audio_manager.dart';

class Checkpoint extends RectangleComponent with CollisionCallbacks {
  bool isActivated = false;

  Checkpoint({
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
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

    // 1. Stand body
    final standPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, standPaint);

    // 2. Active cyan vs Idle amber color
    final Color activeColor = isActivated ? const Color(0xFF00F5FF) : const Color(0xFFF59E0B);

    // 3. Scanner lens indicator
    final lensPaint = Paint()..color = activeColor;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 6, lensPaint);

    // 4. Scanner glow
    final glowPaint = Paint()
      ..color = activeColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 6, glowPaint);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !isActivated) {
      isActivated = true;
      other.spawnPoint = position + Vector2(0, -other.size.y);
      AudioManager.playCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
