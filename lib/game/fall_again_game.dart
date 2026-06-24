import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import '../components/players/player.dart';
import 'package:flame/input.dart';
import '../levels/level_manager.dart';
import 'package:flame/collisions.dart';

class FallAgainGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Player player;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // creating the player
    player = Player();

    //starting position (center)
    player.position = Vector2(400, 0);

    world.add(LevelManager());

    world.add(player);

    //camera follow the player
    camera.follow(player);
  }

  @override
  void onTapDown(TapDownInfo info) {
    player.jump();
  }
}
