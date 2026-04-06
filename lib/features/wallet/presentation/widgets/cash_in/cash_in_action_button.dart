import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/action_button.dart';

class CashInActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  final bool isLoading;

  const CashInActionButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      label: 'Confirm Cash In',
      icon: Icons.add_circle_outline,
      enabled: enabled,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
