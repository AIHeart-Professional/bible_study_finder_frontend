# Bible Study Finder

A Flutter application for finding and managing Bible study groups with an integrated theme system supporting light and dark modes.

## 🚀 Launch Application

```bash
# Launch emulator
flutter emulators --launch Pixel_7

# Run application
flutter run -d emulator-5554

# Run on Chrome (web)
flutter run -d chrome
```

## ✨ Features

- **Theme System**: Professional light/dark mode with automatic background switching
- **Bible Study Groups**: Find, join, and manage study groups
- **Church Finder**: Discover churches in your area
- **Bible Reader**: Read and study scripture with multiple translations
- **Study Plans**: Structured Bible study plans
- **Notifications**: Stay updated with group activities

## 🎨 Theme System

The app features a professional theme system with:
- ✅ Light and Dark modes
- ✅ System theme support
- ✅ Automatic background image switching
- ✅ Persistent theme preferences
- ✅ Smooth transitions
- ✅ Theme toggle in navigation bar

### Quick Theme Usage

```dart
// Switch theme
final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
await themeProvider.setThemeMode(AppThemeMode.dark);

// Add theme toggle button
const ThemeToggleButton()
```

📚 **Documentation**:
- [Theme System Guide](THEME_SYSTEM.md) - Complete documentation
- [Quick Start Guide](THEME_QUICK_START.md) - Quick reference
- [Background Styling](BACKGROUND_STYLING_GUIDE.md) - Styling guidelines

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── navigation/                  # Navigation and routing
├── pages/                       # UI pages (by domain)
├── widgets/                     # Reusable UI components
├── services/                    # Business logic
├── apis/                        # API communication
├── models/                      # Data models
├── providers/                   # State management
└── utils/                       # Utilities and helpers

assets/
└── images/
    ├── background.jpg           # Light mode background
    └── background-dark.jpg      # Dark mode background
```

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (^3.9.2)
- Dart SDK
- Android Studio / VS Code
- Firebase account (for notifications)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase (see `API_SETUP.md`)
4. Run the app:
   ```bash
   flutter run
   ```

## 📦 Dependencies

Key packages:
- `provider: ^6.1.1` - State management
- `shared_preferences: ^2.2.2` - Local storage
- `firebase_core: ^3.0.0` - Firebase integration
- `firebase_messaging: ^15.0.0` - Push notifications
- `http: ^1.1.0` - HTTP requests
- `go_router: ^14.2.7` - Navigation

See `pubspec.yaml` for complete list.

## 🏗️ Architecture

The app follows a clean architecture pattern:
- **Pages**: UI layer
- **Services**: Business logic
- **APIs**: Backend communication
- **Models**: Data structures
- **Providers**: State management

See [Frontend Architecture Rules](.cursor/rules/frontend-architecture-rules.mdc) for details.

TODO:
High priority:

Group Details
- Allow roles for group owners.
  - Set creator to owner.
  - Allow the ability to provide roles.
  - Set role functionality.
  - Allow uploading study-guide/creating in-app.
- Fix info tab for groups
- Implement worksheet link that allows users to go straight to the bible chapter/verse.
Find Groups
- Remove groups you are already apart of.
Bible
- Allow caching of current bible version
- Fix the verses in chapter from saying '0' to listing the actual verse number.

Low priority:
Homepage
- Make homepage more unique and clean.
- Create unique UX design to standout.
Groups
- Move 'Join group' and 'Leave group' to the left side of the card.
- Make sure cards match for 'My Groups' and 'Find Groups' tabs.
Study Guide
- Implement study plans (Similar to bible app)
Churches
- Allow finding actual churches through external API.
