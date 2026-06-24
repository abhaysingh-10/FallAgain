import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../components/players/player.dart';

class FallAgainGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // creating the player
    final player = Player();

    //starting position (center)
    player.position = size / 2;

    add(player);
  }
}
