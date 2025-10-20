export 'app_error.dart';
import 'app_error.dart';

/// Result type for operations that can succeed or fail.
/// Eliminates need for try-catch by making errors explicit.
sealed class Result<T> {
  const Result();

  /// Creates a successful result.
  const factory Result.success(T data) = Success<T>;

  /// Creates a failed result.
  const factory Result.failure(AppError error) = Failure<T>;

  /// Pattern matching for result handling.
  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  });

  /// Whether this result is successful.
  bool get isSuccess => this is Success<T>;

  /// Whether this result is a failure.
  bool get isFailure => this is Failure<T>;
}

/// Successful result containing data.
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) =>
      success(data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Failed result containing error.
final class Failure<T> extends Result<T> {
  final AppError error;

  const Failure(this.error);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) =>
      failure(error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> && error == other.error;

  @override
  int get hashCode => error.hashCode;
}
