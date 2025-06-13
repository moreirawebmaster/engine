import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(final FutureOr<void> Function() testMain) async {
  setUpAll(() async {
    // Global setup for all tests
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDownAll(() async {
    // Global cleanup after all tests
  });

  await testMain();
}
