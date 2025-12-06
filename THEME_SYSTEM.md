# Theme System Documentation

## Overview

The Bible Study Finder app implements a professional, extensible theme system that supports multiple themes (Light, Dark, and System) with automatic background image switching and persistent user preferences.

## Architecture

### Core Components

1. **Theme Provider** (`lib/providers/theme_provider.dart`)
   - Manages theme state using Flutter's `ChangeNotifier`
   - Persists theme selection using `SharedPreferences`
   - Provides theme switching methods
   - Automatically switches background images

2. **Theme Configurations** (`lib/utils/app_themes.dart`)
   - Centralized theme definitions
   - Light and dark theme configurations
   - Consistent opacity values
   - Material 3 design implementation

3. **Theme Mode Enum** (`lib/utils/theme_mode_enum.dart`)
   - Defines available theme modes
   - Maps themes to background images
   - Provides display names and icons

4. **Theme-Aware Background** (`lib/widgets/background_image.dart`)
   - Automatically switches background images based on theme
   - Supports manual override
   - Seamless integration with theme provider

5. **Theme Toggle UI** (`lib/widgets/theme_toggle_button.dart`)
   - Multiple style variants (icon, chip, card)
   - Theme selection dialog
   - Integrated into navigation bar

## Theme Modes

### Light Mode
- **Background**: `assets/images/background.jpg`
- **Color Scheme**: Light brightness with primary color #6B73FF
- **Opacity**: 85% for navigation, 95% for cards
- **Best for**: Daytime use, bright environments

### Dark Mode
- **Background**: `assets/images/background-dark.jpg`
- **Color Scheme**: Dark brightness with primary color #6B73FF
- **Opacity**: 88% for navigation, 92% for cards
- **Best for**: Nighttime use, low-light environments

### System Mode
- **Background**: Follows system preference
- **Color Scheme**: Matches system theme
- **Automatic**: Switches with device settings
- **Best for**: Users who want automatic switching

## Usage

### Basic Theme Switching

```dart
// Get the theme provider
final themeProvider = Provider.of<ThemeProvider>(context);

// Switch to a specific theme
await themeProvider.setThemeMode(AppThemeMode.dark);

// Toggle between light and dark
await themeProvider.toggleTheme();

// Cycle through all themes
await themeProvider.cycleTheme();

// Check current theme
final isDark = themeProvider.isDarkMode;
final currentTheme = themeProvider.themeMode;
```

### Using Theme Toggle Button

```dart
// Simple icon button (default)
const ThemeToggleButton()

// Chip with label
const ThemeToggleButton(
  style: ThemeToggleStyle.chip,
  showLabel: true,
)

// Card with details
const ThemeToggleButton(
  style: ThemeToggleStyle.card,
)

// Show theme selection dialog
showDialog(
  context: context,
  builder: (context) => const ThemeSelectionDialog(),
)
```

### Theme-Aware Widgets

```dart
// Background automatically switches with theme
BackgroundImage(
  child: YourWidget(),
)

// Override background image
BackgroundImage(
  imagePathOverride: 'assets/images/custom.jpg',
  child: YourWidget(),
)

// Access theme provider in widgets
final themeProvider = Provider.of<ThemeProvider>(context);
final opacity = themeProvider.isDarkMode ? 0.88 : 0.85;
```

## Adding New Themes

### Step 1: Add Theme Mode

Edit `lib/utils/theme_mode_enum.dart`:

```dart
enum AppThemeMode {
  light,
  dark,
  system,
  custom, // New theme
}
```

### Step 2: Add Background Image

1. Add image to `assets/images/background-custom.jpg`
2. Update `pubspec.yaml` if needed
3. Update `backgroundImagePath` getter in enum

### Step 3: Create Theme Configuration

Edit `lib/utils/app_themes.dart`:

```dart
static ThemeData get customTheme {
  return ThemeData(
    // Your custom theme configuration
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.light,
    ),
    // ... other configurations
  );
}
```

### Step 4: Update Main App

Edit `lib/main.dart` to include new theme:

```dart
MaterialApp(
  theme: AppThemes.lightTheme,
  darkTheme: AppThemes.darkTheme,
  // Add custom theme handling
  themeMode: _getThemeMode(themeProvider.themeMode),
)
```

## Opacity Guidelines

### Light Mode Opacity Values
- **Navigation bars**: 85%
- **Cards**: 95%
- **Containers**: 90%
- **Input fields**: 90%
- **Dialogs**: 95%
- **Bottom sheets**: 95%

### Dark Mode Opacity Values
- **Navigation bars**: 88% (slightly higher for better contrast)
- **Cards**: 92%
- **Containers**: 90%
- **Input fields**: 90%
- **Dialogs**: 95%
- **Bottom sheets**: 95%

### Accessing Opacity Values

