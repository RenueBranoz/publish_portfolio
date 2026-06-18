/// Responsive breakpoints used across the app, aligned with
/// responsive_framework's ResponsiveBreakpoints.
class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 480;
  static const double tablet = 800;
  static const double desktop = 1100;
  static const double ultraWide = 1900;

  static bool isMobile(double width) => width < tablet;
  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isDesktop(double width) => width >= desktop && width < ultraWide;
  static bool isUltraWide(double width) => width >= ultraWide;
}

/// Max content width so text/cards don't stretch absurdly on ultra-wide
/// monitors -- content stays centered with side padding.
class AppLayout {
  AppLayout._();

  static const double maxContentWidth = 1280;
  static const double sectionVerticalPaddingDesktop = 120;
  static const double sectionVerticalPaddingMobile = 64;

  static double horizontalPadding(double screenWidth) {
    if (AppBreakpoints.isMobile(screenWidth)) return 20;
    if (AppBreakpoints.isTablet(screenWidth)) return 40;
    if (AppBreakpoints.isUltraWide(screenWidth)) return 160;
    return 80;
  }
}
