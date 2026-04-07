import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:maya_e_wallet/features/transaction/domain/usecases/record_send_money_transaction_usecase.dart';

class MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late RecordSendMoneyTransactionUseCase recordSendMoneyTransactionUseCase;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    recordSendMoneyTransactionUseCase = RecordSendMoneyTransactionUseCase(
      mockTransactionRepository,
    );
  });

  group('RecordSendMoneyTransactionUseCase', () {
    const tRecipientName = 'John Doe';
    const tAmount = 500.0;

    final tTransaction = TransactionEntity(
      id: '1',
      type: 'send',
      amount: tAmount,
      recipient: tRecipientName,
      dateTime: DateTime(2024, 12, 20, 10, 30, 0),
      status: 'completed',
    );

    test('should record send money transaction with correct parameters', () async {
      // Arrange
      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'send',
          amount: tAmount,
          recipient: tRecipientName,
        ),
      ).thenAnswer((_) async => tTransaction);

      // Act
      final result = await recordSendMoneyTransactionUseCase(
        recipientName: tRecipientName,
        amount: tAmount,
      );

      // Assert
      expect(result, tTransaction);
      verify(
        () => mockTransactionRepository.recordTransaction(
          type: 'send',
          amount: tAmount,
          recipient: tRecipientName,
        ),
      ).called(1);
    });

    test('should return transaction with type send', () async {
      // Arrange
      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'send',
          amount: tAmount,
          recipient: tRecipientName,
        ),
      ).thenAnswer((_) async => tTransaction);

      // Act
      final result = await recordSendMoneyTransactionUseCase(
        recipientName: tRecipientName,
        amount: tAmount,
      );

      // Assert
      expect(result.type, 'send');
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'send',
          amount: tAmount,
          recipient: tRecipientName,
        ),
      ).thenThrow(Exception('Failed to record'));

      // Act & Assert
      expect(
        () => recordSendMoneyTransactionUseCase(
          recipientName: tRecipientName,
          amount: tAmount,
        ),
        throwsException,
      );
    });

    test('should record transaction with different amounts', () async {
      // Arrange
      const newAmount = 1000.0;
      final newTransaction = TransactionEntity(
        id: '2',
        type: 'send',
        amount: newAmount,
        recipient: tRecipientName,
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'send',
          amount: newAmount,
          recipient: tRecipientName,
        ),
      ).thenAnswer((_) async => newTransaction);

      // Act
      final result = await recordSendMoneyTransactionUseCase(
        recipientName: tRecipientName,
        amount: newAmount,
      );

      // Assert
      expect(result.amount, newAmount);
    });

    test('should record transaction with different recipients', () async {
      // Arrange
      const newRecipient = 'Jane Smith';
      final newTransaction = TransactionEntity(
        id: '3',
        type: 'send',
        amount: tAmount,
        recipient: newRecipient,
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'send',
          amount: tAmount,
          recipient: newRecipient,
        ),
      ).thenAnswer((_) async => newTransaction);

      // Act
      final result = await recordSendMoneyTransactionUseCase(
        recipientName: newRecipient,
        amount: tAmount,
      );

      // Assert
      expect(result.recipient, newRecipient);
    });

    test('should preserve all transaction details', () async {
      // Arrange
      when(
        () => mockTransactionRepository.recordTransaction(
          type: 'send',
          amount: tAmount,
          recipient: tRecipientName,
        ),
      ).thenAnswer((_) async => tTransaction);

      // Act
      final result = await recordSendMoneyTransactionUseCase(
        recipientName: tRecipientName,
        amount: tAmount,
      );

      // Assert
      expect(result.id, '1');
      expect(result.type, 'send');
      expect(result.amount, tAmount);
      expect(result.recipient, tRecipientName);
      expect(result.status, 'completed');
      expect(result.dateTime, isA<DateTime>());
    });
  });
}
