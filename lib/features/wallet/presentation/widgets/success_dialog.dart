import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/core/routing/app_router.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String description;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.check_circle,
        size: 48,
        color: Colors.green,
      ),
      title: Text(title),
      content: Text(
        description,
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              context.pop();
              context.goNamed(AppRoute.wallet.name);
            },
            child: const Text('Back to Wallet'),
          ),
        ),
      ],
    );
  }
}
