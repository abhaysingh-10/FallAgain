import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';

class Lava extends RectangleComponent {
  Lava({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          paint: Paint()..color = Colors.red,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }
}
