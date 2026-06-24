import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import '../platforms/platform.dart';
import '../hazards/lava.dart';

class Player extends RectangleComponent with CollisionCallbacks {
  //Adding Gravity
  final double gravity = 800;
  Vector2 velocity = Vector2.zero();

  //horizontal speed movement
  final double moveSpeed = 300;

  bool isOnGround = false;

//player
  Player()
      : super(
          size: Vector2(50, 50),
          paint: Paint()..color = Colors.blue,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    //Vertical Movement gravity
    velocity.y += gravity * dt;
    position.y += velocity.y * dt;

    //auto run
    velocity.x = moveSpeed;

    //horizontal Movement
    position.x += velocity.x * dt;

    isOnGround = false;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      if (velocity.y > 0) {
        velocity.y = 0;
        position.y = other.position.y - size.y;
        isOnGround = true;
      }
    }
    
    if (other is Lava) {
      die();
    }

    super.onCollision(intersectionPoints, other);
  }

  // jump
  void jump() {
    if (isOnGround) {
      velocity.y = -500;
    }
  }

  void die() {
    position = Vector2(400, 0);
    velocity = Vector2.zero();
  }
}
