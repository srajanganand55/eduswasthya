import 'package:flutter/material.dart';

import '../features/nursery/animals/animals_module_config.dart';
import '../features/nursery/animals/animals_progress_service.dart';
import '../features/nursery/colours/colours_module_config.dart';
import '../features/nursery/colours/services/colours_progress_service.dart';
import '../features/nursery/engine/nursery_module_entry_screen.dart';
import '../features/nursery/fruits/fruits_module_config.dart';
import '../features/nursery/shared/nursery_module_theme.dart';
import '../features/nursery/shared/premium_module_card.dart';
import '../features/nursery/vehicles/vehicles_module_config.dart';
import '../services/progress_service.dart';
import '../services/shapes_progress_service.dart';
import 'alphabet_list_screen.dart';
import 'numbers_list_screen.dart';
import 'shapes_list_screen.dart';

class NurseryModulesScreen extends StatefulWidget {
  const NurseryModulesScreen({super.key});

  @override
  State<NurseryModulesScreen> createState() =>
      _NurseryModulesScreenState();
}

class _NurseryModulesScreenState extends State<NurseryModulesScreen> {
  bool _alphaCompleted = false;
  bool _numbersCompleted = false;
  bool _shapesCompleted = false;
  bool _coloursCompleted = false;
  bool _animalsCompleted = false;
  bool _fruitsCompleted = false;
  bool _vehiclesCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final alphaDone =
        await ProgressService.isAlphabetFullyCompleted();
    final numbersDone =
        await ProgressService.isNumbersFullyCompleted();
    final shapesDone =
        await ShapesProgressService.isShapesFullyCompleted();
    final coloursDone =
        await ColoursProgressService.isColoursFullyCompleted();
    final animalsDone =
        await AnimalsProgressService.isAnimalsFullyCompleted();
    final fruitsDone =
        await fruitsModuleConfig.persistenceAdapter.isModuleCompleted();
    final vehiclesDone =
        await vehiclesModuleConfig.persistenceAdapter.isModuleCompleted();

    if (!mounted) return;

    setState(() {
      _alphaCompleted = alphaDone;
      _numbersCompleted = numbersDone;
      _shapesCompleted = shapesDone;
      _coloursCompleted = coloursDone;
      _animalsCompleted = animalsDone;
      _fruitsCompleted = fruitsDone;
      _vehiclesCompleted = vehiclesDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nursery Learning"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.92,
                children: [
                  _buildLegacyCard(
                    moduleId: 'alphabets',
                    title: 'Alphabets',
                    imagePath: 'assets/images/alphabets_icon.png',
                    isCompleted: _alphaCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AlphabetListScreen(),
                        ),
                      );
                      _loadProgress();
                    },
                  ),
                  _buildLegacyCard(
                    moduleId: 'numbers',
                    title: 'Numbers',
                    imagePath: 'assets/images/numbers_icon.png',
                    isCompleted: _numbersCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NumbersListScreen(),
                        ),
                      );
                      _loadProgress();
                    },
                  ),
                  _buildLegacyCard(
                    moduleId: 'shapes',
                    title: 'Shapes',
                    imagePath: 'assets/images/shapes_icon.png',
                    isCompleted: _shapesCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShapesListScreen(),
                        ),
                      );
                      _loadProgress();
                    },
                  ),
                  _buildLegacyCard(
                    moduleId: 'colours',
                    title: 'Colours',
                    imagePath: 'assets/images/colours_icon.png',
                    isCompleted: _coloursCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NurseryModuleEntryScreen(
                            config: coloursModuleConfig,
                          ),
                        ),
                      );
                      _loadProgress();
                    },
                  ),
                  _buildLegacyCard(
                    moduleId: 'animals',
                    title: 'Animals',
                    imagePath: 'assets/images/animals/dog.png',
                    isCompleted: _animalsCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NurseryModuleEntryScreen(
                            config: animalsModuleConfig,
                          ),
                        ),
                      );
                      _loadProgress();
                    },
                  ),
                  _buildLegacyCard(
                    moduleId: 'fruits',
                    title: 'Fruits',
                    imagePath: 'assets/images/fruits/apple.png',
                    isCompleted: _fruitsCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NurseryModuleEntryScreen(
                            config: fruitsModuleConfig,
                          ),
                        ),
                      );
                      _loadProgress();
                    },
                  ),
                  _buildLegacyCard(
                    moduleId: 'vehicles',
                    title: 'Vehicles',
                    imagePath: 'assets/images/vehicles/car.png',
                    isCompleted: _vehiclesCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NurseryModuleEntryScreen(
                            config: vehiclesModuleConfig,
                          ),
                        ),
                      );
                      _loadProgress();
                    },
                  ),
                  _buildLockedCard(
                    moduleId: 'rhymes',
                    title: 'Rhymes',
                    icon: Icons.music_note_rounded,
                  ),
                  _buildLockedCard(
                    moduleId: 'progress',
                    title: 'Progress Report',
                    icon: Icons.analytics_rounded,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F8A9E),
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    "Back to Classes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegacyCard({
    required String moduleId,
    required String title,
    required String imagePath,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return PremiumModuleCard(
      title: title,
      isLocked: false,
      isCompleted: isCompleted,
      onTap: onTap,
      gradientColors: nurseryModuleGradient(moduleId),
      titleStyle: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: nurseryModuleAccentText(moduleId),
      ),
      visual: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  Widget _buildLockedCard({
    required String moduleId,
    required String title,
    required IconData icon,
  }) {
    return PremiumModuleCard(
      title: title,
      isLocked: true,
      isCompleted: false,
      onTap: null,
      gradientColors: nurseryModuleGradient(moduleId),
      titleStyle: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: nurseryModuleAccentText(moduleId),
      ),
      visual: Icon(
        icon,
        size: 82,
        color: nurseryModuleAccentText(moduleId),
      ),
    );
  }
}
