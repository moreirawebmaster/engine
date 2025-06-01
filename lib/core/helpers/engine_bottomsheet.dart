import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EngineBottomsheet<T> {
  EngineBottomsheet._();

  static Future<T?> show<T>({
    required final Widget content,
    final bool isDismissible = true,
    final bool enableDrag = true,
    final bool isScrollControlled = false,
    final bool needPageIsLoaded = false,
    final VoidCallback? onClose,
  }) async {
    if (!needPageIsLoaded) {
      return await _makeBottomsheet(
        content: content,
        enableDrag: enableDrag,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        onClose: onClose,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (final _) async {
        final result = await _makeBottomsheet(
          content: content,
          enableDrag: enableDrag,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
          onClose: onClose,
        );

        if (result == null && !isDismissible) {
          return _makeBottomsheet(
            content: content,
            enableDrag: enableDrag,
            isDismissible: isDismissible,
            isScrollControlled: isScrollControlled,
            onClose: onClose,
          );
        }
        return result;
      },
    );
    return null;
  }

  static Future<T?> _makeBottomsheet<T>({
    required final Widget content,
    required final bool isDismissible,
    required final bool enableDrag,
    required final bool isScrollControlled,
    final VoidCallback? onClose,
  }) async {
    final result = await Get.bottomSheet<T>(
      content,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      persistent: isDismissible,
    ).whenComplete(() => onClose?.call());
    return result;
  }
}
