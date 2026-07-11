import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../game/fall_again_game.dart';

class CybercityBackground extends Component with HasGameRef<FallAgainGame> {
  double time = 0.0;
  late final List<_Building> layer1Buildings;
  late final List<_Building> layer2Buildings;
  late final List<_Building> layer3Buildings; // Near layer for foreground parallax
  late final List<Offset> stars;
  late final List<_Searchlight> searchlights;

  CybercityBackground() : super() {
    priority = -100; // Render behind everything

    final random = Random(2026);

    // Generate static stars
    stars = List.generate(40, (index) {
      return Offset(
        random.nextDouble() * 2000,
        random.nextDouble() * 400,
      );
    });

    // Generate Layer 1 (Far - Tall spires, dark indigo)
    layer1Buildings = List.generate(20, (index) {
      return _Building(
        width: 100.0 + random.nextDouble() * 80,
        height: 400.0 + random.nextDouble() * 200,
        color: const Color(0xFF0F0C24),
      );
    });

    // Generate searchlights on top of some Layer 1 buildings
    searchlights = [
      _Searchlight(buildingIndex: 3, baseAngle: -0.5, sweepRange: 0.4, speed: 0.6, color: const Color(0xFF00F5FF)),
      _Searchlight(buildingIndex: 8, baseAngle: 0.2, sweepRange: 0.3, speed: 0.4, color: const Color(0xFFFF007F)),
      _Searchlight(buildingIndex: 14, baseAngle: -0.1, sweepRange: 0.5, speed: 0.5, color: const Color(0xFF00FFCC)),
    ];

    // Generate Layer 2 (Mid - Navy with cyan/yellow window grids)
    layer2Buildings = List.generate(20, (index) {
      return _Building(
        width: 140.0 + random.nextDouble() * 90,
        height: 250.0 + random.nextDouble() * 150,
        color: const Color(0xFF07051C),
        hasWindows: true,
        windowColor: index % 2 == 0 ? const Color(0xFF00FFCC) : const Color(0xFFFFD700),
      );
    });

    // Generate Layer 3 (Near - Dark slate with neon outlines and billboards)
    layer3Buildings = List.generate(15, (index) {
      return _Building(
        width: 180.0 + random.nextDouble() * 120,
        height: 140.0 + random.nextDouble() * 100,
        color: const Color(0xFF04020E),
        neonColor: index % 3 == 0 ? const Color(0xFFFF007F) : (index % 3 == 1 ? const Color(0xFF00F5FF) : const Color(0xFFB55FE6)),
        hasBillboard: index % 2 == 0,
        billboardText: index % 4 == 0 ? "GLITCH" : (index % 4 == 1 ? "BAR" : (index % 4 == 2 ? "RAGE" : "RUN")),
      );
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
  }

  @override
  void render(Canvas canvas) {
    final cameraX = gameRef.camera.viewfinder.position.x;
    final viewportRect = gameRef.camera.visibleWorldRect;

    // 1. Cyber Sky Gradient (Dark purple to deep violet/magenta hue at horizon)
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF03010A), Color(0xFF0E0824), Color(0xFF220C30)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(viewportRect);
    canvas.drawRect(viewportRect, skyPaint);

    // 2. Draw Stars
    final starPaint = Paint()..color = Colors.white.withOpacity(0.5);
    for (var star in stars) {
      // Offset stars slightly based on camera for a distant parallax feel
      final starX = viewportRect.left + ((star.dx - cameraX * 0.05) % (viewportRect.width + 100));
      canvas.drawCircle(Offset(starX, viewportRect.top + star.dy), 1.2, starPaint);
    }

    // 3. Draw searchlights (behind far layer)
    _drawSearchlights(canvas, cameraX * 0.15, viewportRect);

    // 4. Draw Layer 1 (Far Parallax)
    _drawLayer1(canvas, cameraX * 0.15, viewportRect);

    // 5. Draw Layer 2 (Mid Parallax with windows)
    _drawLayer2(canvas, cameraX * 0.35, viewportRect);

    // 6. Draw Layer 3 (Near Parallax with neon outlines and billboards)
    _drawLayer3(canvas, cameraX * 0.55, viewportRect);

    // 7. Draw Cyber Retro Scanlines overlay
    final scanlinePaint = Paint()
      ..color = const Color(0xFF000000).withOpacity(0.08)
      ..strokeWidth = 1.0;
    for (double y = viewportRect.top; y < viewportRect.bottom; y += 4) {
      canvas.drawLine(Offset(viewportRect.left, y), Offset(viewportRect.right, y), scanlinePaint);
    }
  }

  void _drawSearchlights(Canvas canvas, double scrollOffset, Rect viewportRect) {
    double currentX = viewportRect.left - (scrollOffset % 300);
    
    for (var light in searchlights) {
      // Find building X position
      double bX = currentX;
      for (int i = 0; i < light.buildingIndex; i++) {
        bX += layer1Buildings[i % layer1Buildings.length].width + 12;
      }
      
      final b = layer1Buildings[light.buildingIndex % layer1Buildings.length];
      final baseCenter = Offset(bX + b.width / 2, viewportRect.bottom - b.height);
      
      // Calculate sweeping angle
      final angle = light.baseAngle + sin(time * light.speed) * light.sweepRange;
      
      // Draw searchlight beam (cone)
      final beamPath = Path();
      beamPath.moveTo(baseCenter.dx, baseCenter.dy);
      
      final beamLength = 600.0;
      final leftAngle = angle - 0.12;
      final rightAngle = angle + 0.12;
      
      beamPath.lineTo(
        baseCenter.dx + sin(leftAngle) * beamLength,
        baseCenter.dy - cos(leftAngle) * beamLength,
      );
      beamPath.lineTo(
        baseCenter.dx + sin(rightAngle) * beamLength,
        baseCenter.dy - cos(rightAngle) * beamLength,
      );
      beamPath.close();
      
      final beamPaint = Paint()
        ..shader = LinearGradient(
          colors: [light.color.withOpacity(0.25), light.color.withOpacity(0.0)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).createShader(Rect.fromLTWH(baseCenter.dx - 100, baseCenter.dy - beamLength, 200, beamLength));
      
      canvas.drawPath(beamPath, beamPaint);
    }
  }

  void _drawLayer1(Canvas canvas, double scrollOffset, Rect viewportRect) {
    double currentX = viewportRect.left - (scrollOffset % 300);
    int index = 0;
    while (currentX < viewportRect.right + 200) {
      final b = layer1Buildings[index % layer1Buildings.length];
      final rect = Rect.fromLTWH(currentX, viewportRect.bottom - b.height, b.width, b.height);
      final paint = Paint()..color = b.color;
      canvas.drawRect(rect, paint);
      currentX += b.width + 12;
      index++;
    }
  }

  void _drawLayer2(Canvas canvas, double scrollOffset, Rect viewportRect) {
    double currentX = viewportRect.left - (scrollOffset % 300);
    int index = 0;
    while (currentX < viewportRect.right + 200) {
      final b = layer2Buildings[index % layer2Buildings.length];
      final rect = Rect.fromLTWH(currentX, viewportRect.bottom - b.height, b.width, b.height);
      final paint = Paint()..color = b.color;
      canvas.drawRect(rect, paint);

      // Window grid drawing
      if (b.hasWindows) {
        final windowPaint = Paint()..color = b.windowColor.withOpacity(0.18);
        final winRows = (b.height / 35).floor();
        final winCols = (b.width / 24).floor();
        for (int r = 2; r < winRows - 1; r++) {
          for (int c = 1; c < winCols - 1; c++) {
            if ((index + r + c) % 6 != 0) {
              canvas.drawRect(
                Rect.fromLTWH(currentX + c * 24, viewportRect.bottom - b.height + r * 35, 8, 12),
                windowPaint,
              );
            }
          }
        }
      }
      currentX += b.width + 15;
      index++;
    }
  }

  void _drawLayer3(Canvas canvas, double scrollOffset, Rect viewportRect) {
    double currentX = viewportRect.left - (scrollOffset % 300);
    int index = 0;
    while (currentX < viewportRect.right + 250) {
      final b = layer3Buildings[index % layer3Buildings.length];
      final rect = Rect.fromLTWH(currentX, viewportRect.bottom - b.height, b.width, b.height);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      
      // Building fill
      final paint = Paint()..color = b.color;
      canvas.drawRRect(rrect, paint);

      // Neon outline edges (Layer 3 details)
      if (b.neonColor != null) {
        final neonBorder = Paint()
          ..color = b.neonColor!.withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawRRect(rrect, neonBorder);

        // Neon bright top line
        final topNeon = Paint()
          ..color = b.neonColor!
          ..strokeWidth = 1.5;
        canvas.drawLine(Offset(currentX + 4, viewportRect.bottom - b.height), Offset(currentX + b.width - 4, viewportRect.bottom - b.height), topNeon);
      }

      // Draw Glowing Billboards!
      if (b.hasBillboard && b.neonColor != null) {
        final double signW = b.width * 0.6;
        final double signH = 30.0;
        final signRect = Rect.fromLTWH(
          currentX + (b.width - signW) / 2,
          viewportRect.bottom - b.height + 40,
          signW,
          signH,
        );
        final signRRect = RRect.fromRectAndRadius(signRect, const Radius.circular(4));

        // Background of sign
        canvas.drawRRect(signRRect, Paint()..color = const Color(0xFF03010A));

        // Pulsing glow factor
        final pulse = 0.5 + 0.5 * sin(time * 6 + index);
        
        // Sign border neon
        final signBorder = Paint()
          ..color = b.neonColor!.withOpacity(0.3 + 0.4 * pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawRRect(signRRect, signBorder);

        // Sign text outline drawing
        final textPaint = Paint()
          ..color = b.neonColor!.withOpacity(0.5 + 0.5 * pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

        // Draw simple neon glyphs or lines inside the sign to simulate text
        final textCenter = signRect.center;
        canvas.drawLine(Offset(textCenter.dx - signW * 0.3, textCenter.dy), Offset(textCenter.dx - signW * 0.1, textCenter.dy), textPaint);
        canvas.drawCircle(Offset(textCenter.dx, textCenter.dy), 3, textPaint);
        canvas.drawLine(Offset(textCenter.dx + signW * 0.1, textCenter.dy), Offset(textCenter.dx + signW * 0.3, textCenter.dy), textPaint);
      }

      currentX += b.width + 20;
      index++;
    }
  }
}

class _Building {
  final double width;
  final double height;
  final Color color;
  final bool hasWindows;
  final Color windowColor;
  final Color? neonColor;
  final bool hasBillboard;
  final String? billboardText;

  _Building({
    required this.width,
    required this.height,
    required this.color,
    this.hasWindows = false,
    this.windowColor = Colors.cyanAccent,
    this.neonColor,
    this.hasBillboard = false,
    this.billboardText,
  });
}

class _Searchlight {
  final int buildingIndex;
  final double baseAngle;
  final double sweepRange;
  final double speed;
  final Color color;

  _Searchlight({
    required this.buildingIndex,
    required this.baseAngle,
    required this.sweepRange,
    required this.speed,
    required this.color,
  });
}
