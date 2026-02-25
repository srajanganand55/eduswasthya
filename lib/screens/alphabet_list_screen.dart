import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/progress_service.dart';
import 'alphabet_lesson_screen.dart';
import '../main.dart';

class AlphabetListScreen extends StatefulWidget {
  const AlphabetListScreen({super.key});

  @override
  State<AlphabetListScreen> createState() => _AlphabetListScreenState();
}

class _AlphabetListScreenState extends State<AlphabetListScreen>
    with RouteAware {
  List<int> completedLetters = [];
  int nextLetterIndex = 0;
  bool showContinue = false;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// ⭐ refresh when returning from lesson
  @override
  void didPopNext() {
    loadProgress();
  }

  Future<void> loadProgress() async {
    completedLetters = await ProgressService.getCompletedLetters();

    final lastIndex =
        await ProgressService.getAlphabetLastIndex();

    final hasPartial =
        await ProgressService.hasStartedAlphabetButNotFinished();

    showContinue = hasPartial;

    // ✅ compute next index safely
    nextLetterIndex = 0;
    for (int i = 0; i < 26; i++) {
      if (!completedLetters.contains(i)) {
        nextLetterIndex = i;
        break;
      }
      if (i == 25) nextLetterIndex = 25;
    }

    if (mounted) setState(() {});
  }

  bool isLetterCompleted(int i) => completedLetters.contains(i);

  bool isLetterUnlocked(int i) =>
      i == 0 || completedLetters.contains(i - 1);

  @override
  Widget build(BuildContext context) {
    List<String> letters =
        List.generate(26, (i) => String.fromCharCode(65 + i));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alphabets"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          /// ===== CONTINUE BANNER =====
          if (showContinue)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade300,
                      Colors.orange.shade200,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.school,
                        size: 40, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Continue learning from Letter ${letters[nextLetterIndex]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AlphabetLessonScreen(
                                    index: nextLetterIndex),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                      ),
                      child: const Text("Continue"),
                    )
                  ],
                ),
              ),
            ),

          /// ===== GRID =====
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: letters.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                bool completed = isLetterCompleted(i);
                bool unlocked = isLetterUnlocked(i);

                Color tileColor = completed
                    ? Colors.green
                    : unlocked
                        ? AppTheme.primaryColor
                        : Colors.grey.shade400;

                return GestureDetector(
                  onTap: unlocked
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AlphabetLessonScreen(index: i),
                            ),
                          );
                        }
                      : null,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            letters[i],
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (completed)
                        const Positioned(
                          top: 6,
                          right: 6,
                          child: Icon(Icons.check_circle,
                              color: Colors.white, size: 24),
                        ),
                      if (!unlocked)
                        const Positioned(
                          top: 6,
                          right: 6,
                          child:
                              Icon(Icons.lock, color: Colors.white, size: 24),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}