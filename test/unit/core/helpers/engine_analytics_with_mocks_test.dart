import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/firebase_test_helper.dart';
import '../../../mocks/firebase_mocks.dart';

void main() {
  group('EngineAnalytics with Firebase Mocks', () {
    late EngineAnalyticsModel enabledModel;

    setUpAll(() {
      enabledModel = EngineAnalyticsModel(firebaseAnalyticsEnabled: true);
    });

    group('Tests with Firebase Analytics Mocked', () {
      setUp(() {
        FirebaseTestHelper.setupFirebaseMocks();
      });

      tearDown(() {
        FirebaseMocks.resetAllMocks();
      });

      test('should initialize analytics with Firebase enabled', () async {
        // Arrange
        final model = FirebaseTestHelper.createAnalyticsModel(analyticsEnabled: true);

        // Act
        await EngineAnalytics.initAnalytics(model);

        // Assert - Verify if mock methods were called
        verify(FirebaseMocks.analytics.setAnalyticsCollectionEnabled(true)).called(1);
      });

      test('should log custom events with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act
        await EngineAnalytics.logEvent(
          name: 'test_event',
          parameters: {'test_param': 'test_value'},
        );

        // Assert
        verify(FirebaseMocks.analytics.logEvent(
          name: 'test_event',
          parameters: {'test_param': 'test_value'},
        )).called(1);
      });

      test('should set user ID with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);
        const testUserId = 'test_user_123';

        // Act
        await EngineAnalytics.setUserId(testUserId);

        // Assert
        verify(FirebaseMocks.analytics.setUserId(id: testUserId)).called(1);
      });

      test('should set user properties with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act
        await EngineAnalytics.setUserProperty(name: 'user_type', value: 'premium');

        // Assert
        verify(FirebaseMocks.analytics.setUserProperty(
          name: 'user_type',
          value: 'premium',
        )).called(1);
      });

      test('should track screen views with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act
        await EngineAnalytics.setCurrentScreen(
          screenName: 'HomeScreen',
          screenClass: 'MainScreen',
        );

        // Assert
        verify(FirebaseMocks.analytics.logScreenView(
          screenName: 'HomeScreen',
          screenClass: 'MainScreen',
        )).called(1);
      });

      test('should log predefined events with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act
        await EngineAnalytics.logAppOpen();
        await EngineAnalytics.logLogin(loginMethod: 'google');
        await EngineAnalytics.logSignUp(signUpMethod: 'email');
        await EngineAnalytics.logSearch(searchTerm: 'flutter');

        // Assert
        verify(FirebaseMocks.analytics.logAppOpen()).called(1);
        verify(FirebaseMocks.analytics.logLogin(loginMethod: 'google')).called(1);
        verify(FirebaseMocks.analytics.logSignUp(signUpMethod: 'email')).called(1);
        verify(FirebaseMocks.analytics.logSearch(searchTerm: 'flutter')).called(1);
      });

      test('should log tutorial events with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act
        await EngineAnalytics.logTutorialBegin();
        await EngineAnalytics.logTutorialComplete();
        await EngineAnalytics.logLevelUp(level: 5, character: 'warrior');

        // Assert
        verify(FirebaseMocks.analytics.logTutorialBegin()).called(1);
        verify(FirebaseMocks.analytics.logTutorialComplete()).called(1);
        verify(FirebaseMocks.analytics.logLevelUp(level: 5, character: 'warrior')).called(1);
      });

      test('should reset analytics data with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act
        await EngineAnalytics.resetAnalyticsData();

        // Assert
        verify(FirebaseMocks.analytics.resetAnalyticsData()).called(1);
      });

      test('should set default event parameters with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);
        final defaultParams = {
          'app_version': '1.0.0',
          'platform': 'flutter',
        };

        // Act
        await EngineAnalytics.setDefaultEventParameters(defaultParams);

        // Assert
        verify(FirebaseMocks.analytics.setDefaultEventParameters(defaultParams)).called(1);
      });

      test('should respect collectEvents configuration', () async {
        // Arrange
        final modelNoEvents = EngineAnalyticsModel(
          firebaseAnalyticsEnabled: true,
          collectEvents: false,
        );
        await EngineAnalytics.initAnalytics(modelNoEvents);

        // Act
        await EngineAnalytics.logEvent(name: 'should_not_be_logged');

        // Assert - Event should NOT be logged when collectEvents = false
        verifyNever(FirebaseMocks.analytics.logEvent(
          name: 'should_not_be_logged',
          parameters: any,
        ));
      });

      test('should respect collectUserProperties configuration', () async {
        // Arrange
        final modelNoProps = EngineAnalyticsModel(
          firebaseAnalyticsEnabled: true,
          collectUserProperties: false,
        );
        await EngineAnalytics.initAnalytics(modelNoProps);

        // Act
        await EngineAnalytics.setUserProperty(name: 'should_not_be_set', value: 'test');

        // Assert - Property should NOT be set when collectUserProperties = false
        verifyNever(FirebaseMocks.analytics.setUserProperty(
          name: 'should_not_be_set',
          value: 'test',
        ));
      });

      test('should handle null user ID gracefully', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act
        await EngineAnalytics.setUserId(null);

        // Assert - Method should NOT be called when userId is null
        verifyNever(FirebaseMocks.analytics.setUserId(id: any));
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

      test('should handle Firebase initialization errors gracefully', () async {
        // Act & Assert - Should handle error during initialization
        expect(() async {
          await EngineAnalytics.initAnalytics(enabledModel);
        }, throwsA(isA<Exception>()));
      });

      test('should handle Firebase event logging errors gracefully', () async {
        // Arrange - Force error during initialization
        try {
          await EngineAnalytics.initAnalytics(enabledModel);
        } catch (e) {
          // Esperado
        }

        // Act & Assert - Should handle error during event logging
        expect(() async {
          await EngineAnalytics.logEvent(name: 'error_event');
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

      test('should handle complete user journey with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act - Simulate complete user journey
        await EngineAnalytics.logAppOpen();
        await EngineAnalytics.setCurrentScreen(screenName: 'LoginScreen');
        await EngineAnalytics.logLogin(loginMethod: 'email');
        await EngineAnalytics.setUserId('user123');
        await EngineAnalytics.setUserProperty(name: 'user_type', value: 'premium');
        await EngineAnalytics.setCurrentScreen(screenName: 'HomeScreen');
        await EngineAnalytics.logEvent(
          name: 'feature_used',
          parameters: {'feature': 'search', 'screen': 'home'},
        );

        // Assert - Verify all events were logged correctly
        verify(FirebaseMocks.analytics.logAppOpen()).called(1);
        verify(FirebaseMocks.analytics.logScreenView(screenName: 'LoginScreen', screenClass: any)).called(1);
        verify(FirebaseMocks.analytics.logLogin(loginMethod: 'email')).called(1);
        verify(FirebaseMocks.analytics.setUserId(id: 'user123')).called(1);
        verify(FirebaseMocks.analytics.setUserProperty(name: 'user_type', value: 'premium')).called(1);
        verify(FirebaseMocks.analytics.logScreenView(screenName: 'HomeScreen', screenClass: any)).called(1);
        verify(FirebaseMocks.analytics.logEvent(
          name: 'feature_used',
          parameters: {'feature': 'search', 'screen': 'home'},
        )).called(1);
      });

      test('should handle e-commerce events with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act - Simulate e-commerce events
        await EngineAnalytics.logEvent(
          name: 'view_item',
          parameters: {
            'item_id': 'product123',
            'item_name': 'Flutter Book',
            'category': 'books',
            'price': 29.99,
          },
        );

        await EngineAnalytics.logEvent(
          name: 'add_to_cart',
          parameters: {
            'currency': 'USD',
            'value': 29.99,
            'items': ['product123'],
          },
        );

        // Assert
        verify(FirebaseMocks.analytics.logEvent(
          name: 'view_item',
          parameters: {
            'item_id': 'product123',
            'item_name': 'Flutter Book',
            'category': 'books',
            'price': 29.99,
          },
        )).called(1);

        verify(FirebaseMocks.analytics.logEvent(
          name: 'add_to_cart',
          parameters: {
            'currency': 'USD',
            'value': 29.99,
            'items': ['product123'],
          },
        )).called(1);
      });

      test('should handle concurrent analytics operations with Firebase enabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(enabledModel);

        // Act - Execute concurrent operations
        final futures = [
          EngineAnalytics.logEvent(name: 'concurrent_event_1'),
          EngineAnalytics.logEvent(name: 'concurrent_event_2'),
          EngineAnalytics.setUserProperty(name: 'prop1', value: 'value1'),
          EngineAnalytics.setUserProperty(name: 'prop2', value: 'value2'),
          EngineAnalytics.setCurrentScreen(screenName: 'Screen1'),
          EngineAnalytics.setCurrentScreen(screenName: 'Screen2'),
        ];

        await Future.wait(futures);

        // Assert - Verify all operations were executed
        verify(FirebaseMocks.analytics.logEvent(name: 'concurrent_event_1', parameters: any)).called(1);
        verify(FirebaseMocks.analytics.logEvent(name: 'concurrent_event_2', parameters: any)).called(1);
        verify(FirebaseMocks.analytics.setUserProperty(name: 'prop1', value: 'value1')).called(1);
        verify(FirebaseMocks.analytics.setUserProperty(name: 'prop2', value: 'value2')).called(1);
        verify(FirebaseMocks.analytics.logScreenView(screenName: 'Screen1', screenClass: any)).called(1);
        verify(FirebaseMocks.analytics.logScreenView(screenName: 'Screen2', screenClass: any)).called(1);
      });
    });
  });
}
