import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../theme/app_theme.dart';
import '../services/shapes_progress_service.dart';
import '../services/tts_service.dart';
import 'shapes_list_screen.dart';
import 'nursery_modules_screen.dart';

class ShapesCompleteScreen extends StatefulWidget {
  const ShapesCompleteScreen({super.key});

  @override
  State<ShapesCompleteScreen> createState() =>
      _ShapesCompleteScreenState();
}

class _ShapesCompleteScreenState extends State<ShapesCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _trophyController;
  late Animation<double> _scaleAnim;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    /// 🎉 Confetti
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3))
          ..play();

    /// 🔊 Voice
    Future.delayed(const Duration(milliseconds: 400), () async {
      await TTSService().speak(
        "Fantastic! You finished all shapes. Great job!",
      );
    });

    /// 🏆 Trophy bounce
    _trophyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.9, end: 1.08).animate(
      CurvedAnimation(parent: _trophyController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // ================= BACK TO SUBJECTS =================

  void _backToSubjects() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const NurseryModulesScreen(),
      ),
      (route) => route.isFirst,
    );
  }

  // ================= RESTART SHAPES =================

  Future<void> _restartShapes() async {
    await ShapesProgressService.resetShapesProgress();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const ShapesListScreen(),
      ),
      (route) => false,
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Great Job!"),
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          /// ⭐ Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF3CD),
                  Color(0xFFFFE08A),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// 🎉 Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 25,
              gravity: 0.25,
            ),
          ),

          /// ⭐ Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnim,
                  child: const Icon(
                    Icons.emoji_events,
                    size: 130,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Fantastic!",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "You finished all shapes!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      /// 🔙 Back to Subjects
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _backToSubjects,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding:
                                const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            "Back to Subjects",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🔁 Restart
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _restartShapes,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding:
                                const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            "Restart Shapes",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}