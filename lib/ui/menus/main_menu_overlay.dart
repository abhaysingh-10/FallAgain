import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/fall_again_game.dart';

class MainMenuOverlay extends StatelessWidget {
  final FallAgainGame game;
  const MainMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'FALL AGAIN',
                      style: GoogleFonts.orbitron(
                        textStyle: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4.0,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.cyanAccent,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The Ultimate Rage Platformer',
                      style: GoogleFonts.orbitron(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildMenuButton(
                      text: 'PLAY',
                      color: Colors.cyanAccent,
                      textColor: Colors.black,
                      onPressed: () {
                        game.overlays.remove('MainMenu');
                        game.overlays.add('Controls');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      text: 'LEVELS',
                      color: Colors.white10,
                      textColor: Colors.white,
                      onPressed: () {
                        game.overlays.remove('MainMenu');
                        game.overlays.add('LevelSelection');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      text: 'SKINS',
                      color: Colors.white10,
                      textColor: Colors.white,
                      onPressed: () {
                        game.overlays.remove('MainMenu');
                        game.overlays.add('CharacterSelection');
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatChip(Icons.sentiment_very_dissatisfied, 'Deaths: ${game.deaths}'),
                        const SizedBox(width: 16),
                        _buildStatChip(Icons.monetization_on, 'Coins: ${game.coins}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: color == Colors.cyanAccent ? 8 : 0,
          shadowColor: Colors.cyanAccent.withOpacity(0.5),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.orbitron(
            textStyle: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.orbitron(
              textStyle: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
