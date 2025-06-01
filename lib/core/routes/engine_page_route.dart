import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A class that represents a route page in the Engine.
///
/// This class is used to define the routes of the app.
///
/// The properties of this class are:
///
/// * [name]: The name of the route.
/// * [page]: The page of the route.
/// * [title]: The title of the route.
/// * [participatesInRootNavigator]: A boolean indicating whether the route
///   participates in the root navigator.
/// * [gestureWidth]: The width of the gesture area.
/// * [maintainState]: A boolean indicating whether the page should maintain
///   its state.
/// * [curve]: The curve of the transition.
/// * [alignment]: The alignment of the page.
/// * [parameters]: The parameters of the route.
/// * [opaque]: A boolean indicating whether the route is opaque.
/// * [transitionDuration]: The duration of the transition.
/// * [popGesture]: A boolean indicating whether the route can be popped by
///   gesture.
/// * [binding]: The binding of the page.
/// * [bindings]: The bindings of the page.
/// * [transition]: The transition of the page.
/// * [customTransition]: The custom transition of the page.
/// * [fullscreenDialog]: A boolean indicating whether the route is a
///   full-screen dialog.
/// * [children]: The children of the route.
/// * [middlewares]: The middlewares of the route.
/// * [unknownRoute]: The unknown route of the route.
/// * [arguments]: The arguments of the route.
/// * [showCupertinoParallax]: A boolean indicating whether the route should
///   show the cupertino parallax.
/// * [preventDuplicates]: A boolean indicating whether the route should
///   prevent duplicates.
class EnginePageRoute<T> extends GetPage<T> {
  EnginePageRoute({
    required super.name,
    required super.page,
    super.title,
    super.participatesInRootNavigator,
    super.gestureWidth,
    super.maintainState = true,
    super.curve = Curves.linear,
    super.alignment,
    super.parameters,
    super.opaque = true,
    super.transitionDuration,
    super.popGesture,
    super.binding,
    super.bindings = const [],
    super.transition,
    super.customTransition,
    super.fullscreenDialog = false,
    super.children = const <EnginePageRoute>[],
    super.middlewares,
    super.unknownRoute,
    super.arguments,
    super.showCupertinoParallax = true,
    super.preventDuplicates = true,
  });
}
