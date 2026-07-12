import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'spike.dart';
import '../../game/fall_again_game.dart';

class HiddenSpike extends Spike with HasGameRef<FallAgainGame> {
  final double triggerDistance = 100.0;
  bool isTriggered = false;
  Vector2 targetPosition;
  Vector2 startPosition;
  final double popSpeed = 400.0;

  HiddenSpike({
    required Vector2 position,
    required Vector2 size,
  }) : startPosition = position.clone() + Vector2(0, size.y),
       targetPosition = position.clone(),
       super(
         position: position + Vector2(0, size.y),
         size: size,
       ) {
    paint.color = Colors.transparent; // hidden initially
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isTriggered) {
      final player = game.player;
      if (player.position.x >= targetPosition.x - triggerDistance &&
          player.position.x <= targetPosition.x + size.x + triggerDistance) {
        isTriggered = true;
        paint.color = Colors.orange; // reveal
      }
    } else {
      if (position.y > targetPosition.y) {
        position.y -= popSpeed * dt;
        if (position.y < targetPosition.y) {
          position.y = targetPosition.y;
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (!isTriggered) return;
    super.render(canvas);
  }

  void reset() {
    position = startPosition.clone();
    isTriggered = false;
    paint.color = Colors.transparent;
  }
}
