import 'package:engine/lib.dart';

class EngineInitializer {
  EngineInitializer({required this.initializers});

  final List<IEngineBaseInitializer> initializers;

  Future<void> init() async {
    initializers.sort((final a, final b) => b.priority.compareTo(a.priority));
    for (final initializer in initializers) {
      await initializer.onInit();
    }
  }
}
