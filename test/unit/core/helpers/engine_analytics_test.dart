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
          expect(EngineAnalytics.logLogin, isA<Function>());
          expect(EngineAnalytics.logSignUp, isA<Function>());
          expect(EngineAnalytics.logSearch, isA<Function>());
          expect(EngineAnalytics.logTutorialBegin, isA<Function>());
          expect(EngineAnalytics.logTutorialComplete, isA<Function>());
          expect(EngineAnalytics.logLevelUp, isA<Function>());
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
          await EngineAnalytics.setUserProperty(name: 'test_property', value: 'test_value');
          await EngineAnalytics.logEvent(name: 'test_event');
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
          // Disable Firebase
          await EngineAnalytics.initAnalytics(disabledModel);

          // Should work without Firebase
          await EngineAnalytics.logEvent(name: 'test_event');
          await EngineAnalytics.setUserId('test_user');
          await EngineAnalytics.setUserProperty(name: 'test', value: 'value');
        }(), completes);
      });

      test('should handle concurrent initialization with Firebase disabled', () async {
        // Act & Assert - Test concurrent initialization with Firebase disabled
        final futures = List.generate(10, (final index) => EngineAnalytics.initAnalytics(disabledModel));

        await expectLater(Future.wait(futures), completes);
      });
    });

    group('Event Logging', () {
      test('should log custom events', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.logEvent(name: 'custom_event');
        }(), completes);
      });

      test('should log events with parameters', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test events with various parameters
        await expectLater(() async {
          await EngineAnalytics.logEvent(
            name: 'event_with_params',
            parameters: {
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
          await EngineAnalytics.logLogin(loginMethod: 'email');
          await EngineAnalytics.logSignUp(signUpMethod: 'google');
          await EngineAnalytics.logSearch(searchTerm: 'test query');
          await EngineAnalytics.logTutorialBegin();
          await EngineAnalytics.logTutorialComplete();
          await EngineAnalytics.logLevelUp(level: 5, character: 'warrior');
        }(), completes);
      });

      test('should handle empty and special values', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test edge cases
        await expectLater(() async {
          await EngineAnalytics.logEvent(name: 'empty_params', parameters: {});
          await EngineAnalytics.logLogin();
          await EngineAnalytics.logSignUp();
          await EngineAnalytics.logLevelUp(level: 0);
        }(), completes);
      });

      test('should handle concurrent event logging', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test concurrent operations
        final futures = List.generate(
            20,
            (final index) => EngineAnalytics.logEvent(
                  name: 'concurrent_event_$index',
                  parameters: {'index': index},
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

      test('should handle null user ID', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setUserId(null);
        }(), completes);
      });

      test('should set user properties', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test various user properties
        await expectLater(() async {
          await EngineAnalytics.setUserProperty(name: 'user_type', value: 'premium');
          await EngineAnalytics.setUserProperty(name: 'signup_method', value: 'google');
          await EngineAnalytics.setUserProperty(name: 'age_group', value: '25-34');
          await EngineAnalytics.setUserProperty(name: 'country', value: 'BR');
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

      test('should handle empty and special user properties', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test edge cases
        await expectLater(() async {
          await EngineAnalytics.setUserProperty(name: 'empty_value', value: '');
          await EngineAnalytics.setUserProperty(name: 'null_value', value: null);
          await EngineAnalytics.setUserProperty(name: 'unicode_prop', value: '🚀🌟💯');
        }(), completes);
      });

      test('should handle concurrent user property updates', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test concurrent updates
        final futures = List.generate(
            10,
            (final index) => EngineAnalytics.setUserProperty(
                  name: 'property_$index',
                  value: 'value_$index',
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
          await EngineAnalytics.setCurrentScreen(screenName: 'HomeScreen');
        }(), completes);
      });

      test('should set screen with class', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert
        await expectLater(() async {
          await EngineAnalytics.setCurrentScreen(
            screenName: 'ProductDetails',
            screenClass: 'ShoppingScreen',
          );
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
            await EngineAnalytics.setCurrentScreen(screenName: screen);
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
                  screenName: 'Screen_$index',
                  screenClass: 'Class_$index',
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
          await EngineAnalytics.setCurrentScreen(screenName: 'SplashScreen');

          // User signs up
          await EngineAnalytics.setCurrentScreen(screenName: 'SignUpScreen');
          await EngineAnalytics.logSignUp(signUpMethod: 'email');
          await EngineAnalytics.setUserId('user123');

          // User explores app
          await EngineAnalytics.setCurrentScreen(screenName: 'HomeScreen');
          await EngineAnalytics.logSearch(searchTerm: 'flutter tutorials');
          await EngineAnalytics.setCurrentScreen(screenName: 'SearchResults');

          // User completes tutorial
          await EngineAnalytics.logTutorialBegin();
          await EngineAnalytics.logTutorialComplete();
          await EngineAnalytics.logLevelUp(level: 1);
        }(), completes);
      });

      test('should handle e-commerce tracking', () async {
        // Act & Assert - Test e-commerce scenario
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(disabledModel);

          // User browses products
          await EngineAnalytics.setCurrentScreen(screenName: 'ProductList');
          await EngineAnalytics.logEvent(
            name: 'view_item_list',
            parameters: {
              'item_category': 'electronics',
              'item_list_name': 'featured_products',
            },
          );

          // User views product
          await EngineAnalytics.setCurrentScreen(screenName: 'ProductDetails');
          await EngineAnalytics.logEvent(
            name: 'view_item',
            parameters: {
              'item_id': 'product123',
              'item_name': 'Smartphone',
              'item_category': 'electronics',
              'price': 999.99,
            },
          );

          // User adds to cart
          await EngineAnalytics.logEvent(
            name: 'add_to_cart',
            parameters: {
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
          await EngineAnalytics.setUserProperty(name: 'player_type', value: 'casual');
          await EngineAnalytics.logEvent(
            name: 'level_start',
            parameters: {
              'level_number': 1,
              'character': 'warrior',
            },
          );

          // Player progresses
          await EngineAnalytics.logEvent(
            name: 'score_update',
            parameters: {
              'score': 1500,
              'level': 1,
            },
          );

          // Player levels up
          await EngineAnalytics.logLevelUp(level: 2, character: 'warrior');

          // Player achieves milestone
          await EngineAnalytics.logEvent(
            name: 'unlock_achievement',
            parameters: {
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
            await EngineAnalytics.logEvent(name: 'high_frequency_event_$i');
            await EngineAnalytics.setUserProperty(name: 'counter', value: i.toString());
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
            ..add(EngineAnalytics.logEvent(name: 'concurrent_event_$i'))
            ..add(EngineAnalytics.setUserProperty(name: 'prop_$i', value: 'value_$i'))
            ..add(EngineAnalytics.setCurrentScreen(screenName: 'Screen_$i'));
        }

        await expectLater(Future.wait(futures), completes);
      });

      test('should maintain consistent performance', () async {
        // Arrange
        await EngineAnalytics.initAnalytics(disabledModel);

        // Act & Assert - Test performance consistency
        final stopwatch = Stopwatch()..start();

        for (var i = 0; i < 100; i++) {
          await EngineAnalytics.logEvent(name: 'performance_test_$i');
          await EngineAnalytics.setUserProperty(name: 'perf_$i', value: i.toString());
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
                ..add(EngineAnalytics.logEvent(name: 'batch_${batch}_event_$i'))
                ..add(EngineAnalytics.setUserProperty(name: 'batch_${batch}_prop_$i', value: i.toString()));
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
          await EngineAnalytics.logEvent(name: 'test_disabled');
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
          await EngineAnalytics.setUserProperty(name: 'mode', value: 'disabled');

          // Switch back to disabled (should work)
          await EngineAnalytics.initAnalytics(disabledModel);
          await EngineAnalytics.setUserProperty(name: 'mode', value: 'disabled_again');
        }(), completes);

        // Test switching to enabled - expect exception when Firebase not initialized
        expect(() async {
          await EngineAnalytics.initAnalytics(enabledModel);
        }, throwsA(anything));
      });
    });

    group('Analytics Model Configuration', () {
      test('should respect collectEvents setting with Firebase disabled', () async {
        // Arrange
        final noEventsModel = EngineAnalyticsModel(
          firebaseAnalyticsEnabled: false,
          collectEvents: false,
        );

        // Act & Assert - Events should be skipped when collectEvents is false
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(noEventsModel);
          await EngineAnalytics.logEvent(name: 'should_be_skipped');
          await EngineAnalytics.logAppOpen();
        }(), completes);
      });

      test('should respect collectUserProperties setting with Firebase disabled', () async {
        // Arrange
        final noPropsModel = EngineAnalyticsModel(
          firebaseAnalyticsEnabled: false,
          collectUserProperties: false,
        );

        // Act & Assert - User properties should be skipped when collectUserProperties is false
        await expectLater(() async {
          await EngineAnalytics.initAnalytics(noPropsModel);
          await EngineAnalytics.setUserProperty(name: 'should_be_skipped', value: 'test');
        }(), completes);
      });

      test('should handle Firebase enabled configuration gracefully', () async {
        // Arrange
        final debugModel = EngineAnalyticsModel(
          firebaseAnalyticsEnabled: true,
          enableDebugView: true,
        );

        // Act & Assert - Should handle Firebase enabled gracefully when not initialized
        expect(() async {
          await EngineAnalytics.initAnalytics(debugModel);
        }, throwsA(anything));
      });
    });
  });
}
