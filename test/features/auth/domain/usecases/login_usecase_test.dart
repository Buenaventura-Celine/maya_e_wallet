import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/auth/domain/entities/user.dart';
import 'package:maya_e_wallet/features/auth/domain/repositories/auth_repository.dart';
import 'package:maya_e_wallet/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    const testUsername = 'test123';
    const testPassword = 'test123';
    const testUser = User(username: testUsername);

    test('should return User when login is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(testUsername, testPassword),
      ).thenAnswer((_) async => testUser);

      // Act
      final result = await loginUseCase(testUsername, testPassword);

      // Assert
      expect(result, equals(testUser));
      verify(
        () => mockAuthRepository.login(testUsername, testPassword),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should throw exception when username is invalid', () async {
      // Arrange
      const invalidUsername = 'wronguser';
      when(
        () => mockAuthRepository.login(invalidUsername, testPassword),
      ).thenThrow(Exception('Invalid credentials'));

      // Act & Assert
      expect(
        () => loginUseCase(invalidUsername, testPassword),
        throwsException,
      );
      verify(
        () => mockAuthRepository.login(invalidUsername, testPassword),
      ).called(1);
    });

    test('should throw exception when password is invalid', () async {
      // Arrange
      const invalidPassword = 'wrongpass';
      when(
        () => mockAuthRepository.login(testUsername, invalidPassword),
      ).thenThrow(Exception('Invalid credentials'));

      // Act & Assert
      expect(
        () => loginUseCase(testUsername, invalidPassword),
        throwsException,
      );
      verify(
        () => mockAuthRepository.login(testUsername, invalidPassword),
      ).called(1);
    });

    test('should throw exception when credentials are empty', () async {
      // Arrange
      when(
        () => mockAuthRepository.login('', ''),
      ).thenThrow(Exception('Invalid credentials'));

      // Act & Assert
      expect(
        () => loginUseCase('', ''),
        throwsException,
      );
    });
  });
}
