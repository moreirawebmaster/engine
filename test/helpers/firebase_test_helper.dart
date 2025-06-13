import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/firebase_mocks.dart';
import '../mocks/firebase_mocks.mocks.dart';

/// Helper to facilitate Firebase mocks setup in tests
class FirebaseTestHelper {
  static bool _initialized = false;

  /// Initializes Firebase mocks and replaces real instances
  static void setupFirebaseMocks() {
    if (_initialized) {
      return;
    }

    FirebaseMocks.setupAllMocks();
    _initialized = true;
  }

  /// Tests EngineAnalytics with Firebase enabled using mocks
  static Future<void> testAnalyticsWithFirebaseEnabled({
    required final String testName,
    required final Future<void> Function(EngineAnalyticsModel model) testBody,
  }) async {
    test('$testName - with Firebase Analytics enabled', () async {
      // Arrange
      setupFirebaseMocks();
      final model = EngineAnalyticsModel(firebaseAnalyticsEnabled: true);

      // Act & Assert
      await testBody(model);

      // Cleanup
      FirebaseMocks.resetAllMocks();
    });
  }

  /// Tests EngineBugTracking with Firebase enabled using mocks
  static Future<void> testBugTrackingWithFirebaseEnabled({
    required final String testName,
    required final Future<void> Function(EngineBugTrackingModel model) testBody,
  }) async {
    test('$testName - with Firebase Crashlytics enabled', () async {
      // Arrange
      setupFirebaseMocks();
      final model = EngineBugTrackingModel(
        crashlyticsConfig: CrashlyticsConfig(enabled: true),
        faroConfig: EngineFaroConfig(
          enabled: false,
          endpoint: '',
          appName: '',
          appVersion: '',
          environment: '',
          apiKey: '',
        ),
      );

      // Act & Assert
      await testBody(model);

      // Cleanup
      FirebaseMocks.resetAllMocks();
    });
  }

  /// Tests Firebase error scenarios with actual error injection
  static Future<void> testWithFirebaseErrors({
    required final String testName,
    required final Future<void> Function() testBody,
  }) async {
    test('$testName - handling Firebase errors', () async {
      // Arrange
      setupFirebaseMocks();
      FirebaseMocks.setupErrorMocks();

      // Act & Assert - Test should handle errors gracefully
      await expectLater(testBody, returnsNormally);

      // Cleanup
      FirebaseMocks.resetAllMocks();
    });
  }

  /// Verifies Analytics methods were called with correct parameters
  static void verifyAnalyticsMethodCalls(
    final MockFirebaseAnalytics mock, {
    final int? setAnalyticsCollectionEnabledCount,
    final int? logEventCount,
    final int? setUserIdCount,
    final int? setUserPropertyCount,
    final int? logScreenViewCount,
    final int? logAppOpenCount,
    final int? resetAnalyticsDataCount,
    final int? setDefaultEventParametersCount,
  }) {
    if (setAnalyticsCollectionEnabledCount != null) {
      verify(mock.setAnalyticsCollectionEnabled(any)).called(setAnalyticsCollectionEnabledCount);
    }

    if (logEventCount != null) {
      verify(mock.logEvent(name: anyNamed('name'), parameters: anyNamed('parameters'))).called(logEventCount);
    }

    if (setUserIdCount != null) {
      verify(mock.setUserId(id: anyNamed('id'))).called(setUserIdCount);
    }

    if (setUserPropertyCount != null) {
      verify(mock.setUserProperty(name: anyNamed('name'), value: anyNamed('value'))).called(setUserPropertyCount);
    }

    if (logScreenViewCount != null) {
      verify(mock.logScreenView(
        screenName: anyNamed('screenName'),
        screenClass: anyNamed('screenClass'),
      )).called(logScreenViewCount);
    }

    if (logAppOpenCount != null) {
      verify(mock.logAppOpen()).called(logAppOpenCount);
    }

    if (resetAnalyticsDataCount != null) {
      verify(mock.resetAnalyticsData()).called(resetAnalyticsDataCount);
    }

    if (setDefaultEventParametersCount != null) {
      verify(mock.setDefaultEventParameters(any)).called(setDefaultEventParametersCount);
    }
  }

  /// Verifies Crashlytics methods were called with correct parameters
  static void verifyCrashlyticsMethodCalls(
    final MockFirebaseCrashlytics mock, {
    final int? setCrashlyticsCollectionEnabledCount,
    final int? setCustomKeyCount,
    final int? setUserIdentifierCount,
    final int? logCount,
    final int? recordErrorCount,
    final int? recordFlutterErrorCount,
  }) {
    if (setCrashlyticsCollectionEnabledCount != null) {
      verify(mock.setCrashlyticsCollectionEnabled(any)).called(setCrashlyticsCollectionEnabledCount);
    }

    if (setCustomKeyCount != null) {
      verify(mock.setCustomKey(any, any)).called(setCustomKeyCount);
    }

    if (setUserIdentifierCount != null) {
      verify(mock.setUserIdentifier(any)).called(setUserIdentifierCount);
    }

    if (logCount != null) {
      verify(mock.log(any)).called(logCount);
    }

    if (recordErrorCount != null) {
      verify(mock.recordError(
        any,
        any,
        reason: anyNamed('reason'),
        printDetails: anyNamed('printDetails'),
        fatal: anyNamed('fatal'),
        information: anyNamed('information'),
      )).called(recordErrorCount);
    }

    if (recordFlutterErrorCount != null) {
      verify(mock.recordFlutterError(any)).called(recordFlutterErrorCount);
    }
  }

