import 'package:maya_e_wallet/features/transaction/domain/usecases/record_cash_in_transaction_usecase.dart';
import 'package:maya_e_wallet/features/wallet/domain/repositories/wallet_repository.dart';

class CashInUseCase {
  final WalletRepository repository;
  final RecordCashInTransactionUseCase? recordTransactionUseCase;

  CashInUseCase(
    this.repository, {
    this.recordTransactionUseCase,
  });

  Future<void> call(double amount) async {
    // Cash in the amount
    await repository.cashIn(amount);

    // Record the transaction if use case is provided
    if (recordTransactionUseCase != null) {
      await recordTransactionUseCase!(
        source: 'Bank Account',
        amount: amount,
      );
    }
  }
}
