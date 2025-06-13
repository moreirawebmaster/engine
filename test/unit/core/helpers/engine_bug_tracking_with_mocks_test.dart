import 'package:engine/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/firebase_test_helper.dart';
import '../../../mocks/firebase_mocks.dart';

void main() {
  group('EngineBugTracking with Firebase Mocks', () {
    late EngineBugTrackingModel enabledModel;

    setUpAll(() {
      enabledModel = EngineBugTrackingModel(crashlyticsEnabled: true);
    });

    group('Tests with Firebase Crashlytics Mocked', () {
      setUp(() {
        FirebaseTestHelper.setupFirebaseMocks();
      });

      tearDown(() {
        FirebaseMocks.resetAllMocks();
      });

      test('should initialize crash reporting with Firebase enabled', () async {
        // Arrange
        final model = FirebaseTestHelper.createBugTrackingModel(true);

        // Act
        await EngineBugTracking.init(model);

        // Assert - Verify if mock methods were called
        verify(FirebaseMocks.crashlytics.setCrashlyticsCollectionEnabled(true)).called(1);
      });

      test('should set custom keys with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);

        // Act
        await EngineBugTracking.setCustomKey('test_key', 'test_value');

        // Assert
        verify(FirebaseMocks.crashlytics.setCustomKey('test_key', 'test_value')).called(1);
      });

      test('should set user identifier with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);
        const testUserId = 'user123';

        // Act
        await EngineBugTracking.setUserIdentifier(testUserId);

        // Assert
        verify(FirebaseMocks.crashlytics.setUserIdentifier(testUserId)).called(1);
      });

      test('should log messages with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);
        const testMessage = 'Test log message';

        // Act
        await EngineBugTracking.log(testMessage);

        // Assert
        verify(FirebaseMocks.crashlytics.log(testMessage)).called(1);
      });

      test('should record errors with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);
        final testException = Exception('Test error');
        final testStackTrace = StackTrace.current;

        // Act
        await EngineBugTracking.recordError(
          testException,
          testStackTrace,
          reason: 'Test reason',
          isFatal: false,
        );

        // Assert
        verify(FirebaseMocks.crashlytics.recordError(
          testException,
          testStackTrace,
          reason: 'Test reason',
          printDetails: true,
          fatal: false,
          information: any,
        )).called(1);
      });

      test('should record Flutter errors with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);
        final testFlutterError = FlutterErrorDetails(
          exception: Exception('Test Flutter error'),
          stack: StackTrace.current,
          library: 'test_library',
        );

        // Act
        await EngineBugTracking.recordFlutterError(testFlutterError);

        // Assert
        verify(FirebaseMocks.crashlytics.recordFlutterError(testFlutterError)).called(1);
      });

      test('should handle test crash with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);

        // Act
        await EngineBugTracking.testCrash();

        // Assert - Verify crash was called to simulate crash
        verify(FirebaseMocks.crashlytics.crash()).called(1);
      });

      test('should handle multiple custom keys with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);

        // Act
        await EngineBugTracking.setCustomKey('user_id', 'user123');
        await EngineBugTracking.setCustomKey('session_id', 'session456');
        await EngineBugTracking.setCustomKey('app_version', '1.0.0');
        await EngineBugTracking.setCustomKey('build_number', 42);

        // Assert
        verify(FirebaseMocks.crashlytics.setCustomKey('user_id', 'user123')).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('session_id', 'session456')).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('app_version', '1.0.0')).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('build_number', 42)).called(1);
      });

      test('should handle different error types with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);
        final networkError = Exception('Network connection failed');
        const parseError = FormatException('Invalid JSON format');
        final stateError = StateError('Invalid state');

        // Act
        await EngineBugTracking.recordError(networkError, StackTrace.current, reason: 'Network issue');
        await EngineBugTracking.recordError(parseError, StackTrace.current, reason: 'Parse issue');
        await EngineBugTracking.recordError(stateError, StackTrace.current, reason: 'State issue');

        // Assert
        verify(FirebaseMocks.crashlytics.recordError(
          networkError,
          any,
          reason: 'Network issue',
          printDetails: true,
          fatal: false,
          information: any,
        )).called(1);

        verify(FirebaseMocks.crashlytics.recordError(
          parseError,
          any,
          reason: 'Parse issue',
          printDetails: true,
          fatal: false,
          information: any,
        )).called(1);

        verify(FirebaseMocks.crashlytics.recordError(
          stateError,
          any,
          reason: 'State issue',
          printDetails: true,
          fatal: false,
          information: any,
        )).called(1);
      });

      test('should respect crashlyticsEnabled false configuration', () async {
        // Arrange
        final disabledModel = EngineBugTrackingModel(crashlyticsEnabled: false);
        await EngineBugTracking.init(disabledModel);

        // Act
        await EngineBugTracking.setCustomKey('should_not_be_set', 'test');
        await EngineBugTracking.log('should_not_be_logged');

        // Assert - Methods should NOT be called when crashlyticsEnabled = false
        verifyNever(FirebaseMocks.crashlytics.setCustomKey(any, any));
        verifyNever(FirebaseMocks.crashlytics.log(any));
      });
    });

    group('Error Scenarios with Firebase Mocked', () {
      setUp(() {
        FirebaseTestHelper.setupFirebaseMocks();
        FirebaseMocks.setupErrorMocks();
      });

      tearDown(() {
        FirebaseMocks.resetAllMocks();
      });

      test('should handle Firebase Crashlytics initialization errors gracefully', () async {
        // Act & Assert - Should handle error during initialization
        expect(() async {
          await EngineBugTracking.init(enabledModel);
        }, throwsA(isA<Exception>()));
      });

      test('should handle Firebase Crashlytics method errors gracefully', () async {
        // Arrange - Force error during initialization
        try {
          await EngineBugTracking.init(enabledModel);
        } catch (e) {
          // Esperado
        }

        // Act & Assert - Should handle error during operations
        expect(() async {
          await EngineBugTracking.setCustomKey('error_key', 'error_value');
        }, throwsA(isA<Exception>()));
      });
    });

    group('Real World Scenarios with Mocks', () {
      setUp(() {
        FirebaseTestHelper.setupFirebaseMocks();
      });

      tearDown(() {
        FirebaseMocks.resetAllMocks();
      });

      test('should handle complete error tracking flow with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);

        // Act - Simulate complete error tracking flow
        await EngineBugTracking.setUserIdentifier('user123');
        await EngineBugTracking.setCustomKey('user_type', 'premium');
        await EngineBugTracking.setCustomKey('session_id', 'session456');
        await EngineBugTracking.log('User performed critical action');

        // Simulate real error
        final error = Exception('Critical business logic error');
        await EngineBugTracking.recordError(
          error,
          StackTrace.current,
          reason: 'User action failed',
          isFatal: false,
        );

        // Assert - Verify the entire flow was executed correctly
        verify(FirebaseMocks.crashlytics.setUserIdentifier('user123')).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('user_type', 'premium')).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('session_id', 'session456')).called(1);
        verify(FirebaseMocks.crashlytics.log('User performed critical action')).called(1);
        verify(FirebaseMocks.crashlytics.recordError(
          error,
          any,
          reason: 'User action failed',
          printDetails: true,
          fatal: false,
          information: any,
        )).called(1);
      });

      test('should handle multiple concurrent error reports with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);

        // Act - Execute concurrent operations
        final futures = [
          EngineBugTracking.recordError(
            Exception('Error 1'),
            StackTrace.current,
            reason: 'Concurrent error 1',
          ),
          EngineBugTracking.recordError(
            Exception('Error 2'),
            StackTrace.current,
            reason: 'Concurrent error 2',
          ),
          EngineBugTracking.setCustomKey('key1', 'value1'),
          EngineBugTracking.setCustomKey('key2', 'value2'),
          EngineBugTracking.log('Log message 1'),
          EngineBugTracking.log('Log message 2'),
        ];

        await Future.wait(futures);

        // Assert - Verify all operations were executed
        verify(FirebaseMocks.crashlytics.recordError(
          any,
          any,
          reason: 'Concurrent error 1',
          printDetails: true,
          fatal: false,
          information: any,
        )).called(1);

        verify(FirebaseMocks.crashlytics.recordError(
          any,
          any,
          reason: 'Concurrent error 2',
          printDetails: true,
          fatal: false,
          information: any,
        )).called(1);

        verify(FirebaseMocks.crashlytics.setCustomKey('key1', 'value1')).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('key2', 'value2')).called(1);
        verify(FirebaseMocks.crashlytics.log('Log message 1')).called(1);
        verify(FirebaseMocks.crashlytics.log('Log message 2')).called(1);
      });

      test('should handle session tracking with Firebase enabled', () async {
        // Arrange
        await EngineBugTracking.init(enabledModel);
        const sessionId = 'session_abc123';
        const userId = 'user456';

        // Act - Simulate session tracking
        await EngineBugTracking.setUserIdentifier(userId);
        await EngineBugTracking.setCustomKey('session_id', sessionId);
        await EngineBugTracking.setCustomKey('session_start', DateTime.now().toIso8601String());
        await EngineBugTracking.log('Session started');

        // Simulate session activities
        await EngineBugTracking.log('User navigated to home screen');
        await EngineBugTracking.log('User clicked on settings');
        await EngineBugTracking.setCustomKey('last_screen', 'settings');

        // Simulate session end
        await EngineBugTracking.log('Session ended');
        await EngineBugTracking.setCustomKey('session_duration', '00:15:30');

        // Assert - Verify all session events were tracked
        verify(FirebaseMocks.crashlytics.setUserIdentifier(userId)).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('session_id', sessionId)).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('session_start', any)).called(1);
        verify(FirebaseMocks.crashlytics.log('Session started')).called(1);
        verify(FirebaseMocks.crashlytics.log('User navigated to home screen')).called(1);
        verify(FirebaseMocks.crashlytics.log('User clicked on settings')).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('last_screen', 'settings')).called(1);
        verify(FirebaseMocks.crashlytics.log('Session ended')).called(1);
        verify(FirebaseMocks.crashlytics.setCustomKey('session_duration', '00:15:30')).called(1);
      });
    });
  });
}
