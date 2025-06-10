import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(final FutureOr<void> Function() testMain) async {
  setUpAll(() async {
    // Configuração global para todos os testes
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDownAll(() async {
    // Limpeza global após todos os testes
  });

  await testMain();
}
