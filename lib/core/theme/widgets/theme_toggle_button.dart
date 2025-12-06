import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../theme_mode.dart';

/// A button widget for toggling between different theme modes.
/// 
/// This widget provides a visual way for users to switch between
/// light, dark, and system themes. It displays the current theme
/// with an icon and allows cycling through available themes.
class ThemeToggleButton extends StatelessWidget {
  /// Whether to show the theme name text
  final bool showLabel;
  
  /// Custom icon size
  final double? iconSize;
  
  /// Button style variant
  final ThemeToggleStyle style;

  const ThemeToggleButton({
    super.key,
    this.showLabel = false,
    this.iconSize,
    this.style = ThemeToggleStyle.icon,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    switch (style) {
      case ThemeToggleStyle.icon:
        return _buildIconButton(context, themeProvider);
      case ThemeToggleStyle.chip:
        return _buildChip(context, themeProvider);
      case ThemeToggleStyle.card:
        return _buildCard(context, themeProvider);
    }
  }

  Widget _buildIconButton(BuildContext context, ThemeProvider themeProvider) {
    return IconButton(
      icon: Icon(_getIconData(themeProvider.themeMode)),
      iconSize: iconSize ?? 24,
      tooltip: 'Switch to ${_getNextTheme(themeProvider.themeMode).displayName} mode',
      onPressed: () => themeProvider.cycleTheme(),
    );
  }

  Widget _buildChip(BuildContext context, ThemeProvider themeProvider) {
    return ActionChip(
      avatar: Icon(
        _getIconData(themeProvider.themeMode),
        size: 18,
      ),
      label: Text(themeProvider.themeMode.displayName),
      onPressed: () => themeProvider.cycleTheme(),
    );
  }

  Widget _buildCard(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      child: InkWell(
        onTap: () => themeProvider.cycleTheme(),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getIconData(themeProvider.themeMode)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Theme',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    themeProvider.themeMode.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  AppThemeMode _getNextTheme(AppThemeMode current) {
    final currentIndex = current.index;
    final nextIndex = (currentIndex + 1) % AppThemeMode.values.length;
    return AppThemeMode.values[nextIndex];
  }
}

/// Style variants for the theme toggle button
enum ThemeToggleStyle {
  /// Simple icon button
  icon,
  
  /// Chip with icon and label
  chip,
  
  /// Card with detailed information
  card,
}

/// A dialog for selecting theme mode with all available options
class ThemeSelectionDialog extends StatelessWidget {
  const ThemeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AlertDialog(
      title: const Text('Choose Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: AppThemeMode.values.map((mode) {
          final isSelected = themeProvider.themeMode == mode;
          
          return ListTile(
            leading: Icon(
              _getIconData(mode),
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
            title: Text(mode.displayName),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            selected: isSelected,
            onTap: () {
              themeProvider.setThemeMode(mode);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  IconData _getIconData(AppThemeMode mode) {
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

