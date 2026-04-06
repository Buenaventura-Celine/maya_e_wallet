import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/success_dialog.dart';

class SendMoneySuccessDialog extends StatelessWidget {
  final double amount;
  final String recipient;

  const SendMoneySuccessDialog({
    super.key,
    required this.amount,
    required this.recipient,
  });

  @override
  Widget build(BuildContext context) {
    return SuccessDialog(
      title: 'Transaction Successful!',
      description: '₱${amount.toStringAsFixed(2)} sent to $recipient',
    );
  }
}
