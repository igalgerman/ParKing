/// Login use case.
///
/// Handles the business logic for user login authentication.
/// Validates email and password before calling the repository.
library;

import '../../../core/error/result.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Use case for logging in a user.
///
/// Example usage:
/// ```dart
/// final loginUseCase = LoginUseCase(authRepository);
/// final result = await loginUseCase.execute(
///   email: 'user@example.com',
///   password: 'password123',
/// );
///
/// result.when(
///   success: (user) => navigateToHome(user),
///   failure: (error) => showError(error.message),
/// );
/// ```
class LoginUseCase {
  final AuthRepository _authRepository;

  const LoginUseCase(this._authRepository);

  /// Executes the login flow.
  ///
  /// Validates input and authenticates user via repository.
  ///
  /// Returns [Result<User>] with authenticated user on success,
  /// or [Failure] with appropriate error:
  /// - [ValidationError]: Invalid email or password format
  /// - [AuthenticationError]: Invalid credentials
  /// - [NetworkError]: Connection issues
  Future<Result<User>> execute({
    required String email,
    required String password,
  }) async {
    // Validate email format
    final emailValidation = _validateEmail(email);
    if (emailValidation != null) {
      return Failure(emailValidation);
    }

    // Validate password
    final passwordValidation = _validatePassword(password);
    if (passwordValidation != null) {
      return Failure(passwordValidation);
    }

    // Call repository to authenticate
    return await _authRepository.login(
      email: email.trim(),
      password: password,
    );
  }

  /// Validates email format.
  ///
  /// Returns [ValidationError] if invalid, null if valid.
  ValidationError? _validateEmail(String email) {
    if (email.isEmpty) {
      return const ValidationError('Email cannot be empty');
    }

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      return const ValidationError('Email cannot be empty');
    }

    // Basic email regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmedEmail)) {
      return const ValidationError('Please enter a valid email address');
    }

    return null;
  }

  /// Validates password.
  ///
  /// Returns [ValidationError] if invalid, null if valid.
  ValidationError? _validatePassword(String password) {
    if (password.isEmpty) {
      return const ValidationError('Password cannot be empty');
    }

    if (password.length < 8) {
      return const ValidationError('Password must be at least 8 characters');
    }

    return null;
  }
}
