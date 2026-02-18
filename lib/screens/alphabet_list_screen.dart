import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'alphabet_lesson_screen.dart';

class AlphabetListScreen extends StatelessWidget {
  AlphabetListScreen({super.key});

  final List<String> alphabets = List.generate(
    26,
    (index) => String.fromCharCode(65 + index),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Alphabets",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: alphabets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final letter = alphabets[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AlphabetLessonScreen(index: index),
                      ),
                    );
                  },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length]
                      .shade300,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}