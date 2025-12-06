# Background Image

Place your background image file in this directory.

## Supported Formats
- `.jpg` / `.jpeg`
- `.png`
- `.webp`

## Default File Name
The application expects the background image to be named:
- `background.jpg` (default)

If you use a different filename or format, update the `imagePath` parameter in `lib/widgets/background_image.dart` or when using the `BackgroundImage` widget.

## Usage
The background image is automatically applied to all pages through the `MainNavigator` widget. The AppBar has a semi-transparent background (90% opacity) to ensure readability while showing the background image.

## Customization
To customize the background image opacity or use a different image, modify the `BackgroundImage` widget usage in `lib/navigation/navbar.dart`.

