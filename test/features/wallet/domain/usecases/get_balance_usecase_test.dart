import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:maya_e_wallet/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/get_balance_usecase.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  group('GetBalanceUseCase', () {
    late MockWalletRepository mockRepository;
    late GetBalanceUseCase useCase;

    setUp(() {
      mockRepository = MockWalletRepository();
      useCase = GetBalanceUseCase(mockRepository);
    });

    test('should return wallet entity from repository', () async {
      // Arrange
      const walletEntity = WalletEntity(
        balance: 500.00,
        isBalanceHidden: false,
      );
      when(() => mockRepository.getBalance())
          .thenAnswer((_) async => walletEntity);

      // Act
      final result = await useCase();

      // Assert
      expect(result, walletEntity);
      expect(result.balance, 500.00);
      expect(result.isBalanceHidden, false);
      verify(() => mockRepository.getBalance()).called(1);
    });

    test('should return hidden balance when isBalanceHidden is true', () async {
      // Arrange
      const walletEntity = WalletEntity(
        balance: 500.00,
        isBalanceHidden: true,
      );
      when(() => mockRepository.getBalance())
          .thenAnswer((_) async => walletEntity);

      // Act
      final result = await useCase();

      // Assert
      expect(result.isBalanceHidden, true);
    });

    test('should throw exception when repository throws', () async {
      // Arrange
      when(() => mockRepository.getBalance())
          .thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(() => useCase(), throwsException);
    });
  });
}
