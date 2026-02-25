import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/tts_service.dart';
import '../services/progress_service.dart';
import 'numbers_complete_screen.dart';

class NumbersLessonScreen extends StatefulWidget {
  final int index;
  const NumbersLessonScreen({super.key, required this.index});

  @override
  State<NumbersLessonScreen> createState() =>
      _NumbersLessonScreenState();
}

class _NumbersLessonScreenState extends State<NumbersLessonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const List<Map<String, String>> numbersData = [
    {"number": "1", "word": "One", "image": "assets/images/1.png"},
    {"number": "2", "word": "Two", "image": "assets/images/2.png"},
    {"number": "3", "word": "Three", "image": "assets/images/3.png"},
    {"number": "4", "word": "Four", "image": "assets/images/4.png"},
    {"number": "5", "word": "Five", "image": "assets/images/5.png"},
    {"number": "6", "word": "Six", "image": "assets/images/6.png"},
    {"number": "7", "word": "Seven", "image": "assets/images/7.png"},
    {"number": "8", "word": "Eight", "image": "assets/images/8.png"},
    {"number": "9", "word": "Nine", "image": "assets/images/9.png"},
    {"number": "10", "word": "Ten", "image": "assets/images/10.png"},
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600));

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation =
        Tween<double>(begin: 0.85, end: 1.0)
            .animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOutBack));

    _controller.forward();

    _markAndSpeak();
  }

  Future<void> _markAndSpeak() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // ✅ WRITE TO UNIFIED SERVICE
    await ProgressService.markNumberCompleted(widget.index);

    final data = numbersData[widget.index];
    await TTSService().speak(data["word"]!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ================= NAV =================

  void goNext() async {
    if (widget.index < 9) {
      Navigator.pushReplacement(
        context,
        _createRoute(
            NumbersLessonScreen(index: widget.index + 1)),
      );
    } else {
      final done =
          await ProgressService.isNumbersFullyCompleted();

      if (done && mounted) {
        Navigator.pushReplacement(
          context,
          _createRoute(
              const NumbersCompleteScreen()),
        );
      }
    }
  }

  void goPrevious() {
    if (widget.index > 0) {
      Navigator.pushReplacement(
        context,
        _createRoute(
            NumbersLessonScreen(index: widget.index - 1)),
      );
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: 300),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder:
          (_, animation, __, child) {
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
    final data = numbersData[widget.index];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Numbers Lesson"),
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF5F7FA),
              Color(0xFFE9EEF3)
            ],
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
                      padding:
                          const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16),
                      child: Column(
                        children: [
                          Text(
                            data["number"]!,
                            style: const TextStyle(
                                fontSize: 95,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    AppTheme.primaryColor),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data["word"]!,
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          const SizedBox(height: 25),
                          Image.asset(
                              data["image"]!,
                              height: 200),
                          const SizedBox(height: 35),
                          ElevatedButton.icon(
                            onPressed: () async =>
                                await TTSService()
                                    .speak(
                                        data["word"]!),
                            icon: const Icon(
                                Icons.volume_up,
                                size: 32),
                            label: const Text(
                              "Tap to Hear",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold),
                            ),
                            style: ElevatedButton
                                .styleFrom(
                              backgroundColor:
                                  Colors.green,
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                      horizontal:
                                          40,
                                      vertical:
                                          18),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            30),
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
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                        20, 10, 20, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            widget.index > 0
                                ? goPrevious
                                : null,
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              Colors.orange,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                                      vertical:
                                          20),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        24),
                          ),
                        ),
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight
                                      .bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: goNext,
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              AppTheme
                                  .primaryColor,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                                      vertical:
                                          20),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        24),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight
                                      .bold),
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