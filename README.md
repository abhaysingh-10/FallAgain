# Fall Again 

A 2D platformer game built with [Flutter](https://flutter.dev/) and the [Flame Engine](https://flame-engine.org/). 

*Inspired by the chaotic fun of **Level Devil**, this game will test your patience and reflexes!*

Navigate through levels, jump across platforms, avoid hazards, and gather collectibles! The game features a retro-futuristic UI, character selection, multiple levels, and progress tracking.

---

##  Screenshots & Gameplay


### Screenshots
| Main Menu / UI | Gameplay 1 | Gameplay 2 |
| :---: | :---: | :---: |
| <img src="photos/Simulator%20Screenshot%20-%20iPhone%2017%20-%202026-08-14%20at%2014.26.43.png" width="250" /> | <img src="photos/Simulator%20Screenshot%20-%20iPhone%2017%20-%202026-08-14%20at%2014.27.07.png" width="250" /> | <img src="photos/image.png" width="250" /> |
| <img src="photos/Simulator%20Screenshot%20-%20iPhone%2017%20-%202026-08-14%20at%2015.11.28.png" width="250" /> | <img src="photos/Simulator%20Screenshot%20-%20iPhone%2017%20-%202026-08-14%20at%2015.11.35.png" width="250" /> | <img src="photos/Simulator%20Screenshot%20-%20iPhone%2017%20-%202026-08-14%20at%2014.27.34.png" width="250" /> |

---

##  Features

- **Built with Flame:** Physics-based 2D movement and collision detection.
- **Multiple Levels:** Choose and play through beautifully designed levels.
- **Character Selection:** Pick your favorite character to play.
- **Hazards & Collectibles:** Avoid spikes/traps and collect items to increase your score.
- **Audio & Music:** Immersive background music and sound effects using `flame_audio`.
- **Persistent Save Data:** Your level progress and unlocked characters are saved locally using `shared_preferences`.
- **Landscape Mode:** Enforced immersive landscape orientation for a true mobile gaming experience.

---

## Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Game Engine:** [Flame](https://pub.dev/packages/flame)
- **Audio:** [Flame Audio](https://pub.dev/packages/flame_audio)
- **Typography:** [Google Fonts (Orbitron)](https://pub.dev/packages/google_fonts)
- **Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)

---

##  Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.0.0 or higher)
- Dart SDK
- An Android/iOS Emulator or a physical device.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/fall_again.git
   cd fall_again
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the game:**
   ```bash
   flutter run
   ```

---

##  Project Structure

- `lib/game/`: Contains the core Flame game loop (`FallAgainGame`).
- `lib/components/`: Game entities like `players`, `platforms`, `hazards`, `collectibles`, and `background`.
- `lib/levels/`: Logic for loading and rendering individual level layouts.
- `lib/managers/`: Managers for audio and save data (`AudioManager`, `SaveManager`).
- `lib/ui/`: Flutter UI overlays that sit on top of the game (Main Menu, Pause Menu, Level Selection, etc.).
