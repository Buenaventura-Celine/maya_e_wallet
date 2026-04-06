import 'package:maya_e_wallet/features/wallet/data/models/wallet_model.dart';

abstract class LocalWalletDataSource {
  Future<WalletModel> getBalance();
  Future<void> updateBalance(double newBalance);
  Future<void> sendMoney(String recipient, double amount);
  Future<void> cashIn(double amount);
}

class LocalWalletDataSourceImpl implements LocalWalletDataSource {
  static const double _initialBalance = 500.00;
  double _currentBalance = _initialBalance;

  @override
  Future<WalletModel> getBalance() async {
    try {
      return WalletModel(
        balance: _currentBalance,
        isBalanceHidden: false,
      );
    } catch (e) {
      throw Exception('Failed to get balance: ${e.toString()}');
    }
  }

  @override
  Future<void> updateBalance(double newBalance) async {
    try {
      _currentBalance = newBalance;
    } catch (e) {
      throw Exception('Failed to update balance: ${e.toString()}');
    }
  }

  @override
  Future<void> sendMoney(String recipient, double amount) async {
    try {
      if (amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }

      if (amount > _currentBalance) {
        throw Exception('Insufficient balance. Available: ₱$_currentBalance');
      }

      _currentBalance -= amount;
    } catch (e) {
      throw Exception('Failed to send money: ${e.toString()}');
    }
  }

  @override
  Future<void> cashIn(double amount) async {
    try {
      // Validate amount
      if (amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }

      const double maxCashInAmount = 100000.0; // Max ₱100,000
      if (amount > maxCashInAmount) {
        throw Exception(
            'Cash in amount cannot exceed ₱${maxCashInAmount.toStringAsFixed(2)}');
      }

      // Add amount to balance
      _currentBalance += amount;
    } catch (e) {
      throw Exception('Failed to cash in: ${e.toString()}');
    }
  }
}
