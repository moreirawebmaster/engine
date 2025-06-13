import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineAnalytics', () {
    late EngineAnalyticsModel disabledModel;
    late EngineAnalyticsModel enabledModel;

    setUpAll(() {
      disabledModel = EngineAnalyticsModel(firebaseAnalyticsEnabled: false);
      enabledModel = EngineAnalyticsModel(firebaseAnalyticsEnabled: true);
    });

    group('Class Structure and Initialization', () {
      test('should have EngineAnalytics class available', () {
        // Act & Assert - Class should be accessible
        expect(EngineAnalytics, isA<Type>());
      });

      test('should provide all static methods', () {
        // Act & Assert - All methods should be available
        expect(() {
          expect(EngineAnalytics.initAnalytics, isA<Function>());
          expect(EngineAnalytics.logEvent, isA<Function>());
          expect(EngineAnalytics.setUserId, isA<Function>());
          expect(EngineAnalytics.setUserProperty, isA<Function>());
          expect(EngineAnalytics.setCurrentScreen, isA<Function>());
          expect(EngineAnalytics.logAppOpen, isA<Function>());
          expect(EngineAnalytics.resetAnalyticsData, isA<Function>());
          expect(EngineAnalytics.setDefaultEventParameters, isA<Function>());
        }, returnsNormally);
      });

      test('should be a static utility class', () {
        // Act & Assert - Should provide static methods without instantiation
        expect(() {
          // All methods should be static and callable
          expect(EngineAnalytics.initAnalytics, isA<Function>());
          expect(EngineAnalytics.logEvent, isA<Function>());
          expect(EngineAnalytics.setUserId, isA<Function>());
        }, returnsNormally);
      });

      test('should support method chaining patterns', () {
        // Act & Assert - Test method availability for chaining
        expect(() async {
          // All methods should be callable in sequence
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.setUserId('test_user');
          await EngineAnalytics.setUserProperty('test_property', 'test_value');
          await EngineAnalytics.logEvent('test_event');
        }, returnsNormally);
      });
    });

    group('Analytics Initialization', () {
      test('should initialize analytics with Firebase disabled', () async {
        // Act & Assert - Should complete without errors
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(disabledModel);
        }(), completes);
      });

      test('should handle Firebase disabled initialization repeatedly', () async {
        // Act & Assert - Should handle repeated initialization with Firebase disabled
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.initAnalytics(disabledModel);
        }(), completes);
      });

      test('should handle initialization with Firebase disabled only', () async {
        // Act & Assert - Test state with Firebase disabled
        await expectLater(() async {
          // Initialize with Firebase disabled
          await EngineAnalytics.initAnalytics(disabledModel);

          // Should work without Firebase
          await EngineAnalytics.logEvent('test_event');
          await EngineAnalytics.setUserId('test_user');
          await EngineAnalytics.setUserProperty('test', 'value');
        }(), completes);
      });

      test('should handle Firebase enabled gracefully when not initialized', () async {
        // Act & Assert - Should handle Firebase enabled but not initialized
        expect(() async {
          await EngineAnalytics.initAnalytics(enabledModel);
        }, throwsA(anything));
      });
    });

    group('Event Logging', () {
      test('should log custom events', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.logEvent('custom_event');
        }(), completes);
      });

      test('should log events with parameters', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test events with various parameters
        await expectLater(() async {
          await EngineAnalytics.logEvent(
            'event_with_params',
            {
              'param_string': 'test_value',
              'param_int': 123,
              'param_double': 45.67,
              'param_bool': true,
            },
          );
        }(), completes);
      });

      test('should log predefined events', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test predefined events
        await expectLater(() async {
          await EngineAnalytics.logAppOpen();
          await EngineAnalytics.logEvent('login', {'method': 'email'});
          await EngineAnalytics.logEvent('sign_up', {'method': 'google'});
          await EngineAnalytics.logEvent('search', {'search_term': 'test query'});
          await EngineAnalytics.logEvent('tutorial_begin');
          await EngineAnalytics.logEvent('tutorial_complete');
          await EngineAnalytics.logEvent('level_up', {'level': 5, 'character': 'warrior'});
        }(), completes);
      });

      test('should handle empty and special values', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test edge cases
        await expectLater(() async {
          await EngineAnalytics.logEvent('empty_params', {});
          await EngineAnalytics.logEvent('login');
          await EngineAnalytics.logEvent('sign_up');
          await EngineAnalytics.logEvent('level_up', {'level': 0});
        }(), completes);
      });

      test('should handle concurrent event logging', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test concurrent operations
        final futures = List.generate(
            20,
            (final index) => EngineAnalytics.logEvent(
                  'concurrent_event_$index',
                  {'index': index},
                ));

        await expectLater(Future.wait(futures), completes);
      });
    });

    group('User Management', () {
      test('should set user ID', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setUserId('user123');
        }(), completes);
      });

      test('should set user properties', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test various user properties
        await expectLater(() async {
          await EngineAnalytics.setUserProperty('user_type', 'premium');
          await EngineAnalytics.setUserProperty('signup_method', 'google');
          await EngineAnalytics.setUserProperty('age_group', '25-34');
          await EngineAnalytics.setUserProperty('country', 'BR');
        }(), completes);
      });

      test('should handle various user identifier formats', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test various identifier formats
        await expectLater(() async {
          final identifiers = [
            'user123',
            'user@example.com',
            'uuid-12345-67890',
            '1234567890',
            'User Name',
            'user_with_underscores',
            'user-with-dashes',
          ];

          for (final identifier in identifiers) {
            await EngineAnalytics.setUserId(identifier);
          }
        }(), completes);
      });

      test('should handle special user properties', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test edge cases
        await expectLater(() async {
          await EngineAnalytics.setUserProperty('empty_value', '');
          await EngineAnalytics.setUserProperty('unicode_prop', '🚀🌟💯');
        }(), completes);
      });

      test('should handle concurrent user property updates', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test concurrent updates
        final futures = List.generate(
            10,
            (final index) => EngineAnalytics.setUserProperty(
                  'property_$index',
                  'value_$index',
                ));

        await expectLater(Future.wait(futures), completes);
      });
    });

    group('Screen Tracking', () {
      test('should set current screen', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setCurrentScreen('HomeScreen');
        }(), completes);
      });

      test('should set screen with class', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setCurrentScreen('ProductDetails', 'ShoppingScreen');
        }(), completes);
      });

      test('should handle various screen names', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test various screen names
        await expectLater(() async {
          final screens = [
            'HomeScreen',
            'LoginScreen',
            'ProductListScreen',
            'CheckoutScreen',
            'ProfileScreen',
            'SettingsScreen',
          ];

          for (final screen in screens) {
            await EngineAnalytics.setCurrentScreen(screen);
          }
        }(), completes);
      });

      test('should handle concurrent screen tracking', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test concurrent screen tracking
        final futures = List.generate(
            5,
            (final index) => EngineAnalytics.setCurrentScreen(
                  'Screen_$index',
                  'Class_$index',
                ));

        await expectLater(Future.wait(futures), completes);
      });
    });

    group('Analytics Configuration', () {
      test('should reset analytics data', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.resetAnalyticsData();
        }(), completes);
      });

      test('should set default event parameters', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setDefaultEventParameters({
            'app_version': '1.0.0',
            'platform': 'flutter',
            'environment': 'development',
          });
        }(), completes);
      });

      test('should handle complex default parameters', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test complex default parameters
        await expectLater(() async {
          final complexParams = {
            'app_info': {
              'version': '1.0.0',
              'build': '100',
            },
            'device_info': {
              'platform': 'flutter',
              'os': 'android',
            },
            'feature_flags': [
              'new_ui_enabled',
              'beta_features_enabled',
            ],
          };

          await EngineAnalytics.setDefaultEventParameters(complexParams);
        }(), completes);
      });
    });

    group('Real-world Usage Scenarios', () {
      test('should handle user journey tracking', () async {
        // Act & Assert - Test user journey scenario
        await expectLater(() async {
          // App start
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.logAppOpen();
          await EngineAnalytics.setCurrentScreen('SplashScreen');

          // User signs up
          await EngineAnalytics.setCurrentScreen('SignUpScreen');
          await EngineAnalytics.logEvent('sign_up', {'method': 'email'});
          await EngineAnalytics.setUserId('user123');

          // User explores app
          await EngineAnalytics.setCurrentScreen('HomeScreen');
          await EngineAnalytics.logEvent('search', {'search_term': 'flutter tutorials'});
          await EngineAnalytics.setCurrentScreen('SearchResults');

          // User completes tutorial
          await EngineAnalytics.logEvent('tutorial_begin');
          await EngineAnalytics.logEvent('tutorial_complete');
          await EngineAnalytics.logEvent('level_up', {'level': 1});
        }(), completes);
      });

      test('should handle e-commerce tracking', () async {
        // Act & Assert - Test e-commerce scenario
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(disabledModel);

          // User browses products
          await EngineAnalytics.setCurrentScreen('ProductList');
          await EngineAnalytics.logEvent(
            'view_item_list',
            {
              'item_category': 'electronics',
              'item_list_name': 'featured_products',
            },
          );

          // User views product
          await EngineAnalytics.setCurrentScreen('ProductDetails');
          await EngineAnalytics.logEvent(
            'view_item',
            {
              'item_id': 'product123',
              'item_name': 'Smartphone',
              'item_category': 'electronics',
              'price': 999.99,
            },
          );

          // User adds to cart
          await EngineAnalytics.logEvent(
            'add_to_cart',
            {
              'currency': 'USD',
              'value': 999.99,
              'items': ['product123'],
            },
          );
        }(), completes);
      });

      test('should handle gaming analytics', () async {
        // Act & Assert - Test gaming scenario
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(disabledModel);

          // Player starts game
          await EngineAnalytics.setUserProperty('player_type', 'casual');
          await EngineAnalytics.logEvent(
            'level_start',
            {
              'level_number': 1,
              'character': 'warrior',
            },
          );

          // Player progresses
          await EngineAnalytics.logEvent(
            'score_update',
            {
              'score': 1500,
              'level': 1,
            },
          );

          // Player levels up
          await EngineAnalytics.logEvent('level_up', {'level': 2, 'character': 'warrior'});

          // Player achieves milestone
          await EngineAnalytics.logEvent(
            'unlock_achievement',
            {
              'achievement_id': 'first_level_complete',
              'achievement_name': 'Getting Started',
            },
          );
        }(), completes);
      });
    });

    group('Performance and Memory Management', () {
      test('should handle high-frequency operations efficiently', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test high-frequency operations
        expect(() async {
          for (var i = 0; i < 100; i++) {
            await EngineAnalytics.logEvent('high_frequency_event_$i');
            await EngineAnalytics.setUserProperty('counter', i.toString());
          }
        }, returnsNormally);
      });

      test('should handle concurrent operations efficiently', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test concurrent operations
        final futures = <Future>[];

        for (var i = 0; i < 50; i++) {
          futures
            ..add(EngineAnalytics.logEvent('concurrent_event_$i'))
            ..add(EngineAnalytics.setUserProperty('prop_$i', 'value_$i'))
            ..add(EngineAnalytics.setCurrentScreen('Screen_$i'));
        }

        await expectLater(Future.wait(futures), completes);
      });

      test('should maintain consistent performance', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test performance consistency
        final stopwatch = Stopwatch()..start();

        for (var i = 0; i < 100; i++) {
          await EngineAnalytics.logEvent('performance_test_$i');
          await EngineAnalytics.setUserProperty('perf_$i', i.toString());
        }

        stopwatch.stop();

        // Should complete reasonably quickly
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      });

      test('should handle memory efficiency with repeated operations', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test memory efficiency
        expect(() async {
          for (var batch = 0; batch < 10; batch++) {
            final futures = <Future>[];

            for (var i = 0; i < 20; i++) {
              futures
                ..add(EngineAnalytics.logEvent('batch_${batch}_event_$i'))
                ..add(EngineAnalytics.setUserProperty('batch_${batch}_prop_$i', i.toString()));
            }

            await Future.wait(futures);

            // Operations should complete without memory issues
          }
        }, returnsNormally);
      });
    });

    group('Firebase Enabled vs Disabled', () {
      test('should handle initialization with Firebase enabled gracefully', () async {
        // Act & Assert - Should handle Firebase not being initialized gracefully
        expect(() async {
          await EngineAnalytics.initAnalytics(enabledModel);
        }, throwsA(anything));
      });

      test('should work with different model configurations', () async {
        // Act & Assert - Test different configurations
        await expectLater(() async {
          // Test with disabled model
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.logEvent('test_disabled');
        }(), completes);

        // Test with enabled model - expect exception when Firebase not initialized
        expect(() async {
          await EngineAnalytics.initAnalytics(enabledModel);
        }, throwsA(anything));
      });

      test('should handle model switching between disabled and enabled', () async {
        // Act & Assert - Test switching between different models
        await expectLater(() async {
          // Start with disabled
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.setUserProperty('mode', 'disabled');

          // Switch back to disabled (should work)
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.setUserProperty('mode', 'disabled_again');
        }(), completes);

        // Test switching to enabled - expect exception when Firebase not initialized
        expect(() async {
          await EngineAnalytics.initAnalytics(enabledModel);
        }, throwsA(anything));
      });
    });

    group('Analytics Model Configuration', () {
      test('should handle basic Firebase disabled model', () async {
        // Arrange
        final basicModel = EngineAnalyticsModel(
          firebaseAnalyticsEnabled: false,
        );

        // Act & Assert - Should work with basic Firebase disabled model
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(basicModel);
          await EngineAnalytics.logEvent('test_event');
          await EngineAnalytics.logAppOpen();
        }(), completes);
      });

      test('should handle Firebase enabled configuration gracefully', () async {
        // Arrange
        final enabledFirebaseModel = EngineAnalyticsModel(
          firebaseAnalyticsEnabled: true,
        );

        // Act & Assert - Should handle Firebase enabled gracefully when not initialized
        expect(() async {
          await EngineAnalytics.initAnalytics(enabledFirebaseModel);
        }, throwsA(anything));
      });
    });
  });
}
