import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/core/routing/app_router.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Wallet Screen'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.go('/${AppRoute.login.name}');
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
