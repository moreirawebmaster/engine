import 'package:engine/lib.dart';

/// A class that provides settings for the Engine app.
///
/// It provides the following properties:
///
/// * [env]: The current environment of the app.
/// * [isDev]: A boolean indicating whether the app is in a development environment.
/// * [tokenApiUrl]: The URL of the token API.
/// * [refreshTokenApiUrl]: The URL of the refresh token API.
class EngineAppSettings {
  factory EngineAppSettings() => _i ?? EngineAppSettings._();

  EngineAppSettings._() {
    _initEnv();
    _i = this;
  }

  static EngineAppSettings? _i;
  late EngineEnvironment env;
  late bool isDev;
  late String tokenApiUrl;
  late String refreshTokenApiUrl;

  /// Initializes the environment of the app.
  void _initEnv() {
    env = EngineEnvironment.fromEnv(const String.fromEnvironment('env', defaultValue: 'dev'));
    tokenApiUrl = const String.fromEnvironment('tokenApiUrl');
    refreshTokenApiUrl = const String.fromEnvironment('refreshTokenApiUrl');
    isDev = env == EngineEnvironment.dev || env == EngineEnvironment.intg;
  }
}
