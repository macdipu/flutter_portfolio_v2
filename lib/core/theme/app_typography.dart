import '../responsive/responsive_framework.dart';

/// Single source of truth for all font sizes across the app.
/// Call with a cached [ResponsiveInfo] from `context.responsive`.
abstract class AppTypography {
  /// Hero name — large display text
  static double display(ResponsiveInfo r) =>
      r.isMobile ? 28 : r.isTablet ? 38 : r.isSmallLaptop ? 46 : r.isDesktop ? 56 : 64;

  /// Section greeting / hero label ("Hello, I'm")
  static double sectionLabel(ResponsiveInfo r) =>
      r.isMobile ? 18 : r.isTablet ? 20 : r.isSmallLaptop ? 22 : r.isDesktop ? 24 : 26;

  /// Hero title / role ("Flutter Developer")
  static double heroTitle(ResponsiveInfo r) =>
      r.isMobile ? 18 : r.isTablet ? 22 : r.isSmallLaptop ? 24 : r.isDesktop ? 28 : 30;

  /// Section sub-headings ("Work Experience", "Contact Information")
  static double heading(ResponsiveInfo r) =>
      r.isMobile ? 20 : r.isTablet ? 22 : r.isSmallLaptop ? 24 : r.isDesktop ? 26 : 28;

  /// Card / company titles
  static double title(ResponsiveInfo r) =>
      r.isMobile ? 16 : r.isTablet ? 18 : r.isSmallLaptop ? 20 : r.isDesktop ? 22 : 24;

  /// Resume / large CTA headline
  static double largeCta(ResponsiveInfo r) =>
      r.isMobile ? 24 : r.isTablet ? 26 : r.isSmallLaptop ? 28 : r.isDesktop ? 30 : 32;

  /// Body text — intros, descriptions
  static double bodyLarge(ResponsiveInfo r) =>
      r.isMobile ? 14 : r.isTablet ? 16 : r.isSmallLaptop ? 17 : r.isDesktop ? 18 : 20;

  /// Body text — secondary descriptions, card content
  static double bodyMedium(ResponsiveInfo r) =>
      r.isMobile ? 14 : r.isTablet ? 15 : r.isSmallLaptop ? 16 : r.isDesktop ? 17 : 18;

  /// Small text — dates, labels, captions, footer
  static double bodySmall(ResponsiveInfo r) =>
      r.isMobile ? 12 : r.isTablet ? 13 : r.isSmallLaptop ? 14 : r.isDesktop ? 15 : 16;
}
