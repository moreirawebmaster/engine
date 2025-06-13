import 'dart:async';

import 'package:engine/lib.dart';

class EngineAnalyticsInitializer implements IEngineBaseInitializer<EngineAnalyticsModel> {
  EngineAnalyticsInitializer(this.params);

  @override
  final EngineAnalyticsModel? params;

  @override
  final int priority = 2;

  @override
  FutureOr<void> onInit() async {
    if (params == null) {
      EngineLog.error('AnalyticsInitializer: params is null or not EngineAnalyticsModel');
      return;
    }

    try {
      await EngineAnalytics.init(params!);
    } catch (e, stack) {
      EngineLog.error('Failed to initialize Analytics: ${e.toString()}', error: e, stackTrace: stack);
    }
  }

  @override
  FutureOr<void> onDispose() {}
}
