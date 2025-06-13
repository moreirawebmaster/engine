class EngineBugTrackingModel {
  EngineBugTrackingModel({
    required this.crashlyticsConfig,
    required this.faroConfig,
  });

  final CrashlyticsConfig crashlyticsConfig;
  final EngineFaroConfig faroConfig;
}

class EngineBugTrackingConfig {
  EngineBugTrackingConfig({required this.enabled});

  final bool enabled;
}

class CrashlyticsConfig extends EngineBugTrackingConfig {
  CrashlyticsConfig({required super.enabled});
}

class EngineFaroConfig extends EngineBugTrackingConfig {
  EngineFaroConfig({
    required this.endpoint,
    required this.appName,
    required this.appVersion,
    required this.environment,
    required this.apiKey,
    required super.enabled,
  });

  final String endpoint;
  final String appName;
  final String appVersion;
  final String environment;
  final String apiKey;
}

class EngineBugTrackingModelDefault implements EngineBugTrackingModel {
  @override
  CrashlyticsConfig get crashlyticsConfig => CrashlyticsConfig(enabled: false);

  @override
  EngineFaroConfig get faroConfig => EngineFaroConfig(enabled: false, endpoint: '', appName: '', appVersion: '', environment: '', apiKey: '');
}
