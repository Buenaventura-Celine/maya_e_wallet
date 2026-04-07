import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/send_money_usecase.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  group('SendMoneyUseCase', () {
    late MockWalletRepository mockRepository;
    late SendMoneyUseCase useCase;

    setUp(() {
      mockRepository = MockWalletRepository();
      useCase = SendMoneyUseCase(mockRepository);
    });

    test('should call repository sendMoney with correct parameters', () async {
      // Arrange
      const recipient = 'john@example.com';
      const amount = 100.00;
      when(() => mockRepository.sendMoney(recipient, amount))
          .thenAnswer((_) async => {});

      // Act
      await useCase(recipient, amount);

      // Assert
      verify(() => mockRepository.sendMoney(recipient, amount)).called(1);
    });

    test('should handle different valid recipients', () async {
      // Arrange
      const amount = 50.00;
      final recipients = ['john@example.com', '09171234567', 'jane_doe'];

      when(() => mockRepository.sendMoney(any(), amount))
          .thenAnswer((_) async => {});

      // Act & Assert
      for (final recipient in recipients) {
        await useCase(recipient, amount);
        verify(() => mockRepository.sendMoney(recipient, amount)).called(1);
      }
    });

    test('should handle different valid amounts', () async {
      // Arrange
      const recipient = 'john@example.com';
      final amounts = [10.00, 100.00, 500.00, 1000.00];

      when(() => mockRepository.sendMoney(recipient, any()))
          .thenAnswer((_) async => {});

      // Act & Assert
      for (final amount in amounts) {
        await useCase(recipient, amount);
        verify(() => mockRepository.sendMoney(recipient, amount)).called(1);
      }
    });

    test('should throw exception when repository throws', () async {
      // Arrange
      const recipient = 'john@example.com';
      const amount = 600.00;
      when(() => mockRepository.sendMoney(recipient, amount))
          .thenThrow(Exception('Insufficient balance'));

      // Act & Assert
      expect(
        () => useCase(recipient, amount),
        throwsException,
      );
    });

    test('should throw exception for insufficient balance error', () async {
      // Arrange
      const recipient = 'john@example.com';
      const amount = 1000.00;
      when(() => mockRepository.sendMoney(recipient, amount))
          .thenThrow(Exception('Insufficient balance. Available: ₱500.00'));

      // Act & Assert
      expect(
        () => useCase(recipient, amount),
        throwsException,
      );
    });
  });
}
