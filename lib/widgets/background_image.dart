import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_provider.dart';

/// A widget that wraps content with a theme-aware background image.
/// 
/// This widget automatically switches background images based on the current theme:
/// - Light theme: uses 'assets/images/background.jpg'
/// - Dark theme: uses 'assets/images/background-dark.jpg'
/// 
/// The background image is displayed behind all content and fills the entire screen.
class BackgroundImage extends StatelessWidget {
  /// The child widget to display on top of the background.
  final Widget child;
  
  /// Optional override for the background image path.
  /// If not provided, uses the theme-appropriate image.
  final String? imagePathOverride;
  
  /// The opacity of the background image (0.0 to 1.0).
  /// Defaults to 1.0 (fully opaque).
  final double opacity;

  const BackgroundImage({
    super.key,
    required this.child,
    this.imagePathOverride,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // Get the theme provider to determine current theme
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    // Use override path if provided, otherwise use theme-appropriate image
    final imagePath = imagePathOverride ?? themeProvider.backgroundImagePath;
    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          opacity: opacity,
        ),
      ),
      child: child,
    );
  }
}

