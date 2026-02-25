import 'package:flutter/material.dart';
import '../services/shapes_progress_service.dart';
import 'shapes_lesson_screen.dart';
import '../main.dart';
import '../theme/app_theme.dart';

class ShapesListScreen extends StatefulWidget {
  const ShapesListScreen({super.key});

  @override
  State<ShapesListScreen> createState() => _ShapesListScreenState();
}

class _ShapesListScreenState extends State<ShapesListScreen>
    with RouteAware {

  int _nextIndex = 0;
  List<int> _completed = [];

  static const List<Map<String, String>> shapesData = [
    {"name": "Circle", "image": "assets/images/circle.png"},
    {"name": "Square", "image": "assets/images/square.png"},
    {"name": "Triangle", "image": "assets/images/triangle.png"},
    {"name": "Rectangle", "image": "assets/images/rectangle.png"},
    {"name": "Star", "image": "assets/images/star.png"},
    {"name": "Oval", "image": "assets/images/oval.png"},
    {"name": "Diamond", "image": "assets/images/diamond.png"},
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
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
    _loadProgress();
  }

  // ================= LOAD =================

  Future<void> _loadProgress() async {
    final completed =
        await ShapesProgressService.getCompletedShapes();

    int next = 0;
    for (int i = 0; i < shapesData.length; i++) {
      if (!completed.contains(i)) {
        next = i;
        break;
      }
      if (i == shapesData.length - 1) {
        next = shapesData.length - 1;
      }
    }

    if (!mounted) return;

    setState(() {
      _completed = completed;
      _nextIndex = next;
    });
  }

  bool _isUnlocked(int index) {
    return index == 0 || _completed.contains(index - 1);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final bool showContinue =
        _completed.isNotEmpty &&
        _completed.length < shapesData.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shapes"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          if (showContinue) _continueBanner(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: shapesData.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final shape = shapesData[index];
                  final unlocked = _isUnlocked(index);
                  final done = _completed.contains(index);

                  return _shapeTile(
                    index: index,
                    name: shape["name"]!,
                    image: shape["image"]!,
                    unlocked: unlocked,
                    done: done,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CONTINUE =================

  Widget _continueBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                "Continue learning from ${shapesData[_nextIndex]["name"]}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ShapesLessonScreen(index: _nextIndex),
                  ),
                );
              },
              child: const Text("Start"),
            )
          ],
        ),
      ),
    );
  }

  // ================= TILE =================

  Widget _shapeTile({
    required int index,
    required String name,
    required String image,
    required bool unlocked,
    required bool done,
  }) {
    // ⭐⭐⭐ CRITICAL — 4 STATE COLOR LOGIC ⭐⭐⭐
    Color tileColor;

    if (done) {
      tileColor = Colors.green;
    } else if (index == _nextIndex) {
      tileColor = Colors.orange; // current learning tile
    } else if (unlocked) {
      tileColor = AppTheme.primaryColor; // unlocked but not current
    } else {
      tileColor = Colors.grey.shade400; // locked
    }

    return GestureDetector(
      onTap: unlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShapesLessonScreen(index: index),
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: Center(
                      child: SizedBox(
                        width: 110,
                        height: 110,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.asset(image),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (!unlocked)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.lock, color: Colors.white),
              ),

            if (done)
              const Positioned(
                top: 8,
                left: 8,
                child: Icon(Icons.check_circle, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}