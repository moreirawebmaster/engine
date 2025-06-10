abstract class IEngineLocalStorageRepository {
  static const String storageName = 'local_storage';
  bool exists(final String key);
  Future<void> setObject<T>(final String key, final T data);
  Future<void> setString(final String key, final String data);
  Future<void> setJson(final String key, final dynamic data);
  T? getObject<T, TMap>(final String key, {final T Function(TMap)? fromMap});
  String getString(final String key);
  dynamic getJson(final String key);
  Future<void> remove(final String key);
  Future<void> removeAll(final List<String> keys);
  Future<void> clearAll();
}
