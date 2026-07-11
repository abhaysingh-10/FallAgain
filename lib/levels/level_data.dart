import 'package:flame/extensions.dart';

class LevelData {
  final int levelNumber;
  final String name;
  final Vector2 startPosition;
  final List<PlatformData> platforms;
  final List<LavaData> lava;
  final List<SpikeData> spikes;
  final List<CheckpointData> checkpoints;
  final List<CoinData> coins;
  final List<TrapData> fallingHazards;
  final List<TrapData> hiddenSpikes;
  final FinishFlagData finishFlag;

  LevelData({
    required this.levelNumber,
    required this.name,
    required this.startPosition,
    required this.platforms,
    required this.lava,
    required this.spikes,
    required this.checkpoints,
    required this.coins,
    required this.fallingHazards,
    required this.hiddenSpikes,
    required this.finishFlag,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      levelNumber: json['levelNumber'] as int,
      name: json['name'] as String? ?? 'Level ${json['levelNumber']}',
      startPosition: Vector2(
        (json['startPosition']['x'] as num).toDouble(),
        (json['startPosition']['y'] as num).toDouble(),
      ),
      platforms: (json['platforms'] as List? ?? [])
          .map((e) => PlatformData.fromJson(e as Map<String, dynamic>))
          .toList(),
      lava: (json['lava'] as List? ?? [])
          .map((e) => LavaData.fromJson(e as Map<String, dynamic>))
          .toList(),
      spikes: (json['spikes'] as List? ?? [])
          .map((e) => SpikeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      checkpoints: (json['checkpoints'] as List? ?? [])
          .map((e) => CheckpointData.fromJson(e as Map<String, dynamic>))
          .toList(),
      coins: (json['coins'] as List? ?? [])
          .map((e) => CoinData.fromJson(e as Map<String, dynamic>))
          .toList(),
      fallingHazards: (json['fallingHazards'] as List? ?? [])
          .map((e) => TrapData.fromJson(e as Map<String, dynamic>))
          .toList(),
      hiddenSpikes: (json['hiddenSpikes'] as List? ?? [])
          .map((e) => TrapData.fromJson(e as Map<String, dynamic>))
          .toList(),
      finishFlag: FinishFlagData.fromJson(
        json['finishFlag'] as Map<String, dynamic>,
      ),
    );
  }
}

class PlatformData {
  final double x;
  final double y;
  final double width;
  final double height;
  final bool isFake;

  PlatformData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.isFake = false,
  });

  factory PlatformData.fromJson(Map<String, dynamic> json) {
    return PlatformData(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      isFake: json['isFake'] as bool? ?? false,
    );
  }
}

class LavaData {
  final double x;
  final double y;
  final double width;
  final double height;

  LavaData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory LavaData.fromJson(Map<String, dynamic> json) {
    return LavaData(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );
  }
}

class SpikeData {
  final double x;
  final double y;
  final double width;
  final double height;
  final bool isMoving;
  final double range;
  final double speed;

  SpikeData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.isMoving = false,
    this.range = 70.0,
    this.speed = 120.0,
  });

  factory SpikeData.fromJson(Map<String, dynamic> json) {
    return SpikeData(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      isMoving: json['isMoving'] as bool? ?? false,
      range: (json['range'] as num? ?? 70.0).toDouble(),
      speed: (json['speed'] as num? ?? 120.0).toDouble(),
    );
  }
}

class CheckpointData {
  final double x;
  final double y;
  final double width;
  final double height;

  CheckpointData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory CheckpointData.fromJson(Map<String, dynamic> json) {
    return CheckpointData(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );
  }
}

class CoinData {
  final double x;
  final double y;

  CoinData({
    required this.x,
    required this.y,
  });

  factory CoinData.fromJson(Map<String, dynamic> json) {
    return CoinData(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }
}

class TrapData {
  final double x;
  final double y;
  final double width;
  final double height;

  TrapData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory TrapData.fromJson(Map<String, dynamic> json) {
    return TrapData(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );
  }
}

class FinishFlagData {
  final double x;
  final double y;
  final double width;
  final double height;

  FinishFlagData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory FinishFlagData.fromJson(Map<String, dynamic> json) {
    return FinishFlagData(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );
  }
}
