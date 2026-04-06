import 'package:crypto/crypto.dart';
import 'dart:convert';

class PasswordUtils {
  /// Hash a plain password using SHA-256
  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// Verify if a plain password matches a hashed password
  static bool verifyPassword(String plainPassword, String hashedPassword) {
    final hashedInput = hashPassword(plainPassword);
    return hashedInput == hashedPassword;
  }
}
