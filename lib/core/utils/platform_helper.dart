import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Platform and responsive design utilities for detecting screen sizes and platforms
class PlatformHelper {
  // Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if running on web platform
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile platform (not web)
  static bool get isMobilePlatform => !kIsWeb;

  /// Check if screen size is mobile (< 600px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if screen size is tablet (600px - 900px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if screen size is desktop (> 900px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Check if should use web layout (web platform OR desktop screen size)
  static bool shouldUseWebLayout(BuildContext context) {
    return isWeb || isDesktop(context);
  }

  /// Check if should use mobile layout (mobile platform AND mobile screen size)
  static bool shouldUseMobileLayout(BuildContext context) {
    return isMobilePlatform && isMobile(context);
  }

  /// Get current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return ScreenSize.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  /// Get responsive column count based on screen size
  static int getColumnCount(BuildContext context, {int? maxColumns}) {
    final screenSize = getScreenSize(context);
    final columns = maxColumns ?? 3;
    
    switch (screenSize) {
      case ScreenSize.mobile:
        return 1;
      case ScreenSize.tablet:
        return columns >= 2 ? 2 : columns;
      case ScreenSize.desktop:
        return columns;
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(16);
      case ScreenSize.tablet:
        return const EdgeInsets.all(24);
      case ScreenSize.desktop:
        return const EdgeInsets.all(32);
    }
  }

  /// Get responsive spacing based on screen size
  static double getResponsiveSpacing(BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile ?? 16;
      case ScreenSize.tablet:
        return tablet ?? 20;
      case ScreenSize.desktop:
        return desktop ?? 24;
    }
  }
}

/// Screen size categories
enum ScreenSize {
  mobile,
  tablet,
  desktop,
}

