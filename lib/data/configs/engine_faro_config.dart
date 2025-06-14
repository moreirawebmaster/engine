import 'package:engine/lib.dart';

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
