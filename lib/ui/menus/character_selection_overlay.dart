import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/fall_again_game.dart';
import '../../managers/save_manager.dart';

class CharacterSelectionOverlay extends StatefulWidget {
  final FallAgainGame game;

  const CharacterSelectionOverlay({super.key, required this.game});

  @override
  State<CharacterSelectionOverlay> createState() => _CharacterSelectionOverlayState();
}

class _CharacterSelectionOverlayState extends State<CharacterSelectionOverlay> {
  final List<SkinConfig> skins = [
    // Free Squarish Skins
    SkinConfig(
      name: 'Classic Robo',
      bodyStart: const Color(0xFF00D2FF),
      bodyEnd: const Color(0xFF0066FF),
      visor: const Color(0xFF0F172A),
      eyes: const Color(0xFF00F5FF),
      isHumanoid: false,
    ),
    SkinConfig(
      name: 'Neon Phoenix',
      bodyStart: const Color(0xFFFF7E40),
      bodyEnd: const Color(0xFFFF1F40),
      visor: const Color(0xFF2E080C),
      eyes: const Color(0xFFFFD700),
      isHumanoid: false,
    ),
    SkinConfig(
      name: 'Vaporwave Retro',
      bodyStart: const Color(0xFFFF007F),
      bodyEnd: const Color(0xFF6366F1),
      visor: const Color(0xFF1E1035),
      eyes: const Color(0xFFFFE600),
      isHumanoid: false,
    ),
    SkinConfig(
      name: 'Plasmatic Cosmic',
      bodyStart: const Color(0xFF7C3AED),
      bodyEnd: const Color(0xFFC084FC),
      visor: const Color(0xFF1E0B36),
      eyes: const Color(0xFFFDE047),
      isHumanoid: false,
    ),
    
    // Free Humanoid Skins (Trophy/Standard humanoid)
    SkinConfig(
      name: 'Cyber Ninja',
      bodyStart: const Color(0xFF334155),
      bodyEnd: const Color(0xFF0F172A),
      visor: const Color(0xFF000000),
      eyes: const Color(0xFFEF4444),
      isHumanoid: true,
    ),
    SkinConfig(
      name: 'Neon Hazard',
      bodyStart: const Color(0xFFFACC15),
      bodyEnd: const Color(0xFF84CC16),
      visor: const Color(0xFF0F1E10),
      eyes: const Color(0xFF22C55E),
      isHumanoid: true,
    ),

    // Premium Humanoid Skins (Coins Required)
    SkinConfig(
      name: 'Cosmic Cyborg',
      bodyStart: const Color(0xFF7C3AED),
      bodyEnd: const Color(0xFFEC4899),
      visor: const Color(0xFF1F0D3D),
      eyes: const Color(0xFFFBBF24),
      isPremium: true,
      cost: 30,
      isHumanoid: true,
    ),
    SkinConfig(
      name: 'Exo Valkyrie',
      bodyStart: const Color(0xFF06B6D4),
      bodyEnd: const Color(0xFF0891B2),
      visor: const Color(0xFF0F1E24),
      eyes: const Color(0xFF22D3EE),
      isPremium: true,
      cost: 60,
      isHumanoid: true,
    ),
    SkinConfig(
      name: 'Matrix Hacker',
      bodyStart: const Color(0xFF1F2937),
      bodyEnd: const Color(0xFF111827),
      visor: const Color(0xFF000000),
      eyes: const Color(0xFF00FF00),
      isPremium: true,
      cost: 100,
      isHumanoid: true,
    ),
    SkinConfig(
      name: 'Gold Gilded Emperor',
      bodyStart: const Color(0xFFFBBF24),
      bodyEnd: const Color(0xFFB45309),
      visor: const Color(0xFF451A03),
      eyes: const Color(0xFFFFFFFF),
      isPremium: true,
      cost: 150,
      isHumanoid: true,
    ),
  ];

  void _handleSkinTap(SkinConfig skin, bool isUnlocked) {
    if (isUnlocked) {
      setState(() {
        widget.game.selectSkin(skin.name);
      });
    } else {
      final cost = skin.cost;
      if (widget.game.coins >= cost) {
        setState(() {
          widget.game.coins -= cost;
          SaveManager.saveCoins(widget.game.coins);
          SaveManager.unlockSkin(skin.name);
          widget.game.selectSkin(skin.name);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unlocked & Equipped ${skin.name}! -${skin.cost} Coins',
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(color: Colors.greenAccent),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.greenAccent, width: 1.5),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Not enough coins to unlock ${skin.name}! (Needs ${skin.cost})',
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(color: Colors.redAccent),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlockedSkins = SaveManager.getUnlockedSkins();

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.55),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 520,
            height: 480,
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: Column(
              children: [
                // Header with Title & Coin Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CHARACTERS',
                      style: GoogleFonts.orbitron(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.game.coins}',
                            style: GoogleFonts.orbitron(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Character Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: skins.length,
                    itemBuilder: (context, index) {
                      final skin = skins[index];
                      final isSelected = widget.game.selectedSkin == skin.name;
                      final isUnlocked = !skin.isPremium || unlockedSkins.contains(skin.name);

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _handleSkinTap(skin, isUnlocked),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? skin.bodyStart.withOpacity(0.18)
                                : Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? skin.bodyStart
                                  : (isUnlocked ? Colors.white10 : Colors.amber.withOpacity(0.2)),
                              width: 2.0,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Character Preview (Humanoid vs Squarish)
                                  if (skin.isHumanoid)
                                    SizedBox(
                                      height: 42,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Head
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: skin.bodyStart,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          // Torso / Visor
                                          Container(
                                            width: 16,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [skin.bodyStart, skin.bodyEnd],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: 10,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: skin.visor,
                                                  borderRadius: BorderRadius.circular(1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    // Squarish Cube Preview
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [skin.bodyStart, skin.bodyEnd],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 20,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: skin.visor,
                                            borderRadius: BorderRadius.circular(2.5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(width: 3, height: 3, decoration: BoxDecoration(color: skin.eyes, shape: BoxShape.circle)),
                                              Container(width: 3, height: 3, decoration: BoxDecoration(color: skin.eyes, shape: BoxShape.circle)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 8),
                                  Text(
                                    skin.name,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.orbitron(
                                      textStyle: TextStyle(
                                        color: isSelected ? Colors.white : Colors.white60,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Lock Overlay for premium characters
                              if (!isUnlocked)
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: Container(
                                      color: Colors.black54,
                                      child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.lock, color: Colors.amber, size: 18),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.monetization_on, color: Colors.black, size: 10),
                                                const SizedBox(width: 2),
                                                Text(
                                                  '${skin.cost}',
                                                  style: GoogleFonts.orbitron(
                                                    color: Colors.black,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                
                // Back Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    widget.game.overlays.remove('CharacterSelection');
                    widget.game.overlays.add('MainMenu');
                  },
                  child: Text(
                    'BACK',
                    style: GoogleFonts.orbitron(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkinConfig {
  final String name;
  final Color bodyStart;
  final Color bodyEnd;
  final Color visor;
  final Color eyes;
  final bool isPremium;
  final int cost;
  final bool isHumanoid;

  SkinConfig({
    required this.name,
    required this.bodyStart,
    required this.bodyEnd,
    required this.visor,
    required this.eyes,
    this.isPremium = false,
    this.cost = 0,
    this.isHumanoid = false,
  });
}
