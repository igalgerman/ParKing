import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/error/app_error.dart';

void main() {
  group('AppError', () {
    test('NetworkError should contain message and code', () {
      const error = NetworkError('No connection', 'NET_001');

      expect(error.message, 'No connection');
      expect(error.code, 'NET_001');
      expect(error.toString(), '[NET_001] No connection');
    });

    test('ValidationError without code should work', () {
      const error = ValidationError('Invalid email');

      expect(error.message, 'Invalid email');
      expect(error.code, null);
      expect(error.toString(), 'Invalid email');
    });

    test('Different error types are not equal', () {
      const error1 = NetworkError('Error');
      const error2 = ValidationError('Error');

      expect(error1, isNot(error2));
    });

    test('Same error type with same message are equal', () {
      const error1 = NetworkError('Error', 'CODE');
      const error2 = NetworkError('Error', 'CODE');

      expect(error1, error2);
    });

    test('All error types can be instantiated', () {
      const errors = [
        NetworkError('Network error'),
        ValidationError('Validation error'),
        AuthenticationError('Auth error'),
        LocationError('Location error'),
        FirebaseError('Firebase error'),
        StorageError('Storage error'),
        UnknownError('Unknown error'),
      ];

      for (final error in errors) {
        expect(error, isA<AppError>());
        expect(error.message, isNotEmpty);
      }
    });
  });
}
