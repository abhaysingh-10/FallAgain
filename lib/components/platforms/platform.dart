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
          paint: Paint()..color = Colors.green,
        );

  //physical bumper
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }
}
