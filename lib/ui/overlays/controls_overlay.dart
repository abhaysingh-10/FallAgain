import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/fall_again_game.dart';

class ControlsOverlay extends StatefulWidget {
  final FallAgainGame game;
  const ControlsOverlay({super.key, required this.game});

  @override
  State<ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // HUD in the top-left corner
          Positioned(
            left: 24,
            top: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: widget.game.levelNumberNotifier,
                    builder: (context, val, child) {
                      return Text(
                        'LEVEL $val',
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  ValueListenableBuilder<int>(
                    valueListenable: widget.game.levelCoinsNotifier,
                    builder: (context, val, child) {
                      return Text(
                        '$val',
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.sentiment_very_dissatisfied, color: Colors.redAccent, size: 16),
                  const SizedBox(width: 4),
                  ValueListenableBuilder<int>(
                    valueListenable: widget.game.levelDeathsNotifier,
                    builder: (context, val, child) {
                      return Text(
                        '$val',
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Pause button in the top-right corner
          Positioned(
            right: 24,
            top: 24,
            child: GestureDetector(
              onTap: () {
                widget.game.overlays.remove('Controls');
                widget.game.overlays.add('PauseMenu');
                widget.game.pauseEngine();
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.pause,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          // Left and Right buttons in the bottom-left corner
          Positioned(
            left: 24,
            bottom: 24,
            child: Row(
              children: [
                _buildControlButton(
                  icon: Icons.arrow_back,
                  onTapDown: () => widget.game.movingLeft = true,
                  onTapUp: () => widget.game.movingLeft = false,
                ),
                const SizedBox(width: 16),
                _buildControlButton(
                  icon: Icons.arrow_forward,
                  onTapDown: () => widget.game.movingRight = true,
                  onTapUp: () => widget.game.movingRight = false,
                ),
              ],
            ),
          ),
          // Jump button in the bottom-right corner
          Positioned(
            right: 24,
            bottom: 24,
            child: _buildControlButton(
              text: 'JUMP',
              onTapDown: () => widget.game.player.jump(),
              onTapUp: () {},
              width: 80,
              height: 80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    IconData? icon,
    String? text,
    required VoidCallback onTapDown,
    required VoidCallback onTapUp,
    double width = 70,
    double height = 70,
  }) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapUp,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: text == null ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: text != null ? BorderRadius.circular(20) : null,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: Colors.white.withOpacity(0.85), size: 32)
              : Text(
                  text!,
                  style: GoogleFonts.orbitron(
                    textStyle: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
