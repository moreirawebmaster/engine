import 'package:get/get.dart';

/// The [EngineCoreDependency] class is used to register and manage dependencies.
///
/// This class provides a more convenient and simpler API for
/// registering and managing dependencies.
///
/// It also provides a way to register dependencies lazily.
class EngineCoreDependency {
  /// Constructs a new instance of the [EngineCoreDependency] class.
  EngineCoreDependency._();

  static EngineCoreDependency? _instance;

  static EngineCoreDependency get instance => _instance ??= EngineCoreDependency._();

  /// Registers a dependency lazily.
  ///
  /// [builder] is the callback that will be called when the dependency
  /// is needed.
  ///
  /// [tag] is the tag of the dependency.
  ///
  /// [fenix] is a boolean indicating whether the dependency should be
  /// recreated when it is removed.
  void lazyPut<S>(final InstanceBuilderCallback<S> builder, {final String? tag, final bool fenix = false}) =>
      GetInstance().lazyPut<S>(builder, tag: tag, fenix: fenix);

  /// Registers a dependency asynchronously.
  ///
  /// [builder] is the callback that will be called when the dependency
  /// is needed.
  ///
  /// [tag] is the tag of the dependency.
  ///
  /// [permanent] is a boolean indicating whether the dependency should
  /// be permanent.
  Future<S> putAsync<S>(final AsyncInstanceBuilderCallback<S> builder, {final String? tag, final bool permanent = false}) async =>
      GetInstance().putAsync<S>(builder, tag: tag, permanent: permanent);

  /// Registers a dependency.
  ///
  /// [builder] is the callback that will be called when the dependency
  /// is needed.
  ///
  /// [tag] is the tag of the dependency.
  ///
  /// [permanent] is a boolean indicating whether the dependency should
  /// be permanent.
  void create<S>(final InstanceBuilderCallback<S> builder, {final String? tag, final bool permanent = true}) =>
      GetInstance().create<S>(builder, tag: tag, permanent: permanent);

  /// Finds a dependency.
  ///
  /// [tag] is the tag of the dependency.
  S find<S>({final String? tag}) => GetInstance().find<S>(tag: tag);

  /// Registers a dependency.
  ///
  /// [dependency] is the dependency to be registered.
  ///
  /// [tag] is the tag of the dependency.
  ///
  /// [permanent] is a boolean indicating whether the dependency should
  /// be permanent.
  ///
  /// [builder] is a callback that will be called when the dependency
  /// is needed.
  S put<S>(final S dependency, {final String? tag, final bool permanent = false, final InstanceBuilderCallback<S>? builder}) =>
      GetInstance().put<S>(dependency, tag: tag, permanent: permanent);

  /// Deletes a dependency.
  ///
  /// [tag] is the tag of the dependency.
  ///
  /// [force] is a boolean indicating whether the dependency should be
  /// deleted even if it is permanent.
  Future<bool> delete<S>({final String? tag, final bool force = false}) async => GetInstance().delete<S>(tag: tag, force: force);

  /// Deletes all dependencies.
  ///
  /// [force] is a boolean indicating whether the dependencies should be
  /// deleted even if they are permanent.
  Future<void> deleteAll({final bool force = false}) async => GetInstance().deleteAll(force: force);

  /// Reloads all dependencies.
  ///
  /// [force] is a boolean indicating whether the dependencies should be
  /// reloaded even if they are permanent.
  void reloadAll({final bool force = false}) => GetInstance().reloadAll(force: force);

  /// Reloads a dependency.
  ///
  /// [tag] is the tag of the dependency.
  ///
  /// [key] is the key of the dependency.
  ///
  /// [force] is a boolean indicating whether the dependency should be
  /// reloaded even if it is permanent.
  void reload<S>({final String? tag, final String? key, final bool force = false}) => GetInstance().reload<S>(tag: tag, key: key, force: force);

  /// Checks if a dependency is registered.
  ///
  /// [tag] is the tag of the dependency.
  bool isRegistered<S>({final String? tag}) => GetInstance().isRegistered<S>(tag: tag);

  /// Checks if a dependency is prepared.
  ///
  /// [tag] is the tag of the dependency.
  bool isPrepared<S>({final String? tag}) => GetInstance().isPrepared<S>(tag: tag);

  /// Replaces a dependency.
  ///
  /// [child] is the new dependency to be registered.
  ///
  /// [tag] is the tag of the dependency.
  void replace<P>(final P child, {final String? tag}) {
    final info = GetInstance().getInstanceInfo<P>(tag: tag);
    final permanent = (info.isPermanent ?? false);
    delete<P>(tag: tag, force: permanent);
    put(child, tag: tag, permanent: permanent);
  }

  /// Replaces a dependency lazily.
  ///
  /// [builder] is the callback that will be called when the dependency
  /// is needed.
  ///
  /// [tag] is the tag of the dependency.
  ///
  /// [fenix] is a boolean indicating whether the dependency should be
  /// recreated when it is removed.
  void lazyReplace<P>(final InstanceBuilderCallback<P> builder, {final String? tag, final bool? fenix}) {
    final info = GetInstance().getInstanceInfo<P>(tag: tag);
    final permanent = (info.isPermanent ?? false);
    delete<P>(tag: tag, force: permanent);
    lazyPut(builder, tag: tag, fenix: fenix ?? permanent);
  }
}
