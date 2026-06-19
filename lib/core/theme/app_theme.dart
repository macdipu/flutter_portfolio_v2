import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Dark palette — "Ocean Slate" ──────────────────────────────────────────
  // Tailwind slate-900/800 layering: navy undertone is easier on eyes than
  // pure gray-black, and gives depth without harsh contrast.
  static const darkBackground      = Color(0xFF0F172A); // slate-900
  static const darkSurface         = Color(0xFF1E293B); // slate-800
  static const darkSurfaceVariant  = Color(0xFF263347); // slate-700-ish
  static const darkOutline         = Color(0xFF334155); // slate-700
  static const darkOutlineVariant  = Color(0xFF1E293B); // slate-800
  static const darkPrimary         = Color(0xFF38BDF8); // sky-400
  static const darkOnPrimary       = Color(0xFF0F172A); // slate-900
  static const darkSecondary       = Color(0xFF818CF8); // indigo-400
  static const darkTextPrimary     = Color(0xFFE2E8F0); // slate-200
  static const darkTextSecondary   = Color(0xFF94A3B8); // slate-400
  static const darkInputFill       = Color(0xFF263347); // slate-700-ish

  // ── Light palette — "Clean Slate" ─────────────────────────────────────────
  // Slight blue-gray tint so the background is never pure-white glare.
  static const lightBackground     = Color(0xFFF1F5F9); // slate-100
  static const lightSurface        = Color(0xFFFFFFFF); // white
  static const lightSurfaceVariant = Color(0xFFE2E8F0); // slate-200
  static const lightOutline        = Color(0xFFCBD5E1); // slate-300
  static const lightOutlineVariant = Color(0xFFE2E8F0); // slate-200
  static const lightPrimary        = Color(0xFF0369A1); // sky-700
  static const lightOnPrimary      = Color(0xFFFFFFFF); // white
  static const lightSecondary      = Color(0xFF4F46E5); // indigo-600
  static const lightTextPrimary    = Color(0xFF0F172A); // slate-900
  static const lightTextSecondary  = Color(0xFF475569); // slate-600
  static const lightInputFill      = Color(0xFFE2E8F0); // slate-200

  // ── Shared semantic colors ────────────────────────────────────────────────
  static const success            = Color(0xFF4ADE80); // green-400
  static const warning            = Color(0xFFFCD34D); // amber-300
  static const errorColor         = Color(0xFFF87171); // red-400
  static const onError            = Color(0xFFFFFFFF);

  // Error containers
  static const darkErrorContainer   = Color(0xFF93000A); // dark red container
  static const darkOnErrorContainer = Color(0xFFFFDAD6); // light text on it
  static const lightErrorContainer  = Color(0xFFFFDAD6); // light pink container
  static const lightOnErrorContainer= Color(0xFF410002); // dark text on it

  // Shadow (shadows are always dark regardless of theme)
  static const shadowColor = Color(0xFF000000);

  // ── Spacing ───────────────────────────────────────────────────────────────
  static const double spacing4  = 4.0;
  static const double spacing8  = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // ── Border radius ─────────────────────────────────────────────────────────
  static const double borderRadius4  = 4.0;
  static const double borderRadius8  = 8.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius24 = 24.0;

  // ── Public themes ─────────────────────────────────────────────────────────
  static final ThemeData lightTheme = _buildTheme(
    brightness:       Brightness.light,
    primary:          lightPrimary,
    onPrimary:        lightOnPrimary,
    secondary:        lightSecondary,
    background:       lightBackground,
    surface:          lightSurface,
    surfaceVariant:   lightSurfaceVariant,
    outline:          lightOutline,
    outlineVariant:   lightOutlineVariant,
    inversePrimary:   darkPrimary,
    errorContainer:   lightErrorContainer,
    onErrorContainer: lightOnErrorContainer,
    textPrimary:      lightTextPrimary,
    textSecondary:    lightTextSecondary,
    inputFill:        lightInputFill,
  );

  static final ThemeData darkTheme = _buildTheme(
    brightness:       Brightness.dark,
    primary:          darkPrimary,
    onPrimary:        darkOnPrimary,
    secondary:        darkSecondary,
    background:       darkBackground,
    surface:          darkSurface,
    surfaceVariant:   darkSurfaceVariant,
    outline:          darkOutline,
    outlineVariant:   darkOutlineVariant,
    inversePrimary:   lightPrimary,
    errorContainer:   darkErrorContainer,
    onErrorContainer: darkOnErrorContainer,
    textPrimary:      darkTextPrimary,
    textSecondary:    darkTextSecondary,
    inputFill:        darkInputFill,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color onPrimary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color surfaceVariant,
    required Color outline,
    required Color outlineVariant,
    required Color inversePrimary,
    required Color errorContainer,
    required Color onErrorContainer,
    required Color textPrimary,
    required Color textSecondary,
    required Color inputFill,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      colorScheme: ColorScheme(
        brightness:       brightness,
        primary:          primary,
        onPrimary:        onPrimary,
        secondary:        secondary,
        onSecondary:      onPrimary,
        surface:          surface,
        onSurface:        textPrimary,
        background:       background,
        onBackground:     textPrimary,
        error:            errorColor,
        onError:          onError,
        errorContainer:   errorContainer,
        onErrorContainer: onErrorContainer,
        surfaceVariant:   surfaceVariant,
        onSurfaceVariant: textSecondary,
        outline:          outline,
        outlineVariant:   outlineVariant,
        shadow:           shadowColor,
        inverseSurface:   textPrimary,
        onInverseSurface: background,
        inversePrimary:   inversePrimary,
      ),
      textTheme: _buildTextTheme(textPrimary, textSecondary),
      iconTheme: IconThemeData(color: textSecondary),
      appBarTheme: AppBarTheme(
        backgroundColor:  surface,
        foregroundColor:  textPrimary,
        elevation:        0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color:     surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius16),
          side: BorderSide(color: outline, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation:       0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical:   spacing16,
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
            vertical:   spacing16,
          ),
          side: BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled:         true,
        fillColor:      inputFill,
        contentPadding: const EdgeInsets.all(spacing16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
          borderSide:   BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
          borderSide:   BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
          borderSide:   BorderSide(color: primary, width: 1.5),
        ),
        hintStyle:  TextStyle(color: textSecondary.withAlpha(153)),
        labelStyle: TextStyle(color: textSecondary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        side:            BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius8),
        ),
      ),
      dividerTheme: DividerThemeData(
        color:     outline,
        thickness: 1,
      ),
      extensions: [
        TextColors(
          primary:   textPrimary,
          secondary: textSecondary,
          bodySmall: textSecondary,
        ),
      ],
    );
  }

  static TextTheme _buildTextTheme(Color textPrimary, Color textSecondary) {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge:  TextStyle(color: textPrimary,   fontSize: 57, fontWeight: FontWeight.bold,  height: 1.2),
      displayMedium: TextStyle(color: textPrimary,   fontSize: 45, fontWeight: FontWeight.bold,  height: 1.2),
      displaySmall:  TextStyle(color: textPrimary,   fontSize: 36, fontWeight: FontWeight.bold,  height: 1.2),
      headlineLarge: TextStyle(color: textPrimary,   fontSize: 32, fontWeight: FontWeight.bold,  height: 1.2),
      headlineMedium:TextStyle(color: textPrimary,   fontSize: 28, fontWeight: FontWeight.bold,  height: 1.2),
      headlineSmall: TextStyle(color: textPrimary,   fontSize: 24, fontWeight: FontWeight.w600,  height: 1.2),
      titleLarge:    TextStyle(color: textPrimary,   fontSize: 22, fontWeight: FontWeight.w600,  height: 1.3),
      titleMedium:   TextStyle(color: textPrimary,   fontSize: 16, fontWeight: FontWeight.w600,  height: 1.3),
      titleSmall:    TextStyle(color: textPrimary,   fontSize: 14, fontWeight: FontWeight.w600,  height: 1.3),
      bodyLarge:     TextStyle(color: textPrimary,   fontSize: 16, height: 1.5),
      bodyMedium:    TextStyle(color: textPrimary,   fontSize: 14, height: 1.5),
      bodySmall:     TextStyle(color: textSecondary, fontSize: 12, height: 1.5),
      labelLarge:    TextStyle(color: textPrimary,   fontSize: 14, fontWeight: FontWeight.w500,  height: 1.5),
      labelMedium:   TextStyle(color: textPrimary,   fontSize: 12, fontWeight: FontWeight.w500,  height: 1.5),
      labelSmall:    TextStyle(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w500,  height: 1.5),
    );
  }
}

// ── TextColors theme extension ────────────────────────────────────────────────
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
  TextColors copyWith({Color? primary, Color? secondary, Color? bodySmall}) {
    return TextColors(
      primary:   primary   ?? this.primary,
      secondary: secondary ?? this.secondary,
      bodySmall: bodySmall ?? this.bodySmall,
    );
  }

  @override
  TextColors lerp(ThemeExtension<TextColors>? other, double t) {
    if (other is! TextColors) return this;
    return TextColors(
      primary:   Color.lerp(primary,   other.primary,   t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      bodySmall: Color.lerp(bodySmall, other.bodySmall, t),
    );
  }
}

extension ThemeExtras on BuildContext {
  ColorScheme get colors     => Theme.of(this).colorScheme;
  TextTheme   get textStyles => Theme.of(this).textTheme;
  TextColors  get textColors => Theme.of(this).extension<TextColors>()!;
}
