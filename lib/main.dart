import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/fall_again_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //landscape
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  //projector
  final game = FallAgainGame();

  runApp(
    GameWidget(game: game),
  );
}
