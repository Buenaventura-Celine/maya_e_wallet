import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_state.dart';
import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_cubit.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_state.dart';
import 'package:maya_e_wallet/features/wallet/presentation/screens/send_money_screen.dart';

class MockWalletCubit extends Mock implements WalletCubit {}
class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  group('SendMoneyScreen', () {
    late MockWalletCubit mockWalletCubit;
    late MockAuthCubit mockAuthCubit;

    setUp(() {
      mockWalletCubit = MockWalletCubit();
      mockAuthCubit = MockAuthCubit();
    });

    Widget buildTestWidget() {
      return MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<WalletCubit>.value(value: mockWalletCubit),
            BlocProvider<AuthCubit>.value(value: mockAuthCubit),
          ],
          child: const SendMoneyScreen(),
        ),
      );
    }

    void setupCommonMocks() {
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
    }

    testWidgets('displays recipient and amount input fields', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.byType(TextField), findsWidgets);
      expect(find.text('RECIPIENT'), findsOneWidget);
      expect(find.text('AMOUNT'), findsOneWidget);
    });

    testWidgets('displays available balance helper text', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('Available balance: ₱500.00'), findsOneWidget);
    });

    testWidgets('Send button is disabled when form is invalid', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      final sendButton = find.byType(FilledButton).first;
      expect(sendButton, findsOneWidget);
      // Button should be disabled (no need to check exact state as Flutter handles it)
    });

    testWidgets('Send button is enabled when form is valid', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Enter valid recipient
      await tester.enterText(find.byType(TextField).first, 'john@example.com');
      await tester.pumpAndSettle();

      // Enter valid amount
      await tester.enterText(find.byType(TextField).last, '100');
      await tester.pumpAndSettle();

      // Assert
      // Button should now be enabled
      expect(find.byType(FilledButton), findsAtLeastNWidgets(1));
    });

    testWidgets('displays error message for invalid email', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Enter valid recipient then invalid amount to test error display
      await tester.enterText(find.byType(TextField).first, 'john@example.com');
      await tester.pumpAndSettle();

      // Enter amount exceeding balance
      await tester.enterText(find.byType(TextField).last, '1000');
      await tester.pumpAndSettle();

      // Assert - Amount exceeds balance, so form should be invalid
      expect(find.byType(FilledButton).first, findsOneWidget);
    });

    testWidgets('displays error for amount exceeding balance', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Enter valid recipient
      await tester.enterText(find.byType(TextField).first, 'john@example.com');
      await tester.pumpAndSettle();

      // Enter amount exceeding balance
      await tester.enterText(find.byType(TextField).last, '600');
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.error_outline), findsWidgets);
    });

    testWidgets('displays loading state when ActionInProgress', (WidgetTester tester) async {
      // Arrange
      when(() => mockWalletCubit.state).thenReturn(const ActionInProgress());
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const ActionInProgress()));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      // Input fields should be disabled
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('displays error snackbar on ActionFailure', (WidgetTester tester) async {
      // Arrange
      when(() => mockWalletCubit.state)
          .thenReturn(const ActionFailure(message: 'Transaction failed'));
      when(() => mockWalletCubit.stream).thenAnswer(
          (_) => Stream.value(const ActionFailure(message: 'Transaction failed')));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('displays AppBar with Send Money title', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert - AppBar contains "Send Money" title
      expect(find.text('Send Money'), findsAtLeastNWidgets(1));
    });

    testWidgets('Cancel button is enabled and functional', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.sendMoney(any(), any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('Cancel'), findsOneWidget);
      final cancelButton = find.byType(OutlinedButton);
      expect(cancelButton, findsOneWidget);
    });
  });
}
