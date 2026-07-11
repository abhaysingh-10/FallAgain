import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/players/player.dart';
import '../components/background/cybercity_background.dart';
import '../managers/level_manager.dart';
import '../managers/save_manager.dart';
import '../managers/audio_manager.dart';

class FallAgainGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late Player player;
  late LevelManager levelManager;
  
  // Game state
  int coins = 0;
  int deaths = 0;
  int currentLevelNumber = 1;
  String selectedSkin = 'Classic Robo';

  // Level-specific tracking
  double levelTime = 0.0;
  int levelDeaths = 0;
  int levelCoins = 0;

  // Value Notifiers for reactive HUD updates in Flutter overlays
  final ValueNotifier<int> levelCoinsNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> levelDeathsNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> levelNumberNotifier = ValueNotifier<int>(1);

  // Movement control flags (for touch UI and keyboard)
  bool movingLeft = false;
  bool movingRight = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load persisted progress
    coins = SaveManager.getCoins();
    deaths = SaveManager.getDeaths();
    selectedSkin = SaveManager.getSelectedSkin();

    // Create the player
    player = Player();

    // Add Cybercity Background
    world.add(CybercityBackground());

    // Add LevelManager to the world
    levelManager = LevelManager();
    world.add(levelManager);

    // Load Level 1
    await levelManager.loadLevel(currentLevelNumber);

    // Add Player to the world
    world.add(player);

    // Camera follow the player
    camera.follow(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Increment level timer if gameplay is active
    if (!overlays.isActive('LevelComplete')) {
      levelTime += dt;
    }
  }

  void incrementCoins() {
    coins++;
    levelCoins++;
    levelCoinsNotifier.value = levelCoins;
    SaveManager.saveCoins(coins);
  }

  void incrementDeaths() {
    deaths++;
    levelDeaths++;
    levelDeathsNotifier.value = levelDeaths;
    SaveManager.saveDeaths(deaths);
  }

  void completeLevel() {
    AudioManager.playLevelComplete();
    overlays.add('LevelComplete');
  }

  void nextLevel() {
    if (currentLevelNumber < 40) {
      currentLevelNumber++;
      // Save unlocked level progression
      SaveManager.saveUnlockedLevel(currentLevelNumber);
    } else {
      currentLevelNumber = 1;
    }
    levelNumberNotifier.value = currentLevelNumber;
    levelManager.loadLevel(currentLevelNumber);
  }

  void selectSkin(String skinName) {
    selectedSkin = skinName;
    SaveManager.saveSelectedSkin(skinName);
    player.updateSkin();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    movingLeft = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
        
    movingRight = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    final isJump = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    if (isJump && event is KeyDownEvent) {
      player.jump();
    }

    return KeyEventResult.handled;
  }
}
