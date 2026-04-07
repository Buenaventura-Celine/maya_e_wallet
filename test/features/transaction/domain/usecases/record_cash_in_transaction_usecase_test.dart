import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:maya_e_wallet/features/transaction/domain/usecases/record_cash_in_transaction_usecase.dart';

class MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late RecordCashInTransactionUseCase recordCashInTransactionUseCase;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    recordCashInTransactionUseCase = RecordCashInTransactionUseCase(
      mockTransactionRepository,
    );
  });

  group('RecordCashInTransactionUseCase', () {
    const tSource = 'Bank Account';
    const tAmount = 1000.0;

    final tTransaction = TransactionEntity(
      id: '1',
      type: 'cashIn',
      amount: tAmount,
      recipient: tSource,
      dateTime: DateTime(2024, 12, 20, 10, 30, 0),
      status: 'completed',
    );

    test('should record cash in transaction with correct parameters', () async {
      // Arrange
      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'cashIn',
          amount: tAmount,
          recipient: tSource,
        ),
      ).thenAnswer((_) async => tTransaction);

      // Act
      final result = await recordCashInTransactionUseCase(
        source: tSource,
        amount: tAmount,
      );

      // Assert
      expect(result, tTransaction);
      verify(
        () => mockTransactionRepository.recordTransaction(
          type: 'cashIn',
          amount: tAmount,
          recipient: tSource,
        ),
      ).called(1);
    });

    test('should return transaction with type cashIn', () async {
      // Arrange
      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'cashIn',
          amount: tAmount,
          recipient: tSource,
        ),
      ).thenAnswer((_) async => tTransaction);

      // Act
      final result = await recordCashInTransactionUseCase(
        source: tSource,
        amount: tAmount,
      );

      // Assert
      expect(result.type, 'cashIn');
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'cashIn',
          amount: tAmount,
          recipient: tSource,
        ),
      ).thenThrow(Exception('Failed to record'));

      // Act & Assert
      expect(
        () => recordCashInTransactionUseCase(
          source: tSource,
          amount: tAmount,
        ),
        throwsException,
      );
    });

    test('should record transaction with different amounts', () async {
      // Arrange
      const newAmount = 5000.0;
      final newTransaction = TransactionEntity(
        id: '2',
        type: 'cashIn',
        amount: newAmount,
        recipient: tSource,
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'cashIn',
          amount: newAmount,
          recipient: tSource,
        ),
      ).thenAnswer((_) async => newTransaction);

      // Act
      final result = await recordCashInTransactionUseCase(
        source: tSource,
        amount: newAmount,
      );

      // Assert
      expect(result.amount, newAmount);
    });

    test('should use source as recipient in transaction', () async {
      // Arrange
      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'cashIn',
          amount: tAmount,
          recipient: tSource,
        ),
      ).thenAnswer((_) async => tTransaction);

      // Act
      final result = await recordCashInTransactionUseCase(
        source: tSource,
        amount: tAmount,
      );

      // Assert
      expect(result.recipient, tSource);
    });

    test('should preserve all transaction details', () async {
      // Arrange
      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'cashIn',
          amount: tAmount,
          recipient: tSource,
        ),
      ).thenAnswer((_) async => tTransaction);

      // Act
      final result = await recordCashInTransactionUseCase(
        source: tSource,
        amount: tAmount,
      );

      // Assert
      expect(result.id, '1');
      expect(result.type, 'cashIn');
      expect(result.amount, tAmount);
      expect(result.recipient, tSource);
      expect(result.status, 'completed');
      expect(result.dateTime, isA<DateTime>());
    });

    test('should handle various sources', () async {
      // Arrange
      const newSource = 'Credit Card';
      final newTransaction = TransactionEntity(
        id: '3',
        type: 'cashIn',
        amount: tAmount,
        recipient: newSource,
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'cashIn',
          amount: tAmount,
          recipient: newSource,
        ),
      ).thenAnswer((_) async => newTransaction);

      // Act
      final result = await recordCashInTransactionUseCase(
        source: newSource,
        amount: tAmount,
      );

      // Assert
      expect(result.recipient, newSource);
    });
  });
}
