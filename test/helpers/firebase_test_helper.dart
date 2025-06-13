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

  /// Tests with Firebase Analytics enabled using mocks
  static Future<void> testWithAnalyticsEnabled({
    required final String testName,
    required final Future<void> Function() testBody,
  }) async {
    group('Firebase Analytics Enabled - $testName', () {
      setUp(() {
        setupFirebaseMocks();
      });

      tearDown(() {
        FirebaseMocks.resetAllMocks();
      });

      test('should work with analytics enabled', () async {
        // Setup model for Analytics enabled
        final model = EngineAnalyticsModel(
          firebaseAnalyticsEnabled: true,
          collectUserProperties: true,
          collectEvents: true,
          enableDebugView: false,
        );

        await testBody();
      });
    });
  }

  /// Tests with Firebase Crashlytics enabled using mocks
  static Future<void> testWithCrashlyticsEnabled({
    required final String testName,
    required final Future<void> Function() testBody,
  }) async {
    group('Firebase Crashlytics Enabled - $testName', () {
      setUp(() {
        setupFirebaseMocks();
      });

      tearDown(() {
        FirebaseMocks.resetAllMocks();
      });

      test('should work with crashlytics enabled', () async {
        // Setup model for Crashlytics enabled
        final model = EngineBugTrackingModel(crashlyticsEnabled: true);

        await testBody();
      });
    });
  }

  /// Tests Firebase error scenarios
  static Future<void> testFirebaseErrors({
    required final String testName,
    required final Future<void> Function() testBody,
  }) async {
    group('Firebase Errors - $testName', () {
      setUp(() {
        setupFirebaseMocks();
        FirebaseMocks.setupErrorMocks();
      });

      tearDown(() {
        FirebaseMocks.resetAllMocks();
      });

      test('should handle Firebase errors gracefully', () async {
        await testBody();
      });
    });
  }

  /// Verifies if Analytics methods were called correctly
  static void verifyAnalyticsCalls(
    final MockFirebaseAnalytics mock, {
    final bool? setAnalyticsCollectionEnabled,
    final bool? logEvent,
    final bool? setUserId,
    final bool? setUserProperty,
    final bool? logScreenView,
    final bool? logAppOpen,
    final bool? logLogin,
    final bool? logSignUp,
    final bool? logSearch,
    final bool? logTutorialBegin,
    final bool? logTutorialComplete,
    final bool? logLevelUp,
    final bool? resetAnalyticsData,
    final bool? setDefaultEventParameters,
  }) {
    if (setAnalyticsCollectionEnabled == true) {
      verify(mock.setAnalyticsCollectionEnabled(any)).called(greaterThan(0));
    }

    if (logEvent == true) {
      verify(mock.logEvent(name: anyNamed('name'), parameters: anyNamed('parameters'))).called(greaterThan(0));
    }

    if (setUserId == true) {
      verify(mock.setUserId(id: anyNamed('id'))).called(greaterThan(0));
    }

    if (setUserProperty == true) {
      verify(mock.setUserProperty(name: anyNamed('name'), value: anyNamed('value'))).called(greaterThan(0));
    }

    if (logScreenView == true) {
      verify(mock.logScreenView(
        screenName: anyNamed('screenName'),
        screenClass: anyNamed('screenClass'),
      )).called(greaterThan(0));
    }

    if (logAppOpen == true) {
      verify(mock.logAppOpen()).called(greaterThan(0));
    }

    if (logLogin == true) {
      verify(mock.logLogin(loginMethod: anyNamed('loginMethod'))).called(greaterThan(0));
    }

    if (logSignUp == true) {
      verify(mock.logSignUp(signUpMethod: anyNamed('signUpMethod'))).called(greaterThan(0));
    }

    if (logSearch == true) {
      verify(mock.logSearch(searchTerm: anyNamed('searchTerm'))).called(greaterThan(0));
    }

    if (logTutorialBegin == true) {
      verify(mock.logTutorialBegin()).called(greaterThan(0));
    }

    if (logTutorialComplete == true) {
      verify(mock.logTutorialComplete()).called(greaterThan(0));
    }

    if (logLevelUp == true) {
      verify(mock.logLevelUp(level: anyNamed('level'), character: anyNamed('character'))).called(greaterThan(0));
    }

    if (resetAnalyticsData == true) {
      verify(mock.resetAnalyticsData()).called(greaterThan(0));
    }

    if (setDefaultEventParameters == true) {
      verify(mock.setDefaultEventParameters(any)).called(greaterThan(0));
    }
  }

  /// Verifies if Crashlytics methods were called correctly
  static void verifyCrashlyticsCalls(
    final MockFirebaseCrashlytics mock, {
    final bool? setCrashlyticsCollectionEnabled,
    final bool? setCustomKey,
    final bool? setUserIdentifier,
    final bool? testCrash,
    final bool? log,
    final bool? recordError,
    final bool? recordFlutterError,
  }) {
    if (setCrashlyticsCollectionEnabled == true) {
      verify(mock.setCrashlyticsCollectionEnabled(any)).called(greaterThan(0));
    }

    if (setCustomKey == true) {
      verify(mock.setCustomKey(any, any)).called(greaterThan(0));
    }

    if (setUserIdentifier == true) {
      verify(mock.setUserIdentifier(any)).called(greaterThan(0));
    }

    if (log == true) {
      verify(mock.log(any)).called(greaterThan(0));
    }

    if (recordError == true) {
      verify(mock.recordError(
        any,
        any,
        reason: anyNamed('reason'),
        printDetails: anyNamed('printDetails'),
        fatal: anyNamed('fatal'),
        information: anyNamed('information'),
      )).called(greaterThan(0));
    }

    if (recordFlutterError == true) {
      verify(mock.recordFlutterError(any)).called(greaterThan(0));
    }
  }

  /// Runs test with mocked Analytics
  static Future<void> runWithMockedAnalytics(final Function testFunction) async {
    // For now, we'll run the test normally
    // In a real scenario, you would replace FirebaseAnalytics.instance here
    await testFunction();
  }

  /// Runs test with mocked Crashlytics
  static Future<void> runWithMockedCrashlytics(final Function testFunction) async {
    // For now, we'll run the test normally
    // In a real scenario, you would replace FirebaseCrashlytics.instance here
    await testFunction();
  }

  /// Creates a custom Analytics model for tests
  static EngineAnalyticsModel createAnalyticsModel({
    final bool analyticsEnabled = true,
    final bool collectUserProperties = true,
    final bool collectEvents = true,
    final bool enableDebugView = false,
  }) =>
      EngineAnalyticsModel(
        firebaseAnalyticsEnabled: analyticsEnabled,
        collectUserProperties: collectUserProperties,
        collectEvents: collectEvents,
        enableDebugView: enableDebugView,
      );

  /// Creates a custom BugTracking model for tests
  static EngineBugTrackingModel createBugTrackingModel({
    final bool crashlyticsEnabled = true,
  }) =>
      EngineBugTrackingModel(crashlyticsEnabled: crashlyticsEnabled);
}
