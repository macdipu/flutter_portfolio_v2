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
  static const _lightBackground = Color(0xFFF5F5F7);
  static const _lightCard = Colors.white;
  static const _lightTextPrimary = Color(0xFF333333);
  static const _lightTextSecondary = Color(0xFF6E6E73);

  // Dark theme colors
  static const _darkBackground = Color(0xFF121212);
  static const _darkCard = Color(0xFF1E1E1E);
  static const _darkTextPrimary = Color(0xFFF5F5F7);
  static const _darkTextSecondary = Color(0xFFAEAEB2);

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Border radius
  static const double borderRadius4 = 4.0;
  static const double borderRadius8 = 8.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius24 = 24.0;

  // Public themes
  static final ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    background: _lightBackground,
    cardColor: _lightCard,
    textPrimary: _lightTextPrimary,
    textSecondary: _lightTextSecondary,
    textColors: TextColors(
      primary: _lightTextPrimary,
      secondary: _lightTextSecondary,
      bodySmall: _lightTextSecondary,
    ),
  );

  static final ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    background: _darkBackground,
    cardColor: _darkCard,
    textPrimary: _darkTextPrimary,
    textSecondary: _darkTextSecondary,
    textColors: TextColors(
      primary: _darkTextPrimary,
      secondary: _darkTextSecondary,
      bodySmall: _darkTextSecondary,
    ),
  );

  /// Base theme generator
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
    required TextColors textColors,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      cardColor: cardColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        background: background,
        surface: cardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textPrimary,
        onSurface: textPrimary,
        error: error,
        onError: Colors.white,
      ),
      textTheme: _buildTextTheme(textPrimary, textSecondary),
      iconTheme: IconThemeData(color: textPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
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
            horizontal: spacing24,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing16,
          ),
          side: const BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.all(spacing16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
          borderSide: BorderSide(color: textSecondary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
          borderSide: const BorderSide(color: primary),
        ),
      ),
      extensions: [textColors],
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: TextStyle(
        color: primary,
        fontSize: 57,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        color: primary,
        fontSize: 45,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        color: primary,
        fontSize: 36,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      headlineLarge: TextStyle(
        color: primary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        color: primary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      headlineSmall: TextStyle(
        color: primary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        color: primary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleSmall: TextStyle(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        color: primary,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: primary,
        fontSize: 14,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: secondary,
        fontSize: 12,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      labelMedium: TextStyle(
        color: primary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      labelSmall: TextStyle(
        color: secondary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
    );
  }
}

// TextColors extension
class TextColors extends ThemeExtension<TextColors> {
  final Color primary;
  final Color secondary;
  final Color? bodySmall;

  const TextColors({
    required this.primary,
    required this.secondary,
    this.bodySmall,
  });

  @override
  TextColors copyWith({
    Color? primary,
    Color? secondary,
    Color? bodySmall,
  }) {
    return TextColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      bodySmall: bodySmall ?? this.bodySmall,
    );
  }

  @override
  TextColors lerp(ThemeExtension<TextColors>? other, double t) {
    if (other is! TextColors) return this;
    return TextColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      bodySmall: Color.lerp(bodySmall, other.bodySmall, t),
    );
  }
}

extension ThemeExtras on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  TextColors get textColors => Theme.of(this).extension<TextColors>()!;
}
