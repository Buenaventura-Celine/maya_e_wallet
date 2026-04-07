import 'package:flutter_test/flutter_test.dart';
import 'package:maya_e_wallet/features/transaction/data/models/transaction_model.dart';
import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';

void main() {
  group('TransactionModel', () {
    final tTransactionModel = TransactionModel(
      id: '1',
      type: 'send',
      amount: 500.0,
      recipient: 'John Doe',
      dateTime: DateTime(2024, 12, 20, 10, 30, 0),
      status: 'completed',
    );

    test('should be a subclass of TransactionEntity', () async {
      expect(tTransactionModel, isA<TransactionEntity>());
    });

    group('fromJson', () {
      test('should return a valid TransactionModel when JSON has Unix timestamp', () {
        // Arrange
        final json = {
          'id': 1,
          'type': 'send',
          'amount': 500.0,
          'recipient': 'John Doe',
          'dateTime': 1734145800, // Unix timestamp in seconds
          'status': 'completed',
        };

        // Act
        final result = TransactionModel.fromJson(json);

        // Assert
        expect(result.id, '1');
        expect(result.type, 'send');
        expect(result.amount, 500.0);
        expect(result.recipient, 'John Doe');
        expect(result.status, 'completed');
        expect(result.dateTime, isA<DateTime>());
      });

      test('should return a valid TransactionModel when JSON has ISO 8601 string', () {
        // Arrange
        final json = {
          'id': 2,
          'type': 'cashIn',
          'amount': 1000.0,
          'recipient': 'bank',
          'dateTime': '2024-12-20T14:30:00.000Z',
          'status': 'completed',
        };

        // Act
        final result = TransactionModel.fromJson(json);

        // Assert
        expect(result.id, '2');
        expect(result.type, 'cashIn');
        expect(result.amount, 1000.0);
        expect(result.recipient, 'bank');
        expect(result.status, 'completed');
        expect(result.dateTime, isA<DateTime>());
      });

      test('should handle integer id correctly', () {
        // Arrange
        final json = {
          'id': 123,
          'type': 'send',
          'amount': 250.50,
          'recipient': 'Jane',
          'dateTime': 1734145800,
          'status': 'completed',
        };

        // Act
        final result = TransactionModel.fromJson(json);

        // Assert
        expect(result.id, '123');
      });

      test('should handle string id correctly', () {
        // Arrange
        final json = {
          'id': 'abc123',
          'type': 'send',
          'amount': 250.50,
          'recipient': 'Jane',
          'dateTime': 1734145800,
          'status': 'completed',
        };

        // Act
        final result = TransactionModel.fromJson(json);

        // Assert
        expect(result.id, 'abc123');
      });

      test('should convert amount to double correctly', () {
        // Arrange
        final json = {
          'id': 1,
          'type': 'send',
          'amount': 500, // integer
          'recipient': 'John',
          'dateTime': 1734145800,
          'status': 'completed',
        };

        // Act
        final result = TransactionModel.fromJson(json);

        // Assert
        expect(result.amount, 500.0);
        expect(result.amount, isA<double>());
      });

      test('should use default status when status is null', () {
        // Arrange
        final json = {
          'id': 1,
          'type': 'send',
          'amount': 500.0,
          'recipient': 'John',
          'dateTime': 1734145800,
          'status': null,
        };

        // Act
        final result = TransactionModel.fromJson(json);

        // Assert
        expect(result.status, 'completed');
      });

      test('should handle Unix timestamp with decimal', () {
        // Arrange
        final json = {
          'id': 1,
          'type': 'send',
          'amount': 500.0,
          'recipient': 'John',
          'dateTime': 1734145800.5, // decimal timestamp
          'status': 'completed',
        };

        // Act
        final result = TransactionModel.fromJson(json);

        // Assert
        expect(result.dateTime, isA<DateTime>());
      });

      test('should throw FormatException when dateTime is null', () {
        // Arrange
        final json = {
          'id': 1,
          'type': 'send',
          'amount': 500.0,
          'recipient': 'John',
          'dateTime': null,
          'status': 'completed',
        };

        // Act & Assert
        final result = TransactionModel.fromJson(json);
        expect(result.dateTime, isA<DateTime>());
      });
    });

    group('toJson', () {
      test('should return a valid JSON map', () {
        // Act
        final json = tTransactionModel.toJson();

        // Assert
        expect(json['id'], '1');
        expect(json['type'], 'send');
        expect(json['amount'], 500.0);
        expect(json['recipient'], 'John Doe');
        expect(json['status'], 'completed');
        expect(json['dateTime'], isA<String>());
      });

      test('should convert dateTime to ISO 8601 string', () {
        // Arrange
        final transactionModel = TransactionModel(
          id: '1',
          type: 'send',
          amount: 500.0,
          recipient: 'John Doe',
          dateTime: DateTime(2024, 12, 20, 10, 30, 0),
          status: 'completed',
        );

        // Act
        final json = transactionModel.toJson();

        // Assert
        expect(json['dateTime'], '2024-12-20T10:30:00.000');
      });
    });

    group('fromEntity', () {
      test('should return a valid TransactionModel from TransactionEntity', () {
        // Act
        final result = TransactionModel.fromEntity(tTransactionModel);

        // Assert
        expect(result.id, tTransactionModel.id);
        expect(result.type, tTransactionModel.type);
        expect(result.amount, tTransactionModel.amount);
        expect(result.recipient, tTransactionModel.recipient);
        expect(result.dateTime, tTransactionModel.dateTime);
        expect(result.status, tTransactionModel.status);
      });
    });

    group('equality', () {
      test('should return true when two TransactionModels are equal', () {
        // Arrange
        final transactionModel1 = TransactionModel(
          id: '1',
          type: 'send',
          amount: 500.0,
          recipient: 'John Doe',
          dateTime: DateTime(2024, 12, 20, 10, 30, 0),
          status: 'completed',
        );

        final transactionModel2 = TransactionModel(
          id: '1',
          type: 'send',
          amount: 500.0,
          recipient: 'John Doe',
          dateTime: DateTime(2024, 12, 20, 10, 30, 0),
          status: 'completed',
        );

        // Assert
        expect(transactionModel1, transactionModel2);
      });

      test('should return false when two TransactionModels are not equal', () {
        // Arrange
        final transactionModel1 = TransactionModel(
          id: '1',
          type: 'send',
          amount: 500.0,
          recipient: 'John Doe',
          dateTime: DateTime(2024, 12, 20, 10, 30, 0),
          status: 'completed',
        );

        final transactionModel2 = TransactionModel(
          id: '2',
          type: 'cashIn',
          amount: 1000.0,
          recipient: 'bank',
          dateTime: DateTime(2024, 12, 21, 10, 30, 0),
          status: 'pending',
        );

        // Assert
        expect(transactionModel1, isNot(transactionModel2));
      });
    });
  });
}
