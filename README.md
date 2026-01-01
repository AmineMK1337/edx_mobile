# My App - Project Structure

A Flutter mobile application with a Node.js backend, organized with clear separation of concerns.

## Architecture

```
my_app/
├── frontend/          # Flutter mobile application
│   ├── lib/
│   ├── android/
│   ├── ios/
│   ├── web/
│   ├── windows/
│   ├── linux/
│   ├── macos/
│   ├── pubspec.yaml
│   └── README.md
│
└── backend/           # Node.js Express backend server
    ├── src/
    ├── package.json
    └── README.md
```

## Getting Started

### Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run
```

See [frontend/README.md](frontend/README.md) for more details.

### Backend (Node.js)

```bash
cd backend
npm install
npm run dev
```

See [backend/README.md](backend/README.md) for more details.

## Project Structure Details

- **frontend/** - Flutter mobile application
  - Contains all Flutter-specific code, configurations, and platform-specific files
  - Includes iOS, Android, Web, Windows, Linux, and macOS implementations

- **backend/** - Node.js Express backend server
  - REST API server
  - Business logic and data management
  - Database integration (when implemented)

## Development

For detailed instructions on setting up and running the frontend or backend, refer to their respective README files.
