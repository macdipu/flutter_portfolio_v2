import 'package:flutter/material.dart';

/// Spacing scale (logical px).
abstract class Space {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double x3 = 64;
  static const double x4 = 96;
  static const double x5 = 128;
}

/// Radius scale. Hierarchy, not one value for everything.
abstract class Radii {
  static const double sm = 6;
  static const double md = 12;
  static const double device = 36;
  static const double pill = 999;
}

/// Motion tokens. See docs/portfolio-ui-ux-refactoring-plan.md section H.
abstract class Motion {
  static const Duration instant = Duration(milliseconds: 120);
  static const Duration hover = Duration(milliseconds: 180);
  static const Duration press = Duration(milliseconds: 90);
  static const Duration entrance = Duration(milliseconds: 560);
  static const Duration exit = Duration(milliseconds: 240);
  static const Duration stagger = Duration(milliseconds: 70);
  static const Duration scroll = Duration(milliseconds: 520);

  static const Curve easeOut = Cubic(0.22, 1, 0.36, 1);
  static const Curve easeInOut = Cubic(0.65, 0, 0.35, 1);

  /// Fraction of the viewport height an element must have entered to reveal.
  static const double revealThreshold = 0.12;
  static const double entranceOffset = 24;

  /// True when the visitor asked the platform for reduced motion.
  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration scaled(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}

/// Semantic colours, per theme.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.ink,
    required this.paper,
    required this.surface,
    required this.line,
    required this.muted,
    required this.signal,
    required this.onSignal,
    required this.live,
  });

  final Color ink;
  final Color paper;
  final Color surface;
  final Color line;
  final Color muted;
  final Color signal;
  final Color onSignal;
  final Color live;

  static const light = AppColors(
    ink: Color(0xFF081230),
    paper: Color(0xFFF2F5FB),
    surface: Color(0xFFFFFFFF),
    line: Color(0xFFD5DCEB),
    muted: Color(0xFF52607F),
    signal: Color(0xFF0A5BFF),
    onSignal: Color(0xFFFFFFFF),
    live: Color(0xFF16A34A),
  );

  static const dark = AppColors(
    ink: Color(0xFFEEF2FF),
    paper: Color(0xFF0A1330),
    surface: Color(0xFF101C42),
    line: Color(0xFF1F2E5C),
    muted: Color(0xFF8C9BC0),
    signal: Color(0xFF2BB7FF),
    onSignal: Color(0xFF04112B),
    live: Color(0xFF4ADE80),
  );

  @override
  AppColors copyWith({
    Color? ink,
    Color? paper,
    Color? surface,
    Color? line,
    Color? muted,
    Color? signal,
    Color? onSignal,
    Color? live,
  }) =>
      AppColors(
        ink: ink ?? this.ink,
        paper: paper ?? this.paper,
        surface: surface ?? this.surface,
        line: line ?? this.line,
        muted: muted ?? this.muted,
        signal: signal ?? this.signal,
        onSignal: onSignal ?? this.onSignal,
        live: live ?? this.live,
      );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      ink: Color.lerp(ink, other.ink, t)!,
      paper: Color.lerp(paper, other.paper, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      line: Color.lerp(line, other.line, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      signal: Color.lerp(signal, other.signal, t)!,
      onSignal: Color.lerp(onSignal, other.onSignal, t)!,
      live: Color.lerp(live, other.live, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

/// Fluid value between [min] at 320px and [max] at 1440px viewport width.
double fluid(BuildContext context, double min, double max) {
  final w = MediaQuery.sizeOf(context).width;
  final t = ((w - 320) / (1440 - 320)).clamp(0.0, 1.0);
  return min + (max - min) * t;
}

/// Type scale. Display/UI: Bricolage Grotesque. Reading text: Newsreader.
abstract class AppType {
  static const String ui = 'Bricolage';
  static const String read = 'Newsreader';

  static TextStyle display(BuildContext c) => TextStyle(
        fontFamily: ui,
        fontSize: fluid(c, 44, 104),
        fontWeight: FontWeight.w800,
        height: 0.98,
        letterSpacing: -fluid(c, 1.2, 3.2),
        color: c.colors.ink,
      );

  static TextStyle h1(BuildContext c) => TextStyle(
        fontFamily: ui,
        fontSize: fluid(c, 32, 56),
        fontWeight: FontWeight.w700,
        height: 1.05,
        letterSpacing: -fluid(c, 0.6, 1.4),
        color: c.colors.ink,
      );

  static TextStyle h2(BuildContext c) => TextStyle(
        fontFamily: ui,
        fontSize: fluid(c, 24, 36),
        fontWeight: FontWeight.w700,
        height: 1.12,
        letterSpacing: -0.4,
        color: c.colors.ink,
      );

  static TextStyle h3(BuildContext c) => TextStyle(
        fontFamily: ui,
        fontSize: fluid(c, 20, 24),
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: c.colors.ink,
      );

  static TextStyle lead(BuildContext c) => TextStyle(
        fontFamily: read,
        fontSize: fluid(c, 19, 26),
        height: 1.4,
        color: c.colors.ink,
      );

  static TextStyle body(BuildContext c) => TextStyle(
        fontFamily: read,
        fontSize: fluid(c, 17, 19),
        height: 1.6,
        color: c.colors.muted,
      );

  static TextStyle ui14(BuildContext c) => TextStyle(
        fontFamily: ui,
        fontSize: fluid(c, 14, 15),
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: c.colors.ink,
      );

  static TextStyle caption(BuildContext c) => TextStyle(
        fontFamily: ui,
        fontSize: fluid(c, 13, 14),
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: c.colors.muted,
      );
}

/// Horizontal page gutter, fluid 20 to 64.
double gutter(BuildContext c) => fluid(c, 20, 64);

/// Vertical rhythm between sections, fluid 64 to 128.
double sectionGap(BuildContext c) => fluid(c, 64, 128);

/// Max widths for content.
abstract class Widths {
  static const double reading = 640;
  static const double content = 1120;
  static const double wide = 1320;

  static double forViewport(double w) => w >= 1920 ? wide : content;
}
