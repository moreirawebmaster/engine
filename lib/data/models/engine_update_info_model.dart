import 'package:engine/lib.dart';

class EngineUpdateInfoModel {
  final String env;
  final String url;
  final String version;
  final int versionCode;
  final bool forceAll;

  EngineUpdateInfoModel({
    required this.env,
    required this.url,
    required this.version,
    required this.versionCode,
    required this.forceAll,
  });

  factory EngineUpdateInfoModel.fromMap(final Map<String, dynamic> map) => EngineUpdateInfoModel(
        env: map['env'] ?? '',
        url: map['url_update'] ?? '',
        version: map['version'] ?? '',
        versionCode: map['version_code'] ?? 0,
        forceAll: map['force_all'] ?? false,
      );

  bool shouldForceUpdate(final int currentBuildCode) {
    if (EngineEnvironmentTypeEnum.fromName(env) != EngineAppSettings().env) {
      EngineLog.debug('UpdateInfoModel: env is not the same as the current environment');
      return false;
    }

    if (versionCode <= currentBuildCode) {
      EngineLog.debug('UpdateInfoModel: versionCode is not greater than the current build code');
      return false;
    }

    if (forceAll) {
      EngineLog.debug('UpdateInfoModel: forceAll is true');
      return true;
    }

    EngineLog.debug('UpdateInfoModel: versionCode is greater than the current build code');
    return false;
  }
}
