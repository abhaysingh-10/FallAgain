import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/fall_again_game.dart';

class PauseMenuOverlay extends StatelessWidget {
  final FallAgainGame game;
  const PauseMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PAUSED',
                  style: GoogleFonts.orbitron(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildPauseButton(
                  text: 'RESUME',
                  color: Colors.cyanAccent,
                  textColor: Colors.black,
                  onPressed: () {
                    game.overlays.remove('PauseMenu');
                    game.overlays.add('Controls');
                    game.resumeEngine();
                  },
                ),
                const SizedBox(height: 12),
                _buildPauseButton(
                  text: 'RESTART',
                  color: Colors.white10,
                  textColor: Colors.white,
                  onPressed: () {
                    game.overlays.remove('PauseMenu');
                    game.overlays.add('Controls');
                    game.resumeEngine();
                    game.levelManager.loadLevel(game.currentLevelNumber);
                  },
                ),
                const SizedBox(height: 12),
                _buildPauseButton(
                  text: 'MAIN MENU',
                  color: Colors.redAccent.withOpacity(0.8),
                  textColor: Colors.white,
                  onPressed: () {
                    game.overlays.remove('PauseMenu');
                    game.overlays.add('MainMenu');
                    game.resumeEngine();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPauseButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 200,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.orbitron(
            textStyle: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
