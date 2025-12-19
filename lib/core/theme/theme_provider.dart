import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_mode.dart';
import '../logging/logger.dart';

/// Provider for managing application theme state.
/// 
/// This provider handles:
/// - Current theme mode selection
/// - Theme persistence across app restarts
/// - Theme switching with proper state updates
/// - Background image selection based on theme
/// 
/// Usage:
/// ```dart
/// // Get the provider
/// final themeProvider = Provider.of<ThemeProvider>(context);
/// 
/// // Switch theme
/// themeProvider.setThemeMode(AppThemeMode.dark);
/// 
/// // Get current theme
/// final currentTheme = themeProvider.themeMode;
/// ```
class ThemeProvider extends ChangeNotifier {
  static final _logger = getLogger('ThemeProvider');
  static const String _themePreferenceKey = 'app_theme_mode';

  AppThemeMode _themeMode = AppThemeMode.light;
  bool _isInitialized = false;

  /// Current theme mode
  AppThemeMode get themeMode => _themeMode;

  /// Whether the provider has been initialized
  bool get isInitialized => _isInitialized;

  /// Get current brightness based on theme mode
  Brightness get brightness {
    switch (_themeMode) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        // TODO: Implement system theme detection
        return Brightness.light;
    }
  }

  /// Get background image path for current theme
  String get backgroundImagePath => _themeMode.backgroundImagePath;

  /// Check if current theme is dark
  bool get isDarkMode => brightness == Brightness.dark;

  /// Initialize theme from saved preferences
  Future<void> initialize() async {
    _logger.debug('Initializing ThemeProvider');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeIndex = prefs.getInt(_themePreferenceKey);
      
      if (savedThemeIndex != null && 
          savedThemeIndex >= 0 && 
          savedThemeIndex < AppThemeMode.values.length) {
        _themeMode = AppThemeMode.values[savedThemeIndex];
        _logger.info('Loaded saved theme: ${_themeMode.displayName}');
      } else {
        _logger.info('No saved theme found, using default: ${_themeMode.displayName}');
      }
      
      _isInitialized = true;
      notifyListeners();
      
    } catch (e, stackTrace) {
      _logger.error('Error initializing theme', error: e, stackTrace: stackTrace);
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Set theme mode and persist the selection
  Future<void> setThemeMode(AppThemeMode mode) async {
    _logger.debug('Setting theme mode to: ${mode.displayName}');
    
    if (_themeMode == mode) {
      _logger.debug('Theme mode unchanged, skipping update');
      return;
    }

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePreferenceKey, mode.index);
      _logger.info('Theme mode saved: ${mode.displayName}');
    } catch (e, stackTrace) {
      _logger.error('Error saving theme preference', error: e, stackTrace: stackTrace);
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _logger.debug('Toggling theme');
    
    final newMode = _themeMode == AppThemeMode.light 
        ? AppThemeMode.dark 
        : AppThemeMode.light;
    
    await setThemeMode(newMode);
  }

  /// Cycle through all available themes
  Future<void> cycleTheme() async {
    _logger.debug('Cycling to next theme');
    
    final currentIndex = _themeMode.index;
    final nextIndex = (currentIndex + 1) % AppThemeMode.values.length;
    final nextMode = AppThemeMode.values[nextIndex];
    
    await setThemeMode(nextMode);
  }
}














