import 'package:maya_e_wallet/features/wallet/domain/repositories/wallet_repository.dart';

class CashInUseCase {
  final WalletRepository repository;

  CashInUseCase(this.repository);

  Future<void> call(double amount) async {
    return await repository.cashIn(amount);
  }
}
