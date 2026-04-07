import 'package:maya_e_wallet/features/transaction/data/datasources/remote_transaction_datasource.dart';
import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final RemoteTransactionDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final remoteTransactions = await remoteDataSource.getTransactions();
    return remoteTransactions.cast<TransactionEntity>();
  }
}
