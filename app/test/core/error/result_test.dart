import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/error/result.dart';

void main() {
  group('Result', () {
    test('Success should contain data', () {
      const result = Result<int>.success(42);

      expect(result.isSuccess, true);
      expect(result.isFailure, false);

      result.when(
        success: (data) => expect(data, 42),
        failure: (_) => fail('Should not be failure'),
      );
    });

    test('Failure should contain error', () {
      const error = ValidationError('Invalid input');
      const result = Result<int>.failure(error);

      expect(result.isSuccess, false);
      expect(result.isFailure, true);

      result.when(
        success: (_) => fail('Should not be success'),
        failure: (err) => expect(err, error),
      );
    });

    test('Success equality works', () {
      const result1 = Result<int>.success(42);
      const result2 = Result<int>.success(42);
      const result3 = Result<int>.success(99);

      expect(result1, result2);
      expect(result1, isNot(result3));
    });

    test('Failure equality works', () {
      const error1 = ValidationError('Error message');
      const error2 = ValidationError('Error message');
      const error3 = ValidationError('Different message');

      const result1 = Result<int>.failure(error1);
      const result2 = Result<int>.failure(error2);
      const result3 = Result<int>.failure(error3);

      expect(result1, result2);
      expect(result1, isNot(result3));
    });

    test('when() returns correct value', () {
      const successResult = Result<int>.success(42);
      const failureResult = Result<int>.failure(NetworkError('No network'));

      final successValue = successResult.when(
        success: (data) => 'Success: $data',
        failure: (error) => 'Error: ${error.message}',
      );

      final failureValue = failureResult.when(
        success: (data) => 'Success: $data',
        failure: (error) => 'Error: ${error.message}',
      );

      expect(successValue, 'Success: 42');
      expect(failureValue, 'Error: No network');
    });
  });
}
