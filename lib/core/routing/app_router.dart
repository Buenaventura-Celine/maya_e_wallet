import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/features/auth/presentation/login_screen.dart';
import 'package:maya_e_wallet/features/wallet/presentation/wallet_screen.dart';

enum AppRoute {
  login,
  wallet,
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/${AppRoute.login.name}',
    routes: [
      GoRoute(
        path: '/${AppRoute.login.name}',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/${AppRoute.wallet.name}',
        builder: (context, state) => const WalletScreen(),
      ),
    ],
  );
}
