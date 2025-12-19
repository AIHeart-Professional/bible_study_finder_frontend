import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Central theme configuration for the Bible Study Finder app.
/// 
/// This class provides theme configurations for different modes (light, dark)
/// using explicit color definitions from AppColors.
class AppThemes {
  // Private constructor to prevent instantiation
  AppThemes._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    final colors = AppColors.light;
    
    // Create ColorScheme from explicit colors
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: colors.brandPrimary,
      onPrimary: colors.textOnPrimary,
      primaryContainer: colors.brandSecondary,
      onPrimaryContainer: colors.textOnPrimary,
      secondary: colors.brandSecondary,
      onSecondary: colors.textOnSecondary,
      secondaryContainer: colors.brandTertiary,
      onSecondaryContainer: colors.textOnSecondary,
      tertiary: colors.brandTertiary,
      onTertiary: colors.textOnPrimary,
      error: colors.error,
      onError: colors.textOnError,
      errorContainer: colors.error.withOpacity(0.1),
      onErrorContainer: colors.error,
      surface: colors.bgSurface,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.borderPrimary,
      outlineVariant: colors.borderSecondary,
      shadow: colors.shadowLight,
      scrim: colors.shadowDark,
      inverseSurface: colors.bgPrimary,
      onInverseSurface: colors.textInverse,
      inversePrimary: colors.brandPrimary,
      surfaceTint: colors.brandPrimary,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.light,
      
      // AppBar theme with transparency and professional styling
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
      ),
      
      // Card theme with semi-transparent background
      cardTheme: CardThemeData(
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: colors.bgCard.withOpacity(0.95),
      ),
      
      // Elevated button styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.brandPrimary,
          foregroundColor: colors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Text button styling
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.brandPrimary,
        ),
      ),
      
      // Outlined button styling
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.brandPrimary,
          side: BorderSide(color: colors.borderPrimary),
        ),
      ),
      
      // Input field styling with semi-transparent background
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.bgInput.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.brandPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Transparent scaffold background (for background image)
      scaffoldBackgroundColor: Colors.transparent,
      
      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: colors.bgCard.withOpacity(0.95),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.bgCard.withOpacity(0.95),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    final colors = AppColors.dark;
    
    // Create ColorScheme from explicit colors
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: colors.brandPrimary,
      onPrimary: colors.textOnPrimary,
      primaryContainer: colors.brandSecondary,
      onPrimaryContainer: colors.textOnPrimary,
      secondary: colors.brandSecondary,
      onSecondary: colors.textOnSecondary,
      secondaryContainer: colors.brandTertiary,
      onSecondaryContainer: colors.textOnSecondary,
      tertiary: colors.brandTertiary,
      onTertiary: colors.textOnPrimary,
      error: colors.error,
      onError: colors.textOnError,
      errorContainer: colors.error.withOpacity(0.1),
      onErrorContainer: colors.error,
      surface: colors.bgSurface,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.borderPrimary,
      outlineVariant: colors.borderSecondary,
      shadow: colors.shadowLight,
      scrim: colors.shadowDark,
      inverseSurface: colors.bgPrimary,
      onInverseSurface: colors.textInverse,
      inversePrimary: colors.brandPrimary,
      surfaceTint: colors.brandPrimary,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // AppBar theme with dark styling
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
      ),
      
      // Card theme with dark semi-transparent background
      cardTheme: CardThemeData(
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: colors.bgCard.withOpacity(0.92),
      ),
      
      // Elevated button styling for dark mode
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.brandPrimary,
          foregroundColor: colors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Text button styling
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.brandPrimary,
        ),
      ),
      
      // Outlined button styling
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.brandPrimary,
          side: BorderSide(color: colors.borderPrimary),
        ),
      ),
      
      // Input field styling with dark semi-transparent background
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.bgInput.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.brandPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Transparent scaffold background (for background image)
      scaffoldBackgroundColor: Colors.transparent,
      
      // Dialog theme for dark mode
      dialogTheme: DialogThemeData(
        backgroundColor: colors.bgCard.withOpacity(0.95),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Bottom sheet theme for dark mode
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.bgCard.withOpacity(0.95),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
      ),
    );
  }

  /// Get navigation bar opacity for current theme
  static double getNavigationBarOpacity(Brightness brightness) {
    return brightness == Brightness.dark ? 0.88 : 0.85;
  }

  /// Get card opacity for current theme
  static double getCardOpacity(Brightness brightness) {
    return brightness == Brightness.dark ? 0.92 : 0.95;
  }

  /// Get container opacity for current theme
  static double getContainerOpacity(Brightness brightness) {
    return brightness == Brightness.dark ? 0.90 : 0.90;
  }

  /// Get input field opacity for current theme
  static double getInputOpacity(Brightness brightness) {
    return brightness == Brightness.dark ? 0.90 : 0.90;
  }
}














