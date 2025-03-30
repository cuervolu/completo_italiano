import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppFont {
  nunito,
  quicksand,
  poppins,
  lato,
  montserrat,
  playfair,
  comfortaa,
  pacifico,
  papyrus,
}

extension AppFontExtension on AppFont {
  String get displayName {
    switch (this) {
      case AppFont.nunito:
        return 'Nunito';
      case AppFont.quicksand:
        return 'Quicksand';
      case AppFont.poppins:
        return 'Poppins';
      case AppFont.lato:
        return 'Lato';
      case AppFont.montserrat:
        return 'Montserrat';
      case AppFont.playfair:
        return 'Playfair Display';
      case AppFont.comfortaa:
        return 'Comfortaa';
      case AppFont.pacifico:
        return 'Pacifico';
      case AppFont.papyrus:
        return 'Papyrus';
    }
  }

  TextTheme getGoogleFontTextTheme(Brightness brightness) {
    final TextTheme baseTheme =
        brightness == Brightness.light
            ? ThemeData.light().textTheme
            : ThemeData.dark().textTheme;

    final Color textColor =
        brightness == Brightness.light ? Colors.black87 : Color(0xFFECEFF4);

    switch (this) {
      case AppFont.nunito:
        return GoogleFonts.nunitoTextTheme(
          baseTheme,
        ).apply(bodyColor: textColor, displayColor: textColor);
      case AppFont.quicksand:
        return GoogleFonts.quicksandTextTheme(
          baseTheme,
        ).apply(bodyColor: textColor, displayColor: textColor);
      case AppFont.poppins:
        return GoogleFonts.poppinsTextTheme(
          baseTheme,
        ).apply(bodyColor: textColor, displayColor: textColor);
      case AppFont.lato:
        return GoogleFonts.latoTextTheme(
          baseTheme,
        ).apply(bodyColor: textColor, displayColor: textColor);
      case AppFont.montserrat:
        return GoogleFonts.montserratTextTheme(
          baseTheme,
        ).apply(bodyColor: textColor, displayColor: textColor);
      case AppFont.playfair:
        return GoogleFonts.playfairDisplayTextTheme(
          baseTheme,
        ).apply(bodyColor: textColor, displayColor: textColor);
      case AppFont.comfortaa:
        return GoogleFonts.comfortaaTextTheme(
          baseTheme,
        ).apply(bodyColor: textColor, displayColor: textColor);
      case AppFont.pacifico:
        return GoogleFonts.pacificoTextTheme(
          baseTheme,
        ).apply(bodyColor: textColor, displayColor: textColor);
      case AppFont.papyrus:
        return TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Papyrus',
            fontSize: 96,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Papyrus',
            fontSize: 60,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Papyrus',
            fontSize: 48,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Papyrus',
            fontSize: 34,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
        );
    }
  }
}

class AppTheme {
  static const Color _lightPrimaryColor = Color(0xFFB57BA6);
  static const Color _lightSecondaryColor = Color(0xFFD98E96);
  static const Color _lightTertiaryColor = Color(0xFFF4B8C5);
  static const Color _lightBackgroundColor = Color(0xFFFDF3F0);
  static const Color _lightSurfaceColor = Color(0xFFFFEDEA);

  static const Color _darkPrimaryColor = Color(0xFF89B4FA);
  static const Color _darkSecondaryColor = Color(0xFFF5C2E7);
  static const Color _darkTertiaryColor = Color(0xFFA6E3A1);
  static const Color _darkBackgroundColor = Color(0xFF1E1E2E);
  static const Color _darkSurfaceColor = Color(0xFF3E3E55);

  static ThemeData lightTheme({AppFont font = AppFont.nunito}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        onPrimary: Colors.white,
        secondary: _lightSecondaryColor,
        onSecondary: Colors.black87,
        tertiary: _lightTertiaryColor,
        surface: _lightSurfaceColor,
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: _lightBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimaryColor,
          foregroundColor: Colors.white,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: _lightSurfaceColor,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: Colors.white,
      ),
      textTheme: font
          .getGoogleFontTextTheme(Brightness.light)
          .copyWith(
            bodyMedium: TextStyle(color: Colors.black87),
            bodySmall: TextStyle(color: Colors.black54),
            headlineLarge: TextStyle(color: Colors.black87),
            headlineMedium: TextStyle(color: Colors.black87),
          ),
    );
  }

  static ThemeData darkTheme({AppFont font = AppFont.nunito}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        tertiary: _darkTertiaryColor,
        surface: _darkSurfaceColor,
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
      cardTheme: CardTheme(
        color: _darkSurfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: Colors.white,
      ),
      textTheme: font.getGoogleFontTextTheme(Brightness.dark),
    );
  }
}
