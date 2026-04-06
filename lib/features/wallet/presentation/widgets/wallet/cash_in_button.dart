import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/action_button.dart';

class CashInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const CashInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ActionButton(
        label: 'Cash In',
        icon: Icons.add_circle_outline,
        isLoading: isLoading,
        onPressed: onPressed,
      ),
    );
  }
}
