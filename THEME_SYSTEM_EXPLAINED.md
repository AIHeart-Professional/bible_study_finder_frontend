# Theme System - How It Works & Color Variables

## 🎨 How The Theme System Works

### Architecture Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      App Startup                             │
│  main() → ThemeProvider.initialize() → Load saved theme     │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              MaterialApp Setup                               │
│  MyApp → ChangeNotifierProvider → Consumer<ThemeProvider>  │
│                                                              │
│  theme: AppThemes.lightTheme                                │
│  darkTheme: AppThemes.darkTheme                             │
│  themeMode: _getThemeMode(themeProvider.themeMode)          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│           ThemeProvider State Management                     │
│  - Stores current theme mode (light/dark/system)            │
│  - Notifies listeners when theme changes                     │
│  - Persists theme to SharedPreferences                       │
│  - Provides background image path                            │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              AppThemes Configuration                         │
│  - Defines color schemes for light/dark                      │
│  - Sets component styles (cards, buttons, inputs)            │
│  - Provides opacity helper methods                           │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              Widget Tree                                     │
│  - All widgets access Theme.of(context)                      │
│  - BackgroundImage uses themeProvider.backgroundImagePath    │
│  - Components use Theme.of(context).colorScheme.*           │
└─────────────────────────────────────────────────────────────┘
```

## 🎨 Color System Explained

### 1. Primary Seed Color

**Location**: `lib/utils/app_themes.dart` line 12

```dart
static const Color _primarySeedColor = Color(0xFF6B73FF);
```

This is the **ONLY hard-coded color** in the theme system! It's a purple-blue color (`#6B73FF`) that Flutter uses to generate the entire color scheme.

### 2. Color Scheme Generation

**Location**: `lib/utils/app_themes.dart` lines 16-19 (light) and 88-91 (dark)

```dart
// Light Theme
final colorScheme = ColorScheme.fromSeed(
  seedColor: _primarySeedColor,  // #6B73FF
  brightness: Brightness.light,
);

// Dark Theme  
final colorScheme = ColorScheme.fromSeed(
  seedColor: _primarySeedColor,  // Same #6B73FF
  brightness: Brightness.dark,
);
```

**What `ColorScheme.fromSeed()` does:**
- Takes your seed color (`#6B73FF`)
- Generates a complete Material 3 color palette:
  - `primary` - Main brand color
  - `secondary` - Accent color
  - `tertiary` - Additional accent
  - `surface` - Background surfaces
  - `background` - Main background
  - `error` - Error states
  - `onPrimary`, `onSecondary`, etc. - Text colors on colored backgrounds
  - And more!

### 3. Accessing Colors in Your Code

**You DON'T use hard-coded colors!** Instead, you access them through the theme:

```dart
// ✅ CORRECT: Access colors from theme
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.secondary
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.onSurface
Theme.of(context).colorScheme.error

// ❌ WRONG: Hard-coded colors
Colors.blue
Color(0xFF6B73FF)
Colors.red
```

### 4. Available Color Variables

When you use `Theme.of(context).colorScheme`, you get access to:

#### Primary Colors
- `colorScheme.primary` - Main brand color (derived from seed)
- `colorScheme.onPrimary` - Text color on primary background
- `colorScheme.primaryContainer` - Lighter variant of primary
- `colorScheme.onPrimaryContainer` - Text on primary container

#### Secondary Colors
- `colorScheme.secondary` - Accent color
- `colorScheme.onSecondary` - Text color on secondary
- `colorScheme.secondaryContainer` - Lighter variant
- `colorScheme.onSecondaryContainer` - Text on secondary container

#### Surface Colors
- `colorScheme.surface` - Card/surface backgrounds
- `colorScheme.onSurface` - Main text color
- `colorScheme.surfaceContainerHighest` - Highest elevation surface
- `colorScheme.surfaceContainerHigh` - High elevation surface
- `colorScheme.surfaceContainer` - Medium elevation surface
- `colorScheme.surfaceContainerLow` - Low elevation surface
- `colorScheme.surfaceContainerLowest` - Lowest elevation surface

#### Background Colors
- `colorScheme.background` - Main app background
- `colorScheme.onBackground` - Text on background

#### Other Colors
- `colorScheme.error` - Error states
- `colorScheme.onError` - Text on error
- `colorScheme.outline` - Borders/dividers
- `colorScheme.outlineVariant` - Subtle borders
- `colorScheme.shadow` - Shadow color
- `colorScheme.scrim` - Overlay color
- `colorScheme.inverseSurface` - Inverse surface
- `colorScheme.onInverseSurface` - Text on inverse surface
- `colorScheme.inversePrimary` - Inverse primary

## 📊 How Colors Change Between Themes

### Light Theme Colors (Generated from #6B73FF)
```
Primary:        #6B73FF (your seed color)
Secondary:      Auto-generated complementary color
Surface:        #FFFFFF (white)
Background:     #FFFFFF (white)
OnSurface:      #000000 (black text)
OnPrimary:      #FFFFFF (white text on primary)
```

### Dark Theme Colors (Same seed, different brightness)
```
Primary:        #6B73FF (same seed, but adjusted for dark)
Secondary:      Auto-generated (adjusted for dark)
Surface:        #1E1E1E (dark gray)
Background:     #121212 (very dark)
OnSurface:      #FFFFFF (white text)
OnPrimary:      #000000 (dark text on primary)
```

