import 'package:maya_e_wallet/features/wallet/domain/repositories/wallet_repository.dart';

class SendMoneyUseCase {
  final WalletRepository repository;

  SendMoneyUseCase(this.repository);

  Future<void> call(String recipient, double amount) async {
    return await repository.sendMoney(recipient, amount);
  }
}
