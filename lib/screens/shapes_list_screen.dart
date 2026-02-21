import 'package:flutter/material.dart';
import '../services/shapes_progress_service.dart';
import 'shapes_lesson_screen.dart';

class ShapesListScreen extends StatefulWidget {
  const ShapesListScreen({super.key});

  @override
  State<ShapesListScreen> createState() => _ShapesListScreenState();
}

class _ShapesListScreenState extends State<ShapesListScreen> {
  int _nextIndex = 0;
  List<int> _completed = [];

  /// ⭐ Nursery shapes (keep order fixed)
  static const List<Map<String, String>> shapesData = [
    {"name": "Circle", "image": "assets/images/shapes/circle.png"},
    {"name": "Square", "image": "assets/images/shapes/square.png"},
    {"name": "Triangle", "image": "assets/images/shapes/triangle.png"},
    {"name": "Rectangle", "image": "assets/images/shapes/rectangle.png"},
    {"name": "Star", "image": "assets/images/shapes/star.png"},
    {"name": "Heart", "image": "assets/images/shapes/heart.png"},
    {"name": "Oval", "image": "assets/images/shapes/oval.png"},
    {"name": "Diamond", "image": "assets/images/shapes/diamond.png"},
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed =
        await ShapesProgressService.getCompletedShapes();

    int next = 0;
    while (completed.contains(next)) {
      next++;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shapes"),
      ),
      body: Column(
        children: [
          /// ⭐ Continue learning banner
          if (_nextIndex < shapesData.length)
            _continueBanner(),

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
                  childAspectRatio: 0.95,
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

  // ================= CONTINUE BANNER =================

  Widget _continueBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.school, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Continue learning from ${shapesData[_nextIndex]["name"]}",
                style: const TextStyle(
                  fontSize: 16,
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
                ).then((_) => _loadProgress());
              },
              child: const Text("Start"),
            ),
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
    return GestureDetector(
      onTap: unlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShapesLessonScreen(index: index),
                ),
              ).then((_) => _loadProgress());
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: unlocked ? Colors.orange : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    image,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                child: Icon(Icons.check_circle,
                    color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}