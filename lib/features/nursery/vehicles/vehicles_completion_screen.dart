import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../content/vehicles_data.dart';
import '../engine/nursery_lesson_engine.dart';
import '../engine/nursery_module_entry_screen.dart';
import '../shared/nursery_module_theme.dart';
import '../../../screens/nursery_modules_screen.dart';
import '../../../services/tts_service.dart';
import 'vehicles_module_config.dart';

class VehiclesCompletionScreen extends StatefulWidget {
  const VehiclesCompletionScreen({super.key});

  @override
  State<VehiclesCompletionScreen> createState() =>
      _VehiclesCompletionScreenState();
}

class _VehiclesCompletionScreenState
    extends State<VehiclesCompletionScreen> {
  final NurseryLessonEngine<VehicleItem> _engine =
      NurseryLessonEngine<VehicleItem>(config: vehiclesModuleConfig);
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    )..play();

    Future<void>.delayed(const Duration(milliseconds: 350), () async {
      try {
        await TTSService().speak('Vehicles completed');
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _backToNurseryModules() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const NurseryModulesScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _restartVehicles() async {
    await _engine.resetModuleProgress();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => NurseryModuleEntryScreen(
          config: vehiclesModuleConfig,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF7EE),
                  Color(0xFFF2FBFD),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 24,
              gravity: 0.22,
              shouldLoop: false,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 128,
                    width: 128,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.celebration_rounded,
                      size: 68,
                      color: nurseryModuleColor('vehicles'),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Vehicles Completed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: nurseryModuleColor('vehicles'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Every vehicle lesson is unlocked and finished.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _restartVehicles,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Restart Vehicles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _backToNurseryModules,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F8A9E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Back to Nursery Modules',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
