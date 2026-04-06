import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/success_dialog.dart';

class CashInSuccessDialog extends StatelessWidget {
  final double amount;

  const CashInSuccessDialog({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return SuccessDialog(
      title: 'Cash In Successful!',
      description: '₱${amount.toStringAsFixed(2)} has been added to your wallet',
    );
  }
}
