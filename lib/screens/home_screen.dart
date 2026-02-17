import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<bool> _onBackPressed(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Do you want to close EduSwasthya?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            onPressed: () {
              SystemNavigator.pop(); // 🔥 closes the app completely
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("EduSwasthya"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Hello 👋",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "What would you like to learn today?",
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textLight,
                ),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  children: const [

                    CategoryCard(
                      title: "Kids Learning",
                      icon: Icons.menu_book,
                      color: Colors.orange,
                    ),

                    CategoryCard(
                      title: "Health & Hygiene",
                      icon: Icons.health_and_safety,
                      color: Colors.green,
                    ),

                    CategoryCard(
                      title: "Food & Nutrition",
                      icon: Icons.restaurant,
                      color: Colors.redAccent,
                    ),

                    CategoryCard(
                      title: "Safety & First Aid",
                      icon: Icons.warning,
                      color: Colors.blue,
                    ),

                    CategoryCard(
                      title: "Parents Corner",
                      icon: Icons.family_restroom,
                      color: Colors.purple,
                    ),

                    CategoryCard(
                      title: "Mind & Emotions",
                      icon: Icons.psychology,
                      color: Colors.teal,
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

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(icon, size: 40, color: color),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}