import 'package:engine/lib.dart';

class EngineBugTrackingModel {
  EngineBugTrackingModel({
    required this.crashlyticsConfig,
    required this.faroConfig,
  });

  final EngineCrashlyticsConfig crashlyticsConfig;
  final EngineFaroConfig faroConfig;
}

class EngineBugTrackingModelDefault implements EngineBugTrackingModel {
  @override
  EngineCrashlyticsConfig get crashlyticsConfig => EngineCrashlyticsConfig(enabled: false);

  @override
  EngineFaroConfig get faroConfig => EngineFaroConfig(enabled: false, endpoint: '', appName: '', appVersion: '', environment: '', apiKey: '');
}
