import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0B8FAC);
  static const Color accentColor = Color(0xFF34C3E6);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF6B6B6B);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: textDark),
      titleTextStyle: TextStyle(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}