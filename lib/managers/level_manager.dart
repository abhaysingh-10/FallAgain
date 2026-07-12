import 'package:flame/components.dart';
import '../levels/level_loader.dart';
import '../levels/level_data.dart';
import '../components/platforms/platform.dart';
import '../components/platforms/trap_platform.dart';
import '../components/hazards/lava.dart';
import '../components/hazards/spike.dart';
import '../components/hazards/moving_spike.dart';
import '../components/hazards/falling_hazard.dart';
import '../components/hazards/hidden_spike.dart';
import '../components/collectibles/checkpoint.dart';
import '../components/collectibles/coin.dart';
import '../components/collectibles/finish_flag.dart';
import '../game/fall_again_game.dart';

class LevelManager extends Component with HasGameRef<FallAgainGame> {
  LevelData? currentLevelData;
  final List<Component> _levelComponents = [];

  Future<void> loadLevel(int levelNumber) async {
    // 1. Clean up existing level components
    for (var component in _levelComponents) {
      component.removeFromParent();
    }
    _levelComponents.clear();

    // 2. Load level data
    currentLevelData = await LevelLoader.loadLevel(levelNumber);
    final data = currentLevelData!;

    // Reset level statistics
    gameRef.levelTime = 0.0;
    gameRef.levelDeaths = 0;
    gameRef.levelCoins = 0;
    gameRef.levelCoinsNotifier.value = 0;
    gameRef.levelDeathsNotifier.value = 0;
    gameRef.levelNumberNotifier.value = levelNumber;

    // 3. Reset player position and spawnPoint
    gameRef.player.spawnPoint = data.startPosition.clone();
    gameRef.player.resetToSpawn();

    // 4. Create and add platforms
    for (var plat in data.platforms) {
      final Component p = plat.isFake
          ? TrapPlatform(
              position: Vector2(plat.x, plat.y),
              size: Vector2(plat.width, plat.height),
            )
          : Platform(
              position: Vector2(plat.x, plat.y),
              size: Vector2(plat.width, plat.height),
            );
      _levelComponents.add(p);
      add(p);
    }

    // 5. Create and add lava
    for (var l in data.lava) {
      final lav = Lava(
        position: Vector2(l.x, l.y),
        size: Vector2(l.width, l.height),
      );
      _levelComponents.add(lav);
      add(lav);
    }

    // 6. Create and add spikes
    for (var s in data.spikes) {
      final Component spk = s.isMoving
          ? MovingSpike(
              position: Vector2(s.x, s.y),
              size: Vector2(s.width, s.height),
              range: s.range,
              speed: s.speed,
            )
          : Spike(
              position: Vector2(s.x, s.y),
              size: Vector2(s.width, s.height),
            );
      _levelComponents.add(spk);
      add(spk);
    }

    // 7. Create and add falling hazards (crushing ceilings)
    for (var fh in data.fallingHazards) {
      final fallingHaz = FallingHazard(
        position: Vector2(fh.x, fh.y),
        size: Vector2(fh.width, fh.height),
      );
      _levelComponents.add(fallingHaz);
      add(fallingHaz);
    }

    // 8. Create and add hidden spikes
    for (var hs in data.hiddenSpikes) {
      final hidSpk = HiddenSpike(
        position: Vector2(hs.x, hs.y),
        size: Vector2(hs.width, hs.height),
      );
      _levelComponents.add(hidSpk);
      add(hidSpk);
    }

    // 9. Create and add checkpoints
    for (var cp in data.checkpoints) {
      final chk = Checkpoint(
        position: Vector2(cp.x, cp.y),
        size: Vector2(cp.width, cp.height),
      );
      _levelComponents.add(chk);
      add(chk);
    }

    // 10. Create and add coins
    for (var c in data.coins) {
      final cn = Coin(
        position: Vector2(c.x, c.y),
      );
      _levelComponents.add(cn);
      add(cn);
    }

    // 11. Create and add finish flag
    final ff = FinishFlag(
      position: Vector2(data.finishFlag.x, data.finishFlag.y),
      size: Vector2(data.finishFlag.width, data.finishFlag.height),
    );
    _levelComponents.add(ff);
    add(ff);
  }

  void resetTraps() {
    for (var component in _levelComponents) {
      if (component is TrapPlatform) {
        component.reset();
      } else if (component is FallingHazard) {
        component.reset();
      } else if (component is HiddenSpike) {
        component.reset();
      }
    }
  }
}
