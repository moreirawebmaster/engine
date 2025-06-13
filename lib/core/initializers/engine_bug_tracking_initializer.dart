import 'dart:async';

import 'package:engine/lib.dart';

class EngineBugTrackingInitializer implements IEngineBaseInitializer<EngineBugTrackingModel> {
  EngineBugTrackingInitializer(this.params);

  @override
  final EngineBugTrackingModel? params;

  @override
  final int priority = 1;

  @override
  FutureOr<void> onInit() async {
    if (params == null) {
      EngineLog.error('BugTrackingInitializer: params is null or not EngineBugTrackingModel');
      return;
    }

    try {
      await EngineBugTracking.initCrashReporting(params!);
    } catch (e, stack) {
      EngineLog.error('Failed to initialize initCrashReporting: ${e.toString()}', error: e, stackTrace: stack);
    }
  }

  @override
  FutureOr<void> onDispose() {}
}
