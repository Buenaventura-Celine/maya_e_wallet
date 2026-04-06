import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/confirmation_dialog.dart';

class CashInConfirmationDialog extends StatelessWidget {
  final double amount;
  final String source;
  final VoidCallback onConfirm;

  const CashInConfirmationDialog({
    super.key,
    required this.amount,
    required this.source,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Confirm Payment',
      details: [
        (label: 'Amount:', value: '₱${amount.toStringAsFixed(2)}'),
      ],
      onConfirm: onConfirm,
    );
  }
}
