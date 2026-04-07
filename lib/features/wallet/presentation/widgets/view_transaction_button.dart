import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/core/routing/app_router.dart';

class ViewTransactionButton extends StatelessWidget {
  const ViewTransactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.pushNamed(AppRoute.transactions.name);
        },
        child: const Text('View Transactions'),
      ),
    );
  }
}
