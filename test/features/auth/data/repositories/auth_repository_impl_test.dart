import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/core/exceptions/auth_exception.dart';
import 'package:maya_e_wallet/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:maya_e_wallet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:maya_e_wallet/features/auth/domain/entities/user.dart';

class MockLocalAuthDataSource extends Mock implements LocalAuthDataSource {}

void main() {
  late AuthRepositoryImpl authRepositoryImpl;
  late MockLocalAuthDataSource mockLocalAuthDataSource;

  setUp(() {
    mockLocalAuthDataSource = MockLocalAuthDataSource();
    authRepositoryImpl = AuthRepositoryImpl(
      localDataSource: mockLocalAuthDataSource,
    );
  });

  group('AuthRepositoryImpl', () {
    const testUsername = 'test123';
    const testPassword = 'test123';
    const testUser = User(username: testUsername);

    test('should return User when login is successful', () async {
      // Arrange
      when(
        () => mockLocalAuthDataSource.authenticate(testUsername, testPassword),
      ).thenAnswer((_) async => testUser);

      // Act
      final result = await authRepositoryImpl.login(testUsername, testPassword);

      // Assert
      expect(result, equals(testUser));
      verify(
        () => mockLocalAuthDataSource.authenticate(testUsername, testPassword),
      ).called(1);
    });

    test('should throw AuthException when authentication fails', () async {
      // Arrange
      when(
        () => mockLocalAuthDataSource.authenticate(
          testUsername,
          'wrongPassword',
        ),
      ).thenThrow(AuthException('Invalid credentials'));

      // Act & Assert
      expect(
        () => authRepositoryImpl.login(testUsername, 'wrongPassword'),
        throwsA(isA<AuthException>()),
      );
      verify(
        () => mockLocalAuthDataSource.authenticate(
          testUsername,
          'wrongPassword',
        ),
      ).called(1);
    });

    test('should call datasource with correct parameters', () async {
      // Arrange
      when(
        () => mockLocalAuthDataSource.authenticate(testUsername, testPassword),
      ).thenAnswer((_) async => testUser);

      // Act
      await authRepositoryImpl.login(testUsername, testPassword);

      // Assert
      verify(
        () => mockLocalAuthDataSource.authenticate(testUsername, testPassword),
      ).called(1);
    });

    test('should propagate datasource exceptions', () async {
      // Arrange
      final testException = AuthException('Database error');
      when(
        () => mockLocalAuthDataSource.authenticate(testUsername, testPassword),
      ).thenThrow(testException);

      // Act & Assert
      expect(
        () => authRepositoryImpl.login(testUsername, testPassword),
        throwsA(equals(testException)),
      );
    });
  });
}
