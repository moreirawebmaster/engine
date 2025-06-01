import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  /// Calls [setState] in safe way, by first checking if [mounted] is `true`.
  @protected
  void setStateSafely(final VoidCallback fn, {final VoidCallback? orElse}) {
    if (mounted) {
      setState(fn);
    } else if (orElse != null) {
      orElse();
    }
  }
}
