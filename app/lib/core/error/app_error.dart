/// Base class for all application errors.
/// Provides consistent error structure across the app.
abstract class AppError {
  final String message;
  final String? code;

  const AppError(this.message, [this.code]);

  @override
  String toString() => code == null ? message : '[$code] $message';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Network-related errors.
class NetworkError extends AppError {
  const NetworkError(super.message, [super.code]);
}

/// Validation errors.
class ValidationError extends AppError {
  const ValidationError(super.message, [super.code]);
}

/// Authentication errors.
class AuthenticationError extends AppError {
  const AuthenticationError(super.message, [super.code]);
}

/// Location/GPS errors.
class LocationError extends AppError {
  const LocationError(super.message, [super.code]);
}

/// Firebase-specific errors.
class FirebaseError extends AppError {
  const FirebaseError(super.message, [super.code]);
}

/// Storage errors.
class StorageError extends AppError {
  const StorageError(super.message, [super.code]);
}

/// Unknown/unexpected errors.
class UnknownError extends AppError {
  const UnknownError(super.message, [super.code]);
}
