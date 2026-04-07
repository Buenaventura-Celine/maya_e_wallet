import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:maya_e_wallet/features/transaction/presentation/cubits/transaction_cubit.dart';
import 'package:maya_e_wallet/features/transaction/presentation/cubits/transaction_state.dart';

class MockGetTransactionsUseCase extends Mock
    implements GetTransactionsUseCase {}

void main() {
  late MockGetTransactionsUseCase mockGetTransactionsUseCase;
  late TransactionCubit transactionCubit;

  setUp(() {
    mockGetTransactionsUseCase = MockGetTransactionsUseCase();
    transactionCubit = TransactionCubit(
      getTransactionsUseCase: mockGetTransactionsUseCase,
    );
  });

  tearDown(() {
    transactionCubit.close();
  });

  group('TransactionCubit', () {
    final tTransactionList = [
      TransactionEntity(
        id: '1',
        type: 'send',
        amount: 500.0,
        recipient: 'John Doe',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      ),
      TransactionEntity(
        id: '2',
        type: 'cashIn',
        amount: 1000.0,
        recipient: 'bank',
        dateTime: DateTime(2024, 12, 21, 14, 30, 0),
        status: 'completed',
      ),
      TransactionEntity(
        id: '3',
        type: 'send',
        amount: 250.0,
        recipient: 'Jane Smith',
        dateTime: DateTime(2024, 12, 19, 9, 15, 0),
        status: 'completed',
      ),
    ];

    group('loadTransactions', () {
      blocTest<TransactionCubit, TransactionState>(
        'emits [TransactionLoading, TransactionLoaded] when loadTransactions is called successfully',
        build: () {
          when(() => mockGetTransactionsUseCase())
              .thenAnswer((_) async => tTransactionList);
          return transactionCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        expect: () => [
          const TransactionLoading(),
          isA<TransactionLoaded>(),
        ],
      );

      blocTest<TransactionCubit, TransactionState>(
        'should sort transactions in reverse chronological order (most recent first)',
        build: () {
          when(() => mockGetTransactionsUseCase())
              .thenAnswer((_) async => tTransactionList);
          return transactionCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        verify: (cubit) {
          final state = cubit.state as TransactionLoaded;
          final transactions = state.transactions;

          // Most recent should be first (id: '2')
          expect(transactions[0].id, '2');
          expect(transactions[0].dateTime,
              DateTime(2024, 12, 21, 14, 30, 0));

          // Second most recent (id: '1')
          expect(transactions[1].id, '1');
          expect(transactions[1].dateTime,
              DateTime(2024, 12, 20, 10, 30, 0));

          // Least recent (id: '3')
          expect(transactions[2].id, '3');
          expect(transactions[2].dateTime,
              DateTime(2024, 12, 19, 9, 15, 0));
        },
      );

      blocTest<TransactionCubit, TransactionState>(
        'emits [TransactionLoading, TransactionError] when loadTransactions fails',
        build: () {
          when(() => mockGetTransactionsUseCase())
              .thenThrow(Exception('Failed to fetch transactions'));
          return transactionCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        expect: () => [
          const TransactionLoading(),
          isA<TransactionError>(),
        ],
      );

      blocTest<TransactionCubit, TransactionState>(
        'should handle empty transaction list',
        build: () {
          when(() => mockGetTransactionsUseCase())
              .thenAnswer((_) async => []);
          return transactionCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        verify: (cubit) {
          final state = cubit.state as TransactionLoaded;
          expect(state.transactions, isEmpty);
        },
      );

      blocTest<TransactionCubit, TransactionState>(
        'should include error message in TransactionError state',
        build: () {
          const errorMessage = 'Network error';
          when(() => mockGetTransactionsUseCase())
              .thenThrow(Exception(errorMessage));
          return transactionCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        verify: (cubit) {
          final state = cubit.state as TransactionError;
          expect(state.message, contains('Exception'));
        },
      );

      blocTest<TransactionCubit, TransactionState>(
        'should call GetTransactionsUseCase exactly once',
        build: () {
          when(() => mockGetTransactionsUseCase())
              .thenAnswer((_) async => tTransactionList);
          return transactionCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        verify: (cubit) {
          verify(() => mockGetTransactionsUseCase()).called(1);
        },
      );

      blocTest<TransactionCubit, TransactionState>(
        'should handle single transaction',
        build: () {
          final singleTransaction = [tTransactionList.first];
          when(() => mockGetTransactionsUseCase())
              .thenAnswer((_) async => singleTransaction);
          return transactionCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        verify: (cubit) {
          final state = cubit.state as TransactionLoaded;
          expect(state.transactions.length, 1);
          expect(state.transactions.first.id, '1');
        },
      );

      blocTest<TransactionCubit, TransactionState>(
        'should maintain original list when all transactions have same dateTime',
        build: () {
          final sameDateTime = DateTime(2024, 12, 20, 10, 30, 0);
          final transactionsSameDatetime = [
            TransactionEntity(
              id: '1',
              type: 'send',
              amount: 500.0,
              recipient: 'John',
              dateTime: sameDateTime,
              status: 'completed',
            ),
            TransactionEntity(
              id: '2',
              type: 'cashIn',
              amount: 1000.0,
              recipient: 'bank',
              dateTime: sameDateTime,
              status: 'completed',
            ),
          ];
          when(() => mockGetTransactionsUseCase())
              .thenAnswer((_) async => transactionsSameDatetime);
          return transactionCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        verify: (cubit) {
          final state = cubit.state as TransactionLoaded;
          expect(state.transactions.length, 2);
        },
      );
    });
  });
}
