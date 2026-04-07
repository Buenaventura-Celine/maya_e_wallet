import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/cash_in_usecase.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/get_balance_usecase.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/send_money_usecase.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_cubit.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_state.dart';

class MockGetBalanceUseCase extends Mock implements GetBalanceUseCase {}

class MockSendMoneyUseCase extends Mock implements SendMoneyUseCase {}

class MockCashInUseCase extends Mock implements CashInUseCase {}

void main() {
  group('WalletCubit', () {
    late MockGetBalanceUseCase mockGetBalanceUseCase;
    late MockSendMoneyUseCase mockSendMoneyUseCase;
    late MockCashInUseCase mockCashInUseCase;
    late WalletCubit walletCubit;

    setUp(() {
      mockGetBalanceUseCase = MockGetBalanceUseCase();
      mockSendMoneyUseCase = MockSendMoneyUseCase();
      mockCashInUseCase = MockCashInUseCase();

      walletCubit = WalletCubit(
        getBalanceUseCase: mockGetBalanceUseCase,
        sendMoneyUseCase: mockSendMoneyUseCase,
        cashInUseCase: mockCashInUseCase,
      );
    });

    tearDown(() {
      walletCubit.close();
    });

    group('loadBalance', () {
      blocTest<WalletCubit, WalletState>(
        'should emit [WalletLoading, WalletLoaded] when loadBalance is called successfully',
        build: () {
          const walletEntity = WalletEntity(
            balance: 500.00,
            isBalanceHidden: false,
          );
          when(() => mockGetBalanceUseCase()).thenAnswer((_) async => walletEntity);
          return walletCubit;
        },
        act: (cubit) => cubit.loadBalance(),
        expect: () => [
          isA<WalletLoading>(),
          isA<WalletLoaded>()
              .having((state) => state.wallet.balance, 'balance', 500.00)
              .having((state) => state.wallet.isBalanceHidden, 'isBalanceHidden', false),
        ],
        verify: (cubit) {
          verify(() => mockGetBalanceUseCase()).called(1);
        },
      );

      blocTest<WalletCubit, WalletState>(
        'should emit [WalletLoading, ActionFailure] when loadBalance fails',
        build: () {
          when(() => mockGetBalanceUseCase())
              .thenThrow(Exception('Failed to load balance'));
          return walletCubit;
        },
        act: (cubit) => cubit.loadBalance(),
        expect: () => [
          isA<WalletLoading>(),
          isA<ActionFailure>()
              .having((state) => state.message, 'message', contains('Failed to load balance')),
        ],
      );
    });

    group('toggleBalanceVisibility', () {
      blocTest<WalletCubit, WalletState>(
        'should toggle balance visibility from false to true',
        build: () {
          const walletEntity = WalletEntity(
            balance: 500.00,
            isBalanceHidden: false,
          );
          when(() => mockGetBalanceUseCase()).thenAnswer((_) async => walletEntity);
          return walletCubit;
        },
        seed: () => const WalletLoaded(
          wallet: WalletEntity(balance: 500.00, isBalanceHidden: false),
        ),
        act: (cubit) => cubit.toggleBalanceVisibility(),
        expect: () => [
          isA<WalletLoaded>()
              .having((state) => state.wallet.isBalanceHidden, 'isBalanceHidden', true),
        ],
      );

      blocTest<WalletCubit, WalletState>(
        'should toggle balance visibility from true to false',
        build: () => walletCubit,
        seed: () => const WalletLoaded(
          wallet: WalletEntity(balance: 500.00, isBalanceHidden: true),
        ),
        act: (cubit) => cubit.toggleBalanceVisibility(),
        expect: () => [
          isA<WalletLoaded>()
              .having((state) => state.wallet.isBalanceHidden, 'isBalanceHidden', false),
        ],
      );

      blocTest<WalletCubit, WalletState>(
        'should not emit any state when not in WalletLoaded state',
        build: () => walletCubit,
        seed: () => const WalletInitial(),
        act: (cubit) => cubit.toggleBalanceVisibility(),
        expect: () => [],
      );
    });

    group('sendMoney', () {
      blocTest<WalletCubit, WalletState>(
        'should emit [ActionInProgress, ActionSuccess] when sendMoney succeeds',
        build: () {
          when(() => mockSendMoneyUseCase('john@example.com', 100.0))
              .thenAnswer((_) async => {});
          return walletCubit;
        },
        act: (cubit) => cubit.sendMoney('john@example.com', 100.0),
        expect: () => [
          isA<ActionInProgress>(),
          isA<ActionSuccess>()
              .having((state) => state.message, 'message', contains('Money sent successfully')),
        ],
        verify: (cubit) {
          verify(() => mockSendMoneyUseCase('john@example.com', 100.0)).called(1);
        },
      );

      blocTest<WalletCubit, WalletState>(
        'should emit [ActionInProgress, ActionFailure] when sendMoney fails with insufficient balance',
        build: () {
          when(() => mockSendMoneyUseCase('john@example.com', 600.0))
              .thenThrow(Exception('Insufficient balance'));
          return walletCubit;
        },
        act: (cubit) => cubit.sendMoney('john@example.com', 600.0),
        expect: () => [
          isA<ActionInProgress>(),
          isA<ActionFailure>()
              .having((state) => state.message, 'message', contains('Failed to send money')),
        ],
      );

      blocTest<WalletCubit, WalletState>(
        'should emit [ActionInProgress, ActionFailure] when sendMoney fails with invalid amount',
        build: () {
          when(() => mockSendMoneyUseCase('john@example.com', -50.0))
              .thenThrow(Exception('Amount must be greater than 0'));
          return walletCubit;
        },
        act: (cubit) => cubit.sendMoney('john@example.com', -50.0),
        expect: () => [
          isA<ActionInProgress>(),
          isA<ActionFailure>()
              .having((state) => state.message, 'message', contains('Failed to send money')),
        ],
      );
    });

    group('cashIn', () {
      blocTest<WalletCubit, WalletState>(
        'should emit [ActionInProgress, ActionSuccess] when cashIn succeeds',
        build: () {
          when(() => mockCashInUseCase(1000.0))
              .thenAnswer((_) async => {});
          return walletCubit;
        },
        act: (cubit) => cubit.cashIn(1000.0),
        expect: () => [
          isA<ActionInProgress>(),
          isA<ActionSuccess>()
              .having((state) => state.message, 'message', contains('Cash in')),
        ],
        verify: (cubit) {
          verify(() => mockCashInUseCase(1000.0)).called(1);
        },
      );

      blocTest<WalletCubit, WalletState>(
        'should emit [ActionInProgress, ActionFailure] when cashIn fails with amount exceeds maximum',
        build: () {
          when(() => mockCashInUseCase(100001.0))
              .thenThrow(Exception('Cash in amount cannot exceed ₱100,000.00'));
          return walletCubit;
        },
        act: (cubit) => cubit.cashIn(100001.0),
        expect: () => [
          isA<ActionInProgress>(),
          isA<ActionFailure>()
              .having((state) => state.message, 'message', contains('Failed to cash in')),
        ],
      );

      blocTest<WalletCubit, WalletState>(
        'should emit [ActionInProgress, ActionFailure] when cashIn fails with zero amount',
        build: () {
          when(() => mockCashInUseCase(0.0))
              .thenThrow(Exception('Amount must be greater than 0'));
          return walletCubit;
        },
        act: (cubit) => cubit.cashIn(0.0),
        expect: () => [
          isA<ActionInProgress>(),
          isA<ActionFailure>()
              .having((state) => state.message, 'message', contains('Failed to cash in')),
        ],
      );
    });
  });
}
