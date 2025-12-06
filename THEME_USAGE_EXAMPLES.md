# Theme System - Usage Examples

## 🎨 Common Use Cases

### 1. Basic Theme Switching

```dart
import 'package:provider/provider.dart';
import 'package:bible_study_finder/providers/theme_provider.dart';
import 'package:bible_study_finder/utils/theme_mode_enum.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    return ElevatedButton(
      onPressed: () => themeProvider.toggleTheme(),
      child: Text('Toggle Theme'),
    );
  }
}
```

### 2. Theme-Aware UI Component

```dart
class ThemedCard extends StatelessWidget {
  final Widget child;
  
  const ThemedCard({required this.child});
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final opacity = themeProvider.isDarkMode ? 0.92 : 0.95;
    
    return Card(
      color: Theme.of(context).colorScheme.surface.withOpacity(opacity),
      elevation: themeProvider.isDarkMode ? 4 : 3,
      child: child,
    );
  }
}
```

### 3. Conditional Rendering Based on Theme

```dart
class ThemeAwareIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Icon(
      isDark ? Icons.dark_mode : Icons.light_mode,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
```

### 4. Theme Selection Menu

```dart
class ThemeMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppThemeMode>(
      icon: Icon(Icons.palette),
      onSelected: (mode) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.setThemeMode(mode);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppThemeMode.light,
          child: Row(
            children: [
              Icon(Icons.light_mode),
              SizedBox(width: 8),
              Text('Light'),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppThemeMode.dark,
          child: Row(
            children: [
              Icon(Icons.dark_mode),
              SizedBox(width: 8),
              Text('Dark'),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppThemeMode.system,
          child: Row(
            children: [
              Icon(Icons.brightness_auto),
              SizedBox(width: 8),
              Text('System'),
            ],
          ),
        ),
      ],
    );
  }
}
```

### 5. Settings Page with Theme Option

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.palette),
          title: Text('Theme'),
          subtitle: Text(themeProvider.themeMode.displayName),
          trailing: ThemeToggleButton(style: ThemeToggleStyle.chip),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ThemeSelectionDialog(),
            );
          },
        ),
      ],
    );
  }
}
```

### 6. Custom Background for Specific Page

```dart
class CustomBackgroundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      imagePathOverride: 'assets/images/custom-background.jpg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Custom Background')),
        body: YourContent(),
      ),
    );
  }
}
```

### 7. Theme-Aware Container with Shadow

```dart
class ThemedContainer extends StatelessWidget {
  final Widget child;
  
  const ThemedContainer({required this.child});
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(
          isDark ? 0.90 : 0.90,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: isDark ? 12 : 8,
            offset: Offset(0, isDark ? 4 : 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
```

### 8. Animated Theme Transition

```dart
class AnimatedThemedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      color: Theme.of(context).colorScheme.surface.withOpacity(
        themeProvider.isDarkMode ? 0.88 : 0.85,
      ),
      child: YourContent(),
    );
  }
}
```

### 9. Theme-Aware Text Styling

```dart
class ThemedText extends StatelessWidget {
  final String text;
  
