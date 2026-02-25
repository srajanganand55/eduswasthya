import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/tts_service.dart';
import '../services/progress_service.dart';
import 'alphabet_complete_screen.dart';

class AlphabetLessonScreen extends StatefulWidget {
  final int index;
  const AlphabetLessonScreen({super.key, required this.index});

  @override
  State<AlphabetLessonScreen> createState() => _AlphabetLessonScreenState();
}

class _AlphabetLessonScreenState extends State<AlphabetLessonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const List<Map<String, String>> alphabetData = [
    {"letter": "A", "word": "Apple", "image": "assets/images/apple.png"},
    {"letter": "B", "word": "Ball", "image": "assets/images/ball.png"},
    {"letter": "C", "word": "Cat", "image": "assets/images/cat.png"},
    {"letter": "D", "word": "Dog", "image": "assets/images/dog.png"},
    {"letter": "E", "word": "Elephant", "image": "assets/images/elephant.png"},
    {"letter": "F", "word": "Fish", "image": "assets/images/fish.png"},
    {"letter": "G", "word": "Grapes", "image": "assets/images/grapes.png"},
    {"letter": "H", "word": "Hen", "image": "assets/images/hen.png"},
    {"letter": "I", "word": "Ice Cream", "image": "assets/images/icecream.png"},
    {"letter": "J", "word": "Jug", "image": "assets/images/jug.png"},
    {"letter": "K", "word": "Kite", "image": "assets/images/kite.png"},
    {"letter": "L", "word": "Lion", "image": "assets/images/lion.png"},
    {"letter": "M", "word": "Mango", "image": "assets/images/mango.png"},
    {"letter": "N", "word": "Nest", "image": "assets/images/nest.png"},
    {"letter": "O", "word": "Orange", "image": "assets/images/orange.png"},
    {"letter": "P", "word": "Parrot", "image": "assets/images/parrot.png"},
    {"letter": "Q", "word": "Queen", "image": "assets/images/queen.png"},
    {"letter": "R", "word": "Rabbit", "image": "assets/images/rabbit.png"},
    {"letter": "S", "word": "Sun", "image": "assets/images/sun.png"},
    {"letter": "T", "word": "Tiger", "image": "assets/images/tiger.png"},
    {"letter": "U", "word": "Umbrella", "image": "assets/images/umbrella.png"},
    {"letter": "V", "word": "Van", "image": "assets/images/van.png"},
    {"letter": "W", "word": "Watch", "image": "assets/images/watch.png"},
    {"letter": "X", "word": "X-ray", "image": "assets/images/xray.png"},
    {"letter": "Y", "word": "Yak", "image": "assets/images/yak.png"},
    {"letter": "Z", "word": "Zebra", "image": "assets/images/zebra.png"},
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    _markAndSpeak();
  }

  Future<void> _markAndSpeak() async {
    await Future.delayed(const Duration(milliseconds: 300));

    await ProgressService.markLetterCompleted(widget.index);

    final data = alphabetData[widget.index];
    await TTSService().speak("${data["letter"]} for ${data["word"]}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ================= NAV =================

  void goNext() async {
    if (widget.index < 25) {
      Navigator.pushReplacement(
        context,
        _createRoute(
          AlphabetLessonScreen(index: widget.index + 1),
        ),
      );
    } else {
      final done = await ProgressService.isAlphabetFullyCompleted();

      if (done && mounted) {
        Navigator.pushReplacement(
          context,
          _createRoute(const AlphabetCompleteScreen()),
        );
      }
    }
  }

  void goPrevious() {
    if (widget.index > 0) {
      Navigator.pushReplacement(
        context,
        _createRoute(
          AlphabetLessonScreen(index: widget.index - 1),
        ),
      );
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = alphabetData[widget.index];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Alphabet Lesson"),
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFE9EEF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        children: [
                          Text(
                            data["letter"]!,
                            style: const TextStyle(
                              fontSize: 95,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "${data["letter"]} for ${data["word"]}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Image.asset(data["image"]!, height: 200),
                          const SizedBox(height: 35),
                          ElevatedButton.icon(
                            onPressed: () async =>
                                await TTSService().speak(
                                    "${data["letter"]} for ${data["word"]}"),
                            icon: const Icon(Icons.volume_up, size: 32),
                            label: const Text(
                              "Tap to Hear",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ===== NAV BAR =====

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.index > 0 ? goPrevious : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding:
                              const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: goNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding:
                              const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
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