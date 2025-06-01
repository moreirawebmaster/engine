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
  static final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: 5.seconds, minimumFetchInterval: 0.seconds));
    await _remoteConfig.fetchAndActivate();
  }

  String getString(final String key) => _remoteConfig.getString(key);
  bool getBool(final String key) => _remoteConfig.getBool(key);
  int getInt(final String key) => _remoteConfig.getInt(key);
  double getDouble(final String key) => _remoteConfig.getDouble(key);

  T getObject<T>(final String key, final T Function(Map<String, dynamic>) fromMap) {
    final raw = getString(key);
    final decoded = jsonDecode(raw);
    return fromMap(decoded);
  }

  Future<bool> shouldForceUpdate() async {
    final updateJson = getString('APP_UPDATE');

    if (updateJson.isEmpty) {
      return false;
    }

    final decoded = jsonDecode(updateJson);
    final model = EngineUpdateInfoModel.fromJson(decoded);

    final packageInfo = await PackageInfo.fromPlatform();
    final localVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

    return model.shouldForceUpdate(
      currentBuildCode: localVersionCode,
    );
  }
}
