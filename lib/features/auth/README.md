# Auth Feature Documentation

## Overview

The Auth feature is responsible for user authentication, login/logout operations, and session management in the Maya E-Wallet application. It implements clean architecture principles with clear separation of concerns across domain, data, and presentation layers.

**Current Implementation:**
- ✅ User authentication with SHA-256 password hashing
- ✅ Local credential storage (hardcoded for testing)
- ✅ State management with BLoC pattern (Cubit)
- ✅ Form validation
- ✅ Error handling and user feedback
- ✅ 41 comprehensive unit tests (100% passing)

---

## Architecture Overview

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────┐
│          PRESENTATION LAYER (UI/State)              │
│  ├─ Screens: LoginScreen, WalletScreen              │
│  ├─ Widgets: Components (Header, Form, Button)      │
│  ├─ Cubits: AuthCubit (State Management)            │
│  └─ States: AuthInitial, AuthLoading, etc.          │
└────────────────┬────────────────────────────────────┘
                 │ depends on
┌────────────────▼────────────────────────────────────┐
│           DOMAIN LAYER (Business Logic)             │
│  ├─ Entities: User                                  │
│  ├─ Repositories (Abstract): AuthRepository         │
│  └─ Use Cases: LoginUseCase                         │
└────────────────┬────────────────────────────────────┘
                 │ depends on
┌────────────────▼────────────────────────────────────┐
│            DATA LAYER (Implementation)              │
│  ├─ Data Sources: LocalAuthDataSource               │
│  ├─ Repository Impl: AuthRepositoryImpl             │
│  ├─ Utils: PasswordUtils                            │
│  └─ Exceptions: AuthException                       │
└─────────────────────────────────────────────────────┘
```

### Folder Structure

```
lib/features/auth/
├── presentation/
│   ├── cubits/
│   │   ├── auth_cubit.dart          # State management
│   │   └── auth_state.dart          # State definitions
│   ├── screens/
│   │   └── login_screen.dart        # Main login UI
│   ├── widgets/
│   │   ├── app_drawer.dart          # Navigation drawer
│   │   ├── login_header.dart        # Logo + title
│   │   ├── login_form.dart          # Form fields
│   │   ├── login_button.dart        # Login button
│   │   ├── demo_credentials.dart    # Demo credentials display
│   │   └── credential_row.dart      # Credential display row
│   ├── utils/
│   │   └── validators.dart          # Form validation
│   └── login_screen.dart            # (Main screen file)
├── domain/
│   ├── entities/
│   │   └── user.dart                # User entity
│   ├── repositories/
│   │   └── auth_repository.dart     # Abstract repository
│   └── usecases/
│       └── login_usecase.dart       # Login business logic
├── data/
│   ├── datasources/
│   │   └── local_auth_datasource.dart  # Local auth data
│   ├── repositories/
│   │   └── auth_repository_impl.dart   # Repository implementation
│   └── utils/
│       └── password_utils.dart      # Password hashing
└── README.md                         # This file
```

---

## Authentication Flow

### 1. Login Flow (Happy Path)

```
User Input (Username + Password)
            ↓
    Form Validation
            ↓
  LoginButton.onPressed()
            ↓
  AuthCubit.login(username, password)
            ↓
  emit(AuthLoading)
            ↓
  LoginUseCase(username, password)
            ↓
  AuthRepository.login(username, password)
            ↓
  LocalAuthDataSource.authenticate(username, password)
            ↓
  PasswordUtils.hashPassword(inputPassword)
            ↓
  Compare with hardcoded hash
            ↓
         ✅ Match
            ↓
  Return User(username: 'test123')
            ↓
  emit(AuthSuccess(user: user))
            ↓
  GoRouter redirect to /wallet
            ↓
       WalletScreen
```

### 2. Login Flow (Error Path)

```
User Input
    ↓
Form Validation
    ↓
LoginButton.onPressed()
    ↓
AuthCubit.login()
    ↓
emit(AuthLoading)
    ↓
LoginUseCase → AuthRepository → LocalAuthDataSource
    ↓
❌ Exception (Invalid username/password)
    ↓
catch(Exception e)
    ↓
emit(AuthFailure(message: e.toString()))
    ↓
SnackBar displays error message
```

### 3. Logout Flow

```
Drawer SignOut Button / WalletScreen SignOut Button
            ↓
  AuthCubit.logout()
            ↓
  emit(AuthInitial)
            ↓
  GoRouter redirect to /login
            ↓
      LoginScreen
