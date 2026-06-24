import 'package:flame/components.dart';
import '../components/platforms/platform.dart';

class LevelManager extends Component {
  @override
  Future<void> onLoad() async {
    
    // The Starting Floor (So the player doesn't instantly fall to their death)
    add(
      Platform(
        position: Vector2(0, 300),
        size: Vector2(1000, 20), // 1000 pixels wide
      ),
    );

    // This is where we will build the gaps and fake traps you drew!

  }
}
