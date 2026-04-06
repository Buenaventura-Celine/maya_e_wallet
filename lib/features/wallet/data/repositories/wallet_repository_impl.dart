import 'package:maya_e_wallet/features/wallet/data/datasources/local_wallet_datasource.dart';
import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:maya_e_wallet/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final LocalWalletDataSource localDataSource;

  WalletRepositoryImpl({required this.localDataSource});

  @override
  Future<WalletEntity> getBalance() async {
    return await localDataSource.getBalance();
  }

  @override
  Future<void> updateBalance(double newBalance) async {
    return await localDataSource.updateBalance(newBalance);
  }

  @override
  Future<void> sendMoney(String recipient, double amount) async {
    return await localDataSource.sendMoney(recipient, amount);
  }

  @override
  Future<void> cashIn(double amount) async {
    return await localDataSource.cashIn(amount);
  }
}