  const ThemedText(this.text);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
        fontWeight: isDark ? FontWeight.w400 : FontWeight.w500,
      ),
    );
  }
}
```

### 10. Theme Toggle with Animation

```dart
class AnimatedThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
      child: IconButton(
        key: ValueKey(themeProvider.themeMode),
        icon: Icon(
          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        ),
        onPressed: () => themeProvider.toggleTheme(),
      ),
    );
  }
}
```

## 🎯 Advanced Patterns

### 1. Theme-Aware Gradient

```dart
LinearGradient getThemeGradient(BuildContext context) {
  final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
  
  return LinearGradient(
    colors: [
      Theme.of(context).colorScheme.primary.withOpacity(isDark ? 0.9 : 0.9),
      Theme.of(context).colorScheme.secondary.withOpacity(isDark ? 0.9 : 0.9),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

### 2. Responsive Theme-Aware Layout

```dart
class ResponsiveThemedLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isWeb = MediaQuery.of(context).size.width > 600;
    
    return Container(
      color: Theme.of(context).colorScheme.surface.withOpacity(
        themeProvider.isDarkMode ? 0.88 : 0.85,
      ),
      child: isWeb ? WebLayout() : MobileLayout(),
    );
  }
}
```

### 3. Theme State Listener

```dart
class ThemeListener extends StatefulWidget {
  final Widget child;
  
  const ThemeListener({required this.child});
  
  @override
  State<ThemeListener> createState() => _ThemeListenerState();
}

class _ThemeListenerState extends State<ThemeListener> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    provider.addListener(_onThemeChanged);
  }
  
  void _onThemeChanged() {
    print('Theme changed to: ${context.read<ThemeProvider>().themeMode}');
    // Perform actions on theme change
  }
  
  @override
  void dispose() {
    context.read<ThemeProvider>().removeListener(_onThemeChanged);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => widget.child;
}
```

### 4. Theme-Aware Navigation

```dart
class ThemedNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final navOpacity = themeProvider.isDarkMode ? 0.88 : 0.85;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(navOpacity),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(themeProvider.isDarkMode ? 0.3 : 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: [...],
      ),
    );
  }
}
```

### 5. Optimized Theme Consumer

```dart
class OptimizedThemedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Only rebuild when theme changes, not on every provider update
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          color: Theme.of(context).colorScheme.surface.withOpacity(
            themeProvider.isDarkMode ? 0.88 : 0.85,
          ),
          child: child, // This doesn't rebuild
        );
      },
      child: ExpensiveWidget(), // Cached, doesn't rebuild
    );
  }
}
```

## 🛠️ Utility Functions

### 1. Get Theme-Appropriate Color

```dart
Color getThemedColor(BuildContext context, {
  required Color lightColor,
  required Color darkColor,
}) {
  final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
  return isDark ? darkColor : lightColor;
}
```

### 2. Get Theme-Appropriate Opacity

```dart
double getThemedOpacity(BuildContext context, {
  required double lightOpacity,
  required double darkOpacity,
}) {
  final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
  return isDark ? darkOpacity : lightOpacity;
}
```

### 3. Execute Theme-Specific Code

```dart
T executeForTheme<T>(
  BuildContext context, {
  required T Function() onLight,
  required T Function() onDark,
}) {
  final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
  return isDark ? onDark() : onLight();
}
```

## 📱 Real-World Examples

### Complete Settings Page

```dart
class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: ListView(
        children: [
          _buildThemeSection(context),
          _buildPreviewSection(context),
        ],
      ),
    );
  }
  
  Widget _buildThemeSection(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('App Theme'),
            subtitle: Text('Choose your preferred theme'),
          ),
          ...AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              value: mode,
              groupValue: themeProvider.themeMode,
              title: Text(mode.displayName),
              subtitle: Text(_getThemeDescription(mode)),
              secondary: Icon(_getThemeIcon(mode)),
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildPreviewSection(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ThemedContainer(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('This is how your theme looks!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getThemeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Bright and clear';
      case AppThemeMode.dark:
        return 'Easy on the eyes';
      case AppThemeMode.system:
        return 'Follows device settings';
    }
  }
  
  IconData _getThemeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
```

## 🎓 Best Practices

1. **Always use `listen: false` when you don't need rebuilds**
2. **Use `Consumer` for targeted rebuilds**
3. **Cache expensive computations**
4. **Test in both themes**
5. **Use theme colors, not hard-coded values**
6. **Provide theme toggle in accessible location**
7. **Document theme-specific behavior**

## 🚫 Anti-Patterns to Avoid

```dart
// ❌ Bad: Hard-coded colors
Container(color: Colors.blue)

// ✅ Good: Theme colors
Container(color: Theme.of(context).colorScheme.primary)

// ❌ Bad: Same opacity for all themes
Container(color: Colors.white.withOpacity(0.85))

// ✅ Good: Theme-appropriate opacity
Container(
  color: Colors.white.withOpacity(
    isDarkMode ? 0.88 : 0.85
  )
)

// ❌ Bad: Unnecessary rebuilds
Provider.of<ThemeProvider>(context) // Rebuilds on every change

// ✅ Good: Targeted listening
Provider.of<ThemeProvider>(context, listen: false) // No rebuilds
```

