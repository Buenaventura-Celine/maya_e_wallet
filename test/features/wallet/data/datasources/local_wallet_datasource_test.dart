import 'package:flutter_test/flutter_test.dart';
import 'package:maya_e_wallet/features/wallet/data/datasources/local_wallet_datasource.dart';

void main() {
  group('LocalWalletDataSourceImpl', () {
    late LocalWalletDataSourceImpl dataSource;

    setUp(() {
      dataSource = LocalWalletDataSourceImpl();
    });

    group('getBalance', () {
      test('should return initial balance of 500.00', () async {
        // Act
        final result = await dataSource.getBalance();

        // Assert
        expect(result.balance, 500.00);
        expect(result.isBalanceHidden, false);
      });
    });

    group('updateBalance', () {
      test('should update the balance', () async {
        // Arrange
        const newBalance = 750.50;

        // Act
        await dataSource.updateBalance(newBalance);
        final result = await dataSource.getBalance();

        // Assert
        expect(result.balance, newBalance);
      });
    });

    group('sendMoney', () {
      test('should deduct amount from balance when sending money', () async {
        // Arrange
        const recipient = 'john@example.com';
        const amount = 100.00;

        // Act
        await dataSource.sendMoney(recipient, amount);
        final result = await dataSource.getBalance();

        // Assert
        expect(result.balance, 400.00); // 500 - 100
      });

      test('should throw exception when amount is zero', () async {
        // Arrange
        const recipient = 'john@example.com';
        const amount = 0.0;

        // Act & Assert
        expect(
          () => dataSource.sendMoney(recipient, amount),
          throwsException,
        );
      });

      test('should throw exception when amount is negative', () async {
        // Arrange
        const recipient = 'john@example.com';
        const amount = -50.0;

        // Act & Assert
        expect(
          () => dataSource.sendMoney(recipient, amount),
          throwsException,
        );
      });

      test('should throw exception when amount exceeds balance', () async {
        // Arrange
        const recipient = 'john@example.com';
        const amount = 600.00;

        // Act & Assert
        expect(
          () => dataSource.sendMoney(recipient, amount),
          throwsException,
        );
      });

      test('should allow sending exactly the balance amount', () async {
        // Arrange
        const recipient = 'john@example.com';
        const amount = 500.00;

        // Act
        await dataSource.sendMoney(recipient, amount);
        final result = await dataSource.getBalance();

        // Assert
        expect(result.balance, 0.0);
      });
    });

    group('cashIn', () {
      test('should add amount to balance when cashing in', () async {
        // Arrange
        const amount = 1000.00;

        // Act
        await dataSource.cashIn(amount);
        final result = await dataSource.getBalance();

        // Assert
        expect(result.balance, 1500.00); // 500 + 1000
      });

      test('should throw exception when amount is zero', () async {
        // Arrange
        const amount = 0.0;

        // Act & Assert
        expect(
          () => dataSource.cashIn(amount),
          throwsException,
        );
      });

      test('should throw exception when amount is negative', () async {
        // Arrange
        const amount = -100.0;

        // Act & Assert
        expect(
          () => dataSource.cashIn(amount),
          throwsException,
        );
      });

      test('should throw exception when amount exceeds maximum (100000)', () async {
        // Arrange
        const amount = 100001.00;

        // Act & Assert
        expect(
          () => dataSource.cashIn(amount),
          throwsException,
        );
      });

      test('should allow cashing in exactly the maximum amount', () async {
        // Arrange
        const amount = 100000.00;

        // Act
        await dataSource.cashIn(amount);
        final result = await dataSource.getBalance();

        // Assert
        expect(result.balance, 100500.00); // 500 + 100000
      });
    });
  });
}
