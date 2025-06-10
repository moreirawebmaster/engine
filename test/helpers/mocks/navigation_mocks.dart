import 'package:mockito/mockito.dart';

class MockEngineLog extends Mock {
  static void debug(final String message, {final dynamic data, final Object? error, final StackTrace? stackTrace}) {
    // Mock implementation - no actual logging in tests
  }
}