  /// Tests Analytics initialization and basic operations
  static Future<void> testAnalyticsFlow({
    required final String testName,
    required final Future<void> Function() operations,
  }) async {
    await testAnalyticsWithFirebaseEnabled(
      testName: testName,
      testBody: (final model) async {
        // Initialize Analytics
        await EngineAnalytics.init(model);

        // Execute test operations
        await operations();
      },
    );
  }

  /// Tests BugTracking initialization and basic operations
  static Future<void> testBugTrackingFlow({
    required final String testName,
    required final Future<void> Function() operations,
  }) async {
    await testBugTrackingWithFirebaseEnabled(
      testName: testName,
      testBody: (final model) async {
        // Initialize BugTracking
        await EngineBugTracking.init(model);

        // Execute test operations
        await operations();
      },
    );
  }

  /// Validates Analytics disabled behavior
  static Future<void> testAnalyticsDisabled({
    required final String testName,
    required final Future<void> Function() operations,
  }) async {
    test('$testName - with Firebase Analytics disabled', () async {
      // Arrange
      final model = EngineAnalyticsModel(firebaseAnalyticsEnabled: false);
      await EngineAnalytics.init(model);

      // Act & Assert - Should complete without Firebase calls
      await expectLater(operations, returnsNormally);
    });
  }

  /// Validates BugTracking disabled behavior
  static Future<void> testBugTrackingDisabled({
    required final String testName,
    required final Future<void> Function() operations,
  }) async {
    test('$testName - with Firebase Crashlytics disabled', () async {
      // Arrange
      final model = EngineBugTrackingModel(
        crashlyticsConfig: CrashlyticsConfig(enabled: false),
        faroConfig: EngineFaroConfig(
          enabled: false,
          endpoint: '',
          appName: '',
          appVersion: '',
          environment: '',
          apiKey: '',
        ),
      );
      await EngineBugTracking.init(model);

      // Act & Assert - Should complete without Firebase calls
      await expectLater(operations, returnsNormally);
    });
  }

  /// Creates Analytics model for unit tests
  static EngineAnalyticsModel createAnalyticsModel([final bool enabled = true]) => EngineAnalyticsModel(firebaseAnalyticsEnabled: enabled);

  /// Creates BugTracking model for unit tests
  static EngineBugTrackingModel createBugTrackingModel([final bool enabled = true]) => EngineBugTrackingModel(
        crashlyticsConfig: CrashlyticsConfig(enabled: enabled),
        faroConfig: EngineFaroConfig(
          enabled: false,
          endpoint: '',
          appName: '',
          appVersion: '',
          environment: '',
          apiKey: '',
        ),
      );

  /// Comprehensive Analytics test suite
  static void runAnalyticsTestSuite() {
    group('Firebase Analytics Integration Tests', () async {
      await testAnalyticsFlow(
        testName: 'Basic Analytics Operations',
        operations: () async {
          await EngineAnalytics.logEvent('test_event', {'param': 'value'});
          await EngineAnalytics.setUserId('test_user_123');
          await EngineAnalytics.setUserProperty('user_type', 'tester');
          await EngineAnalytics.setCurrentScreen('TestScreen', 'TestClass');
          await EngineAnalytics.logAppOpen();
        },
      );

      await testAnalyticsDisabled(
        testName: 'Analytics Operations with Firebase Disabled',
        operations: () async {
          await EngineAnalytics.logEvent('test_event');
          await EngineAnalytics.setUserId('test_user');
          await EngineAnalytics.setUserProperty('prop', 'value');
        },
      );

      await testWithFirebaseErrors(
        testName: 'Analytics Error Handling',
        testBody: () async {
          final model = createAnalyticsModel();
          await EngineAnalytics.init(model);
          await EngineAnalytics.logEvent('error_test');
        },
      );
    });
  }

  /// Comprehensive BugTracking test suite
  static void runBugTrackingTestSuite() {
    group('Firebase Crashlytics Integration Tests', () async {
      await testBugTrackingFlow(
        testName: 'Basic BugTracking Operations',
        operations: () async {
          await EngineBugTracking.setCustomKey('test_key', 'test_value');
          await EngineBugTracking.setUserIdentifier('test_user_123', 'test@example.com', 'Test User');
          await EngineBugTracking.log('Test log message');
          await EngineBugTracking.recordError(
            Exception('Test exception'),
            StackTrace.current,
            reason: 'Unit test',
            isFatal: false,
          );
        },
      );

      await testBugTrackingDisabled(
        testName: 'BugTracking Operations with Firebase Disabled',
        operations: () async {
          await EngineBugTracking.setCustomKey('key', 'value');
          await EngineBugTracking.setUserIdentifier('user', 'user@example.com', 'User Name');
          await EngineBugTracking.log('Log message');
        },
      );

      await testWithFirebaseErrors(
        testName: 'BugTracking Error Handling',
        testBody: () async {
          final model = createBugTrackingModel();
          await EngineBugTracking.init(model);
          await EngineBugTracking.log('Error test log');
        },
      );
    });
  }
}

// Empty main for test runner compatibility
void main() {
  // This file is a helper class, not a test file
  // Run the test suites in actual test files:
  // FirebaseTestHelper.runAnalyticsTestSuite();
  // FirebaseTestHelper.runBugTrackingTestSuite();
}
