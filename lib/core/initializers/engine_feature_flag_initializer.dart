import 'dart:async';

import 'package:engine/lib.dart';

class EngineFeatureFlagInitializer extends IEngineBaseInitializer<dynamic> {
  EngineFeatureFlagInitializer(super.params, super.priority);

  @override
  FutureOr<void> onInit() async {
    await EngineFeatureFlag().init();
    return;
  }
}
