import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineHttpResult', () {
    group('Successful', () {
      test('should create a successful result', () {
        // Arrange
        const testData = 'test data';

        // Act
        const result = Successful<String, String>(testData);

        // Assert
        expect(result.isSuccessful, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.data, equals(testData));
      });

      test('should throw exception when accessing failure on successful result', () {
        // Arrange
        const result = Successful<String, String>('test');

        // Act & Assert
        expect(() => result.failure, throwsException);
      });

      test('should transform successful value with map', () {
        // Arrange
        const result = Successful<String, int>(5);

        // Act
        final transformed = result.map<String>((final value) => 'Number: $value');

        // Assert
        expect(transformed.isSuccessful, isTrue);
        expect(transformed.data, equals('Number: 5'));
      });

      test('should not transform failure with mapFailure on successful result', () {
        // Arrange
        const result = Successful<String, int>(5);

        // Act
        final transformed = result.mapFailure<int>((final failure) => 10);

        // Assert
        expect(transformed.isSuccessful, isTrue);
        expect(transformed.data, equals(5));
      });

      test('should chain operations with then', () {
        // Arrange
        const result = Successful<String, int>(5);

        // Act
        final chained = result.then<String>((final value) => Successful('Value: $value'));

        // Assert
        expect(chained.isSuccessful, isTrue);
        expect(chained.data, equals('Value: 5'));
      });

      test('should not execute thenFailure on successful result', () {
        // Arrange
        const result = Successful<String, int>(5);

        // Act
        final chained = result.thenFailure<int>((final failure) => const Failure(10));

        // Assert
        expect(chained.isSuccessful, isTrue);
        expect(chained.data, equals(5));
      });

      test('should fold successful value', () {
        // Arrange
        const result = Successful<String, int>(5);

        // Act
        final folded = result.fold(
          (final failure) => 'Error: $failure',
          (final data) => 'Success: $data',
        );

        // Assert
        expect(folded, equals('Success: 5'));
      });

      test('should swap successful to failure', () {
        // Arrange
        const result = Successful<String, int>(5);

        // Act
        final swapped = result.swap();

        // Assert
        expect(swapped.isFailure, isTrue);
        expect(swapped.failure, equals(5));
      });
    });

    group('Failure', () {
      test('should create a failure result', () {
        // Arrange
        const errorMessage = 'test error';

        // Act
        const result = Failure<String, int>(errorMessage);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.isSuccessful, isFalse);
        expect(result.failure, equals(errorMessage));
      });

      test('should throw exception when accessing data on failure result', () {
        // Arrange
        const result = Failure<String, int>('error');

        // Act & Assert
        expect(() => result.data, throwsException);
      });

      test('should not transform successful value with map on failure', () {
        // Arrange
        const result = Failure<String, int>('error');

        // Act
        final transformed = result.map<String>((final value) => 'Number: $value');

        // Assert
        expect(transformed.isFailure, isTrue);
        expect(transformed.failure, equals('error'));
      });

      test('should transform failure value with mapFailure', () {
        // Arrange
        const result = Failure<String, int>('error');

        // Act
        final transformed = result.mapFailure<int>((final failure) => 404);

        // Assert
        expect(transformed.isFailure, isTrue);
        expect(transformed.failure, equals(404));
      });

      test('should not execute then on failure result', () {
        // Arrange
        const result = Failure<String, int>('error');

        // Act
        final chained = result.then<String>((final value) => Successful('Value: $value'));

        // Assert
        expect(chained.isFailure, isTrue);
        expect(chained.failure, equals('error'));
      });

      test('should execute thenFailure on failure result', () {
        // Arrange
        const result = Failure<String, int>('error');

        // Act
        final chained = result.thenFailure<int>((final failure) => const Successful(100));

        // Assert
        expect(chained.isSuccessful, isTrue);
        expect(chained.data, equals(100));
      });

      test('should fold failure value', () {
        // Arrange
        const result = Failure<String, int>('error');

        // Act
        final folded = result.fold(
          (final failure) => 'Error: $failure',
          (final data) => 'Success: $data',
        );

        // Assert
        expect(folded, equals('Error: error'));
      });

      test('should swap failure to successful', () {
        // Arrange
        const result = Failure<String, int>('error');

        // Act
        final swapped = result.swap();

        // Assert
        expect(swapped.isSuccessful, isTrue);
        expect(swapped.data, equals('error'));
      });
    });

    group('Static Methods', () {
      test('tryCatch should return successful when no exception', () {
        // Act
        final result = EngineResult.tryCatch<String, int, Exception>(
          (final error) => 'Exception: $error',
          () => 42,
        );

        // Assert
        expect(result.isSuccessful, isTrue);
        expect(result.data, equals(42));
      });

      test('tryCatch should return failure when exception occurs', () {
        // Act
        final result = EngineResult.tryCatch<String, int, Exception>(
          (final error) => 'Exception: ${error.toString()}',
          () => throw Exception('Test exception'),
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, contains('Exception: Exception: Test exception'));
      });

      test('tryExcept should return successful when no exception', () {
        // Act
        final result = EngineResult.tryExcept<Exception, int>(() => 42);

        // Assert
        expect(result.isSuccessful, isTrue);
        expect(result.data, equals(42));
      });

      test('tryExcept should return failure when exception occurs', () {
        // Act
        final result = EngineResult.tryExcept<Exception, int>(
          () => throw Exception('Test exception'),
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<Exception>());
      });

      test('cond should return successful when condition is true', () {
        // Act
        final result = EngineResult.cond<String, int>(true, 'error', 42);

        // Assert
        expect(result.isSuccessful, isTrue);
        expect(result.data, equals(42));
      });

      test('cond should return failure when condition is false', () {
        // Act
        final result = EngineResult.cond<String, int>(false, 'error', 42);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, equals('error'));
      });

      test('condLazy should return successful when condition is true', () {
        // Act
        final result = EngineResult.condLazy<String, int>(
          true,
          () => 'error',
          () => 42,
        );

        // Assert
        expect(result.isSuccessful, isTrue);
        expect(result.data, equals(42));
      });

      test('condLazy should return failure when condition is false', () {
        // Act
        final result = EngineResult.condLazy<String, int>(
          false,
          () => 'error',
          () => 42,
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, equals('error'));
      });
    });

    group('Async Operations', () {
      test('thenAsync should work with successful result', () async {
        // Arrange
        const result = Successful<String, int>(5);

        // Act
        final chained = await result.thenAsync<String>(
          (final value) async => Successful('Async: $value'),
        );

        // Assert
        expect(chained.isSuccessful, isTrue);
        expect(chained.data, equals('Async: 5'));
      });

      test('thenFailureAsync should work with failure result', () async {
        // Arrange
        const result = Failure<String, int>('error');

        // Act
        final chained = await result.thenFailureAsync<int>(
          (final failure) async => const Successful(100),
        );

        // Assert
        expect(chained.isSuccessful, isTrue);
        expect(chained.data, equals(100));
      });

      test('mapAsync should transform successful value', () async {
        // Arrange
        const result = Successful<String, int>(5);

        // Act
        final transformed = await result.mapAsync<String>(
          (final value) async => 'Async: $value',
        );

        // Assert
        expect(transformed.isSuccessful, isTrue);
        expect(transformed.data, equals('Async: 5'));
      });

      test('mapFailureAsync should transform failure value', () async {
        // Arrange
        const result = Failure<String, int>('error');

        // Act
        final transformed = await result.mapFailureAsync<int>(
          (final failure) async => 404,
        );

        // Assert
        expect(transformed.isFailure, isTrue);
        expect(transformed.failure, equals(404));
      });
    });

    group('Equality', () {
      test('successful results with same value should be equal', () {
        // Arrange
        const result1 = Successful<String, int>(42);
        const result2 = Successful<String, int>(42);

        // Assert
        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('failure results with same value should be equal', () {
        // Arrange
        const result1 = Failure<String, int>('error');
        const result2 = Failure<String, int>('error');

        // Assert
        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('results with different values should not be equal', () {
        // Arrange
        const result1 = Successful<String, int>(42);
        const result2 = Successful<String, int>(24);

        // Assert
        expect(result1, isNot(equals(result2)));
      });

      test('successful and failure results should not be equal', () {
        // Arrange
        const result1 = Successful<String, int>(42);
        const result2 = Failure<String, int>('error');

        // Assert
        expect(result1, isNot(equals(result2)));
      });
    });
  });
}
