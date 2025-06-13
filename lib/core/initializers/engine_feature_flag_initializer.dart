import 'dart:async';

import 'package:engine/lib.dart';

class EngineFeatureFlagInitializer implements IEngineBaseInitializer<EngineFeatureFlagModel> {
  EngineFeatureFlagInitializer(this.params);

  @override
  final EngineFeatureFlagModel? params;

  @override
  final int priority = 3;

  @override
  FutureOr<void> onInit() async {
    if (params == null) {
      EngineLog.error('FeatureFlagInitializer: params is null or not EngineFeatureFlagModel');
      return;
    }

    await EngineFeatureFlag().init(params!);
    return;
  }

  @override
  FutureOr<void> onDispose() {
    EngineFeatureFlag().dispose();
  }
}
