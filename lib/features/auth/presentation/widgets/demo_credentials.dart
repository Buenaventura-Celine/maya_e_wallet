import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/auth/presentation/widgets/credential_row.dart';

class DemoCredentials extends StatelessWidget {
  const DemoCredentials({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Demo Credentials',
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const CredentialRow(
              label: 'Username',
              value: 'test123',
            ),
            const SizedBox(height: 8),
            const CredentialRow(
              label: 'Password',
              value: 'test123',
            ),
          ],
        ),
      ),
    );
  }
}
