import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/fall_again_game.dart';

class LevelCompleteOverlay extends StatelessWidget {
  final FallAgainGame game;
  const LevelCompleteOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final timeStr = game.levelTime.toStringAsFixed(1);
    
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            width: 400,
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LEVEL COMPLETE!',
                  style: GoogleFonts.orbitron(
                    textStyle: const TextStyle(
                      color: Colors.amber,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildStatRow(Icons.timer, 'Time', '$timeStr s'),
                const SizedBox(height: 12),
                _buildStatRow(Icons.sentiment_very_dissatisfied, 'Deaths', '${game.levelDeaths}'),
                const SizedBox(height: 12),
                _buildStatRow(Icons.monetization_on, 'Coins', '${game.levelCoins}'),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      context,
                      text: 'RETRY',
                      color: Colors.grey[700]!,
                      onPressed: () {
                        game.overlays.remove('LevelComplete');
                        game.levelManager.loadLevel(game.currentLevelNumber);
                      },
                    ),
                    _buildButton(
                      context,
                      text: 'NEXT',
                      color: Colors.green,
                      onPressed: () {
                        game.overlays.remove('LevelComplete');
                        game.nextLevel();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.orbitron(
                textStyle: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.orbitron(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
