import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineAnalytics with Disabled Firebase', () {
    late EngineAnalyticsModel disabledModel;

    setUpAll(() {
      disabledModel = EngineAnalyticsModel(firebaseAnalyticsEnabled: false);
    });

    group('Basic Functionality Tests', () {
      test('should initialize analytics with Firebase disabled', () async {
        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(disabledModel);
        }(), completes);
      });

      test('should log custom events with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Should complete without errors even though Firebase is disabled
        await expectLater(() async {
          await EngineAnalytics.logEvent('test_event', {'test_param': 'test_value'});
        }(), completes);
      });

      test('should set user ID with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setUserId('test_user_123');
        }(), completes);
      });

      test('should set user properties with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setUserProperty('user_type', 'premium');
        }(), completes);
      });

      test('should track screen views with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setCurrentScreen('HomeScreen', 'MainScreen');
        }(), completes);
      });

      test('should log predefined events with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.logAppOpen();
          await EngineAnalytics.logEvent('login', {'method': 'google'});
          await EngineAnalytics.logEvent('sign_up', {'method': 'email'});
          await EngineAnalytics.logEvent('search', {'search_term': 'flutter'});
        }(), completes);
      });

      test('should log tutorial events with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.logEvent('tutorial_begin');
          await EngineAnalytics.logEvent('tutorial_complete');
          await EngineAnalytics.logEvent('level_up', {'level': 5, 'character': 'warrior'});
        }(), completes);
      });

      test('should reset analytics data with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.resetAnalyticsData();
        }(), completes);
      });

      test('should set default event parameters with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);
        final defaultParams = {
          'app_version': '1.0.0',
          'platform': 'flutter',
        };

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setDefaultEventParameters(defaultParams);
        }(), completes);
      });
    });

    group('Real World Scenarios with Firebase Disabled', () {
      test('should handle complete user journey with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Simulate complete user journey
        await expectLater(() async {
          await EngineAnalytics.logAppOpen();
          await EngineAnalytics.setCurrentScreen('LoginScreen');
          await EngineAnalytics.logEvent('login', {'method': 'email'});
          await EngineAnalytics.setUserId('user123');
          await EngineAnalytics.setUserProperty('user_type', 'premium');
          await EngineAnalytics.setCurrentScreen('HomeScreen');
          await EngineAnalytics.logEvent('feature_used', {'feature': 'search', 'screen': 'home'});
        }(), completes);
      });

      test('should handle e-commerce events with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Simulate e-commerce events
        await expectLater(() async {
          await EngineAnalytics.logEvent('view_item', {
            'item_id': 'product123',
            'item_name': 'Flutter Book',
            'category': 'books',
            'price': 29.99,
          });

          await EngineAnalytics.logEvent('add_to_cart', {
            'currency': 'USD',
            'value': 29.99,
            'items': ['product123'],
          });
        }(), completes);
      });

      test('should handle concurrent analytics operations with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act - Execute concurrent operations
        final futures = [
          EngineAnalytics.logEvent('concurrent_event_1'),
          EngineAnalytics.logEvent('concurrent_event_2'),
          EngineAnalytics.setUserProperty('prop1', 'value1'),
          EngineAnalytics.setUserProperty('prop2', 'value2'),
          EngineAnalytics.setCurrentScreen('Screen1'),
          EngineAnalytics.setCurrentScreen('Screen2'),
        ];

        // Assert - All operations should complete without errors
        await expectLater(Future.wait(futures), completes);
      });

      test('should handle high-frequency operations with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test high-frequency operations
        await expectLater(() async {
          for (var i = 0; i < 50; i++) {
            await EngineAnalytics.logEvent('high_freq_event_$i');
            await EngineAnalytics.setUserProperty('prop_$i', 'value_$i');
          }
        }(), completes);
      });
    });

    group('Configuration Tests', () {
      test('should work with basic disabled model configuration', () async {
        // Arrange
        final basicModel = EngineAnalyticsModel(firebaseAnalyticsEnabled: false);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(basicModel);
          await EngineAnalytics.logEvent('basic_test');
          await EngineAnalytics.setUserId('basic_user');
        }(), completes);
      });

      test('should maintain state between operations', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test that state is maintained
        await expectLater(() async {
          await EngineAnalytics.setUserId('persistent_user');
          await EngineAnalytics.logEvent('state_test_1');
          await EngineAnalytics.setUserProperty('persistent_prop', 'value');
          await EngineAnalytics.logEvent('state_test_2');
        }(), completes);
      });

      test('should handle model reinitialization', () async {
        // Act & Assert - Reinitializations should work
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.logEvent('after_first_init');

          // Reinitialize with same model
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.logEvent('after_second_init');

          // Initialize with another disabled model
          final anotherModel = EngineAnalyticsModel(firebaseAnalyticsEnabled: false);
          await EngineAnalytics.initAnalytics(anotherModel);
          await EngineAnalytics.logEvent('after_third_init');
        }(), completes);
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle empty and special values with Firebase disabled', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.logEvent('empty_params', {});
          await EngineAnalytics.logEvent('no_params');
          await EngineAnalytics.setUserProperty('empty_value', '');
          await EngineAnalytics.setUserProperty('unicode_prop', '🚀🌟💯');
          await EngineAnalytics.setCurrentScreen('EmptyScreen', '');
          await EngineAnalytics.setCurrentScreen('NoClassScreen');
        }(), completes);
      });

      test('should handle special characters in event names and parameters', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.logEvent('event_with_special_chars', {
            'special_chars': 'àáâãäåæçèéêë',
            'numbers': 12345,
            'boolean': true,
            'float': 123.456,
          });
          await EngineAnalytics.setUserProperty('special_property', 'ñóôõöøùúûü');
        }(), completes);
      });
    });
  });
}
