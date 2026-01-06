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

The project is organized by user role for better maintainability and scalability:

```
lib/
├── main.dart              # Entry point
├── core/
│   └── constants/         # App constants (colors, etc.)
├── models/
│   ├── student/           # Student-specific data models
│   ├── professor/         # Professor-specific data models
│   ├── common/            # Shared data models
│   └── admin/             # Administration data models (placeholder)
├── services/              # API and external services
├── viewmodels/
│   ├── student/           # Student-specific view models
│   ├── professor/         # Professor-specific view models
│   ├── common/            # Shared view models (login, settings, etc.)
│   ├── admin/             # Administration view models (placeholder)
│   └── auth/              # Authentication view models
├── views/
│   ├── student/           # Student screens (student_e_view, absences_e_view, etc.)
│   ├── professor/         # Professor screens (home_view, exams_view, etc.)
│   ├── common/            # Shared screens (login, settings, about, general_info)
│   ├── admin/             # Administration screens (placeholder)
│   └── auth/              # Authentication screens (forgot_password, reset_password)
└── widgets/               # Reusable widgets
```

### User Roles

1. **Student** (`student/`): Contains all student-specific pages for viewing grades, schedules, absences, documents, messages, and tickets.

2. **Professor** (`professor/`): Contains all professor-specific pages for managing courses, exams, notes, absences, announcements, and calendar.

3. **Common** (`common/`): Contains pages shared across all user roles like login, settings, about, and general information.

4. **Admin** (`admin/`): Placeholder folder for future administration functionality.

## Architecture Pattern

This project follows the MVVM (Model-View-ViewModel) pattern for clean architecture and separation of concerns.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

## Backend Integration

This frontend communicates with the backend server. See [../backend/README.md](../backend/README.md) for backend setup instructions.