```dart
// Get theme-appropriate opacity
final navOpacity = AppThemes.getNavigationBarOpacity(
  Theme.of(context).brightness
);

final cardOpacity = AppThemes.getCardOpacity(
  Theme.of(context).brightness
);
```

## Theme Persistence

Themes are automatically persisted using `SharedPreferences`:

- **Storage Key**: `app_theme_mode`
- **Storage Format**: Integer index of `AppThemeMode` enum
- **Initialization**: Automatic on app startup
- **Fallback**: Defaults to light mode if no saved preference

## Integration Points

### Main App Entry
```dart
// Initialize theme provider before app starts
final themeProvider = ThemeProvider();
await themeProvider.initialize();

// Wrap app with provider
ChangeNotifierProvider.value(
  value: themeProvider,
  child: MyApp(),
)
```

### Navigation Bar
- Theme toggle button in AppBar actions
- Dynamic opacity based on current theme
- Smooth transitions between themes

### Background Images
- Automatic switching via `BackgroundImage` widget
- No manual intervention required
- Preloaded for smooth transitions

## Best Practices

### 1. Always Use Theme Colors
```dart
// Good
color: Theme.of(context).colorScheme.primary

// Bad
color: Colors.blue
```

### 2. Use Theme-Aware Opacity
```dart
// Good
final opacity = themeProvider.isDarkMode ? 0.88 : 0.85;

// Bad
final opacity = 0.85; // Same for all themes
```

### 3. Test Both Themes
- Always test UI changes in both light and dark modes
- Ensure text remains readable
- Check contrast ratios

### 4. Respect System Preferences
- Provide system theme option
- Don't force users into a specific theme
- Persist user's explicit choice

## Troubleshooting

### Theme Not Persisting
- Check `SharedPreferences` initialization
- Verify `ThemeProvider.initialize()` is called
- Ensure async initialization completes before app builds

### Background Image Not Switching
- Verify both background images exist in assets
- Check `pubspec.yaml` includes both images
- Ensure `BackgroundImage` widget is used correctly

### Opacity Issues
- Use theme-appropriate opacity values
- Check `AppThemes.get*Opacity()` methods
- Verify brightness detection

### Provider Not Found
- Ensure `ChangeNotifierProvider` wraps MaterialApp
- Check provider is initialized before use
- Verify import statements

## Performance Considerations

1. **Image Preloading**: Background images are loaded on demand
2. **State Management**: Provider only notifies when theme changes
3. **Persistence**: Async operations don't block UI
4. **Memory**: Only one background image loaded at a time

## Accessibility

- High contrast support in dark mode
- Readable text in all themes
- System theme respects accessibility settings
- Keyboard navigation for theme toggle

## Future Enhancements

Potential additions to the theme system:

1. **Custom Color Schemes**: User-defined primary colors
2. **Scheduled Themes**: Auto-switch based on time of day
3. **Location-Based**: Theme based on sunrise/sunset
4. **Theme Presets**: Predefined theme combinations
5. **Gradient Backgrounds**: Support for gradient backgrounds
6. **Animation**: Smooth transitions between themes

## File Structure

```
lib/
├── providers/
│   └── theme_provider.dart          # Theme state management
├── utils/
│   ├── app_themes.dart              # Theme configurations
│   └── theme_mode_enum.dart         # Theme mode definitions
├── widgets/
│   ├── background_image.dart        # Theme-aware background
│   └── theme_toggle_button.dart     # UI for theme switching
└── main.dart                        # Theme integration

assets/
└── images/
    ├── background.jpg               # Light mode background
    └── background-dark.jpg          # Dark mode background
```

## Dependencies

Required packages in `pubspec.yaml`:

```yaml
dependencies:
  provider: ^6.1.1              # State management
  shared_preferences: ^2.2.2    # Theme persistence
```

## Testing

### Unit Tests
```dart
test('Theme provider switches themes correctly', () async {
  final provider = ThemeProvider();
  await provider.initialize();
  
  await provider.setThemeMode(AppThemeMode.dark);
  expect(provider.themeMode, AppThemeMode.dark);
  expect(provider.isDarkMode, true);
});
```

### Widget Tests
```dart
testWidgets('Theme toggle button switches theme', (tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MaterialApp(
        home: Scaffold(
          body: ThemeToggleButton(),
        ),
      ),
    ),
  );
  
  await tester.tap(find.byType(ThemeToggleButton));
  await tester.pumpAndSettle();
  
  // Verify theme changed
});
```

## Support

For issues or questions about the theme system:
1. Check this documentation
2. Review example implementations in the codebase
3. Test in both light and dark modes
4. Verify all dependencies are installed

## Version History

- **v1.0.0**: Initial theme system implementation
  - Light and dark themes
  - System theme support
  - Theme persistence
  - Background image switching
  - Theme toggle UI

