import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/fall_again_game.dart';
import '../../managers/save_manager.dart';

class LevelSelectionOverlay extends StatelessWidget {
  final FallAgainGame game;
  const LevelSelectionOverlay({super.key, required this.game});

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
        child: Stack(
          children: [
            Positioned(
              top: 24,
              left: 24,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                onPressed: () {
                  game.overlays.remove('LevelSelection');
                  game.overlays.add('MainMenu');
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  Text(
                    'SELECT LEVEL',
                    style: GoogleFonts.orbitron(
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: 40,
                        itemBuilder: (context, index) {
                          final levelNum = index + 1;
                          final isUnlocked = levelNum <= SaveManager.getUnlockedLevel();

                          return GestureDetector(
                            onTap: isUnlocked
                                ? () {
                                    game.overlays.remove('LevelSelection');
                                    game.currentLevelNumber = levelNum;
                                    game.levelManager.loadLevel(levelNum);
                                    game.overlays.add('Controls');
                                  }
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isUnlocked
                                    ? Colors.cyanAccent.withOpacity(0.15)
                                    : Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isUnlocked
                                      ? Colors.cyanAccent.withOpacity(0.5)
                                      : Colors.white10,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: isUnlocked
                                    ? Text(
                                        '$levelNum',
                                        style: GoogleFonts.orbitron(
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.lock,
                                        color: Colors.white24,
                                        size: 20,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
