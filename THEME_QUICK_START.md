# Theme System - Quick Start Guide

## 🚀 Quick Implementation

### 1. Switch Theme Programmatically

```dart
import 'package:provider/provider.dart';
import 'package:bible_study_finder/providers/theme_provider.dart';
import 'package:bible_study_finder/utils/theme_mode_enum.dart';

// In your widget
final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

// Switch to dark mode
await themeProvider.setThemeMode(AppThemeMode.dark);

// Switch to light mode
await themeProvider.setThemeMode(AppThemeMode.light);

// Toggle between light/dark
await themeProvider.toggleTheme();
```

### 2. Add Theme Toggle Button

```dart
import 'package:bible_study_finder/widgets/theme_toggle_button.dart';

// In your AppBar or anywhere
AppBar(
  actions: [
    const ThemeToggleButton(), // Simple icon button
  ],
)
```

### 3. Check Current Theme

```dart
final themeProvider = Provider.of<ThemeProvider>(context);

if (themeProvider.isDarkMode) {
  // Do something for dark mode
} else {
  // Do something for light mode
}
```

### 4. Use Theme-Aware Opacity

```dart
final themeProvider = Provider.of<ThemeProvider>(context);
final opacity = themeProvider.isDarkMode ? 0.88 : 0.85;

Container(
  color: Colors.white.withOpacity(opacity),
  child: YourWidget(),
)
```

## 📱 UI Components

### Icon Button (Default)
```dart
const ThemeToggleButton()
```

### Chip with Label
```dart
const ThemeToggleButton(
  style: ThemeToggleStyle.chip,
)
```

### Card with Details
```dart
const ThemeToggleButton(
  style: ThemeToggleStyle.card,
)
```

### Selection Dialog
```dart
IconButton(
  icon: Icon(Icons.palette),
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) => const ThemeSelectionDialog(),
    );
  },
)
```

## 🎨 Theme Colors

### Using Theme Colors (Recommended)
```dart
// Primary color
color: Theme.of(context).colorScheme.primary

// Surface color
color: Theme.of(context).colorScheme.surface

// Background color
color: Theme.of(context).colorScheme.background

// Text colors
color: Theme.of(context).colorScheme.onSurface
```

### Avoid Hard-Coded Colors
```dart
// ❌ Bad - Won't adapt to theme
color: Colors.blue

// ✅ Good - Adapts to theme
color: Theme.of(context).colorScheme.primary
```

## 🖼️ Background Images

### Automatic (Recommended)
```dart
// Automatically switches based on theme
BackgroundImage(
  child: YourWidget(),
)
```

### Manual Override
```dart
// Use specific background regardless of theme
BackgroundImage(
  imagePathOverride: 'assets/images/custom.jpg',
  child: YourWidget(),
)
```

## 💾 Persistence

Theme preferences are automatically saved and restored:
- ✅ Survives app restarts
- ✅ No manual save required
- ✅ Instant switching

## 🔧 Common Patterns

### Theme-Aware Container
```dart
Widget buildContainer(BuildContext context) {
  final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
  
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withOpacity(
        isDark ? 0.88 : 0.85,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: YourContent(),
  );
}
```

### Theme-Aware Text
```dart
Text(
  'Hello World',
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
  ),
)
```

### Theme-Aware Card
```dart
Card(
  color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
  child: YourContent(),
)
```

## 🐛 Troubleshooting

### Theme Not Changing?
1. Ensure `Provider` is wrapping your widget tree
2. Check `ThemeProvider` is initialized in `main.dart`
3. Use `Provider.of<ThemeProvider>(context)` not `context.read()`

### Background Not Switching?
1. Verify both images exist: `background.jpg` and `background-dark.jpg`
2. Check `pubspec.yaml` includes assets
3. Ensure using `BackgroundImage` widget

### Opacity Looks Wrong?
1. Use theme-appropriate values (88% dark, 85% light)
2. Check `AppThemes.getNavigationBarOpacity(brightness)`
3. Test in both themes

## 📚 More Information

- Full documentation: `THEME_SYSTEM.md`
- Background styling: `BACKGROUND_STYLING_GUIDE.md`
- Architecture rules: `.cursor/rules/frontend-architecture-rules.mdc`

## ⚡ Performance Tips

1. **Use `listen: false`** when you don't need rebuilds:
   ```dart
   final provider = Provider.of<ThemeProvider>(context, listen: false);
   ```

2. **Avoid unnecessary rebuilds**:
   ```dart
   Consumer<ThemeProvider>(
     builder: (context, provider, child) {
       // Only this part rebuilds
       return ThemedWidget();
     },
   )
   ```

3. **Cache opacity values**:
   ```dart
   final opacity = useMemoized(() => 
     isDarkMode ? 0.88 : 0.85
   );
   ```

## 🎯 Best Practices

1. ✅ Always use `Theme.of(context)` for colors
2. ✅ Test UI in both light and dark modes
3. ✅ Use theme-appropriate opacity values
4. ✅ Provide theme toggle in accessible location
5. ✅ Respect user's theme preference
6. ❌ Don't hard-code colors
7. ❌ Don't use same opacity for all themes
8. ❌ Don't forget to test contrast ratios

