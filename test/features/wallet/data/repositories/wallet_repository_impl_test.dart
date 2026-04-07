import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/wallet/data/datasources/local_wallet_datasource.dart';
import 'package:maya_e_wallet/features/wallet/data/models/wallet_model.dart';
import 'package:maya_e_wallet/features/wallet/data/repositories/wallet_repository_impl.dart';

class MockLocalWalletDataSource extends Mock implements LocalWalletDataSource {}

void main() {
  group('WalletRepositoryImpl', () {
    late MockLocalWalletDataSource mockDataSource;
    late WalletRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockLocalWalletDataSource();
      repository = WalletRepositoryImpl(localDataSource: mockDataSource);
    });

    group('getBalance', () {
      test('should return wallet model from data source', () async {
        // Arrange
        const walletModel = WalletModel(
          balance: 500.00,
          isBalanceHidden: false,
        );
        when(() => mockDataSource.getBalance())
            .thenAnswer((_) async => walletModel);

        // Act
        final result = await repository.getBalance();

        // Assert
        expect(result.balance, 500.00);
        expect(result.isBalanceHidden, false);
        verify(() => mockDataSource.getBalance()).called(1);
      });

      test('should throw exception when data source throws', () async {
        // Arrange
        when(() => mockDataSource.getBalance())
            .thenThrow(Exception('Data source error'));

        // Act & Assert
        expect(
          () => repository.getBalance(),
          throwsException,
        );
      });
    });

    group('updateBalance', () {
      test('should call data source updateBalance with correct amount', () async {
        // Arrange
        const newBalance = 750.50;
        when(() => mockDataSource.updateBalance(newBalance))
            .thenAnswer((_) async => {});

        // Act
        await repository.updateBalance(newBalance);

        // Assert
        verify(() => mockDataSource.updateBalance(newBalance)).called(1);
      });
    });

    group('sendMoney', () {
      test('should call data source sendMoney with correct parameters', () async {
        // Arrange
        const recipient = 'john@example.com';
        const amount = 100.00;
        when(() => mockDataSource.sendMoney(recipient, amount))
            .thenAnswer((_) async => {});

        // Act
        await repository.sendMoney(recipient, amount);

        // Assert
        verify(() => mockDataSource.sendMoney(recipient, amount)).called(1);
      });

      test('should throw exception when data source throws', () async {
        // Arrange
        const recipient = 'john@example.com';
        const amount = 100.00;
        when(() => mockDataSource.sendMoney(recipient, amount))
            .thenThrow(Exception('Insufficient balance'));

        // Act & Assert
        expect(
          () => repository.sendMoney(recipient, amount),
          throwsException,
        );
      });
    });

    group('cashIn', () {
      test('should call data source cashIn with correct amount', () async {
        // Arrange
        const amount = 1000.00;
        when(() => mockDataSource.cashIn(amount))
            .thenAnswer((_) async => {});

        // Act
        await repository.cashIn(amount);

        // Assert
        verify(() => mockDataSource.cashIn(amount)).called(1);
      });

      test('should throw exception when data source throws', () async {
        // Arrange
        const amount = 100001.00;
        when(() => mockDataSource.cashIn(amount))
            .thenThrow(Exception('Amount exceeds maximum'));

        // Act & Assert
        expect(
          () => repository.cashIn(amount),
          throwsException,
        );
      });
    });
  });
}
