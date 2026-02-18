import 'package:flutter/material.dart';
import 'alphabet_list_screen.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {"title": "Alphabets", "icon": Icons.sort_by_alpha, "color": Colors.blue},
      {"title": "Numbers", "icon": Icons.looks_one_rounded, "color": Colors.green},
      {"title": "General Knowledge", "icon": Icons.public, "color": Colors.orange},
      {"title": "Health & Hygiene", "icon": Icons.health_and_safety, "color": Colors.red},
      {"title": "Stories", "icon": Icons.menu_book, "color": Colors.purple},
      {"title": "Rhymes", "icon": Icons.music_note, "color": Colors.teal},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Subject"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: GridView.builder(
          itemCount: subjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = subjects[index];

            return GestureDetector(
              onTap: () {
                if (item["title"] == "Alphabets") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AlphabetListScreen(),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: item["color"] as Color,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item["icon"] as IconData,
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        item["title"] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}