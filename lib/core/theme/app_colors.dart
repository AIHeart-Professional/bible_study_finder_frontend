import 'package:flutter/material.dart';

/// Centralized color definitions for the Bible Study Finder app.
/// 
/// This class provides explicit color variables for light and dark themes,
/// similar to CSS custom properties (--bg-primary, --text-primary, etc.).
/// 
/// Usage:
/// ```dart
/// // In light theme
/// AppColors.light.bgPrimary
/// 
/// // In dark theme
/// AppColors.dark.bgPrimary
/// 
/// // Theme-aware (recommended)
/// AppColors.of(context).bgPrimary
/// ```
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  /// Light theme color palette
  static const LightColors light = LightColors();

  /// Dark theme color palette
  static const DarkColors dark = DarkColors();

  /// Get colors based on current theme brightness
  static ColorPalette of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  /// Get colors based on brightness
  static ColorPalette fromBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}

/// Base class for color palettes
abstract class ColorPalette {
  // Background Colors
  Color get bgPrimary;
  Color get bgSecondary;
  Color get bgTertiary;
  Color get bgSurface;
  Color get bgCard;
  Color get bgInput;
  Color get bgNavBar;
  Color get bgAppBar;

  // Text Colors
  Color get textPrimary;
  Color get textSecondary;
  Color get textTertiary;
  Color get textInverse;
  Color get textOnPrimary;
  Color get textOnSecondary;
  Color get textOnError;

  // Brand Colors
  Color get brandPrimary;
  Color get brandSecondary;
  Color get brandTertiary;
  Color get brandAccent;

  // Semantic Colors
  Color get success;
  Color get warning;
  Color get error;
  Color get info;

  // Border/Outline Colors
  Color get borderPrimary;
  Color get borderSecondary;
  Color get divider;

  // Shadow Colors
  Color get shadowLight;
  Color get shadowDark;

  // Interactive Colors
  Color get link;
  Color get linkHover;
  Color get disabled;
}

/// Light theme color palette
/// Colors designed to complement cream/parchment background
class LightColors implements ColorPalette {
  const LightColors();

  // Background Colors - Warm, cream tones matching parchment
  @override
  Color get bgPrimary => const Color(0xFFFFFEF9); // Warm off-white (parchment)
  @override
  Color get bgSecondary => const Color(0xFFF8F6F0); // Warm light cream
  @override
  Color get bgTertiary => const Color(0xFFF0EDE5); // Warmter cream
  @override
  Color get bgSurface => const Color(0xFFFFFEF9); // Warm off-white surface
  @override
  Color get bgCard => const Color(0xFFFFFEF9); // Warm off-white cards
  @override
  Color get bgInput => const Color(0xFFFFFEF9); // Warm off-white inputs
  @override
  Color get bgNavBar => const Color(0xFFFFFEF9); // Warm off-white nav bar
  @override
  Color get bgAppBar => const Color(0xFFFFFEF9); // Warm off-white app bar

  // Text Colors - Rich, readable browns
  @override
  Color get textPrimary => const Color(0xFF2C2416); // Rich dark brown
  @override
  Color get textSecondary => const Color(0xFF5C4E3A); // Medium brown
  @override
  Color get textTertiary => const Color(0xFF8B7D6B); // Light brown
  @override
  Color get textInverse => const Color(0xFFFFFEF9); // Warm off-white
  @override
  Color get textOnPrimary => const Color(0xFFFFFFFF); // White on primary
  @override
  Color get textOnSecondary => const Color(0xFFFFFFFF); // White on secondary
  @override
  Color get textOnError => const Color(0xFFFFFFFF); // White on error

  // Brand Colors - Professional, muted tones
  @override
  Color get brandPrimary => const Color(0xFF5B6C8F); // Muted blue-gray (professional)
  @override
  Color get brandSecondary => const Color(0xFF7A8BA8); // Lighter blue-gray
  @override
  Color get brandTertiary => const Color(0xFF9AA5B8); // Lightest blue-gray
  @override
  Color get brandAccent => const Color(0xFFB8865B); // Warm brown accent (matches parchment)

  // Semantic Colors
  @override
  Color get success => const Color(0xFF4CAF50); // Green
  @override
  Color get warning => const Color(0xFFFF9800); // Orange
  @override
  Color get error => const Color(0xFFE53935); // Red
  @override
  Color get info => const Color(0xFF2196F3); // Blue

