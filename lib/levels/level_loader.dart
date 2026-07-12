import 'dart:convert';
import 'package:flutter/services.dart';
import 'level_data.dart';

class LevelLoader {
  static Future<LevelData> loadLevel(int levelNumber) async {
    final jsonString = await rootBundle.loadString('assets/levels/level_$levelNumber.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return LevelData.fromJson(jsonMap);
  }
}
