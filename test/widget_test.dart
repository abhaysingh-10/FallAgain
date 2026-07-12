import 'package:flutter_test/flutter_test.dart';
import 'package:fall_again/game/fall_again_game.dart';
import 'package:fall_again/managers/save_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Game initial state unit test', () async {
    SharedPreferences.setMockInitialValues({});
    await SaveManager.init();
    final game = FallAgainGame();
    expect(game.coins, 0);
    expect(game.deaths, 0);
    expect(game.currentLevelNumber, 1);
  });
}
