import 'package:flutter_test/flutter_test.dart';
import 'package:maya_e_wallet/core/exceptions/auth_exception.dart';
import 'package:maya_e_wallet/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:maya_e_wallet/features/auth/domain/entities/user.dart';

void main() {
  late LocalAuthDataSource localAuthDataSource;

  setUp(() {
    localAuthDataSource = LocalAuthDataSource();
  });

  group('LocalAuthDataSource', () {
    test('should return User when credentials are correct', () async {
      // Arrange
      const username = 'test123';
      const password = 'test123';

      // Act
      final result = await localAuthDataSource.authenticate(username, password);

      // Assert
      expect(result, isA<User>());
      expect(result.username, equals(username));
    });

    test('should throw AuthException when username is wrong', () async {
      // Arrange
      const wrongUsername = 'wronguser';
      const password = 'test123';

      // Act & Assert
      expect(
        () => localAuthDataSource.authenticate(wrongUsername, password),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException when password is wrong', () async {
      // Arrange
      const username = 'test123';
      const wrongPassword = 'wrongpass';

      // Act & Assert
      expect(
        () => localAuthDataSource.authenticate(username, wrongPassword),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException when both credentials are wrong', () async {
      // Arrange
      const wrongUsername = 'wronguser';
      const wrongPassword = 'wrongpass';

      // Act & Assert
      expect(
        () => localAuthDataSource.authenticate(wrongUsername, wrongPassword),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException when username is empty', () async {
      // Arrange
      const emptyUsername = '';
      const password = 'test123';

      // Act & Assert
      expect(
        () => localAuthDataSource.authenticate(emptyUsername, password),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException when password is empty', () async {
      // Arrange
      const username = 'test123';
      const emptyPassword = '';

      // Act & Assert
      expect(
        () => localAuthDataSource.authenticate(username, emptyPassword),
        throwsA(isA<AuthException>()),
      );
    });

    test('should be case-sensitive for username and password', () async {
      // Arrange
      const wrongCaseUsername = 'Test123';
      const correctPassword = 'test123';

      // Act & Assert
      expect(
        () => localAuthDataSource.authenticate(wrongCaseUsername, correctPassword),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
