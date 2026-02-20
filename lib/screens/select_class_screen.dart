import 'package:flutter/material.dart';
import 'subjects_screen.dart';
import 'nursery_modules_screen.dart';

class SelectClassScreen extends StatelessWidget {
  const SelectClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = [
      {"title": "Nursery", "icon": Icons.child_care, "color": Colors.pink},
      {"title": "LKG", "icon": Icons.toys, "color": Colors.orange},
      {"title": "UKG", "icon": Icons.auto_stories, "color": Colors.purple},
      {"title": "Class 1", "icon": Icons.filter_1, "color": Colors.blue},
      {"title": "Class 2", "icon": Icons.filter_2, "color": Colors.teal},
      {"title": "Class 3", "icon": Icons.filter_3, "color": Colors.green},
      {"title": "Class 4", "icon": Icons.filter_4, "color": Colors.indigo},
      {"title": "Class 5", "icon": Icons.filter_5, "color": Colors.red},
      {"title": "Class 6", "icon": Icons.filter_6, "color": Colors.cyan},
      {"title": "Class 7", "icon": Icons.filter_7, "color": Colors.amber},
      {"title": "Class 8", "icon": Icons.filter_8, "color": Colors.deepPurple},
      {"title": "Class 9", "icon": Icons.filter_9, "color": Colors.brown},
      {"title": "Class 10", "icon": Icons.school, "color": Colors.deepOrange},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Class"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: GridView.builder(
          itemCount: classes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = classes[index];
            final title = item["title"] as String;

            return GestureDetector(
              onTap: () {

                /// ⭐ SPECIAL FLOW FOR NURSERY
                if (title == "Nursery") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NurseryModulesScreen(),
                    ),
                  );
                }

                /// OTHER CLASSES → SUBJECTS SCREEN
                else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SubjectsScreen(),
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
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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