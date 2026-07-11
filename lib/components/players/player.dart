import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import '../platforms/platform.dart';
import '../hazards/hazard.dart';
import '../../game/fall_again_game.dart';
import '../../managers/audio_manager.dart';

class Player extends RectangleComponent with CollisionCallbacks, HasGameRef<FallAgainGame> {
  // Adding Gravity
  final double gravity = 1000;
  Vector2 velocity = Vector2.zero();

  // Horizontal speed movement
  final double moveSpeed = 320;

  bool isOnGround = false;

  // Player starting position tracker
  Vector2 spawnPoint = Vector2(100, 100);

  // Procedural Animation variables
  double animationTime = 0.0;
  double squashTimer = 0.0;
  double squashX = 1.0;
  double squashY = 1.0;
  
  // For smooth direction transitions
  double facingDirection = 1.0; // 1.0 for right, -1.0 for left

  // Skin color variables (Classic Robo default)
  Color bodyColorStart = const Color(0xFF00D2FF);
  Color bodyColorEnd = const Color(0xFF0066FF);
  Color visorColor = const Color(0xFF0F172A);
  Color eyeColor = const Color(0xFF00F5FF);
  Color feetColor = const Color(0xFF1E293B);
  bool isHumanoid = false;

  Player()
      : super(
          size: Vector2(40, 40),
          paint: Paint()..color = Colors.transparent, // transparent because we draw procedurally
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    updateSkin();
  }