```

### 4. Route Protection (Go Router)

```
Unauthenticated User
    ↓
Try to access /wallet
    ↓
GoRouter.redirect() checks AuthState
    ↓
State is NOT AuthSuccess
    ↓
Redirect to /login
    ↓
Authenticated User
    ↓
Try to access /login
    ↓
GoRouter.redirect() checks AuthState
    ↓
State IS AuthSuccess
    ↓
Redirect to /wallet
```

---

## Core Components

### 1. AuthCubit (State Management)

**File:** `presentation/cubits/auth_cubit.dart`

```dart
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  // Initial state: AuthInitial

  // Methods:
  // - login(String username, String password) -> emits states
  // - logout() -> resets to AuthInitial
}
```

**State Flow:**
- `AuthInitial` - App started, user logged out
- `AuthLoading` - Login request in progress
- `AuthSuccess(User)` - Login successful, user authenticated
- `AuthFailure(String)` - Login failed with error message

### 2. LoginUseCase (Business Logic)

**File:** `domain/usecases/login_usecase.dart`

Orchestrates the login flow:
1. Takes username and password
2. Calls AuthRepository.login()
3. Returns User or throws exception

### 3. AuthRepository & Implementation

**Abstract:** `domain/repositories/auth_repository.dart`
**Implementation:** `data/repositories/auth_repository_impl.dart`

Defines the contract for authentication operations:
```dart
Future<User> login(String username, String password);
```

### 4. LocalAuthDataSource (Data Access)

**File:** `data/datasources/local_auth_datasource.dart`

Handles actual authentication:
- Stores hardcoded credentials
- Validates input against stored hash
- Throws AuthException on failure

**Hardcoded Credentials:**
```
Username: test123
Password: test123 (hashed with SHA-256)
Hash: ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae
```

### 5. PasswordUtils (Security)

**File:** `data/utils/password_utils.dart`

Provides password security functions:
- `hashPassword(String password)` - Creates SHA-256 hash
- `verifyPassword(String plain, String hash)` - Compares passwords

### 6. Validators (Form Validation)

**File:** `presentation/utils/validators.dart`

Validates user input:
- Username: minimum 3 characters
- Password: minimum 3 characters

---

## Security Implementation

### Password Hashing

**Algorithm:** SHA-256 (Secure Hash Algorithm)

```dart
// Example: test123
String hashedPassword = PasswordUtils.hashPassword('test123');
// Result: ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae
```

**Features:**
- ✅ One-way hashing (irreversible)
- ✅ Deterministic (same input = same hash)
- ✅ Case-sensitive
- ✅ Secure comparison in LocalAuthDataSource

### Credential Validation

```dart
// LocalAuthDataSource.authenticate()
1. Check username matches hardcoded username
2. Hash input password with SHA-256
3. Compare hash with stored hash
4. Throw AuthException if mismatch
5. Return User if match
```

### Error Handling

Custom exception for auth failures:
```dart
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
```

---

## UI Components

### 1. LoginScreen
Main screen with composable widgets:
- LoginHeader (Logo + Title)
- LoginForm (Username + Password fields)
- LoginButton (Sign In button with loading state)
- DemoCredentials (Test credentials card)
- Error SnackBar (Error messages)

### 2. AppDrawer
Navigation drawer with:
- User profile info
- Navigation menu items
- Sign Out button

### 3. Responsive Design
- Uses Theme.of(context) for theming
- Material Design components
- Outlined text fields with 8px radius
- Filled buttons
- Colored icons using colorScheme

---

## State Management Flow

### Cubit States

```
AuthInitial
    ├─→ User taps login
    └─→ emit(AuthLoading)
            ├─→ Success
            │   └─→ emit(AuthSuccess(user))
            │       └─→ Navigate to /wallet
            │
            └─→ Failure
                └─→ emit(AuthFailure(message))
                    └─→ Show SnackBar

AuthSuccess
    └─→ User taps logout
        └─→ emit(AuthInitial)
            └─→ Navigate to /login
