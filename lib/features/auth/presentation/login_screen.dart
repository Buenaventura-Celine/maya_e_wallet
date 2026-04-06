import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/core/routing/app_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Screen'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.go('/${AppRoute.wallet.name}');
              },
              child: const Text('Go to Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
