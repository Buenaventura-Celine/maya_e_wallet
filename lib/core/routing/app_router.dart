import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_state.dart';
import 'package:maya_e_wallet/features/auth/presentation/login_screen.dart';
import 'package:maya_e_wallet/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:maya_e_wallet/features/wallet/presentation/screens/send_money_screen.dart';
import 'package:maya_e_wallet/features/wallet/presentation/screens/cash_in_screen.dart';
import 'package:maya_e_wallet/features/transaction/presentation/transactions_screen.dart';

enum AppRoute {
  login,
  wallet,
  sendMoney,
  cashIn,
  transactions,
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/${AppRoute.login.name}',
    redirect: (context, state) {
      final authState = context.read<AuthCubit>().state;
      final isAuthenticated = authState is AuthSuccess;
      final isLoggingIn = state.matchedLocation == '/${AppRoute.login.name}';

      // If not authenticated and trying to access wallet, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return '/${AppRoute.login.name}';
      }

      // If authenticated and on login, redirect to wallet
      if (isAuthenticated && isLoggingIn) {
        return '/${AppRoute.wallet.name}';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        name: AppRoute.login.name,
        path: '/${AppRoute.login.name}',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: AppRoute.wallet.name,
        path: '/${AppRoute.wallet.name}',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        name: AppRoute.sendMoney.name,
        path: '/${AppRoute.sendMoney.name}',
        builder: (context, state) => const SendMoneyScreen(),
      ),
      GoRoute(
        name: AppRoute.cashIn.name,
        path: '/${AppRoute.cashIn.name}',
        builder: (context, state) => const CashInScreen(),
      ),
      GoRoute(
        name: AppRoute.transactions.name,
        path: '/${AppRoute.transactions.name}',
        builder: (context, state) => const TransactionsScreen(),
      ),
    ],
  );
}
