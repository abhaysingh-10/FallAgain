import 'dart:math';
import 'package:flame/components.dart';
import 'spike.dart';

class MovingSpike extends Spike {
  final double speed;
  final double range;
  final bool isHorizontal;
  late double startX;
  late double startY;
  double time = 0.0;

  MovingSpike({
    required Vector2 position,
    required Vector2 size,
    this.speed = 120.0,
    this.range = 70.0,
    this.isHorizontal = true,
  }) : startX = position.x,
       startY = position.y,
       super(position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
    
    // Smooth harmonic movement back and forth
    if (isHorizontal) {
      position.x = startX + sin(time * (speed / range)) * range;
    } else {
      position.y = startY + sin(time * (speed / range)) * range;
    }
  }
}
