import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../game/fall_again_game.dart';

class CybercityBackground extends Component with HasGameRef<FallAgainGame> {
  double time = 0.0;
  late final List<_Building> layer1Buildings;
  late final List<_Building> layer2Buildings;
  late final List<_Building> layer3Buildings;
  late final List<Offset> stars;
  late final List<_Searchlight> searchlights;

  // ─── Cached Paint objects (created ONCE, never re-allocated) ───
  final Paint _skyPaint = Paint();
  final Paint _starPaint = Paint()..color = const Color(0x80FFFFFF);
  final Paint _overlayPaint = Paint()..color = const Color(0x14000000);
  final Paint _buildingPaint = Paint(); // reused for all building fills
  final Paint _signBgPaint = Paint()..color = const Color(0xFF03010A);

  // Sky shader is only recreated when the viewport rect changes
  Rect _cachedSkyRect = Rect.zero;

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
      final wColor = index % 2 == 0 ? const Color(0xFF00FFCC) : const Color(0xFFFFD700);
      return _Building(
        width: 140.0 + random.nextDouble() * 90,
        height: 250.0 + random.nextDouble() * 150,
        color: const Color(0xFF07051C),
        hasWindows: true,
        windowColor: wColor,
        // Pre-cached window paint — avoids withOpacity() every frame
        cachedWindowPaint: Paint()..color = wColor.withValues(alpha: 0.18),
      );
    });

    // Generate Layer 3 (Near - Dark slate with neon outlines and billboards)
    layer3Buildings = List.generate(15, (index) {
      final nColor = index % 3 == 0
          ? const Color(0xFFFF007F)
          : (index % 3 == 1 ? const Color(0xFF00F5FF) : const Color(0xFFB55FE6));
      return _Building(
        width: 180.0 + random.nextDouble() * 120,
        height: 140.0 + random.nextDouble() * 100,
        color: const Color(0xFF04020E),
        neonColor: nColor,
        hasBillboard: index % 2 == 0,
        billboardText: index % 4 == 0 ? "GLITCH" : (index % 4 == 1 ? "BAR" : (index % 4 == 2 ? "RAGE" : "RUN")),
        // Pre-cached neon paints — created once, never reallocated
        cachedNeonBorderPaint: Paint()
          ..color = nColor.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
        cachedNeonTopPaint: Paint()
          ..color = nColor
          ..strokeWidth = 1.5,
        cachedSignBorderPaint: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
        cachedSignTextPaint: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
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

    // 1. Cyber Sky Gradient — shader only recreated when viewport actually changes
    if (_cachedSkyRect != viewportRect) {
      _cachedSkyRect = viewportRect;
      _skyPaint.shader = const LinearGradient(
        colors: [Color(0xFF03010A), Color(0xFF0E0824), Color(0xFF220C30)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(viewportRect);
    }
    canvas.drawRect(viewportRect, _skyPaint);

    // 2. Draw Stars (cached paint — no withOpacity per frame)
    for (var star in stars) {
      final starX = viewportRect.left + ((star.dx - cameraX * 0.05) % (viewportRect.width + 100));
      canvas.drawCircle(Offset(starX, viewportRect.top + star.dy), 1.2, _starPaint);
    }

    // 3. Draw searchlights (behind far layer)
    _drawSearchlights(canvas, cameraX * 0.15, viewportRect);

    // 4. Draw Layer 1 (Far Parallax)
    _drawLayer1(canvas, cameraX * 0.15, viewportRect);

    // 5. Draw Layer 2 (Mid Parallax with windows)
    _drawLayer2(canvas, cameraX * 0.35, viewportRect);

    // 6. Draw Layer 3 (Near Parallax with neon outlines and billboards)
    _drawLayer3(canvas, cameraX * 0.55, viewportRect);

    // 7. Subtle darkening overlay — replaces ~150 scanline drawLine calls with 1 drawRect
    canvas.drawRect(viewportRect, _overlayPaint);
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
      final baseCenterX = bX + b.width / 2;

      // Culling: skip searchlights whose base is way off-screen
      if (baseCenterX < viewportRect.left - 600 || baseCenterX > viewportRect.right + 600) continue;

      final baseCenterY = viewportRect.bottom - b.height;
      final baseCenter = Offset(baseCenterX, baseCenterY);

      // Calculate sweeping angle
      final angle = light.baseAngle + sin(time * light.speed) * light.sweepRange;

      // Draw searchlight beam (cone)
      final beamPath = Path();
      beamPath.moveTo(baseCenter.dx, baseCenter.dy);

      const beamLength = 600.0;
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

      // Reuse cached Paint, update shader with pre-computed colors
      light.beamPaint.shader = LinearGradient(
        colors: [light.colorStart, light.colorEnd],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Rect.fromLTWH(baseCenter.dx - 100, baseCenter.dy - beamLength, 200, beamLength));

      canvas.drawPath(beamPath, light.beamPaint);
    }
  }

  void _drawLayer1(Canvas canvas, double scrollOffset, Rect viewportRect) {
    double currentX = viewportRect.left - (scrollOffset % 300);
    int index = 0;
    while (currentX < viewportRect.right + 200) {
      final b = layer1Buildings[index % layer1Buildings.length];
      // Culling: only draw if building overlaps viewport
      if (currentX + b.width >= viewportRect.left) {
        final rect = Rect.fromLTWH(currentX, viewportRect.bottom - b.height, b.width, b.height);
        _buildingPaint.color = b.color;
        canvas.drawRect(rect, _buildingPaint);
      }
      currentX += b.width + 12;
      index++;
    }
  }

  void _drawLayer2(Canvas canvas, double scrollOffset, Rect viewportRect) {
    double currentX = viewportRect.left - (scrollOffset % 300);
    int index = 0;
    while (currentX < viewportRect.right + 200) {
      final b = layer2Buildings[index % layer2Buildings.length];

      // Culling: only draw if building overlaps viewport
      if (currentX + b.width >= viewportRect.left) {
        final rect = Rect.fromLTWH(currentX, viewportRect.bottom - b.height, b.width, b.height);
        _buildingPaint.color = b.color;
        canvas.drawRect(rect, _buildingPaint);

        // Window grid — pre-cached paint, wider spacing for fewer draw calls
        if (b.hasWindows) {
          final winRows = (b.height / 40).floor();
          final winCols = (b.width / 28).floor();
          for (int r = 2; r < winRows - 1; r++) {
            for (int c = 1; c < winCols - 1; c++) {
              if ((index + r + c) % 6 != 0) {
                canvas.drawRect(
                  Rect.fromLTWH(currentX + c * 28, viewportRect.bottom - b.height + r * 40, 8, 12),
                  b.cachedWindowPaint!,
                );
              }
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

      // Culling: only draw if building overlaps viewport
      if (currentX + b.width >= viewportRect.left) {
        final rect = Rect.fromLTWH(currentX, viewportRect.bottom - b.height, b.width, b.height);
        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

        // Building fill — reuse cached paint
        _buildingPaint.color = b.color;
        canvas.drawRRect(rrect, _buildingPaint);

        // Neon outline edges (pre-cached paints)
        if (b.neonColor != null) {
          canvas.drawRRect(rrect, b.cachedNeonBorderPaint!);

          // Neon bright top line
          canvas.drawLine(
            Offset(currentX + 4, viewportRect.bottom - b.height),
            Offset(currentX + b.width - 4, viewportRect.bottom - b.height),
            b.cachedNeonTopPaint!,
          );
        }

        // Draw Glowing Billboards
        if (b.hasBillboard && b.neonColor != null) {
          final double signW = b.width * 0.6;
          const double signH = 30.0;
          final signRect = Rect.fromLTWH(
            currentX + (b.width - signW) / 2,
            viewportRect.bottom - b.height + 40,
            signW,
            signH,
          );
          final signRRect = RRect.fromRectAndRadius(signRect, const Radius.circular(4));

          // Background of sign
          canvas.drawRRect(signRRect, _signBgPaint);

          // Pulsing glow factor
          final pulse = 0.5 + 0.5 * sin(time * 6 + index);

          // Update cached paint color for pulse (mutates existing paint, no allocation)
          b.cachedSignBorderPaint!.color = b.neonColor!.withValues(alpha: 0.3 + 0.4 * pulse);
          canvas.drawRRect(signRRect, b.cachedSignBorderPaint!);

          // Sign text outline
          b.cachedSignTextPaint!.color = b.neonColor!.withValues(alpha: 0.5 + 0.5 * pulse);

          final textCenter = signRect.center;
          canvas.drawLine(Offset(textCenter.dx - signW * 0.3, textCenter.dy), Offset(textCenter.dx - signW * 0.1, textCenter.dy), b.cachedSignTextPaint!);
          canvas.drawCircle(Offset(textCenter.dx, textCenter.dy), 3, b.cachedSignTextPaint!);
          canvas.drawLine(Offset(textCenter.dx + signW * 0.1, textCenter.dy), Offset(textCenter.dx + signW * 0.3, textCenter.dy), b.cachedSignTextPaint!);
        }
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
  // Pre-cached Paint objects (created once in constructor, reused every frame)
  final Paint? cachedWindowPaint;
  final Paint? cachedNeonBorderPaint;
  final Paint? cachedNeonTopPaint;
  final Paint? cachedSignBorderPaint;
  final Paint? cachedSignTextPaint;

  _Building({
    required this.width,
    required this.height,
    required this.color,
    this.hasWindows = false,
    this.windowColor = Colors.cyanAccent,
    this.neonColor,
    this.hasBillboard = false,
    this.billboardText,
    this.cachedWindowPaint,
    this.cachedNeonBorderPaint,
    this.cachedNeonTopPaint,
    this.cachedSignBorderPaint,
    this.cachedSignTextPaint,
  });
}

class _Searchlight {
  final int buildingIndex;
  final double baseAngle;
  final double sweepRange;
  final double speed;
  final Color color;
  // Pre-computed gradient colors (avoids withOpacity every frame)
  late final Color colorStart;
  late final Color colorEnd;
  // Cached Paint object (reused every frame, only shader is updated)
  late final Paint beamPaint;

  _Searchlight({
    required this.buildingIndex,
    required this.baseAngle,
    required this.sweepRange,
    required this.speed,
    required this.color,
  }) {
    colorStart = color.withValues(alpha: 0.25);
    colorEnd = color.withValues(alpha: 0.0);
    beamPaint = Paint();
  }
}
