import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/tts_service.dart';
import 'alphabet_complete_screen.dart';

class AlphabetLessonScreen extends StatefulWidget {
  final int index;

  const AlphabetLessonScreen({
    super.key,
    required this.index,
  });

  @override
  State<AlphabetLessonScreen> createState() => _AlphabetLessonScreenState();
}

class _AlphabetLessonScreenState extends State<AlphabetLessonScreen> {

  static const List<Map<String, String>> alphabetData = [
    {"letter": "A", "word": "Apple", "image": "assets/images/apple.png"},
    {"letter": "B", "word": "Ball", "image": "assets/images/ball.png"},
    {"letter": "C", "word": "Cat", "image": "assets/images/cat.png"},
    {"letter": "D", "word": "Dog", "image": "assets/images/placeholder.png"},
    {"letter": "E", "word": "Elephant", "image": "assets/images/placeholder.png"},
    {"letter": "F", "word": "Fish", "image": "assets/images/placeholder.png"},
    {"letter": "G", "word": "Grapes", "image": "assets/images/placeholder.png"},
    {"letter": "H", "word": "Hen", "image": "assets/images/placeholder.png"},
    {"letter": "I", "word": "Ice Cream", "image": "assets/images/placeholder.png"},
    {"letter": "J", "word": "Jug", "image": "assets/images/placeholder.png"},
    {"letter": "K", "word": "Kite", "image": "assets/images/placeholder.png"},
    {"letter": "L", "word": "Lion", "image": "assets/images/placeholder.png"},
    {"letter": "M", "word": "Mango", "image": "assets/images/placeholder.png"},
    {"letter": "N", "word": "Nest", "image": "assets/images/placeholder.png"},
    {"letter": "O", "word": "Orange", "image": "assets/images/placeholder.png"},
    {"letter": "P", "word": "Parrot", "image": "assets/images/placeholder.png"},
    {"letter": "Q", "word": "Queen", "image": "assets/images/placeholder.png"},
    {"letter": "R", "word": "Rabbit", "image": "assets/images/placeholder.png"},
    {"letter": "S", "word": "Sun", "image": "assets/images/placeholder.png"},
    {"letter": "T", "word": "Tiger", "image": "assets/images/placeholder.png"},
    {"letter": "U", "word": "Umbrella", "image": "assets/images/placeholder.png"},
    {"letter": "V", "word": "Van", "image": "assets/images/placeholder.png"},
    {"letter": "W", "word": "Watch", "image": "assets/images/placeholder.png"},
    {"letter": "X", "word": "Xylophone", "image": "assets/images/placeholder.png"},
    {"letter": "Y", "word": "Yak", "image": "assets/images/placeholder.png"},
    {"letter": "Z", "word": "Zebra", "image": "assets/images/placeholder.png"},
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () async {
      final data = alphabetData[widget.index];
      await TTSService().speak("${data["letter"]} for ${data["word"]}");

      // ⭐ Praise when reaching last letter
      if (widget.index == alphabetData.length - 1) {
        Future.delayed(const Duration(seconds: 3), () async {
          await TTSService().speak("Great job! You finished all letters");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = alphabetData[widget.index];
    final letter = data["letter"]!;
    final word = data["word"]!;
    final image = data["image"]!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Alphabet Lesson"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// MAIN CONTENT
              Column(
                children: [
                  const SizedBox(height: 20),

                  Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "$letter for $word",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  GestureDetector(
                    onTap: () async {
                      await TTSService().speak("$letter for $word");
                    },
                    child: Image.asset(image, height: 220),
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton.icon(
                    onPressed: () async {
                      await TTSService().speak("$letter for $word");
                    },
                    icon: const Icon(Icons.volume_up, size: 28),
                    label: const Text(
                      "Tap to Hear",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ],
              ),

              /// NAVIGATION BUTTONS
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
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
                                    builder: (_) => AlphabetLessonScreen(
                                      index: widget.index - 1,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Previous",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// NEXT (includes completion logic)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.index < alphabetData.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AlphabetLessonScreen(
                                  index: widget.index + 1,
                                ),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AlphabetCompleteScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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