import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const primary = Color(0xFF0175C2);
  static const secondary = Color(0xFF02569B);
  static const accent = Color(0xFFFF8A65);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFF44336);

  // Light theme colors
  static const lightBackground = Color(0xFFF5F5F7);
  static const lightCardBackground = Colors.white;
  static const lightTextPrimary = Color(0xFF333333);
  static const lightTextSecondary = Color(0xFF6E6E73);

  // Dark theme colors
  static const darkBackground = Color(0xFF121212);
  static const darkCardBackground = Color(0xFF1E1E1E);
  static const darkTextPrimary = Color(0xFFF5F5F7);
  static const darkTextSecondary = Color(0xFFAEAEB2);

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Border radius
  static const double borderRadius8 = 8.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius24 = 24.0;

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: lightBackground,
      surface: lightCardBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: lightTextPrimary,
      onSurface: lightTextPrimary,
    ),
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightCardBackground,
    textTheme: _getTextTheme(lightTextPrimary, lightTextSecondary),
    appBarTheme: AppBarTheme(
      backgroundColor: lightCardBackground,
      foregroundColor: lightTextPrimary,
      elevation: 0,
    ),
    iconTheme: IconThemeData(
      color: lightTextPrimary,
    ),
    cardTheme: CardThemeData(
      color: lightCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
            horizontal: spacing24, vertical: spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(
            horizontal: spacing24, vertical: spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
        ),
        side: const BorderSide(color: primary, width: 1.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightCardBackground,
      contentPadding: const EdgeInsets.all(spacing16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius8),
        borderSide: BorderSide(color: lightTextSecondary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius8),
        borderSide: const BorderSide(color: primary),
      ),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      background: darkBackground,
      surface: darkCardBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: darkTextPrimary,
      onSurface: darkTextPrimary,
    ),
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCardBackground,
    textTheme: _getTextTheme(darkTextPrimary, darkTextSecondary),
    appBarTheme: AppBarTheme(
      backgroundColor: darkCardBackground,
      foregroundColor: darkTextPrimary,
      elevation: 0,
    ),
    iconTheme: IconThemeData(
      color: darkTextPrimary,
    ),
    cardTheme: CardThemeData(
      color: darkCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
            horizontal: spacing24, vertical: spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(
            horizontal: spacing24, vertical: spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
        ),
        side: const BorderSide(color: primary, width: 1.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardBackground,
      contentPadding: const EdgeInsets.all(spacing16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius8),
        borderSide: BorderSide(color: darkTextSecondary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius8),
        borderSide: const BorderSide(color: primary),
      ),
    ),
  );

  // Text theme
  static TextTheme _getTextTheme(Color primary, Color secondary) {
    return GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: TextStyle(
            color: primary,
            fontSize: 57,
            fontWeight: FontWeight.bold,
            height: 1.2),
        displayMedium: TextStyle(
            color: primary,
            fontSize: 45,
            fontWeight: FontWeight.bold,
            height: 1.2),
        displaySmall: TextStyle(
            color: primary,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.2),
        headlineLarge: TextStyle(
            color: primary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.2),
        headlineMedium: TextStyle(
            color: primary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2),
        headlineSmall: TextStyle(
            color: primary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.2),
        titleLarge: TextStyle(
            color: primary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            height: 1.3),
        titleMedium: TextStyle(
            color: primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.3),
        titleSmall: TextStyle(
            color: primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3),
        bodyLarge: TextStyle(color: primary, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: primary, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: secondary, fontSize: 12, height: 1.5),
        labelLarge: TextStyle(
            color: primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5),
        labelMedium: TextStyle(
            color: primary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.5),
        labelSmall: TextStyle(
            color: secondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.5),
      ),
    );
  }
}
