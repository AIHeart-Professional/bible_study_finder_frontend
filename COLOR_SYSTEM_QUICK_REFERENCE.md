# Color System Quick Reference

## 🎨 Quick Access

```dart
import 'package:bible_study_finder/utils/app_colors.dart';

// Get theme-aware colors (recommended)
final colors = AppColors.of(context);

// Use colors
Container(color: colors.bgPrimary)
Text(style: TextStyle(color: colors.textPrimary))
```

## 📋 All Available Colors

### Backgrounds
```dart
colors.bgPrimary      // Main background
colors.bgSecondary    // Secondary background
colors.bgTertiary     // Tertiary background
colors.bgSurface      // Surface backgrounds
colors.bgCard         // Card backgrounds
colors.bgInput        // Input field backgrounds
colors.bgNavBar       // Navigation bar
colors.bgAppBar       // App bar
```

### Text
```dart
colors.textPrimary    // Main text
colors.textSecondary  // Secondary text
colors.textTertiary   // Tertiary text
colors.textInverse    // Inverse text
colors.textOnPrimary  // Text on primary color
colors.textOnSecondary // Text on secondary color
colors.textOnError    // Text on error color
```

### Brand
```dart
colors.brandPrimary   // Main brand (#6B73FF)
colors.brandSecondary // Secondary brand
colors.brandTertiary  // Tertiary brand
colors.brandAccent    // Accent color
```

### Semantic
```dart
colors.success        // Success (green)
colors.warning        // Warning (orange)
colors.error          // Error (red)
colors.info           // Info (blue)
```

### Borders
```dart
colors.borderPrimary  // Primary borders
colors.borderSecondary // Secondary borders
colors.divider        // Dividers
```

### Shadows
```dart
colors.shadowLight    // Light shadows
colors.shadowDark     // Dark shadows
```

### Interactive
```dart
colors.link           // Links
colors.linkHover      // Link hover
colors.disabled       // Disabled state
```

## 💡 Common Patterns

### Container with Background
```dart
Container(
  color: AppColors.of(context).bgCard,
  child: YourWidget(),
)
```

### Text with Color
```dart
Text(
  'Hello',
  style: TextStyle(
    color: AppColors.of(context).textPrimary,
  ),
)
```

### Button
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.of(context).brandPrimary,
    foregroundColor: AppColors.of(context).textOnPrimary,
  ),
  onPressed: () {},
  child: Text('Click'),
)
```

### Border
```dart
Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: AppColors.of(context).borderPrimary,
    ),
  ),
)
```

### Shadow
```dart
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.of(context).shadowLight,
        blurRadius: 8,
      ),
    ],
  ),
)
```

## 🎯 Light vs Dark Values

### Light Theme
- `bgPrimary`: `#FFFFFF` (White)
- `bgCard`: `#FFFFFF` (White)
- `textPrimary`: `#000000` (Black)
- `brandPrimary`: `#6B73FF` (Purple-Blue)

### Dark Theme
- `bgPrimary`: `#121212` (Very Dark)
- `bgCard`: `#1E1E1E` (Dark Gray)
- `textPrimary`: `#FFFFFF` (White)
- `brandPrimary`: `#7B83FF` (Lighter Purple-Blue)

## 🔧 Customization

Edit `lib/utils/app_colors.dart` to change any color:

```dart
// Light theme
@override
Color get bgPrimary => const Color(0xFFFFFFFF); // Change hex value

// Dark theme  
@override
Color get bgPrimary => const Color(0xFF121212); // Change hex value
```

All colors are in one place for easy maintenance!

