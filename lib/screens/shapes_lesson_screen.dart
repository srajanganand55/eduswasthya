import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../services/shapes_progress_service.dart';
import '../theme/app_theme.dart';
import 'shapes_complete_screen.dart';

class ShapesLessonScreen extends StatefulWidget {
  final int index;

  const ShapesLessonScreen({super.key, required this.index});

  @override
  State<ShapesLessonScreen> createState() => _ShapesLessonScreenState();
}

class _ShapesLessonScreenState extends State<ShapesLessonScreen> {
  late int currentIndex;

  final List<Map<String, String>> shapes = const [
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
    currentIndex = widget.index;

    // ⭐ mark progress immediately (nursery-friendly)
    ShapesProgressService.markShapeCompleted(currentIndex);

    // ⭐ auto speak
    Future.delayed(const Duration(milliseconds: 400), () {
      _speakShape();
    });
  }

  Future<void> _speakShape() async {
    final name = shapes[currentIndex]["name"]!;
    await TTSService().speak(name);
  }

  Future<void> _goNext() async {
    await ShapesProgressService.markShapeCompleted(currentIndex);

    if (currentIndex < shapes.length - 1) {
      setState(() => currentIndex++);
      Future.delayed(const Duration(milliseconds: 300), _speakShape);
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ShapesCompleteScreen(),
        ),
      );
    }
  }

  void _goPrevious() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      Future.delayed(const Duration(milliseconds: 300), _speakShape);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shape = shapes[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shapes Lesson"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// ===== MAIN CONTENT =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// 🔷 BIG SHAPE NAME
                    Text(
                      shape["name"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// 🔷 DOMINANT IMAGE (KEY UPGRADE)
                    SizedBox(
                      height: 220,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset(shape["image"]!),
                      ),
                    ),

                    const SizedBox(height: 36),

                    /// 🔊 PREMIUM BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _speakShape,
                        icon: const Icon(Icons.volume_up),
                        label: const Text("Tap to Hear"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ===== NAV BAR =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goPrevious,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.black87,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        "Previous",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 18,
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
    );
  }
}