import 'package:engine/lib.dart';

/// A base class for all controllers in the Engine.
///
/// This class provides common features for all controllers such as:
///
/// * [navigation]: A service that provides navigation methods
/// * [checkStatus]: A service that provides check status methods
/// * [onInit]: A method called when the controller is initialized
/// * [onReady]: A method called when the controller is ready
/// * [onDetached]: A method called when the controller is detached
/// * [onHidden]: A method called when the controller is hidden
/// * [onInactive]: A method called when the controller is inactive
/// * [onPaused]: A method called when the controller is paused
/// * [onResumed]: A method called when the controller is resumed
/// * [onEndScroll]: A method called when the controller reaches the end of scroll
/// * [onTopScroll]: A method called when the controller reaches the top of scroll
class EngineBaseController<TModel> extends SuperController<TModel> with ScrollMixin {
  /// A flag that indicates whether the controller is loading data.
  ///
  /// This flag is used to show a loading indicator while the data is being fetched.
  final isLoading = false.obs;

  final arguments = EngineCore.instance.arguments;

  /// A service that provides navigation methods.
  ///
  /// This service provides methods for navigation such as `toNamed`, `offNamed`, `back`, `removeRoute`, etc.
  ///
  /// It is a shortcut for `EngineCoreDependency.instance.find<EngineNavigationService>()`.
  EngineNavigationService get navigation => EngineCoreDependency.instance.find<EngineNavigationService>();

  /// A service that provides check status methods.
  ///
  /// This service provides methods for checking the status of the controller such as `hasConnection`, `hasInternetConnection`, etc.
  ///
  /// It is a shortcut for `EngineCoreDependency.instance.find<EngineCheckStatusService>()`.
  EngineCheckStatusService get checkStatus => EngineCoreDependency.instance.find<EngineCheckStatusService>();

  EngineBaseController() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been created');
  }

  /// A method called when the controller is initialized
  @override
  void onInit() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been initialized');
    super.onInit();
  }

  /// A method called when the controller is ready
  @override
  void onReady() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been ready');
    super.onReady();
  }

  /// A method called when the controller is detached
  @override
  void onDetached() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been detached');
  }

  /// A method called when the controller is hidden
  @override
  void onHidden() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been hidden');
  }

  /// A method called when the controller is inactive
  @override
  void onInactive() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been inactive');
  }

  /// A method called when the controller is paused
  @override
  void onPaused() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been paused');
  }

  /// A method called when the controller is resumed
  @override
  void onResumed() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been resumed');
  }

  /// A method called when the controller reaches the end of scroll
  @override
  Future<void> onEndScroll() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been ended scroll');
    return Future.value();
  }

  /// A method called when the controller reaches the top of scroll
  @override
  Future<void> onTopScroll() {
    EngineLog.debug('Controller ${runtimeType.toString()} has been top scroll');
    return Future.value();
  }
}
