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

### 2.1 (Optional) Install Markdown Preview Extension

For better viewing of markdown documentation files (`.md`), you can install the **Markdown Preview Enhanced** extension in your code editor:

**For VS Code:**
- Open Extensions (Ctrl+Shift+X / Cmd+Shift+X)
- Search for "Markdown Preview Enhanced"
- Install by Yiyi Wang
- Right-click any `.md` file and select "Open Preview" or press Ctrl+K V

**Benefits:**
- Better formatted preview of README and feature documentation
- Syntax highlighting
- Table rendering
- Easier navigation through documentation

This will help you read the project documentation more clearly:
- `README.md` - Main project documentation
- `lib/features/auth/README.md` - Auth feature documentation
- `lib/features/transaction/README.md` - Transaction feature documentation

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

### 4. Login Credentials

Once the application is running, use the following test credentials to log in:

| Field | Value |
|-------|-------|
| **Username** | `test123` |
| **Password** | `test123` |

**Note:** These are hardcoded credentials for testing and development purposes. In a production environment, authentication should use a real backend API.

**Demo Credentials Display:**
The login screen displays these credentials in a helpful card labeled "Demo Credentials" for easy reference during testing.

### 5. Running Tests

The project includes comprehensive unit and widget tests with 100% passing rate.

#### Run All Tests

```bash
flutter test
```

#### Run Tests with Coverage Report

```bash
flutter test --coverage
```

This generates a `coverage/` directory with coverage data.

#### Run Tests for a Specific Feature

```bash
# Auth feature tests
flutter test test/features/auth/

# Transaction feature tests
flutter test test/features/transaction/
```

#### Run Tests with Verbose Output

```bash
flutter test -v
```

#### Run a Specific Test File

```bash
flutter test test/features/auth/presentation/screens/login_screen_test.dart
```

#### Run Tests and Watch for Changes

```bash
flutter test --watch
```

#### Test Coverage Information

The project has comprehensive test coverage across all layers:

**Auth Feature:** 41 tests (100% passing)
- Domain layer: LoginUseCase tests
- Data layer: PasswordUtils, LocalAuthDataSource, AuthRepositoryImpl tests
- Presentation layer: AuthCubit, LoginScreen tests

**Transaction Feature:** 993+ lines of tests
- Domain layer: Use case tests for getting, recording cash-in, and recording send transactions
- Data layer: TransactionModel JSON serialization/deserialization tests
- Presentation layer: TransactionCubit, TransactionListItem, TransactionsScreen tests

#### Viewing Test Results

After running tests, you'll see output like:

```
✓ All tests passed!

Ran 41 tests in test/features/auth/ (X.XXs)
```

Each test file includes:
- Unit tests for business logic (domain layer)
- Data tests for models and repositories (data layer)
- Widget tests for UI components (presentation layer)
- BLoC tests for state management using `bloc_test`

#### Testing Tools Used

- **flutter_test**: Core testing framework
- **mocktail**: Mocking and stubbing
- **bloc_test**: BLoC/Cubit state testing

### 6. Build for Release

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
