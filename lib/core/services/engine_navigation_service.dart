import 'dart:async';

import 'package:engine/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A service that provides navigation methods
///
/// You can use it with `EngineCoreApp.find<EngineNavigationService>()` or inject it in your class
class EngineNavigationService extends EngineBaseService {
  /// Returns true if a Snackbar, Dialog or BottomSheet is currently OPEN
  bool get isOverlaysOpen => Get.isOverlaysOpen;

  /// Returns true if there is no Snackbar, Dialog or BottomSheet open
  bool get isOverlaysClosed => Get.isOverlaysClosed;

  /// **Navigation.pushNamed()** shortcut.<br><br>
  ///
  /// Pushes a new named `page` to the stack.
  ///
  /// It has the advantage of not needing context, so you can call
  /// from your business logic.
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unnexpected errors
  Future<T?>? toNamed<T>(
    final String page, {
    final dynamic arguments,
    final int? id,
    final bool preventDuplicates = true,
    final Map<String, String>? parameters,
  }) {
    EngineLog.debug('Navigating toNamed to $page', data: {
      'arguments': arguments,
      'id': id,
      'preventDuplicates': preventDuplicates,
      'parameters': parameters,
    });
    return Get.toNamed<T>(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
  }

  /// **Navigation.pushReplacementNamed()** shortcut.<br><br>
  ///
  /// Pop the current named `page` in the stack and push a new one in its place
  ///
  /// It has the advantage of not needing context, so you can call
  /// from your business logic.
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unnexpected errors
  Future<T?>? offNamed<T>(
    final String page, {
    final dynamic arguments,
    final int? id,
    final bool preventDuplicates = true,
    final Map<String, String>? parameters,
  }) {
    EngineLog.debug('Navigating offNamed to $page', data: {
      'arguments': arguments,
      'id': id,
      'preventDuplicates': preventDuplicates,
      'parameters': parameters,
    });
    return Get.offNamed<T>(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
  }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.<br><br>
  ///
  /// Push the given named `page`, and then pop several pages in the stack
  /// until [predicate] returns true
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// [predicate] can be used like this:
  /// `Get.offNamedUntil(page, ModalRoute.withName('/home'))`
  /// to pop routes in stack until home,
  /// or like this:
  /// `Get.offNamedUntil((route) => !Get.isDialogOpen())`,
  /// to make sure the dialog is closed
  ///
  /// Note: Always put a slash on the route name ('/page1'), to avoid unexpected errors
  Future<T?>? offNamedUntil<T>(
    final String page,
    final RoutePredicate predicate, {
    final int? id,
    final dynamic arguments,
    final Map<String, String>? parameters,
  }) {
    EngineLog.debug('Navigating offNamedUntil to $page', data: {
      'predicate': predicate,
      'id': id,
      'arguments': arguments,
      'parameters': parameters,
    });
    return Get.offNamedUntil<T>(
      page,
      predicate,
      id: id,
      arguments: arguments,
      parameters: parameters,
    );
  }

  /// **Navigation.popAndPushNamed()** shortcut.<br><br>
  ///
  /// Pop the current named page and pushes a new `page` to the stack
  /// in its place
  ///
  /// You can send any type of value to the other route in the [arguments].
  /// It is very similar to `offNamed()` but use a different approach
  ///
  /// The `offNamed()` pop a page, and goes to the next. The
  /// `offAndToNamed()` goes to the next page, and removes the previous one.
  /// The route transition animation is different.
  Future<T?>? offAndToNamed<T>(
    final String page, {
    final dynamic arguments,
    final int? id,
    final dynamic result,
    final Map<String, String>? parameters,
  }) {
    EngineLog.debug('Navigating offAndToNamed to $page', data: {
      'arguments': arguments,
      'id': id,
      'result': result,
      'parameters': parameters,
    });
    return Get.offAndToNamed<T>(
      page,
      arguments: arguments,
      id: id,
      result: result,
      parameters: parameters,
    );
  }

  /// **Navigation.removeRoute()** shortcut.<br><br>
  ///
  /// Remove a specific [route] from the stack
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  void removeRoute(final Route<dynamic> route, {final int? id}) {
    EngineLog.debug('Removing route $route', data: {
      'id': id,
    });
    Get.removeRoute(route, id: id);
  }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.<br><br>
  ///
  /// Push a named `page` and pop several pages in the stack
  /// until [predicate] returns true. [predicate] is optional
  ///
  /// It has the advantage of not needing context, so you can
  /// call from your business logic.
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [predicate] can be used like this:
  /// `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  /// or also like
  /// `Get.until((route) => !Get.isDialogOpen())`, to make sure the dialog
  /// is closed
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unexpected errors
  Future<T?>? offAllNamed<T>(
    final String newRouteName, {
    final RoutePredicate? predicate,
    final dynamic arguments,
    final int? id,
    final Map<String, String>? parameters,
  }) {
    EngineLog.debug('Navigating offAllNamed to $newRouteName', data: {
      'predicate': predicate,
      'arguments': arguments,
      'id': id,
      'parameters': parameters,
    });
    return Get.offAllNamed<T>(
      newRouteName,
      predicate: predicate,
      arguments: arguments,
      id: id,
      parameters: parameters,
    );
  }

  /// **Navigation.popUntil()** shortcut.<br><br>
  ///
  /// Pop the current page, snackbar, dialog or bottomsheet in the stack
  ///
  /// if your set [closeOverlays] to true, Get.back() will close the
  /// currently open snackbar/dialog/bottomsheet AND the current page
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// It has the advantage of not needing context, so you can call
  /// from your business logic.
  void back<T>({
    final T? result,
    final bool closeOverlays = false,
    final bool canPop = true,
    final int? id,
    final String? pathFallback,
  }) {
    if (pathFallback != null) {
      EngineLog.debug('Backing to $pathFallback');
      unawaited(offAllNamed<T>(pathFallback));
      return;
    }

    Get.back<T>(
      result: result,
      closeOverlays: closeOverlays,
      canPop: canPop,
      id: id,
    );
    EngineLog.debug('Backing to ${Get.currentRoute}');
  }

  /// **Navigation.popUntil()** (with predicate) shortcut .<br><br>
  ///
  /// Close as many routes as defined by [times]
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  void close(final int times, [final int? id]) {
    EngineLog.debug('Closing $times');
    Get.close(times, id);
    EngineLog.debug('Closed $times');
  }
}
