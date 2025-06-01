import 'package:engine/lib.dart';
import 'package:get/get.dart';

/// A base class for all bindings in the Engine.
///
/// This class provides common features for all bindings such as:
///
/// * [dependencies]: A method that should be overridden to register
abstract class EngineBaseBinding implements Bindings {
  EngineCoreDependency get register => EngineCoreDependency.instance;

  EngineBaseBinding() {
    EngineLog.debug('Binding ${runtimeType.toString()} has been created');
  }
}
