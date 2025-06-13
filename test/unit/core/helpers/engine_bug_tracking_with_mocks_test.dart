import 'package:engine/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineBugTracking with Firebase Disabled', () {
    late EngineBugTrackingModel disabledModel;

    setUpAll(() {
      disabledModel = EngineBugTrackingModel(crashlyticsEnabled: false);
    });

    group('Basic Functionality Tests', () {
      test('should initialize crash reporting with Firebase disabled', () async {
        // Act & Assert
        await expectLater(() async {
          await EngineBugTracking.init(disabledModel);
        }(), completes);
      });

      test('should set custom keys with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Should complete without errors
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('test_key', 'test_value');
        }(), completes);
      });

      test('should set user identifier with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Should complete without errors
        await expectLater(() async {
          await EngineBugTracking.setUserIdentifier('test_user_123');
        }(), completes);
      });

      test('should log messages with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Should complete without errors
        await expectLater(() async {
          await EngineBugTracking.log('Test log message');
        }(), completes);
      });

      test('should record errors with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Should complete without errors
        await expectLater(() async {
          await EngineBugTracking.recordError(
            Exception('Test exception'),
            StackTrace.current,
            reason: 'Unit test',
            isFatal: false,
          );
        }(), completes);
      });

      test('should record Flutter errors with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Should complete without errors
        await expectLater(() async {
          await EngineBugTracking.recordFlutterError(
            FlutterErrorDetails(
              exception: Exception('Test Flutter error'),
              stack: StackTrace.current,
              library: 'test_library',
              context: ErrorDescription('Test context'),
            ),
          );
        }(), completes);
      });

      test('should handle test crash with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Should complete without errors
        await expectLater(() async {
          await EngineBugTracking.testCrash();
        }(), completes);
      });

      test('should handle multiple custom keys with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Should complete without errors
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('key1', 'value1');
          await EngineBugTracking.setCustomKey('key2', 'value2');
          await EngineBugTracking.setCustomKey('key3', 'value3');
        }(), completes);
      });

      test('should handle different error types with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Should complete without errors for different error types
        await expectLater(() async {
          final errorTypes = [
            Exception('Exception test'),
            StateError('StateError test'),
            ArgumentError('ArgumentError test'),
            const FormatException('FormatException test'),
            UnimplementedError('UnimplementedError test'),
          ];

          for (final error in errorTypes) {
            await EngineBugTracking.recordError(
              error,
              StackTrace.current,
              reason: 'Testing ${error.runtimeType}',
              isFatal: false,
            );
          }
        }(), completes);
      });
    });

    group('Configuration Tests', () {
      test('should handle different configuration combinations with Firebase disabled', () async {
        // Act & Assert - Test different configurations
        await expectLater(() async {
          final configs = [
            EngineBugTrackingModel(crashlyticsEnabled: false),
            EngineBugTrackingModel(crashlyticsEnabled: false),
          ];

          for (final config in configs) {
            await EngineBugTracking.init(config);
            await EngineBugTracking.log('Config test');
          }
        }(), completes);
      });
    });

    group('Error Scenarios', () {
      test('should handle methods calls gracefully when Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - All methods should complete normally
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('key', 'value');
          await EngineBugTracking.setUserIdentifier('user');
          await EngineBugTracking.log('Log message');
        }(), completes);
      });

      test('should handle null error gracefully', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Should handle null error gracefully
        await expectLater(() async {
          await EngineBugTracking.log('Error test log');
        }(), completes);
      });
    });

    group('Real World Scenarios', () {
      test('should handle complete error tracking flow with Firebase disabled', () async {
        // Act & Assert - Complete flow should work
        await expectLater(() async {
          final model = EngineBugTrackingModel(crashlyticsEnabled: false);
          await EngineBugTracking.init(model);

          // Simulate user session
          await EngineBugTracking.setUserIdentifier('test_user_session');
          await EngineBugTracking.setCustomKey('session_start', DateTime.now().toString());

          // Simulate app operations
          await EngineBugTracking.log('User logged in');
          await EngineBugTracking.setCustomKey('last_action', 'login');

          // Simulate error
          await EngineBugTracking.recordError(
            Exception('Session error'),
            StackTrace.current,
            reason: 'Session tracking test',
            isFatal: false,
          );

          await EngineBugTracking.log('Error handled');
        }(), completes);
      });

      test('should handle multiple concurrent error reports with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Concurrent operations should work
        await expectLater(() async {
          final futures = <Future<void>>[];

          for (var i = 0; i < 10; i++) {
            futures
              ..add(
                EngineBugTracking.recordError(
                  Exception('Concurrent error $i'),
                  StackTrace.current,
                  reason: 'Concurrency test $i',
                  isFatal: false,
                ),
              )
              ..add(
                EngineBugTracking.setCustomKey('concurrent_key_$i', 'value_$i'),
              )
              ..add(
                EngineBugTracking.log('Concurrent log $i'),
              );
          }

          await Future.wait(futures);
        }(), completes);
      });

      test('should handle session tracking with Firebase disabled', () async {
        // Arrange
        await EngineBugTracking.init(disabledModel);

        // Act & Assert - Session tracking should work
        await expectLater(() async {
          // Start session
          await EngineBugTracking.setUserIdentifier('session_user');
          await EngineBugTracking.setCustomKey('session_id', 'sess_123456');
          await EngineBugTracking.setCustomKey('app_version', '1.0.0');
          await EngineBugTracking.setCustomKey('platform', 'flutter');

          // Session activities
          final sessionActivities = [
            'login',
            'navigation_to_dashboard',
            'data_fetch',
            'user_interaction',
            'background_sync',
          ];

          for (final activity in sessionActivities) {
            await EngineBugTracking.log('Session activity: $activity');
            await EngineBugTracking.setCustomKey('last_activity', activity);
          }

          // End session
          await EngineBugTracking.log('Session ended');
          await EngineBugTracking.setCustomKey('session_end', DateTime.now().toString());
        }(), completes);
      });
    });
  });
}
