import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:maya_e_wallet/core/routing/app_router.dart';
import 'package:maya_e_wallet/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:maya_e_wallet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:maya_e_wallet/features/auth/domain/usecases/login_usecase.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_e_wallet/features/wallet/data/datasources/local_wallet_datasource.dart';
import 'package:maya_e_wallet/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/cash_in_usecase.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/get_balance_usecase.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/send_money_usecase.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_cubit.dart';
import 'package:maya_e_wallet/features/transaction/data/datasources/remote_transaction_datasource.dart';
import 'package:maya_e_wallet/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:maya_e_wallet/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:maya_e_wallet/features/transaction/presentation/cubits/transaction_cubit.dart';

void main() {
  // Initialize Auth dependencies
  final localAuthDataSource = LocalAuthDataSource();
  final authRepository = AuthRepositoryImpl(localDataSource: localAuthDataSource);
  final loginUseCase = LoginUseCase(authRepository);

  // Initialize Wallet dependencies
  final localWalletDataSource = LocalWalletDataSourceImpl();
  final walletRepository = WalletRepositoryImpl(localDataSource: localWalletDataSource);
  final getBalanceUseCase = GetBalanceUseCase(walletRepository);
  final sendMoneyUseCase = SendMoneyUseCase(walletRepository);
  final cashInUseCase = CashInUseCase(walletRepository);

  // Initialize Transaction dependencies
  final httpClient = http.Client();
  final remoteTransactionDataSource = RemoteTransactionDataSource(
    httpClient: httpClient,
  );
  final transactionRepository = TransactionRepositoryImpl(
    remoteDataSource: remoteTransactionDataSource,
  );
  final getTransactionsUseCase = GetTransactionsUseCase(transactionRepository);

  runApp(MyApp(
    loginUseCase: loginUseCase,
    getBalanceUseCase: getBalanceUseCase,
    sendMoneyUseCase: sendMoneyUseCase,
    cashInUseCase: cashInUseCase,
    getTransactionsUseCase: getTransactionsUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final GetBalanceUseCase getBalanceUseCase;
  final SendMoneyUseCase sendMoneyUseCase;
  final CashInUseCase cashInUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;

  const MyApp({
    required this.loginUseCase,
    required this.getBalanceUseCase,
    required this.sendMoneyUseCase,
    required this.cashInUseCase,
    required this.getTransactionsUseCase,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(loginUseCase: loginUseCase),
        ),
        BlocProvider(
          create: (context) => WalletCubit(
            getBalanceUseCase: getBalanceUseCase,
            sendMoneyUseCase: sendMoneyUseCase,
            cashInUseCase: cashInUseCase,
          ),
        ),
        BlocProvider(
          create: (context) => TransactionCubit(
            getTransactionsUseCase: getTransactionsUseCase,
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Maya E-Wallet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}