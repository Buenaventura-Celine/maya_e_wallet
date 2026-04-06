import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<WalletEntity> getBalance();
  Future<void> updateBalance(double newBalance);
  Future<void> sendMoney(String recipient, double amount);
  Future<void> cashIn(double amount);
}
