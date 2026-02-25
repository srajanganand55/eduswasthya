import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../../../../screens/nursery_modules_screen.dart';
import '../services/colours_progress_service.dart';
import '../../../../../services/tts_service.dart';
import 'colours_list_screen.dart';

class ColoursCompleteScreen extends StatefulWidget {
  const ColoursCompleteScreen({super.key});

  @override
  State<ColoursCompleteScreen> createState() =>
      _ColoursCompleteScreenState();
}

class _ColoursCompleteScreenState
    extends State<ColoursCompleteScreen> {
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();

    _confetti =
        ConfettiController(duration: const Duration(seconds: 4));
    _confetti.play();

    _speakCongrats();
  }

Future<void> _speakCongrats() async {
  await Future.delayed(const Duration(milliseconds: 500));

  try {
    await TTSService().speak(
      "Excellent! You finished Colours",
    );
  } catch (_) {}
}

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  // ✅ BACK TO SUBJECTS (FIXED — no longer goes to Home)
  void _backToSubjects() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const NurseryModulesScreen(),
      ),
      (route) => false,
    );
  }

  // ✅ RESTART COLOURS
Future<void> _restartColours() async {
  await ColoursProgressService.resetColoursProgress();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => ColoursListScreen(),
    ),
    (route) => route.isFirst,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ⭐ PREMIUM BACKGROUND
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ===== GRADIENT BACKGROUND =====
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE0F7FA),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ===== MAIN CONTENT =====
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ⭐ TITLE
                  const Text(
                    "Excellent!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F8A9E),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "You finished Colours",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ===== BACK TO SUBJECTS =====
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _backToSubjects,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1F8A9E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(32),
                        ),
                        elevation: 6,
                      ),
                      child: const Text(
                        "Back to Subjects",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== RESTART =====
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _restartColours,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(32),
                        ),
                        elevation: 6,
                      ),
                      child: const Text(
                        "Restart Colours",
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

          // ===== PREMIUM CONFETTI =====
          ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality:
                BlastDirectionality.explosive,
            emissionFrequency: 0.04,
            numberOfParticles: 25,
            maxBlastForce: 20,
            minBlastForce: 8,
            gravity: 0.25,
            shouldLoop: false,
          ),
        ],
      ),
    );
  }
}