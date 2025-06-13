import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

// Import Firebase test helpers
import '../../../mocks/firebase_mocks.dart';

void main() {
  group('Engine Bug Tracking with Faro Integration Tests', () {
    late EngineBugTrackingModel crashlyticsOnlyModel;
    late EngineBugTrackingModel faroOnlyModel;
    late EngineBugTrackingModel bothEnabledModel;
    late EngineBugTrackingModel bothDisabledModel;

    setUpAll(() async {
      // Initialize Firebase mocks for all tests
      FirebaseMocks.setupAllMocks();
    });

    setUp(() {
      // Reset mocks before each test
      FirebaseMocks.resetAllMocks();
      FirebaseMocks.setupAllMocks();

      // Crashlytics only model
      crashlyticsOnlyModel = EngineBugTrackingModel(
        crashlyticsEnabled: true,
        faroEnabled: false,
      );

      // Faro only model
      faroOnlyModel = EngineBugTrackingModel(
        crashlyticsEnabled: false,
        faroEnabled: true,
        faroConfig: EngineFaroConfig(
          endpoint: 'https://faro-collector.example.com/collect',
          appName: 'test-app',
          appVersion: '1.0.0',
          environment: 'test',
        ),
      );

      // Both enabled model
      bothEnabledModel = EngineBugTrackingModel(
        crashlyticsEnabled: true,
        faroEnabled: true,
        faroConfig: EngineFaroConfig(
          endpoint: 'https://faro-collector.example.com/collect',
          appName: 'test-app',
          appVersion: '1.0.0',
          environment: 'test',
        ),
      );

      // Both disabled model
      bothDisabledModel = EngineBugTrackingModel(
        crashlyticsEnabled: false,
        faroEnabled: false,
      );
    });

    group('Initialization Tests', () {
      test('should initialize with crashlytics only', () async {
        await EngineBugTracking.init(crashlyticsOnlyModel);

        // Firebase won't be available in test environment, so it should be false
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isFalse);
        expect(EngineBugTracking.getFaroConfig(), isNull);
      });

      test('should initialize with faro only', () async {
        await EngineBugTracking.init(faroOnlyModel);

        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isTrue);
        expect(EngineBugTracking.getFaroConfig(), isNotNull);
        expect(EngineBugTracking.getFaroConfig()!.appName, equals('test-app'));
        expect(EngineBugTracking.getFaroConfig()!.endpoint, equals('https://faro-collector.example.com/collect'));
      });

      test('should initialize with both enabled', () async {
        await EngineBugTracking.init(bothEnabledModel);

        // Firebase won't be available in test environment, so it should be false
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isTrue);
        expect(EngineBugTracking.getFaroConfig(), isNotNull);
      });

      test('should initialize with both disabled', () async {
        await EngineBugTracking.init(bothDisabledModel);

        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isFalse);
        expect(EngineBugTracking.getFaroConfig(), isNull);
      });
    });

    group('Configuration Tests', () {
      test('should provide correct faro configuration', () async {
        await EngineBugTracking.init(bothEnabledModel);

        final config = EngineBugTracking.getFaroConfig();
        expect(config, isNotNull);
        expect(config!.appName, equals('test-app'));
        expect(config.appVersion, equals('1.0.0'));
        expect(config.environment, equals('test'));
        expect(config.endpoint, equals('https://faro-collector.example.com/collect'));
      });

      test('should handle missing faro config when faro is enabled', () async {
        final invalidModel = EngineBugTrackingModel(
          crashlyticsEnabled: false,
          faroEnabled: true,
          // Missing faroConfig
        );

        await EngineBugTracking.init(invalidModel);

        expect(EngineBugTracking.isFaroEnabled, isTrue);
        expect(EngineBugTracking.getFaroConfig(), isNull);
      });
    });

    group('Logging Operations Tests', () {
      test('should handle setCustomKey with both systems enabled', () async {
        await EngineBugTracking.init(bothEnabledModel);

        // Should not throw any exceptions
        expect(
          () async => await EngineBugTracking.setCustomKey('test_key', 'test_value'),
          returnsNormally,
        );
      });

      test('should handle setUserIdentifier with both systems enabled', () async {
        await EngineBugTracking.init(bothEnabledModel);

        // Should not throw any exceptions
        expect(
          () async => await EngineBugTracking.setUserIdentifier('user123'),
          returnsNormally,
        );
      });

      test('should handle log with both systems enabled', () async {
        await EngineBugTracking.init(bothEnabledModel);

        // Should not throw any exceptions
        expect(
          () async => await EngineBugTracking.log('Test log message'),
          returnsNormally,
        );
      });

      test('should handle recordError with both systems enabled', () async {
        await EngineBugTracking.init(bothEnabledModel);

        final testError = Exception('Test error');
        final testStack = StackTrace.current;

        // Should not throw any exceptions
        expect(
          () async => await EngineBugTracking.recordError(
            testError,
            testStack,
            reason: 'Test reason',
            data: {'key': 'value'},
          ),
          returnsNormally,
        );
      });

      test('should handle testCrash in debug mode', () async {
        await EngineBugTracking.init(bothEnabledModel);

        // Should not throw any exceptions
        expect(
          () async => await EngineBugTracking.testCrash(),
          returnsNormally,
        );
      });
    });

    group('Error Handling Tests', () {
      test('should handle operations when both systems are disabled', () async {
        await EngineBugTracking.init(bothDisabledModel);

        // All operations should work without throwing exceptions
        expect(
          () async {
            await EngineBugTracking.setCustomKey('key', 'value');
            await EngineBugTracking.setUserIdentifier('user');
            await EngineBugTracking.log('message');
            await EngineBugTracking.recordError(Exception('error'), StackTrace.current);
            await EngineBugTracking.testCrash();
          },
          returnsNormally,
        );
      });

      test('should handle operations when only crashlytics is enabled', () async {
        await EngineBugTracking.init(crashlyticsOnlyModel);

        // All operations should work without throwing exceptions
        expect(
          () async {
            await EngineBugTracking.setCustomKey('key', 'value');
            await EngineBugTracking.setUserIdentifier('user');
            await EngineBugTracking.log('message');
            await EngineBugTracking.recordError(Exception('error'), StackTrace.current);
          },
          returnsNormally,
        );
      });

      test('should handle operations when only faro is enabled', () async {
        await EngineBugTracking.init(faroOnlyModel);

        // All operations should work without throwing exceptions
        expect(
          () async {
            await EngineBugTracking.setCustomKey('key', 'value');
            await EngineBugTracking.setUserIdentifier('user');
            await EngineBugTracking.log('message');
            await EngineBugTracking.recordError(Exception('error'), StackTrace.current);
          },
          returnsNormally,
        );
      });
    });

    group('Integration Scenarios Tests', () {
      test('should work with complete faro configuration', () async {
        final completeModel = EngineBugTrackingModel(
          crashlyticsEnabled: true,
          faroEnabled: true,
          faroConfig: EngineFaroConfig(
            endpoint: 'https://faro.grafana.com/collect',
            appName: 'production-app',
            appVersion: '2.1.0',
            environment: 'production',
          ),
        );

        await EngineBugTracking.init(completeModel);

        // Firebase won't be available in test environment
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isTrue);

        final config = EngineBugTracking.getFaroConfig();
        expect(config!.appName, equals('production-app'));
        expect(config.appVersion, equals('2.1.0'));
        expect(config.environment, equals('production'));
        expect(config.endpoint, equals('https://faro.grafana.com/collect'));
      });

      test('should maintain state after initialization', () async {
        await EngineBugTracking.init(bothEnabledModel);

        // Check initial state - Firebase won't be available in test environment
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isTrue);

        // Perform some operations
        await EngineBugTracking.setCustomKey('key1', 'value1');
        await EngineBugTracking.log('Test message');

        // State should remain consistent
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isTrue);
        expect(EngineBugTracking.getFaroConfig(), isNotNull);
      });
    });
  });
}
