import 'package:flame/components.dart';
import '../components/platforms/platform.dart';
import '../components/hazards/lava.dart';

class LevelManager extends Component {
  @override
  Future<void> onLoad() async {
    
    // The Starting Floor
    add(Platform(position: Vector2(0, 300), size: Vector2(1000, 20)));

    // The Lava Pit
    add(Lava(position: Vector2(1000, 300), size: Vector2(400, 20)));

    // The Safe Landing Zone
    add(Platform(position: Vector2(1400, 300), size: Vector2(1000, 20)));

  }
}
