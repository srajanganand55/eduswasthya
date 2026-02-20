import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../theme/app_theme.dart';
import '../services/progress_service.dart';
import '../services/tts_service.dart';
import 'numbers_lesson_screen.dart';
import 'nursery_modules_screen.dart';

class NumbersCompleteScreen extends StatefulWidget {
  const NumbersCompleteScreen({super.key});

  @override
  State<NumbersCompleteScreen> createState() =>
      _NumbersCompleteScreenState();
}

class _NumbersCompleteScreenState extends State<NumbersCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _trophyController;
  late Animation<double> _scaleAnim;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    // ⭐⭐⭐ CRITICAL — mark completion
    _markNumbersCompleted();

    /// 🎉 Confetti
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3))
          ..play();

    /// 🔊 Voice
    Future.delayed(const Duration(milliseconds: 400), () async {
      await TTSService().speak(
        "Amazing! You finished all numbers. Great job!",
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

  Future<void> _markNumbersCompleted() async {
    await ProgressService.markNumbersCompleted();
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

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
          /// 🔵 Blue celebration background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFF90CAF9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// 🎉 Confetti burst
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
                  "Amazing!",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "You finished all numbers!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      /// ✅ Back to Subjects
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const NurseryModulesScreen(),
                              ),
                              (route) => route.isFirst,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 18),
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

                      /// 🔄 Restart Numbers
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await ProgressService.resetNumbersProgress();

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const NumbersLessonScreen(index: 0),
                              ),
                              (route) => route.isFirst,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            "Restart Numbers",
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