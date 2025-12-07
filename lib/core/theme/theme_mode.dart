/// Enum representing available theme modes in the application.
/// 
/// This enum is used to identify different theme configurations.
/// New themes can be easily added by extending this enum and adding
/// corresponding theme configurations.
enum AppThemeMode {
  /// Light theme with light background
  light,
  
  /// Dark theme with dark background
  dark,
  
  /// System theme (follows device settings)
  /// Note: Implementation requires platform-specific detection
  system;

  /// Get display name for the theme mode
  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  /// Get icon for the theme mode
  String get icon {
    switch (this) {
      case AppThemeMode.light:
        return '☀️';
      case AppThemeMode.dark:
        return '🌙';
      case AppThemeMode.system:
        return '💻';
    }
  }

  /// Get background image path for this theme
  String get backgroundImagePath {
    switch (this) {
      case AppThemeMode.light:
        return 'assets/images/background.jpg';
      case AppThemeMode.dark:
        return 'assets/images/background-dark.jpg';
      case AppThemeMode.system:
        // TODO: Detect system theme and return appropriate background
        return 'assets/images/background.jpg';
    }
  }
}