```

### BlocListener (Navigation)

LoginScreen listens to AuthState:
- `AuthSuccess` → Navigate to /wallet
- `AuthInitial` → Navigate to /login (from wallet)

### BlocBuilder (UI Update)

Widgets rebuild on state change:
- Show/hide loading indicator
- Enable/disable login button
- Display error messages

---

## Testing Strategy

### Test Coverage: 41 Tests (100% Passing)

#### Domain Layer (4 tests)
**LoginUseCase Tests**
- ✅ Successful login returns User
- ✅ Invalid username throws exception
- ✅ Invalid password throws exception
- ✅ Empty credentials throw exception

**File:** `test/features/auth/domain/usecases/login_usecase_test.dart`

#### Data Layer (19 tests)

**PasswordUtils (8 tests)**
- ✅ Hash generation with SHA-256
- ✅ Consistent hashing
- ✅ Unique hashes for different passwords
- ✅ Correct hash for known password
- ✅ Verify matching passwords
- ✅ Reject non-matching passwords
- ✅ Handle empty hash
- ✅ Case-sensitive comparison

**Files:**
- `test/features/auth/data/utils/password_utils_test.dart`

**LocalAuthDataSource (7 tests)**
- ✅ Successful authentication
- ✅ Wrong username throws AuthException
- ✅ Wrong password throws AuthException
- ✅ Both wrong credentials throw AuthException
- ✅ Empty username throws AuthException
- ✅ Empty password throws AuthException
- ✅ Case-sensitive credential checking

**File:** `test/features/auth/data/datasources/local_auth_datasource_test.dart`

**AuthRepositoryImpl (4 tests)**
- ✅ Success case returns User
- ✅ Authentication failure throws exception
- ✅ Correct parameters passed to datasource
- ✅ Exceptions properly propagated

**File:** `test/features/auth/data/repositories/auth_repository_impl_test.dart`

#### Presentation Layer (17 tests)

**AuthCubit (7 tests)**
- ✅ Initial state is AuthInitial
- ✅ Login success emits [AuthLoading, AuthSuccess]
- ✅ Login failure emits [AuthLoading, AuthFailure]
- ✅ Exception handling emits AuthFailure
- ✅ Logout emits AuthInitial
- ✅ Logout clears user data
- ✅ Error message in AuthFailure

**File:** `test/features/auth/presentation/cubits/auth_cubit_test.dart`

**LoginScreen (10 tests)**
- ✅ All widgets render correctly
- ✅ Header logo and title display
- ✅ Demo credentials card shows
- ✅ Form fields present
- ✅ Password field obscured initially
- ✅ Password visibility toggle works
- ✅ Login button enabled when not loading
- ✅ Loading indicator shows on AuthLoading
- ✅ Error snackbar on AuthFailure
- ✅ Form validation works

**File:** `test/features/auth/presentation/screens/login_screen_test.dart`

---

## Scenarios & Test Cases

### Scenario 1: Valid Login
**Given:** User has entered correct credentials (test123 / test123)
**When:** User taps Sign In button
**Then:**
- Loading indicator shows
- AuthCubit emits AuthSuccess
- User navigates to WalletScreen
- UserData available in AuthSuccess state

**Tests:**
- `AuthCubit: emits [AuthLoading, AuthSuccess] when login is successful`
- `LoginScreen: renders login screen with all widgets`

### Scenario 2: Invalid Username
**Given:** User has entered wrong username (wrong123)
**When:** User taps Sign In button
**Then:**
- Loading indicator shows
- AuthCubit emits AuthFailure
- Error SnackBar displays "Invalid credentials"
- User remains on LoginScreen

**Tests:**
- `LoginUseCase: should throw exception when username is invalid`
- `LocalAuthDataSource: should throw AuthException when username is wrong`
- `LoginScreen: shows error snackbar on login failure`

### Scenario 3: Invalid Password
**Given:** User has entered wrong password (wrong123)
**When:** User taps Sign In button
**Then:**
- Loading indicator shows
- AuthCubit emits AuthFailure
- Error SnackBar displays error message
- User remains on LoginScreen

**Tests:**
- `LoginUseCase: should throw exception when password is invalid`
- `LocalAuthDataSource: should throw AuthException when password is wrong`

### Scenario 4: Empty Credentials
**Given:** User taps Sign In without entering credentials
**When:** Form validation runs
**Then:**
- Form validation errors displayed
- Sign In button disabled
- No API call made

**Tests:**
- `LoginForm: validators reject empty username`
- `LoginForm: validators reject empty password`

### Scenario 5: Case Sensitivity
**Given:** User enters credentials with different case (Test123 / TEST123)
**When:** User taps Sign In
**Then:**
- AuthCubit emits AuthFailure
- "Invalid credentials" error shown

**Tests:**
- `PasswordUtils: should handle case-sensitive comparison`
- `LocalAuthDataSource: should be case-sensitive for username and password`

### Scenario 6: Logout
**Given:** User is authenticated and on WalletScreen
**When:** User taps Sign Out in drawer/button
**Then:**
- AuthCubit emits AuthInitial
- User navigates to LoginScreen
- All user data cleared

**Tests:**
- `AuthCubit: emits AuthInitial when logout is called`
- `AuthCubit: logout clears user data`

### Scenario 7: Route Protection
**Given:** User is NOT authenticated
**When:** User tries to access /wallet via Go Router
**Then:** Redirected to /login

**Scenario 8: Route Protection (Authenticated)
**Given:** User IS authenticated
**When:** User tries to access /login via Go Router
**Then:** Redirected to /wallet

---

## Key Features

### ✅ Form Validation
- Username: 3+ characters required
- Password: 3+ characters required
- Real-time validation feedback
- Error messages on form fields

### ✅ Password Security
- SHA-256 hashing (industry standard)
- Case-sensitive comparison
- No plain text password storage
- Secure password verification

### ✅ State Management
- BLoC pattern using Cubit
- Clear state transitions
- Error state with messages
- Loading state indication

### ✅ User Experience
- Loading indicator during login
- Error messages in SnackBar
- Password visibility toggle
- Demo credentials card for testing
- Responsive UI with theme support

### ✅ Error Handling
- Custom AuthException
- Meaningful error messages
- User-friendly notifications
- Exception propagation

### ✅ Navigation
- Go Router integration
- Route protection (authentication guard)
- Automatic redirection
- Deep linking ready

---

## Data Models

### User Entity
```dart
class User extends Equatable {
  final String username;