  @override
  void update(double dt) {
    super.update(dt);
    animationTime += dt;

    // Apply gravity
    velocity.y += gravity * dt;
    // Cap vertical velocity to prevent extreme falling speeds
    if (velocity.y > 1000) {
      velocity.y = 1000;
    }
    
    position.y += velocity.y * dt;

    // Manual movement
    double moveDirection = 0;
    if (game.movingLeft) {
      moveDirection -= 1;
      facingDirection = -1.0;
    }
    if (game.movingRight) {
      moveDirection += 1;
      facingDirection = 1.0;
    }

    velocity.x = moveDirection * moveSpeed;
    position.x += velocity.x * dt;

    // Keep player within left boundary
    if (position.x < 0) {
      position.x = 0;
      velocity.x = 0;
    }

    // Squash & Stretch logic
    if (squashTimer > 0) {
      squashTimer -= dt;
      if (squashTimer <= 0) {
        squashX = 1.0;
        squashY = 1.0;
      }
    } else {
      if (!isOnGround) {
        // Stretch in mid-air
        squashX = 0.85;
        squashY = 1.15;
      } else {
        if (velocity.x.abs() > 10) {
          // Small running bob
          squashX = 1.0 + sin(animationTime * 15) * 0.05;
          squashY = 1.0 - sin(animationTime * 15) * 0.05;
        } else {
          // Idle breathing
          squashX = 1.0 + sin(animationTime * 4) * 0.02;
          squashY = 1.0 - sin(animationTime * 4) * 0.02;
        }
      }
    }

    isOnGround = false;

    // Fall out of bounds check
    if (position.y > 650) {
      die();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Save canvas state before applying transforms
    canvas.save();

    // Move to center of component to perform scaling / squashing
    canvas.translate(size.x / 2, size.y / 2);
    canvas.scale(squashX, squashY);
    
    if (isHumanoid) {
      // Draw humanoid figure (head, body armor, swinging limbs)
      final headCenter = const Offset(0, -9);
      final double headRadius = 7.0;

      // 1. Draw Legs
      final legPaint = Paint()
        ..color = feetColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3.5;

      double leftLegSwing = 0.0;
      double rightLegSwing = 0.0;
      
      if (!isOnGround) {
        leftLegSwing = -8.0;
        rightLegSwing = 8.0;
      } else if (velocity.x.abs() > 10) {
        leftLegSwing = sin(animationTime * 15) * 10;
        rightLegSwing = -sin(animationTime * 15) * 10;
      }

      // Left leg
      canvas.drawLine(const Offset(-4, 7), Offset(-4 + leftLegSwing * 0.4, 18 + leftLegSwing.abs() * 0.1), legPaint);
      // Right leg
      canvas.drawLine(const Offset(4, 7), Offset(4 + rightLegSwing * 0.4, 18 + rightLegSwing.abs() * 0.1), legPaint);

      // 2. Draw Torso
      final torsoRect = Rect.fromLTRB(-8, -4, 8, 8);
      final torsoRRect = RRect.fromRectAndRadius(torsoRect, const Radius.circular(4));
      final torsoPaint = Paint()
        ..shader = LinearGradient(
          colors: [bodyColorStart, bodyColorEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(torsoRect);
      canvas.drawRRect(torsoRRect, torsoPaint);

      // Valkyrie Wings decoration
      if (gameRef.selectedSkin == 'Exo Valkyrie') {
        final wingPaint = Paint()
          ..color = const Color(0xFF22D3EE).withOpacity(0.55)
          ..style = PaintingStyle.fill;
        final wingLeft = Path()
          ..moveTo(-8, -2)
          ..lineTo(-20, -10)
          ..lineTo(-15, 2)
          ..close();
        final wingRight = Path()
          ..moveTo(8, -2)
          ..lineTo(20, -10)
          ..lineTo(15, 2)
          ..close();
        canvas.drawPath(wingLeft, wingPaint);
        canvas.drawPath(wingRight, wingPaint);
      }

      // Matrix Hood decoration
      if (gameRef.selectedSkin == 'Matrix Hacker') {
        final hoodPaint = Paint()
          ..color = const Color(0xFF0F172A)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(const Offset(0, -9), headRadius + 2.0, hoodPaint);
      }

      // 3. Draw Head
      final headPaint = Paint()
        ..color = gameRef.selectedSkin == 'Matrix Hacker' ? const Color(0xFF1E293B) : bodyColorStart;
      canvas.drawCircle(headCenter, headRadius, headPaint);

      // 4. Draw Visor
      final visorPaint = Paint()..color = visorColor;
      final visorRect = Rect.fromCenter(
        center: Offset(facingDirection * 2, -9),
        width: 10,
        height: 5,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(visorRect, const Radius.circular(1.5)), visorPaint);

      // 5. Draw Glowing Eyes
      final eyePaint = Paint()..color = eyeColor;
      final eyeSize = (sin(animationTime * 2) > 0.98) ? 0.5 : 1.5;
      if (eyeSize > 0.5) {
        canvas.drawCircle(Offset(facingDirection * 2 - 2, -9), eyeSize, eyePaint);
        canvas.drawCircle(Offset(facingDirection * 2 + 2, -9), eyeSize, eyePaint);
      }

      // 6. Draw Arms
      final armPaint = Paint()
        ..color = bodyColorEnd
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3.0;

      double armSwing = 0.0;
      if (isOnGround && velocity.x.abs() > 10) {
        armSwing = -sin(animationTime * 15) * 8;
      }
      canvas.drawLine(const Offset(-9, -2), Offset(-12, 5 + armSwing * 0.4), armPaint);
      canvas.drawLine(const Offset(9, -2), Offset(12, 5 - armSwing * 0.4), armPaint);

    } else {
      // Draw feet when on ground and moving
      if (isOnGround && velocity.x.abs() > 10) {
        final footPaint = Paint()..color = feetColor;
        final leftFootOffset = sin(animationTime * 15) * 8;
        final rightFootOffset = -sin(animationTime * 15) * 8;
        
        // Draw Left Foot
        canvas.drawCircle(Offset(-10, 15 + leftFootOffset.abs() * 0.2), 6, footPaint);
        // Draw Right Foot
        canvas.drawCircle(Offset(10, 15 + rightFootOffset.abs() * 0.2), 6, footPaint);
      }

      // Draw Main Body (cute robot cube)
      final rect = Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
      
      // Body gradient
      final bodyPaint = Paint()
        ..shader = LinearGradient(
          colors: [bodyColorStart, bodyColorEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect);
      
      canvas.drawRRect(rrect, bodyPaint);

      // Draw Body Border/Gloss
      final borderPaint = Paint()
        ..color = const Color(0xFFE2E8F0).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawRRect(rrect, borderPaint);

      // Draw Face/Eyes visor
      final visorPaint = Paint()..color = visorColor;
      final visorRect = Rect.fromCenter(
        center: Offset(facingDirection * 4, -4),
        width: 24,
        height: 12,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(visorRect, const Radius.circular(4)), visorPaint);

      // Draw Glowing Eyes
      final eyePaint = Paint()..color = eyeColor;
      final eyeSize = (sin(animationTime * 2) > 0.98) ? 1.0 : 4.0; // Blink effect
      
      if (eyeSize > 1.0) {
        // Left eye
        canvas.drawCircle(Offset(facingDirection * 4 - 5, -4), eyeSize, eyePaint);
        // Right eye
        canvas.drawCircle(Offset(facingDirection * 4 + 5, -4), eyeSize, eyePaint);
      } else {
        // Draw blink line
        final blinkPaint = Paint()
          ..color = eyeColor
          ..strokeWidth = 1.5;
        canvas.drawLine(Offset(facingDirection * 4 - 7, -4), Offset(facingDirection * 4 - 3, -4), blinkPaint);
        canvas.drawLine(Offset(facingDirection * 4 + 3, -4), Offset(facingDirection * 4 + 7, -4), blinkPaint);
      }
    }

    // Restore canvas state
    canvas.restore();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      final playerRect = toRect();
      final platformRect = other.toRect();
      
      if (playerRect.overlaps(platformRect)) {
        final intersection = playerRect.intersect(platformRect);
        
        // Resolve along axis of minimum penetration
        if (intersection.width < intersection.height) {
          // Horizontal collision resolution (walls)
          if (playerRect.center.dx < platformRect.center.dx) {
            position.x -= intersection.width;
          } else {
            position.x += intersection.width;
          }
          velocity.x = 0;
        } else {
          // Vertical collision resolution (ground and ceiling)
          if (playerRect.center.dy < platformRect.center.dy) {
            // Player is landing on top of the platform
            if (velocity.y > 0) {
              position.y -= intersection.height;
              
              // Trigger landing squash
              if (!isOnGround && velocity.y > 200) {
                squashX = 1.25;
                squashY = 0.75;
                squashTimer = 0.15;
              }
              
              velocity.y = 0;
              isOnGround = true;
            }
          } else {
            // Player bumps head under the platform
            if (velocity.y < 0) {
              position.y += intersection.height;
              velocity.y = 0;
            }
          }
        }
      }
    }
    
    if (other is Hazard) {
      die();
    }

    super.onCollision(intersectionPoints, other);
  }

  // Jump
  void jump() {
    if (isOnGround) {
      velocity.y = -480;
      isOnGround = false;
      AudioManager.playJump();
      
      // Jump stretch
      squashX = 0.8;
      squashY = 1.2;
      squashTimer = 0.2;
    }
  }

  void resetToSpawn() {
    position = spawnPoint.clone();
    velocity = Vector2.zero();
    isOnGround = false;
    squashX = 1.0;
    squashY = 1.0;
    squashTimer = 0.0;
  }

  void die() {
    game.incrementDeaths();
    game.levelManager.resetTraps();
    AudioManager.playDeath();
    
    // Spawn particle explosion
    _spawnDeathParticles();
    
    resetToSpawn();
  }

  void _spawnDeathParticles() {
    final colors = [
      bodyColorStart,
      bodyColorEnd,
      eyeColor,
      Colors.white,
    ];
    final random = Random();
    for (int i = 0; i < 30; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 80.0 + random.nextDouble() * 150.0;
      final velocity = Vector2(cos(angle), sin(angle)) * speed;
      final color = colors[random.nextInt(colors.length)];
      
      game.world.add(
        DeathParticle(
          position: position.clone() + size / 2,
          velocity: velocity,
          color: color,
        ),
      );
    }
  }

  void updateSkin() {
    final skin = gameRef.selectedSkin;
    isHumanoid = false; // default to squarish
    
    switch (skin) {
      case 'Neon Phoenix':
        bodyColorStart = const Color(0xFFFF7E40);
        bodyColorEnd = const Color(0xFFFF1F40);
        visorColor = const Color(0xFF2E080C);
        eyeColor = const Color(0xFFFFD700);
        feetColor = const Color(0xFF3F0B10);
        break;
      case 'Cyber Ninja':
        isHumanoid = true;
        bodyColorStart = const Color(0xFF334155);
        bodyColorEnd = const Color(0xFF0F172A);
        visorColor = const Color(0xFF000000);
        eyeColor = const Color(0xFFEF4444);
        feetColor = const Color(0xFF090D16);
        break;
      case 'Neon Hazard':
        isHumanoid = true;
        bodyColorStart = const Color(0xFFFACC15);
        bodyColorEnd = const Color(0xFF84CC16);
        visorColor = const Color(0xFF0F1E10);
        eyeColor = const Color(0xFF22C55E);
        feetColor = const Color(0xFF142B15);
        break;
      case 'Vaporwave Retro':
        bodyColorStart = const Color(0xFFFF007F);
        bodyColorEnd = const Color(0xFF6366F1);
        visorColor = const Color(0xFF1E1035);
        eyeColor = const Color(0xFFFFE600);
        feetColor = const Color(0xFF29104A);
        break;
      case 'Cosmic Cyborg':
        isHumanoid = true;
        bodyColorStart = const Color(0xFF7C3AED);
        bodyColorEnd = const Color(0xFFEC4899);
        visorColor = const Color(0xFF1F0D3D);
        eyeColor = const Color(0xFFFBBF24);
        feetColor = const Color(0xFF2E0F54);
        break;
      case 'Exo Valkyrie':
        isHumanoid = true;
        bodyColorStart = const Color(0xFF06B6D4);
        bodyColorEnd = const Color(0xFF0891B2);
        visorColor = const Color(0xFF0F1E24);
        eyeColor = const Color(0xFF22D3EE);
        feetColor = const Color(0xFF071F29);
        break;
      case 'Matrix Hacker':
        isHumanoid = true;
        bodyColorStart = const Color(0xFF1F2937);
        bodyColorEnd = const Color(0xFF111827);
        visorColor = const Color(0xFF000000);
        eyeColor = const Color(0xFF00FF00);
        feetColor = const Color(0xFF080C14);
        break;
      case 'Gold Gilded Emperor':
        isHumanoid = true;
        bodyColorStart = const Color(0xFFFBBF24);
        bodyColorEnd = const Color(0xFFB45309);
        visorColor = const Color(0xFF451A03);
        eyeColor = const Color(0xFFFFFFFF);
        feetColor = const Color(0xFF3F1902);
        break;
      case 'Plasmatic Cosmic':
        bodyColorStart = const Color(0xFF7C3AED);
        bodyColorEnd = const Color(0xFFC084FC);
        visorColor = const Color(0xFF1E0B36);
        eyeColor = const Color(0xFFFDE047);
        feetColor = const Color(0xFF2A0F4C);
        break;
      case 'Classic Robo':
      default:
        bodyColorStart = const Color(0xFF00D2FF);
        bodyColorEnd = const Color(0xFF0066FF);
        visorColor = const Color(0xFF0F172A);
        eyeColor = const Color(0xFF00F5FF);
        feetColor = const Color(0xFF1E293B);
        break;
    }
  }
}

// Particle class for death effect
class DeathParticle extends CircleComponent with HasGameRef<FallAgainGame> {
  final Vector2 velocity;
  final double maxLifespan = 0.6;
  double lifespan = 0.0;
  final Color color;

  DeathParticle({
    required super.position,
    required this.velocity,
    required this.color,
  }) : super(
          radius: 5.0,
          paint: Paint()..color = color,
        );

  @override
  void update(double dt) {
    super.update(dt);
    lifespan += dt;
    if (lifespan >= maxLifespan) {
      removeFromParent();
    } else {
      position += velocity * dt;
      // Add slight gravity to particles
      velocity.y += 200 * dt;
      // Fade out and shrink
      final progress = lifespan / maxLifespan;
      paint.color = color.withOpacity(1.0 - progress);
      radius = 5.0 * (1.0 - progress * 0.7);
    }
  }
}
