import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../components/players/player.dart';

class FallAgainGame extends FlameGame {
  late Player player;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // creating the player
    player = Player();

    //starting position (center)
    player.position = Vector2(400, 0);

    world.add(player);


    //camera follow the player
    camera.follow(player);
  }
}
