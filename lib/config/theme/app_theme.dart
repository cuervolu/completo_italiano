import 'package:flutter/material.dart';

class AppTheme {
  // LIGHT THEME
  static const Color _lightPrimaryColor = Color(0xFFC599B6);
  static const Color _lightSecondaryColor = Color(0xFFE6B2BA);
  static const Color _lightTertiaryColor = Color(0xFFFAD0C4);
  static const Color _lightBackgroundColor = Color(0xFFFFF7F3);

  // DARK THEME
  static const Color _darkPrimaryColor = Color(0xFF756AB6);
  static const Color _darkSecondaryColor = Color(0xFFAC87C5);
  static const Color _darkTertiaryColor = Color(0xFFE0AED0);
  static const Color _darkBackgroundColor = Color(0xFFFFE5E5);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _lightPrimaryColor,
        secondary: _lightSecondaryColor,
        tertiary: _lightTertiaryColor,
        surface: _lightBackgroundColor,
      ),
      scaffoldBackgroundColor: _lightBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.black87),
        displayMedium: TextStyle(color: Colors.black87),
        displaySmall: TextStyle(color: Colors.black87),
        headlineMedium: TextStyle(color: Colors.black87),
        headlineSmall: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black87),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        tertiary: _darkTertiaryColor,
        surface: _darkBackgroundColor,
      ),
      scaffoldBackgroundColor: _darkBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.black87),
        displayMedium: TextStyle(color: Colors.black87),
        displaySmall: TextStyle(color: Colors.black87),
        headlineMedium: TextStyle(color: Colors.black87),
        headlineSmall: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black87),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }
}
