# Calculator (Flutter)

Simple, fast, and responsive calculator built with Flutter. Supports basic arithmetic operations and runs on Android, iOS, Web, Windows, macOS, and Linux.

## Features

- Basic operations: addition, subtraction, multiplication, division
- Clear (C/AC) and backspace
- Keyboard input support on desktop/web
- Responsive layout for phone, tablet, and desktop

## Tech Stack

- Flutter (Dart)
- Material Design widgets

## Requirements

- Flutter SDK installed (`flutter --version` should work)
- Android Studio/Xcode/Visual Studio as needed per platform

## Getting Started

1) Install dependencies

```powershell
flutter pub get
```

2) Run on your preferred platform

```powershell
# Android (emulator or device)
flutter run -d android

# iOS (simulator)
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

If you have multiple devices, list them with:

```powershell
flutter devices
```

## Project Structure

```
lib/
  main.dart        // App entry point and calculator UI/logic
test/
  widget_test.dart // Example widget test
```

## Testing

```powershell
flutter test
```

## Build Releases

```powershell
# Android APK (debug)
flutter build apk --debug

# Android APK (release)
flutter build apk --release

# iOS (release, requires code signing)
flutter build ios --release

# Web (release)
flutter build web

# Windows (release)
flutter build windows --release
```

Artifacts are output to the `build/` directory.

## Troubleshooting

- Run `flutter doctor -v` and resolve any reported issues
- If builds fail after SDK updates, try `flutter clean && flutter pub get`

## License

This project is provided as-is. You may use, modify, and distribute it per your needs.
