# maya_e_wallet

A Flutter e-wallet application.

## Prerequisites

Before running this project, ensure you have the following installed:

- **Flutter**: Latest stable version (compatible with the SDK constraints)
- **Dart**: Version 3.5.0 or higher (up to 4.0.0)
- **Git**: For cloning the repository

You can check your Flutter and Dart versions by running:
```bash
flutter --version
dart --version
```

If you don't have Flutter installed, follow the [Flutter installation guide](https://docs.flutter.dev/get-started/install).

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd maya_e_wallet
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the Application

For iOS:
```bash
flutter run -d iPhone
```

For Android:
```bash
flutter run -d Android
```

For Web:
```bash
flutter run -d web
```

Or simply use:
```bash
flutter run
```
to run on the default connected device or emulator.

### 4. Build for Release

For Android:
```bash
flutter build apk
```

For iOS:
```bash
flutter build ios
```

For Web:
```bash
flutter build web
```

## Project Structure

- `lib/` - Main application source code
- `test/` - Unit and widget tests
- `pubspec.yaml` - Project dependencies and configuration

## Dependencies

- **flutter**: Flutter SDK
- **cupertino_icons**: iOS style icons
- **flutter_lints**: Recommended linting rules

## Troubleshooting

If you encounter issues:

1. **Ensure Flutter is up to date:**
   ```bash
   flutter upgrade
   ```

2. **Clean build files:**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Check for platform-specific issues:**
   - **iOS**: Run `flutter doctor -v` to check for Xcode/CocoaPods issues
   - **Android**: Ensure Android SDK is properly configured

For more help, run:
```bash
flutter doctor -v
```

## Resources

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
