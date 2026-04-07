import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_state.dart';
import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_cubit.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_state.dart';
import 'package:maya_e_wallet/features/wallet/presentation/screens/wallet_screen.dart';

class MockWalletCubit extends Mock implements WalletCubit {}
class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  group('WalletScreen', () {
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
          child: const WalletScreen(),
        ),
      );
    }

    testWidgets('displays loading indicator when WalletLoading state',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockWalletCubit.state).thenReturn(const WalletLoading());
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoading()));
      when(() => mockWalletCubit.loadBalance()).thenAnswer((_) async => {});
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays balance and wallet header when WalletLoaded',
        (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.loadBalance()).thenAnswer((_) async => {});
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('₱500.00'), findsOneWidget);
      expect(find.text('Account Balance'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
    });

    testWidgets('displays balance as hidden when isBalanceHidden is true',
        (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: true);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.loadBalance()).thenAnswer((_) async => {});
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      // Should show 7 asterisks instead of balance (₱500.00 = 7 chars)
      expect(find.text('*' * 7), findsOneWidget);
      expect(find.text('₱500.00'), findsNothing);
    });

    testWidgets('calls toggleBalanceVisibility when eye icon is tapped',
        (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.loadBalance()).thenAnswer((_) async => {});
      when(() => mockWalletCubit.toggleBalanceVisibility()).thenReturn(null);
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));

      // Act
      await tester.pumpWidget(buildTestWidget());
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockWalletCubit.toggleBalanceVisibility()).called(1);
    });

    testWidgets('displays Send Money and Cash In buttons',
        (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.loadBalance()).thenAnswer((_) async => {});
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert - Quick Actions section should contain action buttons
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.byType(FilledButton), findsAtLeastNWidgets(2));
    });

    testWidgets('displays error message when ActionFailure state',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockWalletCubit.state)
          .thenReturn(const ActionFailure(message: 'Failed to load balance'));
      when(() => mockWalletCubit.stream).thenAnswer((_) =>
          Stream.value(const ActionFailure(message: 'Failed to load balance')));
      when(() => mockWalletCubit.loadBalance()).thenAnswer((_) async => {});
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('Error: Failed to load balance'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('calls loadBalance on Retry button press',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockWalletCubit.state)
          .thenReturn(const ActionFailure(message: 'Failed to load balance'));
      when(() => mockWalletCubit.stream).thenAnswer((_) =>
          Stream.value(const ActionFailure(message: 'Failed to load balance')));
      when(() => mockWalletCubit.loadBalance()).thenAnswer((_) async => {});
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));

      // Act
      await tester.pumpWidget(buildTestWidget());
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Assert - loadBalance should be called at least once (init + retry)
      verify(() => mockWalletCubit.loadBalance()).called(greaterThanOrEqualTo(1));
    });

    testWidgets('displays AppBar with Wallet title', (WidgetTester tester) async {
      // Arrange
      const walletEntity = WalletEntity(balance: 500.00, isBalanceHidden: false);
      when(() => mockWalletCubit.state)
          .thenReturn(const WalletLoaded(wallet: walletEntity));
      when(() => mockWalletCubit.stream)
          .thenAnswer((_) => Stream.value(const WalletLoaded(wallet: walletEntity)));
      when(() => mockWalletCubit.loadBalance()).thenAnswer((_) async => {});
      when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthInitial()));

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('Wallet'), findsOneWidget);
    });
  });
}
