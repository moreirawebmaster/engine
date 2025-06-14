import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

// Import Firebase test helpers
import '../../../mocks/firebase_mocks.dart';

void main() {
  group('Engine Bug Tracking with Faro Integration Tests', () {
    late EngineBugTrackingModel testModel;
    var isInitialized = false;

    setUpAll(() async {
      // Initialize Firebase mocks for all tests
      FirebaseMocks.setupAllMocks();

      // Initialize once with disabled services to avoid Firebase dependencies and late final issues
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

    setUp(() {
      // Reset mocks before each test
      FirebaseMocks.resetAllMocks();
      FirebaseMocks.setupAllMocks();
    });

    group('Initialization Tests', () {
      test('should initialize with services disabled', () async {
        // Services are disabled in test environment to avoid Firebase dependencies
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isFalse);
      });

      test('should handle different model configurations', () async {
        // Test that different models can be created (even if not initialized due to singleton)
        final crashlyticsOnlyModel = EngineBugTrackingModel(
          crashlyticsConfig: EngineCrashlyticsConfig(enabled: true),
          faroConfig: EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        final faroOnlyModel = EngineBugTrackingModel(
          crashlyticsConfig: EngineCrashlyticsConfig(enabled: false),
          faroConfig: EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro-collector.example.com/collect',
            appName: 'test-app',
            appVersion: '1.0.0',
            environment: 'test',
            apiKey: 'test-api-key',
          ),
        );

        final bothEnabledModel = EngineBugTrackingModel(
          crashlyticsConfig: EngineCrashlyticsConfig(enabled: true),
          faroConfig: EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro-collector.example.com/collect',
            appName: 'test-app',
            appVersion: '1.0.0',
            environment: 'test',
            apiKey: 'test-api-key',
          ),
        );

        // Models should be created successfully
        expect(crashlyticsOnlyModel, isNotNull);
        expect(faroOnlyModel, isNotNull);
        expect(bothEnabledModel, isNotNull);
        expect(crashlyticsOnlyModel.crashlyticsConfig.enabled, isTrue);
        expect(faroOnlyModel.faroConfig.enabled, isTrue);
        expect(bothEnabledModel.crashlyticsConfig.enabled, isTrue);
        expect(bothEnabledModel.faroConfig.enabled, isTrue);
      });

      test('should validate faro configuration properties', () async {
        final faroConfig = EngineFaroConfig(
          enabled: true,
          endpoint: 'https://faro-collector.example.com/collect',
          appName: 'test-app',
          appVersion: '1.0.0',
          environment: 'test',
          apiKey: 'test-api-key',
        );

        expect(faroConfig.enabled, isTrue);
        expect(faroConfig.endpoint, equals('https://faro-collector.example.com/collect'));
        expect(faroConfig.appName, equals('test-app'));
        expect(faroConfig.appVersion, equals('1.0.0'));
        expect(faroConfig.environment, equals('test'));
        expect(faroConfig.apiKey, equals('test-api-key'));
      });

      test('should validate crashlytics configuration properties', () async {
        final crashlyticsConfig = EngineCrashlyticsConfig(enabled: true);
        expect(crashlyticsConfig.enabled, isTrue);

        final disabledConfig = EngineCrashlyticsConfig(enabled: false);
        expect(disabledConfig.enabled, isFalse);
      });
    });

    group('Configuration Tests', () {
      test('should handle model with different configurations', () async {
        final completeModel = EngineBugTrackingModel(
          crashlyticsConfig: EngineCrashlyticsConfig(enabled: true),
          faroConfig: EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro.grafana.com/collect',
            appName: 'production-app',
            appVersion: '2.1.0',
            environment: 'production',
            apiKey: 'production-api-key',
          ),
        );

        expect(completeModel.crashlyticsConfig.enabled, isTrue);
        expect(completeModel.faroConfig.enabled, isTrue);
        expect(completeModel.faroConfig.appName, equals('production-app'));
        expect(completeModel.faroConfig.appVersion, equals('2.1.0'));
        expect(completeModel.faroConfig.environment, equals('production'));
        expect(completeModel.faroConfig.endpoint, equals('https://faro.grafana.com/collect'));
        expect(completeModel.faroConfig.apiKey, equals('production-api-key'));
      });

      test('should handle empty configuration values', () async {
        final emptyModel = EngineBugTrackingModel(
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

        expect(emptyModel.crashlyticsConfig.enabled, isFalse);
        expect(emptyModel.faroConfig.enabled, isFalse);
        expect(emptyModel.faroConfig.endpoint, isEmpty);
        expect(emptyModel.faroConfig.appName, isEmpty);
        expect(emptyModel.faroConfig.appVersion, isEmpty);
        expect(emptyModel.faroConfig.environment, isEmpty);
        expect(emptyModel.faroConfig.apiKey, isEmpty);
      });
    });

    group('Logging Operations Tests', () {
      test('should handle setCustomKey operations', () async {
        // Should not throw any exceptions
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('test_key', 'test_value');
          await EngineBugTracking.setCustomKey('faro_test', 'faro_value');
          await EngineBugTracking.setCustomKey('integration_test', {'nested': 'data'});
        }(), completes);
      });

      test('should handle setUserIdentifier operations', () async {
        // Should not throw any exceptions
        await expectLater(() async {
          await EngineBugTracking.setUserIdentifier('user123', 'user@example.com', 'Test User');
          await EngineBugTracking.setUserIdentifier('faro_user', 'faro@example.com', 'Faro User');
          await EngineBugTracking.setUserIdentifier('integration_user', 'integration@example.com', 'Integration User');
        }(), completes);
      });

      test('should handle log operations', () async {
        // Should not throw any exceptions
        await expectLater(() async {
          await EngineBugTracking.log('Test log message');
          await EngineBugTracking.log('Faro integration log', level: 'info');
          await EngineBugTracking.log('Complex log', level: 'debug', attributes: {'test': 'value'});
        }(), completes);
      });

      test('should handle recordError operations', () async {
        final testError = Exception('Test error');
        final testStack = StackTrace.current;

        // Should not throw any exceptions
        await expectLater(() async {
          await EngineBugTracking.recordError(
            testError,
            testStack,
            reason: 'Test reason',
            data: {'key': 'value'},
          );
          await EngineBugTracking.recordError(
            StateError('State error test'),
            StackTrace.current,
            reason: 'Faro integration test',
            isFatal: false,
          );
        }(), completes);
      });

      test('should handle testCrash in debug mode', () async {
        // Should not throw any exceptions
        await expectLater(() async {
          await EngineBugTracking.testCrash();
        }(), completes);
      });
    });

    group('Error Handling Tests', () {
      test('should handle all operations gracefully when services are disabled', () async {
        // All operations should work without throwing exceptions
        await expectLater(() async {
          await EngineBugTracking.setCustomKey('key', 'value');
          await EngineBugTracking.setUserIdentifier('user', 'user@example.com', 'User Name');
          await EngineBugTracking.log('message');
          await EngineBugTracking.recordError(Exception('error'), StackTrace.current);
          await EngineBugTracking.testCrash();
        }(), completes);
      });

      test('should handle concurrent operations', () async {
        final futures = <Future<void>>[];

        for (var i = 0; i < 5; i++) {
          futures.addAll([
            EngineBugTracking.setCustomKey('concurrent_key_$i', 'value_$i'),
            EngineBugTracking.setUserIdentifier('user_$i', 'user$i@example.com', 'User $i'),
            EngineBugTracking.log('Concurrent log $i'),
            EngineBugTracking.recordError(Exception('Concurrent error $i'), StackTrace.current),
          ]);
        }

        await expectLater(Future.wait(futures), completes);
      });

      test('should handle edge cases', () async {
        await expectLater(() async {
          // Empty values
          await EngineBugTracking.setCustomKey('', '');
          await EngineBugTracking.setUserIdentifier('', '', '');
          await EngineBugTracking.log('');

          // Special characters
          await EngineBugTracking.setCustomKey('special_chars', 'special@#\$%^&*()');
          await EngineBugTracking.setUserIdentifier('user_special', 'test+special@example.com', 'User with Special Chars');
          await EngineBugTracking.log('Log with special chars: special@#\$%^&*()');

          // Large data
          final largeData = List.generate(1000, (final index) => 'item_$index').join(',');
          await EngineBugTracking.setCustomKey('large_data', largeData);
          await EngineBugTracking.log('Large log: $largeData');
        }(), completes);
      });
    });

    group('Integration Scenarios Tests', () {
      test('should work with realistic application scenarios', () async {
        await expectLater(() async {
          // E-commerce scenario
          await EngineBugTracking.setUserIdentifier('customer_123', 'customer@shop.com', 'John Doe');
          await EngineBugTracking.setCustomKey('cart_items', 3);
          await EngineBugTracking.setCustomKey('total_amount', 99.99);
          await EngineBugTracking.log('User added item to cart');

          // Error during checkout
          await EngineBugTracking.recordError(
            Exception('Payment processing failed'),
            StackTrace.current,
            reason: 'Checkout error',
            data: {'payment_method': 'credit_card', 'amount': 99.99},
          );

          // Recovery
          await EngineBugTracking.log('User retried payment');
          await EngineBugTracking.setCustomKey('payment_retry_count', 1);
        }(), completes);
      });

      test('should handle session tracking scenario', () async {
        await expectLater(() async {
          // Session start
          await EngineBugTracking.setUserIdentifier('session_user', 'session@example.com', 'Session User');
          await EngineBugTracking.setCustomKey('session_id', 'sess_${DateTime.now().millisecondsSinceEpoch}');
          await EngineBugTracking.setCustomKey('app_version', '2.1.0');
          await EngineBugTracking.setCustomKey('platform', 'flutter');
          await EngineBugTracking.log('Session started');

          // User activities
          final activities = ['login', 'dashboard_view', 'profile_edit', 'settings_change', 'logout'];
          for (final activity in activities) {
            await EngineBugTracking.log('User activity: $activity');
            await EngineBugTracking.setCustomKey('last_activity', activity);
            await EngineBugTracking.setCustomKey('activity_timestamp', DateTime.now().toIso8601String());
          }

          // Session end
          await EngineBugTracking.log('Session ended');
          await EngineBugTracking.setCustomKey('session_duration', '1800'); // 30 minutes
        }(), completes);
      });

      test('should maintain consistent state throughout operations', () async {
        // Check initial state
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isFalse);

        // Perform operations
        await EngineBugTracking.setCustomKey('state_test', 'value');
        await EngineBugTracking.log('State consistency test');

        // State should remain consistent
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isFalse);
      });
    });
  });
}
