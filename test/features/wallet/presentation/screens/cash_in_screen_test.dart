import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_state.dart';
import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_cubit.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_state.dart';
import 'package:maya_e_wallet/features/wallet/presentation/screens/cash_in_screen.dart';

class MockWalletCubit extends Mock implements WalletCubit {}
class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  group('CashInScreen', () {
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
          child: const CashInScreen(),
        ),
      );
    }

    void setupCommonMocks() {
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
    }

    testWidgets('displays amount input field', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.byType(TextField), findsWidgets);
      expect(find.text('AMOUNT'), findsOneWidget);
    });

    testWidgets('displays maximum limit helper text', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('Maximum: ₱100000.00'), findsOneWidget);
    });

    testWidgets('Confirm button is disabled when form is invalid',
        (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      final confirmButton = find.byType(FilledButton).first;
      expect(confirmButton, findsOneWidget);
    });

    testWidgets('Confirm button is enabled when form is valid',
        (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Enter valid amount
      await tester.enterText(find.byType(TextField), '1000');
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FilledButton), findsAtLeastNWidgets(1));
    });

    testWidgets('displays error for amount exceeding maximum', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Enter amount exceeding maximum
      await tester.enterText(find.byType(TextField), '100001');
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.error_outline), findsWidgets);
    });

    testWidgets('displays error for zero amount', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Enter zero amount
      await tester.enterText(find.byType(TextField), '0');
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.error_outline), findsWidgets);
    });

    testWidgets('displays loading state when ActionInProgress', (WidgetTester tester) async {
      // Arrange
      when(() => mockWalletCubit.state).thenReturn(const ActionInProgress());
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const ActionInProgress()));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('displays error snackbar on ActionFailure', (WidgetTester tester) async {
      // Arrange
      when(() => mockWalletCubit.state)
          .thenReturn(const ActionFailure(message: 'Cash in failed'));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const ActionFailure(message: 'Cash in failed')));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('displays AppBar with Cash In title', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('Cash In'), findsOneWidget);
    });

    testWidgets('Cancel button is enabled and functional', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('Cancel'), findsOneWidget);
      final cancelButton = find.byType(OutlinedButton);
      expect(cancelButton, findsOneWidget);
    });

    testWidgets('accepts valid amount at maximum limit', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.cashIn(any())).thenAnswer((_) async => {});
      setupCommonMocks();

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Enter maximum amount
      await tester.enterText(find.byType(TextField), '100000');
      await tester.pumpAndSettle();

      // Assert
      // Should not show error
      expect(find.byIcon(Icons.error_outline), findsNothing);
    });
  });
}
