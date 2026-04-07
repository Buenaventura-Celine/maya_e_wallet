import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/domain/repositories/transaction_repository.dart';

class RecordCashInTransactionUseCase {
  final TransactionRepository repository;

  RecordCashInTransactionUseCase(this.repository);

  Future<TransactionEntity> call({
    required String source,
    required double amount,
  }) async {
    return await repository.recordTransaction(
      type: 'cashIn',
      amount: amount,
      recipient: source,
    );
  }
}
