# Wallet Feature

A comprehensive wallet management feature for the Maya E-Wallet application. This feature handles balance management, money transfers, and cash-in operations with full input validation and error handling.

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Feature Structure](#feature-structure)
4. [Technical Implementation](#technical-implementation)
5. [Core Components](#core-components)
6. [State Management](#state-management)
7. [Validation Rules](#validation-rules)
8. [Testing](#testing)
9. [Usage Examples](#usage-examples)
10. [Running Tests](#running-tests)

---

## Overview

The Wallet feature provides users with:

- **View Balance**: Display current account balance with toggle to hide/show functionality
- **Send Money**: Transfer funds to other users via email, phone number, or username
- **Cash In**: Add funds to the wallet account with a maximum limit of ₱100,000
- **Balance Management**: Track and manage wallet balance across operations

**Key Features**:
- ✅ Initial balance of ₱500.00
- ✅ Real-time balance updates
- ✅ Balance visibility toggle (hide/show)
- ✅ Comprehensive input validation
- ✅ Error handling and user feedback
- ✅ Transaction confirmations
- ✅ Success/failure notifications

---

## Architecture

The Wallet feature follows **Clean Architecture** principles, divided into three main layers:

```
lib/features/wallet/
├── data/              # Data Layer
├── domain/            # Domain/Business Logic Layer
└── presentation/      # Presentation Layer (UI & State Management)
```

### Layered Architecture Diagram

```
┌─────────────────────────────────────────┐
│      PRESENTATION LAYER                 │
│  (UI, Screens, Widgets, State Mgmt)    │
├─────────────────────────────────────────┤
│                                         │
│  ┌───────────────────────────────┐    │
│  │   Screens                     │    │
│  │ - WalletScreen               │    │
│  │ - SendMoneyScreen            │    │
│  │ - CashInScreen               │    │
│  └───────────────────────────────┘    │
│                  │                      │
│  ┌───────────────▼───────────────┐    │
│  │   WalletCubit (State Mgmt)    │    │
│  │ - loadBalance()               │    │
│  │ - sendMoney()                 │    │
│  │ - cashIn()                    │    │
│  │ - toggleBalanceVisibility()   │    │
│  └───────────────────────────────┘    │
│                  │                      │
└──────────────────┼──────────────────────┘
                   │
        ┌──────────▼──────────┐
        │ Dependency Injection │
        └──────────┬───────────┘
                   │
┌──────────────────▼──────────────────────┐
│     DOMAIN LAYER                        │
│  (Business Logic & Use Cases)          │
├──────────────────────────────────────────┤
│                                          │
│  ┌────────────────────────────────┐    │
│  │   Use Cases                    │    │
│  │ - GetBalanceUseCase           │    │
│  │ - SendMoneyUseCase            │    │
│  │ - CashInUseCase               │    │
│  └────────────────────────────────┘    │
│                  │                       │
│  ┌───────────────▼───────────────┐    │
│  │   Repository Interface        │    │
│  │  (WalletRepository)           │    │
│  └───────────────────────────────┘    │
│                                          │
└──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│     DATA LAYER                          │
│  (Data Sources & Repository Impl)      │
├──────────────────────────────────────────┤
│                                          │
│  ┌────────────────────────────────┐    │
│  │   Repository Implementation    │    │
│  │  (WalletRepositoryImpl)         │    │
│  └────────────────────────────────┘    │
│                  │                       │
│  ┌───────────────▼───────────────┐    │
│  │   Data Sources                │    │
│  │  (LocalWalletDataSource)      │    │
│  └───────────────────────────────┘    │
│                                          │
└──────────────────────────────────────────┘
```

### Design Patterns Used

1. **Clean Architecture**: Separation of concerns across data, domain, and presentation layers
2. **Repository Pattern**: Abstraction of data sources
3. **Use Case Pattern**: Encapsulation of business logic
4. **BLoC/Cubit Pattern**: State management with Flutter BLoC
5. **Dependency Injection**: Loose coupling through constructor injection

---

## Feature Structure

```
lib/features/wallet/
│
├── data/
│   ├── datasources/
│   │   └── local_wallet_datasource.dart    # Local data operations
│   ├── models/
│   │   └── wallet_model.dart               # Data transfer objects
│   └── repositories/
│       └── wallet_repository_impl.dart     # Repository implementation
│
├── domain/
│   ├── entities/
│   │   └── wallet_entity.dart              # Business entities
│   ├── repositories/
│   │   └── wallet_repository.dart          # Repository abstract class
│   └── usecases/
│       ├── get_balance_usecase.dart
│       ├── send_money_usecase.dart
│       └── cash_in_usecase.dart
│
└── presentation/
    ├── cubits/
    │   ├── wallet_cubit.dart               # State management logic
    │   └── wallet_state.dart               # State definitions
    ├── screens/
    │   ├── wallet_screen.dart              # Main wallet view
    │   ├── send_money_screen.dart          # Money transfer screen
    │   └── cash_in_screen.dart             # Deposit screen
    ├── widgets/
    │   ├── wallet/
    │   │   ├── balance_card.dart
    │   │   ├── wallet_header.dart
    │   │   ├── send_money_button.dart
    │   │   └── cash_in_button.dart
    │   ├── send_money/
    │   │   ├── recipient_input_field.dart
    │   │   └── send_money_confirmation_dialog.dart
    │   ├── cash_in/
    │   │   ├── cash_in_amount_input_field.dart
    │   │   └── cash_in_confirmation_dialog.dart
    │   ├── amount_input_field.dart         # Reusable amount input
    │   ├── confirmation_dialog.dart        # Reusable confirmation
    │   └── success_dialog.dart             # Reusable success dialog
    └── utils/
        └── wallet_validators.dart          # Form validation logic
```

---

## Technical Implementation

### 1. Data Layer

#### LocalWalletDataSource
Manages local wallet data operations and validation.

**Key Methods**:
- `getBalance()`: Retrieves current balance and visibility state
- `updateBalance(double)`: Updates account balance
- `sendMoney(String, double)`: Processes money transfer with validation
- `cashIn(double)`: Adds funds with maximum limit validation

**Validation**:
- Send Money: Amount > 0, Amount ≤ Current Balance
- Cash In: Amount > 0, Amount ≤ ₱100,000

#### WalletModel
Data transfer object that extends WalletEntity with serialization:
- `fromJson()`: Parse from JSON/Map
- `toJson()`: Serialize to JSON/Map
- `fromEntity()`: Convert from domain entity

### 2. Domain Layer

#### WalletEntity
Pure business entity with no dependencies:
```dart
class WalletEntity {
  final double balance;
  final bool isBalanceHidden;
}
```

#### Use Cases
Each use case encapsulates a single business operation:

**GetBalanceUseCase**:
```dart
Future<WalletEntity> call() {
  return repository.getBalance();
}
```

**SendMoneyUseCase**:
```dart
Future<void> call(String recipient, double amount) {
  return repository.sendMoney(recipient, amount);
}
```

**CashInUseCase**:
```dart
Future<void> call(double amount) {
  return repository.cashIn(amount);
}
```

### 3. Presentation Layer

#### WalletCubit
State management using Flutter Cubit with three core methods:

**loadBalance()**:
- Emits `WalletLoading` → Fetches balance → Emits `WalletLoaded` or `ActionFailure`

**sendMoney(recipient, amount)**:
- Validates inputs
- Emits `ActionInProgress` → Calls use case → Emits `ActionSuccess` or `ActionFailure`

**cashIn(amount)**:
- Validates amount
- Emits `ActionInProgress` → Calls use case → Emits `ActionSuccess` or `ActionFailure`

**toggleBalanceVisibility()**:
- Toggles `isBalanceHidden` in current WalletLoaded state

---

## Core Components

### Screens

#### WalletScreen
Main wallet dashboard displaying:
- **Balance Card**: Current balance with hide/show toggle
- **Quick Actions**: Send Money and Cash In buttons
- **Error Handling**: Retry button on failure
- **Loading State**: Circular progress indicator

#### SendMoneyScreen
Money transfer interface with:
- **Recipient Input Field**: Accepts email, phone number, or username
- **Amount Input Field**: Validates amount against balance
- **Confirmation Dialog**: Double-check before sending
- **Success/Error Notifications**: User feedback

#### CashInScreen
Deposit funds interface with:
- **Amount Input Field**: Validates against ₱100,000 limit
- **Maximum Limit Display**: Shows "Maximum: ₱100000.00"
- **Confirmation Dialog**: Confirm before processing
- **Success/Error Notifications**: User feedback

### Widgets

#### Balance Card
Displays account balance with visibility toggle.

**Features**:
- Shows formatted balance (₱XXX.XX)
- Eye icon to toggle visibility
- Shows asterisks when hidden (*****)

#### Amount Input Field
Reusable input field for monetary amounts.

**Features**:
- Peso symbol prefix (₱)
- Numeric input only
- Maximum 2 decimal places
- Custom validation
- Error message display

#### Recipient Input Field
Input field for money transfer recipient.

**Features**:
- Accepts email, phone, or username
- Custom validation logic
- Error display
- Helper text guidance

### Validators

#### WalletValidators
Utility class providing validation and formatting functions:

```dart
// Validation
WalletValidators.validateRecipient(String?)
WalletValidators.validateAmount(String?, maxAmount)
WalletValidators.validateCashInAmount(String?, maxAmount)

// Formatting
WalletValidators.formatCurrency(double) // Returns "₱XXX.XX"
```

---

## State Management

### Wallet States

```
WalletState (Abstract Base)
├── WalletInitial           # Initial state
├── WalletLoading           # Loading balance
├── WalletLoaded            # Balance loaded successfully
│   └── Properties: wallet (WalletEntity)
├── ActionInProgress        # Processing transaction
├── ActionSuccess           # Transaction completed
│   └── Properties: message (String)
└── ActionFailure           # Transaction failed
    └── Properties: message (String)
```

### State Transitions

```
Initial
  ↓
loadBalance() → WalletLoading → WalletLoaded or ActionFailure
                                     ↓
                          toggleBalanceVisibility()
                                     ↓
                                WalletLoaded (updated)

WalletLoaded
  ↓
sendMoney() → ActionInProgress → ActionSuccess or ActionFailure

WalletLoaded
  ↓
cashIn() → ActionInProgress → ActionSuccess or ActionFailure
```

---

## Validation Rules

### Send Money

| Rule | Constraint | Error Message |
|------|-----------|---------------|
| Recipient Required | Must not be empty | "Recipient is required" |
| Amount Required | Must not be empty | "Amount is required" |
| Valid Amount Format | Must be numeric | "Invalid amount format" |
| Positive Amount | Amount > 0 | "Amount must be greater than 0" |
| Sufficient Balance | Amount ≤ Available Balance | "Amount exceeds available balance" |
| Decimal Places | Maximum 2 decimals | "Maximum 2 decimal places allowed" |

### Cash In

| Rule | Constraint | Error Message |
|------|-----------|---------------|
| Amount Required | Must not be empty | "Amount is required" |
| Valid Amount Format | Must be numeric | "Invalid amount format" |
| Non-negative | Amount ≥ 0 | "Negative amounts not allowed" |
| Positive Amount | Amount > 0 | "Amount must be greater than 0" |
| Maximum Limit | Amount ≤ ₱100,000 | "Amount exceeds ₱100,000.00 limit" |
| Decimal Places | Maximum 2 decimals | "Maximum 2 decimal places allowed" |

### Balance Constraints

- **Initial Balance**: ₱500.00
- **Minimum Send**: ₱0.01
- **Maximum Send**: Current Balance
- **Minimum Cash In**: ₱0.01
- **Maximum Cash In**: ₱100,000.00
- **Decimal Precision**: 2 decimal places

---

## Testing

### Test Coverage

The wallet feature includes **94 comprehensive tests** covering all layers:

**Data Layer (15 tests)**:
- LocalWalletDataSource operations and validation
- Repository delegation and error handling

**Domain Layer (13 tests)**:
- Use case logic and error propagation
- Multiple input scenarios

**Presentation Layer (66 tests)**:
- Cubit state management and transitions
- Screen UI and interactions
- Widget display and functionality
- Input validation and formatting

### Test Files

| Test File | Location | Tests | Coverage |
|-----------|----------|-------|----------|
| `local_wallet_datasource_test.dart` | `test/data/datasources/` | 9 | Data operations |
| `wallet_repository_impl_test.dart` | `test/data/repositories/` | 6 | Repository pattern |
| `get_balance_usecase_test.dart` | `test/domain/usecases/` | 3 | Balance retrieval |
| `send_money_usecase_test.dart` | `test/domain/usecases/` | 5 | Money transfer |
| `cash_in_usecase_test.dart` | `test/domain/usecases/` | 5 | Cash-in operations |
| `wallet_cubit_test.dart` | `test/presentation/cubits/` | 12 | State management |
| `wallet_screen_test.dart` | `test/presentation/screens/` | 6 | Main screen |
| `send_money_screen_test.dart` | `test/presentation/screens/` | 9 | Transfer screen |
| `cash_in_screen_test.dart` | `test/presentation/screens/` | 8 | Deposit screen |
| `balance_card_test.dart` | `test/presentation/widgets/` | 9 | Balance widget |
| `amount_input_field_test.dart` | `test/presentation/widgets/` | 10 | Amount input |
| `recipient_input_field_test.dart` | `test/presentation/widgets/` | 12 | Recipient input |

### Testing Approach

- **Unit Tests**: Business logic, validators, use cases
- **Widget Tests**: UI components, interactions, validation display
- **Cubit Tests**: State transitions, side effects
- **Mocking**: Repository, use cases, and cubits mocked using `mocktail`
- **Test Patterns**: AAA (Arrange-Act-Assert)

---

## Usage Examples

### 1. Integrating WalletCubit

```dart
// In your main.dart or app setup
BlocProvider(
  create: (context) => WalletCubit(
    getBalanceUseCase: GetBalanceUseCase(repository),
    sendMoneyUseCase: SendMoneyUseCase(repository),
    cashInUseCase: CashInUseCase(repository),
  )..loadBalance(), // Load balance on initialization
  child: const WalletScreen(),
)
```

### 2. Listening to Wallet State

```dart
context.read<WalletCubit>().loadBalance();

BlocListener<WalletCubit, WalletState>(
  listener: (context, state) {
    if (state is WalletLoaded) {
      print('Balance: ₱${state.wallet.balance}');
    } else if (state is ActionSuccess) {
      print('Success: ${state.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is ActionFailure) {
      print('Error: ${state.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  },
  child: const SomeWidget(),
)
```

### 3. Sending Money

```dart
void sendMoney(BuildContext context) {
  final recipient = recipientController.text;
  final amount = double.parse(amountController.text);

  context.read<WalletCubit>().sendMoney(recipient, amount);
}
```

### 4. Cashing In

```dart
void cashIn(BuildContext context) {
  final amount = double.parse(amountController.text);

  context.read<WalletCubit>().cashIn(amount);
}
```

### 5. Using Validators

```dart
String? validateAmount(String? value) {
  return WalletValidators.validateAmount(value, currentBalance);
}

String? validateCashInAmount(String? value) {
  return WalletValidators.validateCashInAmount(value);
}

String formatBalance(double amount) {
  return WalletValidators.formatCurrency(amount);
}
```

---

## Running Tests

### Run All Wallet Tests

```bash
# Run all wallet feature tests
flutter test test/features/wallet/

# Run with coverage
flutter test test/features/wallet/ --coverage

# Run specific test file
flutter test test/features/wallet/presentation/cubits/wallet_cubit_test.dart
```

### Run Tests by Layer

```bash
# Data layer tests
flutter test test/features/wallet/data/

# Domain layer tests
flutter test test/features/wallet/domain/

# Presentation layer tests
flutter test test/features/wallet/presentation/
```

### Run Specific Test Group

```bash
# Run only WalletCubit tests
flutter test test/features/wallet/presentation/cubits/wallet_cubit_test.dart

# Run only screen tests
flutter test test/features/wallet/presentation/screens/
```

### Watch Mode

```bash
# Re-run tests on file changes
flutter test test/features/wallet/ --watch
```

---

## Data Models

### WalletEntity
```dart
class WalletEntity extends Equatable {
  final double balance;
  final bool isBalanceHidden;

  const WalletEntity({
    required this.balance,
    required this.isBalanceHidden,
  });

  @override
  List<Object?> get props => [balance, isBalanceHidden];
}
```

### WalletModel
```dart
class WalletModel extends WalletEntity {
  const WalletModel({
    required super.balance,
    required super.isBalanceHidden,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] as num).toDouble(),
      isBalanceHidden: json['isBalanceHidden'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'isBalanceHidden': isBalanceHidden,
    };
  }
}
```

### Wallet States
```dart
abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;

  const WalletLoaded({required this.wallet});

  @override
  List<Object?> get props => [wallet];
}

class ActionInProgress extends WalletState {
  const ActionInProgress();
}

class ActionSuccess extends WalletState {
  final String message;

  const ActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ActionFailure extends WalletState {
  final String message;

  const ActionFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
```

---

## Test Scenarios & Cases

### Scenario 1: Load Balance Successfully
**Given:** User opens the wallet screen
**When:** WalletCubit initializes and calls loadBalance()
**Then:**
- Loading indicator shows
- WalletCubit emits WalletLoaded with balance
- Balance displays as ₱500.00
- Balance visibility toggle available

**Tests:**
- `WalletCubit: emits [WalletLoading, WalletLoaded] when loadBalance is successful`
- `WalletScreen: displays balance and wallet header when WalletLoaded`

### Scenario 2: Send Money Successfully
**Given:** User is on SendMoneyScreen with balance of ₱500.00
**When:** User enters valid recipient and amount (₱100), then confirms
**Then:**
- Loading indicator shows
- WalletCubit emits ActionSuccess
- Success dialog displays "Money sent successfully"
- User can return to wallet (balance updated)

**Tests:**
- `WalletCubit: emits [ActionInProgress, ActionSuccess] when sendMoney succeeds`
- `SendMoneyScreen: Send button enabled when form is valid`
- `SendMoneyScreen: displays success dialog on transaction`

### Scenario 3: Send Money with Insufficient Balance
**Given:** User has balance of ₱500.00
**When:** User tries to send ₱600.00
**Then:**
- Amount input shows error icon
- "Amount exceeds available balance" error message displays
- Send button disabled
- No transaction processed

**Tests:**
- `WalletCubit: emits [ActionInProgress, ActionFailure] when sendMoney fails`
- `SendMoneyScreen: displays error for amount exceeding balance`
- `AmountInputField: displays error message below field`

### Scenario 4: Cash In Successfully
**Given:** User is on CashInScreen
**When:** User enters valid amount (₱1000), then confirms
**Then:**
- Loading indicator shows
- WalletCubit emits ActionSuccess
- Success dialog displays "Cash in of ₱1000.00 completed"
- Balance updated to ₱1500.00

**Tests:**
- `WalletCubit: emits [ActionInProgress, ActionSuccess] when cashIn succeeds`
- `CashInScreen: Confirm button enabled when form is valid`
- `CashInScreen: accepts valid amount at maximum limit`

### Scenario 5: Cash In Exceeding Maximum Limit
**Given:** User is on CashInScreen
**When:** User tries to cash in ₱100,001.00
**Then:**
- Amount input shows error icon
- "Amount exceeds ₱100,000.00 limit" error displays
- Confirm button disabled
- No transaction processed

**Tests:**
- `WalletCubit: emits [ActionInProgress, ActionFailure] when cashIn exceeds limit`
- `CashInScreen: displays error for amount exceeding maximum`
- `WalletValidators: validates maximum cash-in amount`

### Scenario 6: Toggle Balance Visibility
**Given:** User is viewing wallet with balance ₱500.00
**When:** User taps eye icon to hide balance
**Then:**
- Balance changes to asterisks (******)
- Eye icon changes to eye-off icon
- Tapping again shows balance again

**Tests:**
- `WalletCubit: should toggle balance visibility from false to true`
- `BalanceCard: toggles balance visibility when eye icon is tapped`

### Scenario 7: Zero Amount Validation
**Given:** User enters 0 as amount
**When:** User tries to submit form
**Then:**
- Error message displays "Amount must be greater than 0"
- Button disabled
- No transaction processed

**Tests:**
- `WalletValidators: validates zero amounts`
- `CashInScreen: displays error for zero amount`

### Scenario 8: Decimal Places Validation
**Given:** User enters amount with 3 decimal places (100.999)
**When:** Amount input field attempts to format
**Then:**
- Amount truncated or rejected
- "Maximum 2 decimal places allowed" error (if applicable)
- Only 100.99 accepted

**Tests:**
- `AmountInputField: limits decimal places to 2`
- `WalletValidators: enforces 2 decimal precision`

### Scenario 9: Recipient Type Handling
**Given:** User is on SendMoneyScreen
**When:** User enters different recipient types
**Then:** All valid formats accepted:
- Email: john@example.com ✅
- Phone: 09171234567 ✅
- Username: jane_doe ✅

**Tests:**
- `SendMoneyUseCase: should handle different valid recipients`
- `RecipientInputField: accepts email as recipient`
- `RecipientInputField: accepts phone number as recipient`

### Scenario 10: Load Balance Failure
**Given:** Data source throws exception
**When:** WalletCubit calls loadBalance()
**Then:**
- WalletCubit emits ActionFailure
- Error message displays
- Retry button appears
- User can retry loading balance

**Tests:**
- `WalletCubit: emits [WalletLoading, ActionFailure] when loadBalance fails`
- `WalletScreen: displays error message when ActionFailure`

---

## Installation & Usage

### Setup

```bash
# Get dependencies
flutter pub get

# Run tests
flutter test test/features/wallet/

# Run specific test layer
flutter test test/features/wallet/domain/
flutter test test/features/wallet/data/
flutter test test/features/wallet/presentation/
```

### Integration

The wallet feature is integrated in:
- `lib/main.dart` - BlocProvider setup
- `lib/core/routing/app_router.dart` - Route navigation
- `lib/features/auth/` - Authentication dependency

### Dependency Setup

```dart
// In your service locator or dependency injection setup
final walletRepository = WalletRepositoryImpl(
  localDataSource: LocalWalletDataSourceImpl(),
);

final getBalanceUseCase = GetBalanceUseCase(walletRepository);
final sendMoneyUseCase = SendMoneyUseCase(walletRepository);
final cashInUseCase = CashInUseCase(walletRepository);

BlocProvider(
  create: (context) => WalletCubit(
    getBalanceUseCase: getBalanceUseCase,
    sendMoneyUseCase: sendMoneyUseCase,
    cashInUseCase: cashInUseCase,
  )..loadBalance(),
  child: const WalletScreen(),
)
```

---

## Key Files Reference

### Data Layer
- **local_wallet_datasource.dart** (lines 10-72): Main data source implementation
- **wallet_model.dart** (lines 1-29): Data model with serialization
- **wallet_repository_impl.dart**: Repository implementation

### Domain Layer
- **wallet_entity.dart** (lines 1-14): Business entity
- **wallet_repository.dart** (lines 1-8): Repository interface
- **get_balance_usecase.dart**: Balance retrieval use case
- **send_money_usecase.dart**: Money transfer use case
- **cash_in_usecase.dart**: Cash-in use case

### Presentation Layer
- **wallet_cubit.dart** (lines 1-64): State management
- **wallet_state.dart** (lines 1-48): State definitions
- **wallet_validators.dart** (lines 1-79): Validation utilities
- **wallet_screen.dart**: Main wallet display
- **send_money_screen.dart**: Money transfer screen
- **cash_in_screen.dart**: Deposit screen

---

## Troubleshooting

### Common Issues

**Q: "Balance not loading"**
A: Verify WalletCubit is initialized with loadBalance() called:
```dart
BlocProvider(
  create: (context) => WalletCubit(...)..loadBalance(),
  child: const WalletScreen(),
)
```

**Q: "Send money button always disabled"**
A: Check form validation:
- Recipient field must not be empty
- Amount must be > 0
- Amount must be ≤ available balance
- Amount must have max 2 decimal places

**Q: "Amount input rejects valid input"**
A: Verify decimal places:
- Only 2 decimal places allowed (e.g., 100.50, not 100.500)
- Use numeric input only
- Negative values automatically filtered

**Q: "Tests failing"**
A:
- Run `flutter pub get` to update dependencies
- Clear test cache: `flutter test --no-cache`
- Check Dart version compatibility (3.0+)
- Verify mocktail and bloc_test versions match pubspec.lock

**Q: "Balance visibility toggle not working"**
A: Ensure wallet is in WalletLoaded state before toggling. Check:
- WalletCubit has loaded balance successfully
- toggleBalanceVisibility() only works in WalletLoaded state

**Q: "Cash in amount validation too strict"**
A: Verify validation rules:
- Amount must be between ₱0.01 and ₱100,000.00
- Maximum 2 decimal places
- Negative amounts filtered by input formatter

---

## References

### Architecture & Patterns
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Repository Pattern](https://pub.dev/packages/flutter_bloc)
- [Use Case Pattern](https://medium.com/clean-architecture)

### Flutter Documentation
- [Flutter Testing](https://flutter.dev/docs/testing)
- [Widget Testing](https://flutter.dev/docs/testing/unit-testing)
- [BLoC Testing](https://bloclibrary.dev/testing/)
- [State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt)

### Dependencies
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [equatable](https://pub.dev/packages/equatable)
- [mocktail](https://pub.dev/packages/mocktail)
- [bloc_test](https://pub.dev/packages/bloc_test)

---

## Contact & Support

For questions about the wallet feature:
1. Check test files for usage examples
2. Review architecture diagrams in this README
3. Check error messages and logs
4. Run tests in verbose mode: `flutter test -v`
5. Review related documentation in `/docs` folder

---

## Future Enhancements

Potential improvements for the wallet feature:

1. **Backend Integration**: Replace local data source with API calls
2. **Transaction History**: Track and display past transactions
3. **Receipt Generation**: PDF/image receipts for transactions
4. **Payment Methods**: Multiple payment options (credit card, bank transfer, etc.)
5. **Notifications**: Push notifications for transactions
6. **Analytics**: Track spending patterns and statistics
7. **Bill Payment**: Pay bills directly from wallet
8. **Scheduled Transfers**: Set up recurring transfers
9. **Withdrawal Limits**: Daily/monthly withdrawal restrictions
10. **Two-Factor Authentication**: Enhanced security for large transactions

---

## Dependencies

The wallet feature uses:

- `flutter_bloc`: State management
- `mocktail`: Testing/mocking
- `flutter_test`: Widget testing
- `bloc_test`: Cubit testing
- `equatable`: Value equality

---

## Contributing

When adding new features or tests to the wallet module:

1. Maintain the clean architecture separation
2. Add tests for new functionality
3. Follow existing naming conventions
4. Update validation rules if needed
5. Document new validators in this README
6. Ensure 100% test coverage for critical paths

---

## License

Part of the Maya E-Wallet application.

---

**Status:** ✅ Complete & Tested
**Last Updated:** 2026-04-07
**Test Coverage:** 94/94 (100%)
**Pass Rate:** 100%
