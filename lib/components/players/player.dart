import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends RectangleComponent {
  //Adding Gravity
  final double gravity = 800;
  Vector2 velocity = Vector2.zero();

  //horizontal speed movement
  final double moveSpeed = 300;

//player
  Player()
      : super(
          size: Vector2(50, 50),
          paint: Paint()..color = Colors.blue,
        );

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

    // ground layer
    if (position.y >= 300) {
      position.y = 300;
      velocity.y = 0;
    }
  }
}
