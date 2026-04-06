import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_e_wallet/core/routing/app_router.dart';
import 'package:maya_e_wallet/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:maya_e_wallet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:maya_e_wallet/features/auth/domain/usecases/login_usecase.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';

void main() {
  // Initialize dependencies
  final localAuthDataSource = LocalAuthDataSource();
  final authRepository = AuthRepositoryImpl(localDataSource: localAuthDataSource);
  final loginUseCase = LoginUseCase(authRepository);

  runApp(MyApp(loginUseCase: loginUseCase));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;

  const MyApp({required this.loginUseCase, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(loginUseCase: loginUseCase),
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