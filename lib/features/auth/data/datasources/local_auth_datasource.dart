import 'package:maya_e_wallet/core/exceptions/auth_exception.dart';
import 'package:maya_e_wallet/features/auth/data/utils/password_utils.dart';
import 'package:maya_e_wallet/features/auth/domain/entities/user.dart';

class LocalAuthDataSource {
  // Hardcoded credentials for testing
  static const String hardcodedUsername = 'test123';
  static const String hardcodedPasswordHash =
      'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae';

  Future<User> authenticate(String username, String password) async {
    // Validate username
    if (username != hardcodedUsername) {
      throw AuthException('Invalid username');
    }

    // Validate password
    if (!PasswordUtils.verifyPassword(password, hardcodedPasswordHash)) {
      throw AuthException('Invalid password');
    }

    return User(username: username);
  }
}
