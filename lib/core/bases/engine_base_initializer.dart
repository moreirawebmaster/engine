import 'dart:async';

/// A base interface for all initializers in the Engine.
///
/// This interface provides methods for:
///
/// * [onInit]: Called when the initializer is initialized.
/// * [onDispose]: Called when the initializer is disposed.
/// * [priority]: The priority of the initializer.
/// * [params]: The parameters of the initializer.
abstract class IEngineBaseInitializer<T> {
  /// The priority of the initializer.
  ///
  /// The priority is used to determine the order of initialization.
  /// The higher the priority, the earlier the initializer will be initialized.
  /// The default priority is 0.
  /// The priority is used to determine the order of initialization.
  /// The higher the priority, the earlier the initializer will be initialized.
  IEngineBaseInitializer(this.params, this.priority);

  /// The priority of the initializer.
  final int priority;

  /// The parameters of the initializer.
  final T? params;

  /// Called when the initializer is initialized.
  FutureOr<void> onInit() {}

  /// Called when the initializer is disposed.
  FutureOr<void> onDispose() {}
}
