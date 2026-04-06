import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/core/routing/app_router.dart';
import 'package:maya_e_wallet/features/auth/presentation/widgets/app_drawer.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/wallet/balance_card.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/wallet/cash_in_button.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/wallet/send_money_button.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/wallet/wallet_header.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  static const double _balance = 500.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        centerTitle: false,
        elevation: 0,
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WalletHeader(),
                const SizedBox(height: 24.0),
                BalanceCard(
                  balance: _balance,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
