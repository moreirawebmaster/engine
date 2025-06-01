import 'package:engine/lib.dart';
import 'package:flutter/material.dart';

abstract class MonitorableState<T extends StatefulWidget> extends BaseState<T> {
  @override
  void initState() {
    super.initState();
    EngineLog.debug('Widget ${runtimeType.toString()} has been initialized');
    // TODO: track analytics event here
  }

  @override
  void dispose() {
    EngineLog.debug('Widget ${runtimeType.toString()} has been disposed');
    // TODO: track analytics event here
    super.dispose();
  }
}
