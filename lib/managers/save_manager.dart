import 'package:shared_preferences/shared_preferences.dart';

class SaveManager {
  static const String _keyUnlockedLevel = 'unlocked_level';
  static const String _keyCoins = 'total_coins';
  static const String _keyDeaths = 'total_deaths';
  static const String _keySelectedSkin = 'selected_skin';
  static const String _keyUnlockedSkins = 'unlocked_skins';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int getUnlockedLevel() {
    return _prefs.getInt(_keyUnlockedLevel) ?? 1;
  }

  static Future<void> saveUnlockedLevel(int level) async {
    final current = getUnlockedLevel();
    if (level > current) {
      await _prefs.setInt(_keyUnlockedLevel, level);
    }
  }

  static int getCoins() {
    return _prefs.getInt(_keyCoins) ?? 0;
  }

  static Future<void> saveCoins(int coins) async {
    await _prefs.setInt(_keyCoins, coins);
  }

  static int getDeaths() {
    return _prefs.getInt(_keyDeaths) ?? 0;
  }

  static Future<void> saveDeaths(int deaths) async {
    await _prefs.setInt(_keyDeaths, deaths);
  }

  static String getSelectedSkin() {
    return _prefs.getString(_keySelectedSkin) ?? 'Classic Robo';
  }

  static Future<void> saveSelectedSkin(String skinName) async {
    await _prefs.setString(_keySelectedSkin, skinName);
  }

  static List<String> getUnlockedSkins() {
    final list = _prefs.getStringList(_keyUnlockedSkins);
    if (list == null) {
      return ['Classic Robo', 'Cyber Ninja', 'Neon Hazard', 'Vaporwave Retro'];
    }
    return List<String>.from(list);
  }

  static Future<void> unlockSkin(String skinName) async {
    final list = getUnlockedSkins();
    if (!list.contains(skinName)) {
      list.add(skinName);
      await _prefs.setStringList(_keyUnlockedSkins, list);
    }
  }

  static Future<void> resetProgress() async {
    await _prefs.setInt(_keyUnlockedLevel, 1);
    await _prefs.setInt(_keyCoins, 0);
    await _prefs.setInt(_keyDeaths, 0);
    await _prefs.setString(_keySelectedSkin, 'Classic Robo');
    await _prefs.remove(_keyUnlockedSkins);
  }
}
