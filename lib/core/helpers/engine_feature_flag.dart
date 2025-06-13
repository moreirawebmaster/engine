import 'dart:convert';

import 'package:engine/lib.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class EngineFeatureFlag {
  EngineFeatureFlag._() {
    EngineLog.debug('EngineFeatureFlag initialized');
    _i = this;
  }

  factory EngineFeatureFlag() => _i ??= EngineFeatureFlag._();

  static EngineFeatureFlag? _i;
  static FirebaseRemoteConfig? _remoteConfig;
  static late EngineFeatureFlagModel _engineFeatureFlagModel;

  Future<void> init(final EngineFeatureFlagModel model) async {
    _engineFeatureFlagModel = model;

    if (_engineFeatureFlagModel.firebaseRemoteConfigEnabled) {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig?.setConfigSettings(RemoteConfigSettings(fetchTimeout: 5.seconds, minimumFetchInterval: 0.seconds));
      await _remoteConfig?.fetchAndActivate();
    }
  }

  String getString(final String key) => _remoteConfig?.getString(key) ?? '';
  bool getBool(final String key) => _remoteConfig?.getBool(key) ?? false;
  int getInt(final String key) => _remoteConfig?.getInt(key) ?? 0;
  double getDouble(final String key) => _remoteConfig?.getDouble(key) ?? 0.0;

  T getObject<T>(final String key, final T Function(Map<String, dynamic>) fromMap) {
    final raw = getString(key);
    final decoded = jsonDecode(raw);
    return fromMap(decoded);
  }

  Future<bool> shouldForceUpdate() async {
    final model = getObject(EngineConstant.appUpdateKey, EngineUpdateInfoModel.fromMap);

    final packageInfo = await PackageInfo.fromPlatform();
    final localVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

    return model.shouldForceUpdate(localVersionCode);
  }

  void dispose() {
    _remoteConfig = null;
  }
}
