/// Logout use case.
///
/// Handles the business logic for user logout.
library;

import '../../../core/error/result.dart';
import '../../repositories/auth_repository.dart';

/// Use case for logging out the current user.
///
/// Example usage:
/// ```dart
/// final logoutUseCase = LogoutUseCase(authRepository);
/// final result = await logoutUseCase.execute();
///
/// result.when(
///   success: (_) => navigateToLogin(),
///   failure: (error) => showError(error.message),
/// );
/// ```
class LogoutUseCase {
  final AuthRepository _authRepository;

  const LogoutUseCase(this._authRepository);

  /// Executes the logout flow.
  ///
  /// Logs out the current user and clears authentication state.
  ///
  /// Returns [Result<void>] indicating success or failure:
  /// - [Success]: User logged out successfully
  /// - [Failure]: Logout failed (rare, usually network issues)
  Future<Result<void>> execute() async {
    return await _authRepository.logout();
  }
}
