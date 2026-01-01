# Frontend - Flutter Mobile Application

A Flutter mobile application for my_app platform.

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK (comes with Flutter)
- iOS development requirements (Xcode on macOS)
- Android development requirements (Android Studio)

### Installation

```bash
# Get dependencies
flutter pub get

# Run on your device/emulator
flutter run
```

## Project Structure

```
lib/
├── main.dart              # Entry point
├── core/
│   ├── constants/         # App constants
│   └── utils/             # Utility functions
├── models/                # Data models
├── services/              # API and external services
├── viewmodels/            # Business logic (MVVM pattern)
├── views/                 # UI screens
└── widgets/               # Reusable widgets
```

## Architecture Pattern

This project follows the MVVM (Model-View-ViewModel) pattern for clean architecture and separation of concerns.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

## Backend Integration

This frontend communicates with the backend server. See [../backend/README.md](../backend/README.md) for backend setup instructions.
