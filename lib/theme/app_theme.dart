import 'package:flutter/material.dart';

class AppTheme {
  // Brand Primary Gradient Colors
  static const Color primaryPurple = Color(0xFF8A2387);
  static const Color primaryPink = Color(0xFFE94057);
  static const Color primaryOrange = Color(0xFFF27121);
  static const Color accentViolet = Color(0xFF6A11CB);
  static const Color accentBlue = Color(0xFF2575FC);

  // Background & Surface
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF121212);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFB0B0B0);

  // Divider & Border
  static const Color divider = Color(0xFFEFEFEF);
  static const Color border = Color(0xFFE0E0E0);

  // Gradient Constants
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryPink, primaryOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient storyGradient = LinearGradient(
    colors: [primaryPurple, primaryPink, primaryOrange],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryPurple, primaryPink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient subtleBgGradient = LinearGradient(
    colors: [Color(0xFFFFF5F8), Color(0xFFF7F0FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPink,
        primary: primaryPink,
        secondary: primaryPurple,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryPink,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      fontFamily: 'Roboto',
    );
  }
}
