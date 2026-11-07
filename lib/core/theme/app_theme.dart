import 'package:flutter/material.dart';

import '../design/tokens.dart';

class AppTheme {
  static final ThemeData light = _build(Brightness.light, AppColors.light);
  static final ThemeData dark = _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness b, AppColors c) {
    final scheme = ColorScheme(
      brightness: b,
      primary: c.signal,
      onPrimary: c.onSignal,
      secondary: c.signal,
      onSecondary: c.onSignal,
      error: const Color(0xFFDC2626),
      onError: Colors.white,
      surface: c.surface,
      onSurface: c.ink,
      outline: c.line,
      outlineVariant: c.line,
      surfaceContainerHighest: c.surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.paper,
      canvasColor: c.paper,
      fontFamily: AppType.ui,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      dividerColor: c.line,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: c.signal.withValues(alpha: 0.25),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.ink,
        contentTextStyle: TextStyle(fontFamily: AppType.ui, color: c.paper),
        behavior: SnackBarBehavior.floating,
      ),
      extensions: [c],
    );
  }
}
