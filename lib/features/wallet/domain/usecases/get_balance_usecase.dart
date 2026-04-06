import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:maya_e_wallet/features/wallet/domain/repositories/wallet_repository.dart';

class GetBalanceUseCase {
  final WalletRepository repository;

  GetBalanceUseCase(this.repository);

  Future<WalletEntity> call() async {
    return await repository.getBalance();
  }
}
