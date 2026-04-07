import 'package:maya_e_wallet/features/transaction/domain/usecases/record_send_money_transaction_usecase.dart';
import 'package:maya_e_wallet/features/wallet/domain/repositories/wallet_repository.dart';

class SendMoneyUseCase {
  final WalletRepository repository;
  final RecordSendMoneyTransactionUseCase? recordTransactionUseCase;

  SendMoneyUseCase(
    this.repository, {
    this.recordTransactionUseCase,
  });

  Future<void> call(String recipient, double amount) async {
    // Send the money
    await repository.sendMoney(recipient, amount);

    // Record the transaction if use case is provided
    if (recordTransactionUseCase != null) {
      await recordTransactionUseCase!(
        recipientName: recipient,
        amount: amount,
      );
    }
  }
}
