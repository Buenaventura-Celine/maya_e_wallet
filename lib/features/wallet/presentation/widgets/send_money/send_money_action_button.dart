import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/action_button.dart';

class SendMoneyActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  final bool isLoading;

  const SendMoneyActionButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      label: 'Send Money',
      icon: Icons.send_rounded,
      enabled: enabled,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
