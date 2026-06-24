import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends RectangleComponent {
  //Adding Gravity
  final double gravity = 800;
  Vector2 velocity = Vector2.zero();

//player
  Player()
      : super(
          size: Vector2(50, 50),
          paint: Paint()..color = Colors.blue,
        );

  @override
  void update(double dt) {
    super.update(dt);

    velocity.y += gravity * dt;

    position.y += velocity.y * dt;
  }
}