  // Border/Outline Colors - Subtle browns matching parchment
  @override
  Color get borderPrimary => const Color(0xFFE8E4DC); // Warm light brown border
  @override
  Color get borderSecondary => const Color(0xFFF0EDE5); // Very light warm border
  @override
  Color get divider => const Color(0xFFE8E4DC); // Warm divider color

  // Shadow Colors - Subtle, warm shadows
  @override
  Color get shadowLight => const Color(0x1A2C2416); // 10% brown shadow
  @override
  Color get shadowDark => const Color(0x332C2416); // 20% brown shadow

  // Interactive Colors
  @override
  Color get link => const Color(0xFF5B6C8F); // Primary brand color
  @override
  Color get linkHover => const Color(0xFF4A5A7A); // Darker blue-gray
  @override
  Color get disabled => const Color(0xFFC4BEB0); // Warm gray
}

/// Dark theme color palette
/// Colors designed to complement dark parchment/paper background
/// More muted and subtle to avoid being too bright
class DarkColors implements ColorPalette {
  const DarkColors();

  // Background Colors - Dark, warm tones matching dark parchment
  @override
  Color get bgPrimary => const Color(0xFF1A1815); // Very dark warm brown
  @override
  Color get bgSecondary => const Color(0xFF25221D); // Dark warm brown
  @override
  Color get bgTertiary => const Color(0xFF2F2B25); // Medium dark warm brown
  @override
  Color get bgSurface => const Color(0xFF25221D); // Dark warm surface
  @override
  Color get bgCard => const Color(0xFF25221D); // Dark warm cards (less bright)
  @override
  Color get bgInput => const Color(0xFF2F2B25); // Dark warm inputs
  @override
  Color get bgNavBar => const Color(0xFF25221D); // Dark warm nav bar
  @override
  Color get bgAppBar => const Color(0xFF25221D); // Dark warm app bar

  // Text Colors - Warm, readable creams
  @override
  Color get textPrimary => const Color(0xFFF5F2EB); // Warm cream white
  @override
  Color get textSecondary => const Color(0xFFD4CFC4); // Light warm gray
  @override
  Color get textTertiary => const Color(0xFFB8B2A5); // Medium warm gray
  @override
  Color get textInverse => const Color(0xFF1A1815); // Dark warm brown
  @override
  Color get textOnPrimary => const Color(0xFFFFFFFF); // White on primary
  @override
  Color get textOnSecondary => const Color(0xFFF5F2EB); // Cream on secondary
  @override
  Color get textOnError => const Color(0xFFFFFFFF); // White on error

  // Brand Colors - Muted, professional (less bright for dark mode)
  @override
  Color get brandPrimary => const Color(0xFF6B7A9A); // Muted blue-gray (softer)
  @override
  Color get brandSecondary => const Color(0xFF7D8BA8); // Lighter muted blue-gray
  @override
  Color get brandTertiary => const Color(0xFF8F9BB5); // Lightest muted blue-gray
  @override
  Color get brandAccent => const Color(0xFFA68B6B); // Muted warm brown accent

  // Semantic Colors - Muted for dark mode
  @override
  Color get success => const Color(0xFF6BA86B); // Muted green
  @override
  Color get warning => const Color(0xFFB89A6B); // Muted warm orange
  @override
  Color get error => const Color(0xFFC97A7A); // Muted red
  @override
  Color get info => const Color(0xFF6B8FA8); // Muted blue

  // Border/Outline Colors - Subtle warm borders
  @override
  Color get borderPrimary => const Color(0xFF3D3933); // Dark warm brown border
  @override
  Color get borderSecondary => const Color(0xFF2F2B25); // Very dark warm border
  @override
  Color get divider => const Color(0xFF3D3933); // Warm divider color

  // Shadow Colors - Subtle, warm shadows
  @override
  Color get shadowLight => const Color(0x401A1815); // 25% dark brown shadow
  @override
  Color get shadowDark => const Color(0x661A1815); // 40% dark brown shadow

  // Interactive Colors
  @override
  Color get link => const Color(0xFF6B7A9A); // Primary brand color (muted)
  @override
  Color get linkHover => const Color(0xFF7D8BA8); // Lighter muted blue-gray
  @override
  Color get disabled => const Color(0xFF4A4742); // Dark warm gray
}














