import 'package:flutter/material.dart';

class ContinueLearningBanner extends StatelessWidget {
  final String subjectTitle;
  final String nextLessonText;
  final VoidCallback? onTap;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final List<Color> gradientColors;
  final String buttonLabel;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color subjectTextColor;
  final Color nextLessonTextColor;

  const ContinueLearningBanner({
    super.key,
    required this.subjectTitle,
    required this.nextLessonText,
    required this.onTap,
    this.icon = Icons.pets_rounded,
    this.iconColor = const Color(0xFFDB8A00),
    this.iconBackgroundColor = const Color(0xFFFFF3E0),
    this.gradientColors = const [
      Color(0xFFF7E9D7),
      Colors.white,
    ],
    this.buttonLabel = 'Start',
    this.buttonColor = const Color(0xFF1F8A9E),
    this.buttonTextColor = Colors.white,
    this.subjectTextColor = const Color(0xFF6E5C49),
    this.nextLessonTextColor = const Color(0xFF14323A),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subjectTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: subjectTextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nextLessonText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: nextLessonTextColor,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
