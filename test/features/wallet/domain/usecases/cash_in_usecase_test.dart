import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/cash_in_usecase.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  group('CashInUseCase', () {
    late MockWalletRepository mockRepository;
    late CashInUseCase useCase;

    setUp(() {
      mockRepository = MockWalletRepository();
      useCase = CashInUseCase(mockRepository);
    });

    test('should call repository cashIn with correct amount', () async {
      // Arrange
      const amount = 1000.00;
      when(() => mockRepository.cashIn(amount))
          .thenAnswer((_) async => {});

      // Act
      await useCase(amount);

      // Assert
      verify(() => mockRepository.cashIn(amount)).called(1);
    });

    test('should handle different valid amounts', () async {
      // Arrange
      final amounts = [10.00, 100.00, 1000.00, 50000.00, 100000.00];

      when(() => mockRepository.cashIn(any()))
          .thenAnswer((_) async => {});

      // Act & Assert
      for (final amount in amounts) {
        await useCase(amount);
        verify(() => mockRepository.cashIn(amount)).called(1);
      }
    });

    test('should throw exception when repository throws', () async {
      // Arrange
      const amount = 100001.00;
      when(() => mockRepository.cashIn(amount))
          .thenThrow(Exception('Cash in amount cannot exceed ₱100,000.00'));

      // Act & Assert
      expect(
        () => useCase(amount),
        throwsException,
      );
    });

    test('should throw exception for exceeds maximum error', () async {
      // Arrange
      const amount = 150000.00;
      when(() => mockRepository.cashIn(amount))
          .thenThrow(Exception('Cash in amount cannot exceed ₱100,000.00'));

      // Act & Assert
      expect(
        () => useCase(amount),
        throwsException,
      );
    });

    test('should throw exception for zero amount', () async {
      // Arrange
      const amount = 0.0;
      when(() => mockRepository.cashIn(amount))
          .thenThrow(Exception('Amount must be greater than 0'));

      // Act & Assert
      expect(
        () => useCase(amount),
        throwsException,
      );
    });

    test('should throw exception for negative amount', () async {
      // Arrange
      const amount = -100.0;
      when(() => mockRepository.cashIn(amount))
          .thenThrow(Exception('Amount must be greater than 0'));

      // Act & Assert
      expect(
        () => useCase(amount),
        throwsException,
      );
    });
  });
}
