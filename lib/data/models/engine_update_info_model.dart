import 'package:engine/data/data.dart';

class EngineUpdateInfoModel {
  final String env;
  final String url;
  final String version;
  final int versionCode;
  final List<String> rolesUpdate;
  final List<int> usersIds;
  final List<int> virtualStoresIds;
  final bool forceAll;

  EngineUpdateInfoModel({
    required this.env,
    required this.url,
    required this.version,
    required this.versionCode,
    required this.rolesUpdate,
    required this.usersIds,
    required this.virtualStoresIds,
    required this.forceAll,
  });

  factory EngineUpdateInfoModel.fromJson(final Map<String, dynamic> json) => EngineUpdateInfoModel(
        env: json['env'] ?? '',
        url: json['url_update'] ?? '',
        version: json['version'] ?? '',
        versionCode: json['version_code'] ?? 0,
        rolesUpdate: List<String>.from(json['roles_update'] ?? []),
        usersIds: List<int>.from(json['users_ids'] ?? []),
        virtualStoresIds: List<int>.from(json['virtual_stores_ids'] ?? []),
        forceAll: json['force_all'] ?? false,
      );

  bool shouldForceUpdate({
    required final int currentBuildCode,
    final int userId = 0,
    final List<String> roles = const [],
    final int virtualStoreId = 0,
  }) {
    final currentEnv = EngineEnvironment.fromEnv(const String.fromEnvironment('env', defaultValue: 'prd'));

    if (EngineEnvironment.fromEnv(env) != currentEnv) {
      return false;
    }

    if (versionCode <= currentBuildCode) {
      return false;
    }

    if (forceAll) {
      return true;
    }

    if (rolesUpdate.any((final role) => roles.contains(role))) {
      return true;
    }

    if (usersIds.contains(userId)) {
      return true;
    }

    if (virtualStoreId > 0 && virtualStoresIds.contains(virtualStoreId)) {
      return true;
    }

    return false;
  }
}
