import 'package:maya_e_wallet/features/transaction/data/datasources/remote_transaction_datasource.dart';
import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final RemoteTransactionDataSource remoteDataSource;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    try {
      final remoteTransactions = await remoteDataSource.getTransactions();
      return remoteTransactions.cast<TransactionEntity>();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TransactionEntity> recordTransaction({
    required String type,
    required double amount,
    required String recipient,
  }) async {
    try {
      // Record remotely
      final transaction = await remoteDataSource.recordTransaction(
        type: type,
        amount: amount,
        recipient: recipient,
      );
      return transaction;
    } catch (e) {
      rethrow;
    }
  }
}
