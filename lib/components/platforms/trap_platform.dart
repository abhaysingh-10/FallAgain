import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import '../players/player.dart';
import 'platform.dart';

class TrapPlatform extends Platform with CollisionCallbacks {
  bool isSteppedOn = false;
  double timer = 0.0;
  final double collapseDelay = 0.25; // collapses after 0.25 seconds
  bool collapsed = false;

  TrapPlatform({
    required super.position,
    required super.size,
  });

  @override
  void update(double dt) {
    super.update(dt);
    if (isSteppedOn && !collapsed) {
      timer += dt;
      if (timer >= collapseDelay) {
        collapsed = true;
        paint.color = Colors.transparent;
        children.whereType<RectangleHitbox>().forEach((h) => h.removeFromParent());
      } else {
        paint.color = Colors.redAccent.withOpacity(1.0 - (timer / collapseDelay));
      }
    }
  }

  void reset() {
    isSteppedOn = false;
    timer = 0.0;
    paint.color = Colors.green;
    if (collapsed) {
      collapsed = false;
      add(RectangleHitbox());
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !isSteppedOn) {
      if (other.velocity.y > 0 && other.position.y + other.size.y <= position.y + 10) {
        isSteppedOn = true;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void render(Canvas canvas) {
    if (collapsed) return;

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    final double opacity = isSteppedOn ? (1.0 - (timer / collapseDelay)).clamp(0.0, 1.0) : 1.0;

    // 1. Dark background
    final bgPaint = Paint()
      ..color = const Color(0xFF0F172A).withOpacity(0.7 * opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bgPaint);

    // 2. Faint glow
    final Color wideGlowColor = isSteppedOn ? const Color(0xFFEF4444) : const Color(0xFF10B981);
    final glowPaint1 = Paint()
      ..color = wideGlowColor.withOpacity(0.2 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawRRect(rrect, glowPaint1);

    // 3. Bright core
    final Color coreGlowColor = isSteppedOn ? const Color(0xFFEF4444) : const Color(0xFF34D399);
    final glowPaint2 = Paint()
      ..color = coreGlowColor.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rrect, glowPaint2);
  }
}
