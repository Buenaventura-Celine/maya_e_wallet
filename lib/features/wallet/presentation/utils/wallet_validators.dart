class WalletValidators {
  static String? validateRecipient(String? value) {
    if (value == null || value.isEmpty) {
      return 'Recipient is required';
    }
    return null;
  }

  static String? validateAmount(String? value, double maxAmount) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value);

    if (amount == null) {
      return 'Invalid amount format';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (amount > maxAmount) {
      return 'Amount exceeds available balance';
    }

    // Check decimal places (max 2)
    if (value.contains('.')) {
      final parts = value.split('.');
      if (parts[1].length > 2) {
        return 'Maximum 2 decimal places allowed';
      }
    }

    return null;
  }

  static String? validateCashInAmount(
    String? value, {
    double maxAmount = 100000.0,
  }) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value);

    if (amount == null) {
      return 'Invalid amount format';
    }

    if (amount < 0) {
      return 'Negative amounts not allowed';
    }

    if (amount == 0) {
      return 'Amount must be greater than 0';
    }

    if (amount > maxAmount) {
      return 'Amount exceeds ₱${maxAmount.toStringAsFixed(2)} limit';
    }

    // Check decimal places (max 2)
    if (value.contains('.')) {
      final parts = value.split('.');
      if (parts[1].length > 2) {
        return 'Maximum 2 decimal places allowed';
      }
    }

    return null;
  }

  static String formatCurrency(double amount) {
    return '₱${amount.toStringAsFixed(2)}';
  }
}
