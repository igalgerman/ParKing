/// Register use case.
///
/// Handles the business logic for new user registration.
/// Validates all input fields before calling the repository.
library;

import '../../../core/error/result.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Use case for registering a new user.
///
/// Example usage:
/// ```dart
/// final registerUseCase = RegisterUseCase(authRepository);
/// final result = await registerUseCase.execute(
///   email: 'user@example.com',
///   password: 'SecurePass123',
///   displayName: 'John Doe',
/// );
/// ```
class RegisterUseCase {
  final AuthRepository _authRepository;

  const RegisterUseCase(this._authRepository);

  /// Executes the registration flow.
  ///
  /// Validates input and creates new user account via repository.
  ///
  /// Returns [Result<User>] with newly created user on success,
  /// or [Failure] with appropriate error:
  /// - [ValidationError]: Invalid input (email/password/name format)
  /// - [AuthenticationError]: Email already exists
  /// - [NetworkError]: Connection issues
  Future<Result<User>> execute({
    required String email,
    required String password,
    required String displayName,
  }) async {
    // Validate email format
    final emailValidation = _validateEmail(email);
    if (emailValidation != null) {
      return Failure(emailValidation);
    }

    // Validate password strength
    final passwordValidation = _validatePassword(password);
    if (passwordValidation != null) {
      return Failure(passwordValidation);
    }

    // Validate display name
    final nameValidation = _validateDisplayName(displayName);
    if (nameValidation != null) {
      return Failure(nameValidation);
    }

    // Call repository to create account
    return await _authRepository.register(
      email: email.trim(),
      password: password,
      displayName: displayName.trim(),
    );
  }

  /// Validates email format.
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

  /// Validates password strength.
  ///
  /// Requirements:
  /// - Min 8 characters
  /// - At least 1 uppercase letter
  /// - At least 1 number
  ValidationError? _validatePassword(String password) {
    if (password.isEmpty) {
      return const ValidationError('Password cannot be empty');
    }

    if (password.length < 8) {
      return const ValidationError(
        'Password must be at least 8 characters',
      );
    }

    // Check for uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return const ValidationError(
        'Password must contain at least one uppercase letter',
      );
    }

    // Check for number
    if (!password.contains(RegExp(r'[0-9]'))) {
      return const ValidationError(
        'Password must contain at least one number',
      );
    }

    return null;
  }

  /// Validates display name.
  ///
  /// Requirements:
  /// - Not empty
  /// - Min 2 characters
  /// - Max 50 characters
  ValidationError? _validateDisplayName(String displayName) {
    if (displayName.isEmpty) {
      return const ValidationError('Name cannot be empty');
    }

    final trimmedName = displayName.trim();
    if (trimmedName.isEmpty) {
      return const ValidationError('Name cannot be empty');
    }

    if (trimmedName.length < 2) {
      return const ValidationError('Name must be at least 2 characters');
    }

    if (trimmedName.length > 50) {
      return const ValidationError('Name must be less than 50 characters');
    }

    return null;
  }
}
