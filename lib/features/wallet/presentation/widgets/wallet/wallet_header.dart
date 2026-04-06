import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_state.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final username = state is AuthSuccess ? state.user.username : 'User';
        return Text(
          'Hi $username',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        );
      },
    );
  }
}
