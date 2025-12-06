# Background Image Styling Guide

This document describes the professional styling approach used to integrate the background image throughout the Bible Study Finder app.

## Design Philosophy

The app uses a **layered transparency approach** where:
- Background image is always visible
- UI elements have semi-transparent backgrounds
- Shadows and elevation create depth
- Consistent opacity levels maintain professionalism

## Opacity Levels

### Standard Opacity Values
- **Cards**: `0.95` - Nearly opaque for readability
- **Navigation bars (top & bottom)**: `0.85` - Slightly transparent to show background
- **AppBars (header bar)**: `0.85` - Consistent with navigation bars
- **Containers**: `0.7-0.9` - Varies by content importance
- **Input fields**: `0.9` - High opacity for usability
- **Gradient overlays**: `0.9` - Maintains color vibrancy

## Component Styling

### 1. Navigation Elements

#### Bottom Navigation Bar
```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, -2),
      ),
    ],
  ),
  child: BottomNavigationBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    ...
  ),
)
```

#### AppBar (Header Bar)
```dart
PreferredSize(
  preferredSize: const Size.fromHeight(kToolbarHeight),
  child: Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      ...
    ),
  ),
)
```

### 2. Cards

#### Study Group Cards
```dart
Card(
  elevation: 3,
  color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
  ...
)
```

#### Church Cards
```dart
Card(
  elevation: 3,
  color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ...
)
```

### 3. Containers

#### Header Containers with Gradients
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary.withOpacity(0.9),
        Theme.of(context).colorScheme.secondary.withOpacity(0.9),
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
)
```

#### Content Containers
```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
)
```

### 4. Input Fields

```dart
InputDecoration(
  filled: true,
  fillColor: Colors.white.withOpacity(0.9),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  ),
)
```

### 5. Scaffolds

All Scaffold widgets must have:
```dart
Scaffold(
  backgroundColor: Colors.transparent,
  ...
)
```

## Theme Configuration

### Global Theme Settings (main.dart)

```dart
ThemeData(
  scaffoldBackgroundColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 3,
    color: Colors.white.withOpacity(0.95),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.9),
  ),
)
```

## Shadow Guidelines

### Elevation Shadows
- **Light shadows** (0.1 opacity): Subtle depth for containers
- **Medium shadows** (0.15 opacity): Cards and important elements
- **No shadows**: Transparent navigation elements

### Shadow Patterns
```dart
// Standard container shadow
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 8,
    offset: const Offset(0, 2),
  ),
]

// Header/Important element shadow
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 10,
    offset: const Offset(0, 4),
  ),
]

// Bottom navigation shadow (upward)
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 8,
    offset: const Offset(0, -2),
  ),
]
```

## Best Practices

1. **Consistency**: Use the same opacity levels for similar components
2. **Readability**: Ensure text remains readable against the background
3. **Hierarchy**: Use elevation and shadows to create visual hierarchy
4. **Performance**: Avoid excessive transparency layers
5. **Testing**: Test on different screen sizes and brightness levels

## Files Modified

### Core Navigation
- `lib/navigation/navbar.dart`

### Pages
- `lib/pages/home/home_page.dart`
- `lib/pages/groups/my_groups_page.dart`
- `lib/pages/bible/bible_page.dart`
- `lib/pages/churches/churches_page.dart`
- `lib/pages/groups/search_page.dart`
- `lib/pages/groups/group_chats_tab.dart`
- `lib/pages/groups/group_detail_page.dart`
- `lib/pages/groups/create_group_page.dart`
- `lib/pages/auth/auth_page.dart`
- `lib/pages/study/study_page.dart`

### Widgets
- `lib/widgets/background_image.dart`
- `lib/widgets/study_group_card.dart`
- `lib/widgets/church_card.dart`

### Theme
- `lib/main.dart`

## Maintenance

When adding new UI elements:
1. Always set `backgroundColor: Colors.transparent` on Scaffolds
2. Use `.withOpacity()` on all solid backgrounds
3. Add appropriate shadows for depth
4. Test readability against the background image
5. Maintain consistent opacity levels with existing components

