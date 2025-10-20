/// Authentication repository interface.
///
/// This defines the contract for authentication operations.
/// Implementations will handle the actual Firebase Auth integration.
///
/// All methods return [Result<T>] to explicitly handle success and failure cases.
library;

import '../../core/error/result.dart';
import '../entities/user.dart';

/// Repository for user authentication operations.
abstract class AuthRepository {
  /// Logs in a user with email and password.
  ///
  /// Returns [Result<User>] with the authenticated user on success,
  /// or [Failure] with an [AuthenticationError] if credentials are invalid.
  ///
  /// Example:
  /// ```dart
  /// final result = await authRepository.login('user@example.com', 'password123');
  /// result.when(
  ///   success: (user) => print('Welcome ${user.displayName}'),
  ///   failure: (error) => print('Login failed: ${error.message}'),
  /// );
  /// ```
  Future<Result<User>> login({
    required String email,
    required String password,
  });

  /// Registers a new user account.
  ///
  /// Returns [Result<User>] with the newly created user on success,
  /// or [Failure] if registration fails (e.g., email already exists).
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password (min 8 chars)
  /// - [displayName]: User's display name
  Future<Result<User>> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// Signs in with Google account.
  ///
  /// Opens Google Sign-In flow and authenticates the user.
  /// Returns [Result<User>] with the authenticated user on success,
  /// or [Failure] if sign-in is cancelled or fails.
  ///
  /// Note: Requires Google Sign-In to be enabled in Firebase Console.
  Future<Result<User>> signInWithGoogle();

  /// Initiates phone number authentication.
  ///
  /// Sends a verification code to the provided phone number.
  /// Returns [Result<String>] with the verification ID on success.
  ///
  /// Parameters:
  /// - [phoneNumber]: Phone number in E.164 format (e.g., +1234567890)
  ///
  /// After receiving the verification ID, call [verifyPhoneNumber]
  /// with the SMS code to complete authentication.
  Future<Result<String>> sendPhoneVerificationCode({
    required String phoneNumber,
  });

  /// Completes phone number authentication with SMS code.
  ///
  /// Verifies the SMS code and authenticates the user.
  /// Returns [Result<User>] with the authenticated user on success.
  ///
  /// Parameters:
  /// - [verificationId]: ID returned from [sendPhoneVerificationCode]
  /// - [smsCode]: 6-digit code sent to the user's phone
  Future<Result<User>> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  });

  /// Logs out the current user.
  ///
  /// Returns [Result<void>] indicating success or failure.
  Future<Result<void>> logout();

  /// Gets the currently authenticated user.
  ///
  /// Returns [Result<User>] with the current user if authenticated,
  /// or [Failure] with [AuthenticationError] if no user is logged in.
  Future<Result<User?>> getCurrentUser();

  /// Sends a password reset email to the specified address.
  ///
  /// Returns [Result<void>] indicating success or failure.
  Future<Result<void>> resetPassword({required String email});

  /// Updates the current user's profile information.
  ///
  /// Returns [Result<User>] with the updated user on success.
  Future<Result<User>> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
  });

  /// Deletes the current user account.
  ///
  /// This is a destructive operation and cannot be undone.
  /// Returns [Result<void>] indicating success or failure.
  Future<Result<void>> deleteAccount();

  /// Stream of authentication state changes.
  ///
  /// Emits the current user when logged in, or null when logged out.
  /// Useful for reactive UI updates.
  Stream<User?> get authStateChanges;
}
