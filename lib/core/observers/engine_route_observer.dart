import 'package:engine/lib.dart';
import 'package:flutter/widgets.dart';

class EngineRouteObserver extends NavigatorObserver {
  @override
  void didPush(final Route route, final Route? previousRoute) {
    super.didPush(route, previousRoute);
    EngineRouteCore.instance.history.add(route.settings.name ?? '');
  }

  @override
  void didPop(final Route route, final Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (EngineRouteCore.instance.history.isNotEmpty) {
      EngineRouteCore.instance.history.removeLast();
    }
  }
}
