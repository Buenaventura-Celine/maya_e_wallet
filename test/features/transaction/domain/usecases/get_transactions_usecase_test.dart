import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:maya_e_wallet/features/transaction/domain/usecases/get_transactions_usecase.dart';

class MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late GetTransactionsUseCase getTransactionsUseCase;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    getTransactionsUseCase = GetTransactionsUseCase(mockTransactionRepository);
  });

  group('GetTransactionsUseCase', () {
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
    ];

    test('should get transactions from the repository', () async {
      // Arrange
      when(() => mockTransactionRepository.getTransactions())
          .thenAnswer((_) async => tTransactionList);

      // Act
      final result = await getTransactionsUseCase();

      // Assert
      expect(result, tTransactionList);
      verify(() => mockTransactionRepository.getTransactions()).called(1);
      verifyNoMoreInteractions(mockTransactionRepository);
    });

    test('should return empty list when no transactions exist', () async {
      // Arrange
      when(() => mockTransactionRepository.getTransactions())
          .thenAnswer((_) async => []);

      // Act
      final result = await getTransactionsUseCase();

      // Assert
      expect(result, isEmpty);
      verify(() => mockTransactionRepository.getTransactions()).called(1);
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(() => mockTransactionRepository.getTransactions())
          .thenThrow(Exception('Failed to fetch'));

      // Act & Assert
      expect(
        () => getTransactionsUseCase(),
        throwsException,
      );
    });

    test('should return correct transaction count', () async {
      // Arrange
      when(() => mockTransactionRepository.getTransactions())
          .thenAnswer((_) async => tTransactionList);

      // Act
      final result = await getTransactionsUseCase();

      // Assert
      expect(result.length, 2);
    });

    test('should preserve transaction properties', () async {
      // Arrange
      when(() => mockTransactionRepository.getTransactions())
          .thenAnswer((_) async => tTransactionList);

      // Act
      final result = await getTransactionsUseCase();

      // Assert
      expect(result[0].id, '1');
      expect(result[0].type, 'send');
      expect(result[0].amount, 500.0);
      expect(result[0].recipient, 'John Doe');
      expect(result[0].status, 'completed');

      expect(result[1].id, '2');
      expect(result[1].type, 'cashIn');
      expect(result[1].amount, 1000.0);
      expect(result[1].recipient, 'bank');
      expect(result[1].status, 'completed');
    });
  });
}
