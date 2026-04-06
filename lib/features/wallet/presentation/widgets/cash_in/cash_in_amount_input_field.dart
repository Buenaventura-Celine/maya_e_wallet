import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/amount_input_field.dart';

class CashInAmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final double maxAmount;
  final String? Function(String?)? validator;
  final bool enabled;

  const CashInAmountInputField({
    super.key,
    required this.controller,
    required this.maxAmount,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AmountInputField(
          controller: controller,
          maxAmount: maxAmount,
          helperText: 'Maximum: ₱${maxAmount.toStringAsFixed(2)}',
          validator: validator,
          enabled: enabled,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
