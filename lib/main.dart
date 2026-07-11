import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game/fall_again_game.dart';
import 'managers/save_manager.dart';
import 'managers/audio_manager.dart';
import 'ui/menus/main_menu_overlay.dart';
import 'ui/menus/character_selection_overlay.dart';
import 'ui/menus/pause_menu_overlay.dart';
import 'ui/menus/level_selection_overlay.dart';
import 'ui/overlays/controls_overlay.dart';
import 'ui/overlays/level_complete_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Landscape orientation setup
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Enable full screen mode
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Initialize managers
  await SaveManager.init();
  await AudioManager.init();

  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fall Again',
      theme: ThemeData.dark().copyWith(
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF090D16),
          contentTextStyle: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF00F5FF), width: 1.5),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget<FallAgainGame>(
          game: FallAgainGame(),
          overlayBuilderMap: {
            'MainMenu': (context, game) => MainMenuOverlay(game: game),
            'CharacterSelection': (context, game) =>
                CharacterSelectionOverlay(game: game),
            'PauseMenu': (context, game) => PauseMenuOverlay(game: game),
            'LevelSelection': (context, game) =>
                LevelSelectionOverlay(game: game),
            'Controls': (context, game) => ControlsOverlay(game: game),
            'LevelComplete': (context, game) =>
                LevelCompleteOverlay(game: game),
          },
          initialActiveOverlays: const ['MainMenu'],
        ),
      ),
    );
  }
}
