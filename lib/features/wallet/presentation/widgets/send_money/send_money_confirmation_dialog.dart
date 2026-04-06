import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/confirmation_dialog.dart';

class SendMoneyConfirmationDialog extends StatelessWidget {
  final String recipient;
  final double amount;
  final VoidCallback onConfirm;

  const SendMoneyConfirmationDialog({
    super.key,
    required this.recipient,
    required this.amount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Confirm Payment',
      details: [
        (label: 'Recipient:', value: recipient),
        (label: 'Amount:', value: '₱${amount.toStringAsFixed(2)}'),
      ],
      onConfirm: onConfirm,
    );
  }
}
