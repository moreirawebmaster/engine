import 'dart:convert';

import 'package:engine/lib.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageGetStorageRepository implements IEngineLocalStorageRepository {
  LocalStorageGetStorageRepository(final GetStorage storage) {
    _storage = storage;
  }

  late final GetStorage _storage;

  @override
  T? getObject<T, TMap>(final String key, {final T Function(TMap)? fromMap}) {
    if (exists(key)) {
      final typeData = _storage.read(key);

      if (typeData.runtimeType == String) {
        return fromMap != null ? fromMap(json.decode(typeData)) : json.decode(typeData);
      }

      return typeData;
    }

    return null;
  }

  @override
  String getString(final String key) => _storage.read(key) ?? '';

  @override
  dynamic getJson(final String key) => jsonDecode(_storage.read(key) ?? '');

  @override
  Future<void> setObject<T>(final String key, final T data) {
    if (data.runtimeType.toString().startsWith('List<')) {
      return _storage.write(
          key,
          jsonEncode((data as List).map((final e) {
            if (e.runtimeType == String) {
              return e;
            }

            return e.toMap();
          }).toList()));
    }

    return _storage.write(key, data);
  }

  @override
  Future<void> setString(final String key, final String data) => _storage.write(key, data);

  @override
  Future<void> setJson(final String key, final dynamic data) => _storage.write(key, data);

  @override
  Future<void> clearAll() => _storage.erase();

  @override
  Future<void> remove(final String key) => _storage.remove(key);

  @override
  Future<void> removeAll(final List<String> keys) {
    final removes = keys.map(remove).toList();

    return Future.wait(removes);
  }

  @override
  bool exists(final key) => _storage.hasData(key);
}
