import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static bool playSFX = true;
  static bool playBGM = true;

  static Future<void> init() async {
    try {
      // AudioPlayer bgm initialization is handled by flame_audio's FlameAudio.bgm
      await FlameAudio.audioCache.loadAll([
        'jump.wav',
        'coin.wav',
        'death.wav',
        'checkpoint.wav',
        'level_complete.wav',
        'bgm.ogg',
      ]);
    } catch (e) {
      // Ignored: safe fallback if asset files do not exist yet.
    }
  }

  static void playJump() {
    if (!playSFX) return;
    try {
      FlameAudio.play('jump.wav');
    } catch (e) {
      // Ignored: silent fallback when asset is missing
    }
  }

  static void playCoin() {
    if (!playSFX) return;
    try {
      FlameAudio.play('coin.wav');
    } catch (e) {
      // Ignored: silent fallback when asset is missing
    }
  }

  static void playDeath() {
    if (!playSFX) return;
    try {
      FlameAudio.play('death.wav');
    } catch (e) {
      // Ignored: silent fallback when asset is missing
    }
  }

  static void playLevelComplete() {
    if (!playSFX) return;
    try {
      FlameAudio.play('level_complete.wav');
    } catch (e) {
      // Ignored: silent fallback when asset is missing
    }
  }

  static void playCheckpoint() {
    if (!playSFX) return;
    try {
      FlameAudio.play('checkpoint.wav');
    } catch (e) {
      // Ignored: silent fallback when asset is missing
    }
  }

  static void startBgm() {
    if (!playBGM) return;
    try {
      FlameAudio.bgm.play('bgm.ogg');
    } catch (e) {
      // Ignored: silent fallback when asset is missing
    }
  }

  static void stopBgm() {
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      // Ignored: silent fallback when asset is missing
    }
  }
}
