import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../services/shapes_progress_service.dart';
import 'shapes_complete_screen.dart';

class ShapesLessonScreen extends StatefulWidget {
  final int index;

  const ShapesLessonScreen({super.key, required this.index});

  @override
  State<ShapesLessonScreen> createState() =>
      _ShapesLessonScreenState();
}

class _ShapesLessonScreenState extends State<ShapesLessonScreen> {
  /// ⭐ Must match list screen order
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
    _onEnter();
  }

  Future<void> _onEnter() async {
    final data = shapesData[widget.index];

    // ⭐ mark completed immediately (nursery logic)
    await ShapesProgressService.markShapeCompleted(widget.index);

    // ⭐ speak
    Future.delayed(const Duration(milliseconds: 400), () async {
      await TTSService().speak(data["name"]!);
    });

    // ⭐ final completion praise
    if (widget.index == shapesData.length - 1) {
      Future.delayed(const Duration(seconds: 3), () async {
        await TTSService().speak(
          "Wonderful! You finished all shapes!",
        );
      });
    }
  }

  void _speak() async {
    final data = shapesData[widget.index];
    await TTSService().speak(data["name"]!);
  }

  @override
  Widget build(BuildContext context) {
    final data = shapesData[widget.index];
    final name = data["name"]!;
    final image = data["image"]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shapes Lesson"),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// ===== MAIN CONTENT =====
              Column(
                children: [
                  const SizedBox(height: 10),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: _speak,
                    child: Image.asset(
                      image,
                      height: 240,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 28),

                  ElevatedButton.icon(
                    onPressed: _speak,
                    icon: const Icon(Icons.volume_up, size: 28),
                    label: const Text(
                      "Tap to Hear",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ],
              ),

              /// ===== NAVIGATION =====
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    /// PREVIOUS
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.index > 0
                            ? () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ShapesLessonScreen(
                                      index: widget.index - 1,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18),
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// NEXT
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.index <
                              shapesData.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ShapesLessonScreen(
                                  index: widget.index + 1,
                                ),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ShapesCompleteScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Next",
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
      ),
    );
  }
}