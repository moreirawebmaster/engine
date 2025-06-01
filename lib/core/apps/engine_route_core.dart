import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef EngineSnackBar = GetSnackBar;
typedef RouteRoot = GetDelegate;

class EngineRouteCore {
  EngineRouteCore._();

  static EngineRouteCore? _instance;

  static EngineRouteCore get instance => _instance ??= EngineRouteCore._();

  BuildContext get currentContext => Get.context!;

  dynamic get arguments => Get.arguments;

  Map<String, String?> get parameters => Get.parameters;

  String get currentRoute => Get.currentRoute;

  String get previousRoute => Get.previousRoute;

  bool get isDialogOpen => Get.isDialogOpen ?? false;

  bool get isSnackbarOpen => Get.isSnackbarOpen;

  bool get isBottomSheetOpen => Get.isBottomSheetOpen ?? false;

  bool get isOverlaysOpen => isDialogOpen || isSnackbarOpen || isBottomSheetOpen;

  bool get isPopGestureEnable => Get.isPopGestureEnable;

  bool get isPopGestureDisable => !Get.isPopGestureEnable;

  List<String> get history => [];

  RouteRoot get rootDelegate => Get.rootDelegate;

  // check a raw current route
  Route<dynamic>? get rawRoute => Get.rawRoute;

  Future<T?> bottomSheet<T>(
    final Widget component, {
    final Color? backgroundColor,
    final double? elevation,
    final bool persistent = true,
    final ShapeBorder? shape,
    final Clip? clipBehavior,
    final Color? barrierColor,
    final bool? ignoreSafeArea,
    final bool isScrollControlled = false,
    final bool useRootNavigator = false,
    final bool isDismissible = true,
    final bool enableDrag = true,
    final RouteSettings? settings,
    final Duration? enterBottomSheetDuration,
    final Duration? exitBottomSheetDuration,
  }) =>
      Get.bottomSheet<T?>(
        component,
        backgroundColor: backgroundColor,
        elevation: elevation,
        persistent: persistent,
        shape: shape,
        clipBehavior: clipBehavior,
        barrierColor: barrierColor,
        ignoreSafeArea: ignoreSafeArea,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        settings: settings,
        enterBottomSheetDuration: enterBottomSheetDuration,
        exitBottomSheetDuration: exitBottomSheetDuration,
      );

  /// Show a dialog.
  /// You can pass a [transitionDuration] and/or [transitionCurve],
  /// overriding the defaults when the dialog shows up and closes.
  /// When the dialog closes, uses those animations in reverse.
  Future<T?> dialog<T>(
    final Widget component, {
    final bool barrierDismissible = true,
    final Color? barrierColor,
    final bool useSafeArea = true,
    final GlobalKey<NavigatorState>? navigatorKey,
    final Object? arguments,
    final Duration? transitionDuration,
    final Curve? transitionCurve,
    final String? name,
    final RouteSettings? routeSettings,
  }) =>
      Get.dialog<T?>(
        component,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        useSafeArea: useSafeArea,
        navigatorKey: navigatorKey,
        arguments: arguments,
        transitionDuration: transitionDuration,
        transitionCurve: transitionCurve,
        name: name,
        routeSettings: routeSettings,
      );

  SnackbarController snackBar(final EngineSnackBar snackBar) => Get.showSnackbar(snackBar);
}
