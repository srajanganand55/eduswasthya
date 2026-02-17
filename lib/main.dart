import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const EduSwasthyaApp());
}

class EduSwasthyaApp extends StatelessWidget {
  const EduSwasthyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduSwasthya',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}