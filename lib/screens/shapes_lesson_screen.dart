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

  bool get _isFirst => currentIndex == 0;
  bool get _isLast => currentIndex == shapes.length - 1;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;

    ShapesProgressService.markShapeCompleted(currentIndex);

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

    if (_isLast) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ShapesCompleteScreen(),
        ),
      );
      return;
    }

    setState(() => currentIndex++);
    Future.delayed(const Duration(milliseconds: 300), _speakShape);
  }

  void _goPrevious() {
    if (_isFirst) return;

    setState(() => currentIndex--);
    Future.delayed(const Duration(milliseconds: 300), _speakShape);
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    SizedBox(
                      height: 220,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset(shape["image"]!),
                      ),
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _speakShape,
                        icon: const Icon(Icons.volume_up),
                        label: const Text("Tap to Hear"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 18),
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

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
              child: Row(
                children: [
                  Expanded(
                    child: _PillNavButton(
                      label: "Previous",
                      enabled: !_isFirst,
                      enabledColor: Colors.orange,
                      disabledColor: Colors.grey.shade400,
                      onTap: _goPrevious,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _PillNavButton(
                      label: "Next",
                      enabled: true, // ⭐ always enabled
                      enabledColor: const Color(0xFF1F8A9E),
                      disabledColor: Colors.grey.shade400,
                      onTap: _goNext,
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

/// ⭐ shared button
class _PillNavButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final Color enabledColor;
  final Color disabledColor;
  final VoidCallback onTap;

  const _PillNavButton({
    required this.label,
    required this.enabled,
    required this.enabledColor,
    required this.disabledColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = enabled ? enabledColor : disabledColor;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}