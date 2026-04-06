import 'package:flutter_test/flutter_test.dart';
import 'package:maya_e_wallet/features/auth/data/utils/password_utils.dart';

void main() {
  group('PasswordUtils', () {
    group('hashPassword', () {
      test('should hash password with SHA-256', () {
        // Arrange
        const password = 'test123';

        // Act
        final hashedPassword = PasswordUtils.hashPassword(password);

        // Assert
        expect(hashedPassword, isNotEmpty);
        expect(hashedPassword, isA<String>());
        // SHA-256 produces 64-character hex string
        expect(hashedPassword.length, equals(64));
      });

      test('should produce same hash for same password', () {
        // Arrange
        const password = 'test123';

        // Act
        final hash1 = PasswordUtils.hashPassword(password);
        final hash2 = PasswordUtils.hashPassword(password);

        // Assert
        expect(hash1, equals(hash2));
      });

      test('should produce different hashes for different passwords', () {
        // Arrange
        const password1 = 'test123';
        const password2 = 'test456';

        // Act
        final hash1 = PasswordUtils.hashPassword(password1);
        final hash2 = PasswordUtils.hashPassword(password2);

        // Assert
        expect(hash1, isNot(equals(hash2)));
      });

      test('should produce correct hash for known password', () {
        // Arrange
        const password = 'test123';
        // Pre-computed SHA-256 hash of 'test123'
        const expectedHash =
            'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae';

        // Act
        final actualHash = PasswordUtils.hashPassword(password);

        // Assert
        expect(actualHash, equals(expectedHash));
      });
    });

    group('verifyPassword', () {
      test('should return true when plain password matches hashed password', () {
        // Arrange
        const plainPassword = 'test123';
        final hashedPassword = PasswordUtils.hashPassword(plainPassword);

        // Act
        final result =
            PasswordUtils.verifyPassword(plainPassword, hashedPassword);

        // Assert
        expect(result, isTrue);
      });

      test('should return false when plain password does not match hashed password',
          () {
        // Arrange
        const plainPassword = 'test123';
        const wrongPassword = 'wrong123';
        final hashedPassword = PasswordUtils.hashPassword(plainPassword);

        // Act
        final result =
            PasswordUtils.verifyPassword(wrongPassword, hashedPassword);

        // Assert
        expect(result, isFalse);
      });

      test('should return false when hashed password is empty', () {
        // Arrange
        const plainPassword = 'test123';
        const emptyHash = '';

        // Act
        final result = PasswordUtils.verifyPassword(plainPassword, emptyHash);

        // Assert
        expect(result, isFalse);
      });

      test('should handle case-sensitive comparison', () {
        // Arrange
        const password = 'Test123';
        final hashedPassword = PasswordUtils.hashPassword(password);
        const differentCase = 'test123';

        // Act
        final result =
            PasswordUtils.verifyPassword(differentCase, hashedPassword);

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
