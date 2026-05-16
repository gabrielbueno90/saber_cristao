import 'package:flutter/material.dart';

class AppTheme {
  static const backgroundLight = Color(0xFFF5EAD7);
  static const backgroundDark = Color(0xFF2B1A10);
  static const primaryBrown = Color(0xFF5A3825);
  static const darkBrown = Color(0xFF2F1B10);
  static const secondaryBrown = Color(0xFF8B5E3C);
  static const gold = Color(0xFFC9A24A);
  static const softGold = Color(0xFFE4C978);
  static const cream = Color(0xFFFFF8E8);
  static const parchment = Color(0xFFEFE0C2);
  static const textDark = Color(0xFF2A1A12);
  static const textMuted = Color(0xFF6F5A45);
  static const error = Color(0xFFA94438);
  static const success = Color(0xFF4F6F3E);

  static ThemeData get light {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: primaryBrown,
        onPrimary: cream,
        secondary: gold,
        onSecondary: darkBrown,
        surface: cream,
        onSurface: textDark,
        error: error,
        onError: cream,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: cream,
        foregroundColor: textDark,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: parchment,
        elevation: 1.2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: softGold, width: 0.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBrown,
          foregroundColor: cream,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkBrown,
          side: const BorderSide(color: secondaryBrown),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBrown,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cream,
        labelStyle: const TextStyle(color: textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: secondaryBrown),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: secondaryBrown),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: gold, width: 1.4),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: darkBrown,
        contentTextStyle: TextStyle(color: cream),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textDark, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: textDark, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: textDark, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textDark),
        bodyMedium: TextStyle(color: textMuted),
      ),
    );
  }
}
