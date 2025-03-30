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
        brightness == Brightness.light ? Colors.black87 : Colors.white;

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
          displayLarge: TextStyle(fontFamily: 'Papyrus', fontSize: 96, fontWeight: FontWeight.w300, color: textColor),
          displayMedium: TextStyle(fontFamily: 'Papyrus', fontSize: 60, fontWeight: FontWeight.w300, color: textColor),
          displaySmall: TextStyle(fontFamily: 'Papyrus', fontSize: 48, fontWeight: FontWeight.w400, color: textColor),
          headlineMedium: TextStyle(fontFamily: 'Papyrus', fontSize: 34, fontWeight: FontWeight.w400, color: textColor),
        );
    }
  }
}

class AppTheme {
  // LIGHT THEME
  static const Color _lightPrimaryColor = Color(0xFFC599B6);
  static const Color _lightSecondaryColor = Color(0xFFE6B2BA);
  static const Color _lightTertiaryColor = Color(0xFFFAD0C4);
  static const Color _lightBackgroundColor = Color(0xFFFFF7F3);

  // DARK THEME
  static const Color _darkPrimaryColor = Color(0xFF39375B);
  static const Color _darkSecondaryColor = Color(0xFF745C97);
  static const Color _darkTertiaryColor = Color(0xFFD597CE);
  static const Color _darkBackgroundColor = Color(0xFFF5B0CB);

  static ThemeData lightTheme({AppFont font = AppFont.nunito}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        secondary: _lightSecondaryColor,
        tertiary: _lightTertiaryColor,
        surface: _lightBackgroundColor,
        background: _lightBackgroundColor,
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
      cardTheme: CardTheme(
        color: _lightBackgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: Colors.white,
      ),
      textTheme: font.getGoogleFontTextTheme(Brightness.light),
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
        surface: _darkBackgroundColor,
        background: _darkBackgroundColor,
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
        color: _darkBackgroundColor,
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
