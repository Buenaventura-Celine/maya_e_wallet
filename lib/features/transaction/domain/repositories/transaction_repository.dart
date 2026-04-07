import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();

  Future<TransactionEntity> recordTransaction({
    required String type,
    required double amount,
    required String recipient,
  });
}
