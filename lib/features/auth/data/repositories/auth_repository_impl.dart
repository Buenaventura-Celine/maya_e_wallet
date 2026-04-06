import 'package:maya_e_wallet/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:maya_e_wallet/features/auth/domain/entities/user.dart';
import 'package:maya_e_wallet/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalAuthDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<User> login(String username, String password) async {
    return await localDataSource.authenticate(username, password);
  }
}
