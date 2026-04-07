import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/domain/repositories/transaction_repository.dart';

class RecordSendMoneyTransactionUseCase {
  final TransactionRepository repository;

  RecordSendMoneyTransactionUseCase(this.repository);

  Future<TransactionEntity> call({
    required String recipientName,
    required double amount,
  }) async {
    return await repository.recordTransaction(
      type: 'send',
      amount: amount,
      recipient: recipientName,
    );
  }
}
