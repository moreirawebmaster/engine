import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_mocks.mocks.dart';

// Generating mocks for Firebase components
@GenerateMocks([
  FirebaseAnalytics,
  FirebaseCrashlytics,
  FirebaseApp,
])
void main() {}

/// Utility class for setting up Firebase mocks
class FirebaseMocks {
  static MockFirebaseAnalytics? _mockAnalytics;
  static MockFirebaseCrashlytics? _mockCrashlytics;
  static MockFirebaseApp? _mockApp;

  /// Mock for Firebase Analytics
  static MockFirebaseAnalytics get analytics {
    _mockAnalytics ??= MockFirebaseAnalytics();
    return _mockAnalytics!;
  }

  /// Mock for Firebase Crashlytics
  static MockFirebaseCrashlytics get crashlytics {
    _mockCrashlytics ??= MockFirebaseCrashlytics();
    return _mockCrashlytics!;
  }

  /// Mock for Firebase App
  static MockFirebaseApp get app {
    _mockApp ??= MockFirebaseApp();
    return _mockApp!;
  }

  /// Sets up default behaviors for Firebase Analytics mocks
  static void setupAnalyticsMocks() {
    when(analytics.setAnalyticsCollectionEnabled(any)).thenAnswer((final _) async => {});

    when(analytics.logEvent(name: anyNamed('name'), parameters: anyNamed('parameters'))).thenAnswer((final _) async => {});

    when(analytics.setUserId(id: anyNamed('id'))).thenAnswer((final _) async => {});

    when(analytics.setUserProperty(name: anyNamed('name'), value: anyNamed('value'))).thenAnswer((final _) async => {});

    when(analytics.logScreenView(screenName: anyNamed('screenName'), screenClass: anyNamed('screenClass'))).thenAnswer((final _) async => {});

    when(analytics.logAppOpen()).thenAnswer((final _) async => {});

    when(analytics.logLogin(loginMethod: anyNamed('loginMethod'))).thenAnswer((final _) async => {});

    when(analytics.logSignUp(signUpMethod: anyNamed('signUpMethod'))).thenAnswer((final _) async => {});

    when(analytics.logSearch(searchTerm: anyNamed('searchTerm'))).thenAnswer((final _) async => {});

    when(analytics.logTutorialBegin()).thenAnswer((final _) async => {});

    when(analytics.logTutorialComplete()).thenAnswer((final _) async => {});

    when(analytics.logLevelUp(level: anyNamed('level'), character: anyNamed('character'))).thenAnswer((final _) async => {});

    when(analytics.resetAnalyticsData()).thenAnswer((final _) async => {});

    when(analytics.setDefaultEventParameters(any)).thenAnswer((final _) async => {});
  }

  /// Sets up default behaviors for Firebase Crashlytics mocks
  static void setupCrashlyticsMocks() {
    when(crashlytics.setCrashlyticsCollectionEnabled(any)).thenAnswer((final _) async => {});

    when(crashlytics.setCustomKey(any, any)).thenAnswer((final _) async => {});

    when(crashlytics.setUserIdentifier(any)).thenAnswer((final _) async => {});

    when(crashlytics.log(any)).thenAnswer((final _) async => {});

    when(crashlytics.recordError(
      any,
      any,
      reason: anyNamed('reason'),
      printDetails: anyNamed('printDetails'),
      fatal: anyNamed('fatal'),
      information: anyNamed('information'),
    )).thenAnswer((final _) async => {});

    when(crashlytics.recordFlutterError(any)).thenAnswer((final _) async => {});

    // Mock for checkForUnsentReports property
    when(crashlytics.checkForUnsentReports()).thenAnswer((final _) async => false);

    // Mock for deleteUnsentReports property
    when(crashlytics.deleteUnsentReports()).thenAnswer((final _) async => {});

    // Mock for sendUnsentReports property
    when(crashlytics.sendUnsentReports()).thenAnswer((final _) async => {});
  }

  /// Sets up default behaviors for Firebase App mocks
  static void setupAppMocks() {
    when(app.name).thenReturn('[DEFAULT]');
    when(app.options).thenReturn(const FirebaseOptions(
      appId: 'test-app-id',
      apiKey: 'test-api-key',
      projectId: 'test-project',
      messagingSenderId: 'test-sender-id',
    ));
  }

  /// Sets up all mocks with default behaviors
  static void setupAllMocks() {
    setupAnalyticsMocks();
    setupCrashlyticsMocks();
    setupAppMocks();
  }

  /// Resets all mocks
  static void resetAllMocks() {
    _mockAnalytics = null;
    _mockCrashlytics = null;
    _mockApp = null;
  }

  /// Sets up mocks to simulate Firebase errors
  static void setupErrorMocks() {
    // Analytics with error
    when(analytics.setAnalyticsCollectionEnabled(any)).thenThrow(Exception('Firebase not initialized'));

    when(analytics.logEvent(name: anyNamed('name'), parameters: anyNamed('parameters'))).thenThrow(Exception('Firebase not initialized'));

    // Crashlytics with error
    when(crashlytics.setCrashlyticsCollectionEnabled(any)).thenThrow(Exception('Firebase not initialized'));

    when(crashlytics.setCustomKey(any, any)).thenThrow(Exception('Firebase not initialized'));
  }
}
