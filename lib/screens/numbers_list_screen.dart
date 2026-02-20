import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/numbers_progress_service.dart';
import 'numbers_lesson_screen.dart';
import '../main.dart';

class NumbersListScreen extends StatefulWidget {
  const NumbersListScreen({super.key});

  @override
  State<NumbersListScreen> createState() => _NumbersListScreenState();
}

class _NumbersListScreenState extends State<NumbersListScreen>
    with RouteAware {

  List<int> completedNumbers = [];
  int nextNumberIndex = 0;

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

  @override
  void didPopNext() {
    loadProgress();
  }

  Future<void> loadProgress() async {
    completedNumbers = await NumbersProgressService.getCompletedNumbers();

    nextNumberIndex = 0;
    for (int i = 0; i < 10; i++) {
      if (!completedNumbers.contains(i)) {
        nextNumberIndex = i;
        break;
      }
      if (i == 9) nextNumberIndex = 9;
    }

    setState(() {});
  }

  bool isCompleted(int i) => completedNumbers.contains(i);
  bool isUnlocked(int i) => i == 0 || completedNumbers.contains(i - 1);

  @override
  Widget build(BuildContext context) {
    List<String> numbers = List.generate(10, (i) => "${i + 1}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Numbers"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [

          /// Continue Learning Banner
          if (completedNumbers.isNotEmpty && completedNumbers.length < 10)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.school, size: 40, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Continue learning from Number ${numbers[nextNumberIndex]}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NumbersLessonScreen(index: nextNumberIndex),
                          ),
                        );
                      },
                      child: const Text("Start"),
                    )
                  ],
                ),
              ),
            ),

          /// Numbers Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: numbers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (_, i) {
                bool completed = isCompleted(i);
                bool unlocked = isUnlocked(i);

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
                              builder: (_) => NumbersLessonScreen(index: i),
                            ),
                          );
                        }
                      : null,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            numbers[i],
                            style: const TextStyle(
                              fontSize: 42,
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