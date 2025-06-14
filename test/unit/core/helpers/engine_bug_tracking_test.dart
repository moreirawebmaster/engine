import 'package:engine/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineBugTracking', () {
    late EngineBugTrackingModel testModel;
    var isInitialized = false;

    setUpAll(() async {
      // Inicializa uma única vez com um modelo desabilitado para evitar dependências do Firebase
      testModel = EngineBugTrackingModel(
        crashlyticsConfig: EngineCrashlyticsConfig(enabled: false),
        faroConfig: EngineFaroConfig(
          enabled: false,
          endpoint: '',
          appName: '',
          appVersion: '',
          environment: '',
          apiKey: '',
        ),
      );

      if (!isInitialized) {
        await EngineBugTracking.init(testModel);
        isInitialized = true;
      }
    });

    group('Class Structure and Static Methods', () {
      test('should have EngineBugTracking class available', () {
        expect(EngineBugTracking, isA<Type>());
      });

      test('should provide all static methods', () {
        expect(EngineBugTracking.init, isA<Function>());
        expect(EngineBugTracking.setCustomKey, isA<Function>());
        expect(EngineBugTracking.setUserIdentifier, isA<Function>());
        expect(EngineBugTracking.testCrash, isA<Function>());
        expect(EngineBugTracking.log, isA<Function>());
        expect(EngineBugTracking.recordError, isA<Function>());
        expect(EngineBugTracking.recordFlutterError, isA<Function>());
      });

      test('should provide status getters', () {
        expect(EngineBugTracking.isCrashlyticsEnabled, isA<bool>());
        expect(EngineBugTracking.isFaroEnabled, isA<bool>());
      });
    });

    group('Status Checks', () {
      test('should correctly report disabled services status', () {
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isFalse);
      });
    });

    group('Custom Key Management', () {
      test('should set custom key with various data types', () async {
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('string_key', 'test_value');
          await EngineBugTracking.setCustomKey('int_key', 42);
          await EngineBugTracking.setCustomKey('double_key', 3.14);
          await EngineBugTracking.setCustomKey('bool_key', true);
          await EngineBugTracking.setCustomKey('list_key', [1, 2, 3]);
          await EngineBugTracking.setCustomKey('map_key', {'nested': 'value'});
        }(), completes);
      });

      test('should handle empty values', () async {
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('empty_string', '');
          await EngineBugTracking.setCustomKey('zero', 0);
          await EngineBugTracking.setCustomKey('false_value', false);
          await EngineBugTracking.setCustomKey('empty_list', []);
          await EngineBugTracking.setCustomKey('empty_map', {});
        }(), completes);
      });

      test('should handle complex nested data structures', () async {
        final complexData = {
          'user': {
            'id': 'user123',
            'profile': {
              'name': 'Test User',
              'preferences': ['dark_mode', 'notifications'],
              'settings': {
                'language': 'en',
                'timezone': 'UTC',
              },
            },
          },
          'session': {
            'start_time': DateTime.now().toIso8601String(),
            'events': [
              {'type': 'login', 'timestamp': DateTime.now().toIso8601String()},
              {'type': 'navigation', 'page': 'dashboard'},
            ],
          },
        };

        await expectLater(() async {
          await EngineBugTracking.setCustomKey('complex_data', complexData);
        }(), completes);
      });

      test('should handle concurrent custom key operations', () async {
        final futures = List.generate(20, (final index) => EngineBugTracking.setCustomKey('concurrent_key_$index', 'value_$index'));

        await expectLater(Future.wait(futures), completes);
      });
    });

    group('User Identifier Management', () {
      test('should set user identifier with all parameters', () async {
        await expectLater(() async {
          await EngineBugTracking.setUserIdentifier('user123', 'user@example.com', 'Test User');
        }(), completes);
      });

      test('should handle various identifier formats', () async {
        await expectLater(() async {
          await EngineBugTracking.setUserIdentifier('uuid-123-456', 'test@example.com', 'UUID User');
          await EngineBugTracking.setUserIdentifier('1234567890', 'numeric@example.com', 'Numeric User');
          await EngineBugTracking.setUserIdentifier('user_with_underscores', 'underscore@example.com', 'Underscore User');
          await EngineBugTracking.setUserIdentifier('user-with-dashes', 'dash@example.com', 'Dash User');
        }(), completes);
      });

      test('should handle empty and special values', () async {
        await expectLater(() async {
          await EngineBugTracking.setUserIdentifier('', '', '');
          await EngineBugTracking.setUserIdentifier('anonymous', 'no-email', 'Anonymous');
          await EngineBugTracking.setUserIdentifier('guest', 'guest@localhost', 'Guest User');
        }(), completes);
      });

      test('should skip when id is "0"', () async {
        await expectLater(() async {
          await EngineBugTracking.setUserIdentifier('0', 'test@example.com', 'Test User');
        }(), completes);
      });

      test('should handle concurrent user identifier updates', () async {
        final futures = List.generate(10, (final index) => EngineBugTracking.setUserIdentifier('user_$index', 'user$index@example.com', 'User $index'));

        await expectLater(Future.wait(futures), completes);
      });
    });

    group('Logging Functionality', () {
      test('should log simple messages', () async {
        await expectLater(() async {
          await EngineBugTracking.log('Simple log message');
        }(), completes);
      });

      test('should log with all parameters', () async {
        await expectLater(() async {
          await EngineBugTracking.log(
            'Detailed log message',
            level: 'info',
            attributes: {
              'user_id': 'user123',
              'feature': 'logging',
              'action': 'test',
            },
            stackTrace: StackTrace.current,
          );
        }(), completes);
      });

      test('should log with different levels', () async {
        await expectLater(() async {
          await EngineBugTracking.log('Debug message', level: 'debug');
          await EngineBugTracking.log('Info message', level: 'info');
          await EngineBugTracking.log('Warning message', level: 'warn');
          await EngineBugTracking.log('Error message', level: 'error');
          await EngineBugTracking.log('Fatal message', level: 'fatal');
        }(), completes);
      });

      test('should log with complex attributes', () async {
        final attributes = {
          'session': {
            'id': 'sess123',
            'duration': 1800,
            'actions': ['login', 'navigate', 'purchase'],
          },
          'user': {
            'id': 'user456',
            'type': 'premium',
            'region': 'US',
          },
          'device': {
            'platform': 'iOS',
            'version': '15.0',
            'model': 'iPhone 13',
          },
        };

        await expectLater(() async {
          await EngineBugTracking.log(
            'Complex log with attributes',
            level: 'info',
            attributes: attributes,
          );
        }(), completes);
      });

      test('should handle empty messages and attributes', () async {
        await expectLater(() async {
          await EngineBugTracking.log('');
          await EngineBugTracking.log('Test', attributes: {});
          await EngineBugTracking.log('Test', level: '');
        }(), completes);
      });

      test('should handle concurrent logging', () async {
        final futures = List.generate(30, (final index) => EngineBugTracking.log('Concurrent log $index', level: 'info', attributes: {'index': index}));

        await expectLater(Future.wait(futures), completes);
      });
    });

    group('Error Recording Functionality', () {
      test('should record basic errors', () async {
        await expectLater(() async {
          await EngineBugTracking.recordError(
            Exception('Test error'),
            StackTrace.current,
          );
        }(), completes);
      });

      test('should record errors with all parameters', () async {
        await expectLater(() async {
          await EngineBugTracking.recordError(
            Exception('Comprehensive error'),
            StackTrace.current,
            isFatal: true,
            reason: 'Critical system failure',
            data: {
              'error_code': 'E001',
              'module': 'payment',
              'user_id': 'user123',
              'transaction_id': 'txn456',
            },
            information: ['Additional info 1', 'Additional info 2'],
          );
        }(), completes);
      });

      test('should record various error types', () async {
        await expectLater(() async {
          await EngineBugTracking.recordError(ArgumentError('Invalid argument'), StackTrace.current);
          await EngineBugTracking.recordError(StateError('Invalid state'), StackTrace.current);
          await EngineBugTracking.recordError(const FormatException('Invalid format'), StackTrace.current);
          await EngineBugTracking.recordError(Exception('Generic exception'), StackTrace.current);
          await EngineBugTracking.recordError(Error(), StackTrace.current);
        }(), completes);
      });

      test('should handle fatal and non-fatal errors', () async {
        await expectLater(() async {
          await EngineBugTracking.recordError(
            Exception('Non-fatal error'),
            StackTrace.current,
            isFatal: false,
            reason: 'Recoverable error',
          );

          await EngineBugTracking.recordError(
            Exception('Fatal error'),
            StackTrace.current,
            isFatal: true,
            reason: 'Critical system failure',
          );
        }(), completes);
      });

      test('should handle complex error data', () async {
        final complexData = {
          'error_context': {
            'feature': 'payment_processing',
            'step': 'validation',
            'attempt': 3,
            'previous_errors': ['timeout', 'invalid_card'],
          },
          'user_context': {
            'id': 'user123',
            'session_duration': 1800,
            'actions_taken': 15,
          },
          'system_context': {
            'memory_usage': 0.75,
            'cpu_usage': 0.45,
            'network': 'wifi',
            'battery': 0.60,
          },
        };

        await expectLater(() async {
          await EngineBugTracking.recordError(
            Exception('Complex error scenario'),
            StackTrace.current,
            reason: 'Payment processing failure',
            data: complexData,
            information: ['Context data included', 'Error reproduced'],
          );
        }(), completes);
      });

      test('should handle errors with empty data', () async {
        await expectLater(() async {
          await EngineBugTracking.recordError(Exception('Error with empty data'), StackTrace.current, data: {});
          await EngineBugTracking.recordError(Exception('Error with empty info'), StackTrace.current, information: []);
          await EngineBugTracking.recordError(Exception('Error with empty reason'), StackTrace.current, reason: '');
        }(), completes);
      });

      test('should handle concurrent error recording', () async {
        final futures = List.generate(
            20,
            (final index) => EngineBugTracking.recordError(
                  Exception('Concurrent error $index'),
                  StackTrace.current,
                  reason: 'Concurrent test $index',
                  data: {'index': index},
                ));

        await expectLater(Future.wait(futures), completes);
      });
    });

    group('Flutter Error Recording', () {
      test('should record Flutter error details', () async {
        final errorDetails = FlutterErrorDetails(
          exception: Exception('Flutter error'),
          stack: StackTrace.current,
          library: 'test_library',
          context: ErrorDescription('Test context'),
        );

        await expectLater(() async {
          await EngineBugTracking.recordFlutterError(errorDetails);
        }(), completes);
      });

      test('should handle Flutter errors with all details', () async {
        final errorDetails = FlutterErrorDetails(
          exception: Exception('Comprehensive Flutter error'),
          stack: StackTrace.current,
          library: 'flutter_widgets',
          context: ErrorDescription('Widget build failed'),
          informationCollector: () => [
            ErrorDescription('Additional info'),
            ErrorHint('Hint for fixing'),
          ],
          silent: false,
        );

        await expectLater(() async {
          await EngineBugTracking.recordFlutterError(errorDetails);
        }(), completes);
      });

      test('should handle various Flutter error types', () async {
        final errorTypes = [
          FlutterErrorDetails(
            exception: Exception('Widget build error'),
            stack: StackTrace.current,
            library: 'flutter_widgets',
            context: ErrorDescription('Widget build failed'),
          ),
          FlutterErrorDetails(
            exception: ArgumentError('Invalid widget parameter'),
            stack: StackTrace.current,
            library: 'flutter_rendering',
            context: ErrorDescription('Rendering error'),
          ),
          FlutterErrorDetails(
            exception: StateError('Invalid widget state'),
            stack: StackTrace.current,
            library: 'flutter_gestures',
            context: ErrorDescription('Gesture handling error'),
          ),
        ];

        await expectLater(() async {
          for (final errorDetails in errorTypes) {
            await EngineBugTracking.recordFlutterError(errorDetails);
          }
        }(), completes);
      });

      test('should handle Flutter errors with minimal details', () async {
        final minimalError = FlutterErrorDetails(
          exception: Exception('Minimal error'),
        );

        await expectLater(() async {
          await EngineBugTracking.recordFlutterError(minimalError);
        }(), completes);
      });

      test('should handle silent Flutter errors', () async {
        final silentError = FlutterErrorDetails(
          exception: Exception('Silent error'),
          stack: StackTrace.current,
          silent: true,
        );

        await expectLater(() async {
          await EngineBugTracking.recordFlutterError(silentError);
        }(), completes);
      });

      test('should handle concurrent Flutter error recording', () async {
        final futures = List.generate(
            10,
            (final index) => EngineBugTracking.recordFlutterError(
                  FlutterErrorDetails(
                    exception: Exception('Concurrent Flutter error $index'),
                    stack: StackTrace.current,
                    library: 'test_library_$index',
                    context: ErrorDescription('Concurrent context $index'),
                  ),
                ));

        await expectLater(Future.wait(futures), completes);
      });
    });

    group('Test Crash Functionality', () {
      test('should handle test crash in debug mode', () async {
        expect(() async {
          await EngineBugTracking.testCrash();
        }, returnsNormally);
      });

      test('should handle multiple test crash calls', () async {
        expect(() async {
          await EngineBugTracking.testCrash();
          await EngineBugTracking.testCrash();
          await EngineBugTracking.testCrash();
        }, returnsNormally);
      });
    });

    group('Real-world Integration Scenarios', () {
      test('should handle complete user session tracking', () async {
        await expectLater(() async {
          await EngineBugTracking.setUserIdentifier('session_user_123', 'user@example.com', 'Test User');
          await EngineBugTracking.setCustomKey('session_start', DateTime.now().toIso8601String());
          await EngineBugTracking.log('User session started', level: 'info');

          await EngineBugTracking.setCustomKey('current_page', 'dashboard');
          await EngineBugTracking.log('User navigated to dashboard', level: 'info');

          await EngineBugTracking.setCustomKey('current_page', 'products');
          await EngineBugTracking.log('User browsing products', level: 'info');

          await EngineBugTracking.recordError(
            Exception('Product loading failed'),
            StackTrace.current,
            reason: 'Network timeout',
            data: {
              'user_id': 'session_user_123',
              'page': 'products',
              'retry_count': 3,
            },
          );

          await EngineBugTracking.log('Retrying product load', level: 'info');
          await EngineBugTracking.setCustomKey('retry_successful', true);

          await EngineBugTracking.setCustomKey('session_end', DateTime.now().toIso8601String());
          await EngineBugTracking.log('User session completed', level: 'info');
        }(), completes);
      });

      test('should handle e-commerce transaction tracking', () async {
        await expectLater(() async {
          await EngineBugTracking.setUserIdentifier('buyer_456', 'buyer@example.com', 'John Doe');
          await EngineBugTracking.setCustomKey('cart_value', 299.99);
          await EngineBugTracking.setCustomKey('items_count', 3);

          await EngineBugTracking.log('Processing payment', level: 'info', attributes: {
            'payment_method': 'credit_card',
            'amount': 299.99,
            'currency': 'USD',
          });

          await EngineBugTracking.recordError(
            Exception('Payment gateway timeout'),
            StackTrace.current,
            isFatal: false,
            reason: 'Gateway timeout',
            data: {
              'gateway': 'stripe',
              'transaction_id': 'txn_123456',
              'amount': 299.99,
              'retry_attempt': 1,
            },
          );

          await EngineBugTracking.log('Payment retry successful', level: 'info');
          await EngineBugTracking.setCustomKey('transaction_completed', true);
        }(), completes);
      });

      test('should handle feature flag and A/B testing', () async {
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('feature_new_checkout', true);
          await EngineBugTracking.setCustomKey('feature_recommendation_engine', false);
          await EngineBugTracking.setCustomKey('ab_test_button_color', 'red');

          await EngineBugTracking.log('New checkout flow accessed', level: 'info', attributes: {
            'feature': 'new_checkout',
            'variant': 'v2',
            'user_segment': 'premium',
          });

          await EngineBugTracking.recordError(
            Exception('Checkout validation failed'),
            StackTrace.current,
            reason: 'Feature flag related error',
            data: {
              'feature': 'new_checkout',
              'enabled': true,
              'variant': 'v2',
              'step': 'address_validation',
            },
          );
        }(), completes);
      });

      test('should handle performance monitoring integration', () async {
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('app_launch_time_ms', 2500);
          await EngineBugTracking.setCustomKey('memory_usage_mb', 128);
          await EngineBugTracking.setCustomKey('cpu_usage_percent', 25);

          await EngineBugTracking.log('Performance baseline established', level: 'info', attributes: {
            'launch_time': 2500,
            'memory': 128,
            'cpu': 25,
          });

          await EngineBugTracking.recordError(
            Exception('Performance threshold exceeded'),
            StackTrace.current,
            isFatal: false,
            reason: 'App performance degraded',
            data: {
              'metric': 'response_time',
              'current_value_ms': 5000,
              'threshold_ms': 2000,
              'operation': 'data_fetch',
              'endpoint': '/api/products',
            },
          );

          await EngineBugTracking.log('Performance optimized', level: 'info', attributes: {
            'new_response_time': 1800,
            'optimization': 'caching_enabled',
          });
        }(), completes);
      });
    });

    group('Error Handling and Edge Cases', () {
      test('should handle null and undefined values gracefully', () async {
        await expectLater(() async {
          await EngineBugTracking.log('');
          await EngineBugTracking.setCustomKey('null_test', 'null');
          await EngineBugTracking.setUserIdentifier('', '', '');
        }(), completes);
      });

      test('should handle very large data volumes', () async {
        final largeData = <String, dynamic>{};
        for (var i = 0; i < 100; i++) {
          largeData['field_$i'] = 'x' * 1000;
        }

        await expectLater(() async {
          await EngineBugTracking.recordError(
            Exception('Large data error'),
            StackTrace.current,
            data: largeData,
          );
        }(), completes);
      });

      test('should maintain performance under load', () async {
        final stopwatch = Stopwatch()..start();

        final futures = <Future>[];
        for (var i = 0; i < 100; i++) {
          futures.addAll([
            EngineBugTracking.log('Load test $i', level: 'info'),
            EngineBugTracking.setCustomKey('load_test_$i', i),
            if (i % 10 == 0)
              EngineBugTracking.recordError(
                Exception('Load test error $i'),
                StackTrace.current,
                data: {'iteration': i},
              ),
          ]);
        }

        await Future.wait(futures);
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(10000));
      });
    });

    group('Model Integration', () {
      test('should work with default model', () async {
        final defaultModel = EngineBugTrackingModelDefault();

        expect(defaultModel.crashlyticsConfig.enabled, isFalse);
        expect(defaultModel.faroConfig.enabled, isFalse);
      });

      test('should validate current configuration', () async {
        expect(EngineBugTracking.isFaroEnabled, isFalse);
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
      });
    });

    group('Service Integration Coverage', () {
      test('should work with services disabled', () async {
        await expectLater(() async {
          await EngineBugTracking.setUserIdentifier('disabled_services_user', 'disabled@example.com', 'Disabled Services User');
          await EngineBugTracking.log(
            'Log with services disabled',
            level: 'info',
            attributes: {'service': 'disabled'},
            stackTrace: StackTrace.current,
          );
          await EngineBugTracking.recordError(
            Exception('Error with services disabled'),
            StackTrace.current,
            reason: 'Testing without services',
            data: {'service': 'disabled'},
          );
        }(), completes);
      });

      test('should work with disabled services for Flutter errors', () async {
        final errorDetails = FlutterErrorDetails(
          exception: Exception('Flutter error with services disabled'),
          stack: StackTrace.current,
          library: 'test_library',
          context: ErrorDescription('Disabled services context'),
        );

        await expectLater(() async {
          await EngineBugTracking.recordFlutterError(errorDetails);
        }(), completes);
      });

      test('should handle logging when services are disabled', () async {
        await expectLater(() async {
          await EngineBugTracking.log('Log when disabled', level: 'info', attributes: {
            'test_disabled': true,
            'should_complete': true,
          });
        }(), completes);
      });

      test('should handle operations when services are disabled', () async {
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('disabled_test', true);
          await EngineBugTracking.recordError(
            Exception('Error when disabled'),
            StackTrace.current,
            isFatal: false,
            reason: 'Testing disabled services',
          );
        }(), completes);
      });
    });

    group('Method Parameter Coverage', () {
      test('should cover all setUserIdentifier parameter combinations', () async {
        await expectLater(() async {
          // Test new 3-parameter signature
          await EngineBugTracking.setUserIdentifier('test_id', 'test@email.com', 'Test Name');
          await EngineBugTracking.setUserIdentifier('test_id_2', '', 'Test Name 2');
          await EngineBugTracking.setUserIdentifier('test_id_3', 'test3@email.com', '');
          await EngineBugTracking.setUserIdentifier('test_id_4', '', '');
        }(), completes);
      });

      test('should cover all log parameter combinations', () async {
        await expectLater(() async {
          // Test all parameter combinations
          await EngineBugTracking.log('message only');
          await EngineBugTracking.log('with level', level: 'debug');
          await EngineBugTracking.log('with attributes', attributes: {'key': 'value'});
          await EngineBugTracking.log('with stacktrace', stackTrace: StackTrace.current);
          await EngineBugTracking.log('with all params', level: 'error', attributes: {'all': 'params'}, stackTrace: StackTrace.current);
        }(), completes);
      });

      test('should cover all recordError parameter combinations', () async {
        await expectLater(() async {
          // Basic error
          await EngineBugTracking.recordError(Exception('basic'), StackTrace.current);

          // With fatal flag
          await EngineBugTracking.recordError(Exception('fatal'), StackTrace.current, isFatal: true);

          // With reason
          await EngineBugTracking.recordError(Exception('with reason'), StackTrace.current, reason: 'test reason');

          // With data
          await EngineBugTracking.recordError(Exception('with data'), StackTrace.current, data: {'test': 'data'});

          // With information
          await EngineBugTracking.recordError(Exception('with info'), StackTrace.current, information: ['info1', 'info2']);

          // With all parameters
          await EngineBugTracking.recordError(
            Exception('comprehensive'),
            StackTrace.current,
            isFatal: false,
            reason: 'comprehensive test',
            data: {'comprehensive': true},
            information: ['comprehensive test'],
          );
        }(), completes);
      });
    });

    group('Edge Cases and Error Conditions', () {
      test('should handle null-like values gracefully', () async {
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('null_string', '');
          await EngineBugTracking.setCustomKey('zero_number', 0);
          await EngineBugTracking.setCustomKey('false_boolean', false);
          await EngineBugTracking.log('', level: '', attributes: {});
          await EngineBugTracking.setUserIdentifier('', '', '');
        }(), completes);
      });

      test('should handle special characters in data', () async {
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('special_chars', 'åéîøü@#\$%^&*()');
          await EngineBugTracking.log('Special chars: åéîøü@#\$%^&*()');
          await EngineBugTracking.setUserIdentifier('user@#\$%', 'email@domain.com', 'Name åéîøü');
        }(), completes);
      });

      test('should handle very long strings', () async {
        final longString = 'x' * 10000;
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('long_string', longString);
          await EngineBugTracking.log(longString);
          await EngineBugTracking.setUserIdentifier(longString, 'test@example.com', longString);
        }(), completes);
      });

      test('should handle deeply nested data structures', () async {
        Map<String, dynamic> createNestedMap(final int depth) {
          if (depth <= 0) {
            return {'value': 'leaf'};
          }
          return {'nested': createNestedMap(depth - 1), 'depth': depth};
        }

        final deepData = createNestedMap(10);
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('deep_nested', deepData);
          await EngineBugTracking.recordError(
            Exception('Deep nested error'),
            StackTrace.current,
            data: deepData,
          );
        }(), completes);
      });
    });
  });
}
