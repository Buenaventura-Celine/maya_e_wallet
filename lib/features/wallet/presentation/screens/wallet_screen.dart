import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/core/routing/app_router.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_state.dart';
import 'package:maya_e_wallet/features/auth/presentation/widgets/app_drawer.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_cubit.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_state.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/view_transaction_button.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/wallet/cash_in_button.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/wallet/send_money_button.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/wallet/wallet_header.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().loadBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        centerTitle: false,
        elevation: 0,
      ),
      drawer: AppDrawer(),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            context.goNamed(AppRoute.login.name);
          }
        },
        child: SafeArea(
          child: BlocListener<WalletCubit, WalletState>(
            listener: (context, state) {
              if (state is ActionSuccess) {
                context.read<WalletCubit>().loadBalance();
              }
            },
            child: BlocBuilder<WalletCubit, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WalletLoaded) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const WalletHeader(),
                          const SizedBox(height: 24.0),
                          GestureDetector(
                            onTap: () {
                              context.read<WalletCubit>().toggleBalanceVisibility();
                            },
                            child: _BalanceCardContent(
                              balance: state.wallet.balance,
                              isHidden: state.wallet.isBalanceHidden,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Quick Actions',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              SendMoneyButton(
                                onPressed: () {
                                  context.pushNamed(AppRoute.sendMoney.name);
                                },
                              ),
                              const SizedBox(width: 16.0),
                              CashInButton(
                                onPressed: () {
                                  context.pushNamed(AppRoute.cashIn.name);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          const ViewTransactionButton(),
                        ],
                      ),
                    ),
                  );
                } else if (state is ActionFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.message}'),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            context.read<WalletCubit>().loadBalance();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Handle ActionSuccess and ActionInProgress states
                if (state is ActionSuccess || state is ActionInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }

                return const Center(child: Text('Unknown state'));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceCardContent extends StatelessWidget {
  final double balance;
  final bool isHidden;

  const _BalanceCardContent({
    required this.balance,
    required this.isHidden,
  });

  String _formatBalance(double balance) {
    return '₱${balance.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              'Account Balance',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isHidden
                      ? '*' * _formatBalance(balance).length
                      : _formatBalance(balance),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<WalletCubit>().toggleBalanceVisibility();
                  },
                  icon: Icon(
                    isHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