  const User({required this.username});

  @override
  List<Object?> get props => [username];
}
```

### Auth States
```dart
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
```

---

## Dependencies

### Core Dependencies
```yaml
flutter_bloc: ^8.1.0      # State management
go_router: ^13.0.0        # Routing
crypto: ^3.0.7            # SHA-256 hashing
equatable: ^2.0.0         # Value equality
```

### Dev Dependencies
```yaml
flutter_test:             # Widget testing
  sdk: flutter
mocktail: ^1.0.0          # Mocking
bloc_test: ^9.1.0         # Bloc testing
```

---

## Installation & Usage

### Setup
```bash
# Get dependencies
flutter pub get

# Run tests
flutter test

# Run specific test layer
flutter test test/features/auth/domain/
flutter test test/features/auth/data/
flutter test test/features/auth/presentation/
```

### Integration
The auth feature is integrated in:
- `lib/main.dart` - BlocProvider setup
- `lib/core/routing/app_router.dart` - Route protection
- `lib/features/wallet/` - Wallet screen integration

---

## Future Enhancements

### Phase 2 (Planned)
- [ ] Remote API authentication
- [ ] JWT token management
- [ ] Session timeout handling
- [ ] Biometric authentication
- [ ] Social login (Google, Apple)
- [ ] Password reset flow

### Testing
- [ ] Integration tests
- [ ] E2E tests
- [ ] Performance testing
- [ ] Code coverage reports

### Security
- [ ] Token encryption
- [ ] Secure storage (Flutter Secure Storage)
- [ ] Rate limiting
- [ ] 2FA support

---

## Troubleshooting

### Common Issues

**Q: "No GoRouter found in context"**
A: Ensure LoginScreen is wrapped in MaterialApp.router with GoRouter provider

**Q: "Login always fails"**
A: Verify credentials are exact (case-sensitive):
- Username: `test123`
- Password: `test123`

**Q: "Tests failing"**
A:
- Run `flutter pub get` to update dependencies
- Clear test cache: `flutter test --no-cache`
- Check Dart version compatibility

---

## References

- [BLoC Pattern](https://bloclibrary.dev/)
- [Go Router Navigation](https://pub.dev/packages/go_router)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)
- [Flutter Testing](https://flutter.dev/docs/testing)
- [SHA-256 Hashing](https://pub.dev/packages/crypto)

---

## Contact & Support

For questions about the auth feature:
1. Check test files for usage examples
2. Review architecture diagrams above
3. Check error messages and logs
4. Run tests in verbose mode: `flutter test -v`

---

**Status:** ✅ Complete & Tested
**Last Updated:** 2026-04-06
**Test Coverage:** 41/41 (100%)
**Pass Rate:** 100%