## 🎯 Opacity System

### Why Opacity?

We use opacity to make UI elements semi-transparent so the background image shows through while maintaining readability.

### Opacity Variables

**Location**: `lib/utils/app_themes.dart` lines 158-176

```dart
// Navigation bars
AppThemes.getNavigationBarOpacity(brightness)
// Light: 0.85 (85%)
// Dark: 0.88 (88%)

// Cards
AppThemes.getCardOpacity(brightness)
// Light: 0.95 (95%)
// Dark: 0.92 (92%)

// Containers
AppThemes.getContainerOpacity(brightness)
// Both: 0.90 (90%)

// Input fields
AppThemes.getInputOpacity(brightness)
// Both: 0.90 (90%)
```

### How Opacity is Applied

```dart
// Example: Navigation bar
Container(
  color: Theme.of(context).colorScheme.surface.withOpacity(
    themeProvider.isDarkMode ? 0.88 : 0.85
  ),
)
```

## 🔄 Complete Flow Example

### When User Toggles Theme:

1. **User clicks theme toggle button**
   ```dart
   ThemeToggleButton → themeProvider.cycleTheme()
   ```

2. **ThemeProvider updates state**
   ```dart
   _themeMode = AppThemeMode.dark
   notifyListeners()  // Notifies all listening widgets
   ```

3. **MaterialApp rebuilds**
   ```dart
   Consumer<ThemeProvider> detects change
   → MaterialApp rebuilds with new themeMode
   → Applies AppThemes.darkTheme
   ```

4. **All widgets rebuild**
   ```dart
   Theme.of(context) now returns dark theme
   → All colors automatically update
   → BackgroundImage switches to background-dark.jpg
   ```

5. **Theme is saved**
   ```dart
   SharedPreferences saves theme preference
   → Survives app restart
   ```

## 📝 Code Examples

### Example 1: Using Theme Colors

```dart
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  ),
)
```

### Example 2: Theme-Aware Container

```dart
final themeProvider = Provider.of<ThemeProvider>(context);
final opacity = themeProvider.isDarkMode ? 0.88 : 0.85;

Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface.withOpacity(opacity),
    borderRadius: BorderRadius.circular(12),
  ),
  child: YourContent(),
)
```

### Example 3: Conditional Styling

```dart
final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

Text(
  'Hello',
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: isDark ? FontWeight.w400 : FontWeight.w500,
  ),
)
```

## 🎨 Hard-Coded Colors (Only Where Necessary)

### In `app_themes.dart`:

1. **Primary Seed Color** (line 12)
   ```dart
   static const Color _primarySeedColor = Color(0xFF6B73FF);
   ```

2. **Dark Mode Specific Colors** (lines 112, 129, 141, 150)
   ```dart
   // Dark card background
   color: const Color(0xFF1E1E1E).withOpacity(0.92)
   
   // Dark input background
   fillColor: const Color(0xFF2A2A2A).withOpacity(0.9)
   ```

These are **only** used in theme definitions, not in your app code!

## 🚫 What NOT to Do

```dart
// ❌ DON'T: Hard-code colors in your widgets
Container(color: Colors.blue)
Text(style: TextStyle(color: Colors.black))

// ❌ DON'T: Use the seed color directly
Container(color: Color(0xFF6B73FF))

// ❌ DON'T: Same opacity for all themes
Container(color: Colors.white.withOpacity(0.85))
```

## ✅ What TO Do

```dart
// ✅ DO: Use theme colors
Container(color: Theme.of(context).colorScheme.primary)
Text(style: TextStyle(color: Theme.of(context).colorScheme.onSurface))

// ✅ DO: Use theme-appropriate opacity
final opacity = themeProvider.isDarkMode ? 0.88 : 0.85;
Container(color: Theme.of(context).colorScheme.surface.withOpacity(opacity))

// ✅ DO: Let Material 3 generate colors
// Just use Theme.of(context).colorScheme.*
```

## 🔍 Finding Colors in Your Codebase

### Search for color usage:

```bash
# Find hard-coded colors (should be minimal)
grep -r "Color(0x" lib/
grep -r "Colors\." lib/

# Find theme color usage (should be everywhere)
grep -r "colorScheme\." lib/
grep -r "Theme.of(context)" lib/
```

## 📚 Summary

### Color Variables:
- ✅ **1 seed color**: `_primarySeedColor = Color(0xFF6B73FF)`
- ✅ **Auto-generated**: All other colors from `ColorScheme.fromSeed()`
- ✅ **Access via**: `Theme.of(context).colorScheme.*`
- ✅ **No hard-coding**: Colors adapt automatically to light/dark themes

### Opacity Variables:
- ✅ **Helper methods**: `AppThemes.get*Opacity(brightness)`
- ✅ **Theme-aware**: Different values for light vs dark
- ✅ **Consistent**: Same opacity for similar components

### Theme Flow:
1. Seed color → ColorScheme generation
2. ThemeProvider → State management
3. MaterialApp → Theme application
4. Widgets → Access via `Theme.of(context)`
5. BackgroundImage → Automatic switching

The beauty of this system is that **you only define colors once** (the seed color), and Flutter automatically generates a beautiful, accessible color palette that adapts to both light and dark themes! 🎨✨

