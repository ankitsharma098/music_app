// theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // App colors
  static const Color primaryColor = Color(0xFF6C3EEA);
  static const Color darkPurple = Color(0xFF1E0B42);
  static const Color lightPurple = Color(0xFF8A6EF0);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color gray = Color(0xFF9E9E9E);

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkPurple,
    appBarTheme: const AppBarTheme(
      color: darkPurple,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: white,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: gray,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPurple,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: white,
    ),
  );
}
