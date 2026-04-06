import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/action_button.dart';

class SendMoneyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const SendMoneyButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ActionButton(
        label: 'Send Money',
        icon: Icons.send_rounded,
        isLoading: isLoading,
        onPressed: onPressed,
      ),
    );
  }
}
