import 'package:design_system/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EngineMessage {
  static void showError({
    final String? title,
    required final String message,
    final Color? backgroundColor,
    final Color? borderColor,
    final Color? textColor,
    final Color? iconColor,
  }) =>
      _showCustomSnackbar(
        title: title,
        message: message,
        type: DsSnackbarType.error,
        icon: Symbols.cancel_rounded,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        textColor: textColor,
        iconColor: iconColor,
      );

  static void showAlert({
    final String? title,
    required final String message,
    final Color? backgroundColor,
    final Color? borderColor,
    final Color? textColor,
    final Color? iconColor,
  }) =>
      _showCustomSnackbar(
        title: title,
        message: message,
        type: DsSnackbarType.warning,
        icon: Symbols.error_circle_rounded_rounded,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        textColor: textColor,
        iconColor: iconColor,
      );

  static void showSuccess({
    final String? title,
    required final String message,
    final Color? backgroundColor,
    final Color? borderColor,
    final Color? textColor,
    final Color? iconColor,
  }) =>
      _showCustomSnackbar(
        title: title,
        message: message,
        type: DsSnackbarType.success,
        icon: Symbols.check_circle_outline_rounded,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        textColor: textColor,
        iconColor: iconColor,
      );

  static void showInfo({
    final String? title,
    required final String message,
    final Color? backgroundColor,
    final Color? borderColor,
    final Color? textColor,
    final Color? iconColor,
  }) =>
      _showCustomSnackbar(
        title: title,
        message: message,
        type: DsSnackbarType.info,
        icon: Symbols.lightbulb_2_rounded,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        textColor: textColor,
        iconColor: iconColor,
      );

  static void _showCustomSnackbar({
    final String? title,
    required final String message,
    required final IconData icon,
    final DsSnackbarType type = DsSnackbarType.success,
    final Duration duration = const Duration(seconds: 5),
    final SnackPosition position = SnackPosition.TOP,
    final EdgeInsets margin = const EdgeInsets.all(DsSize.md),
    final Color? backgroundColor,
    final Color? borderColor,
    final Color? textColor,
    final Color? iconColor,
  }) {
    if (Get.isSnackbarOpen) {
      return;
    }
    final color = DsColor.currentColor(Get.context!);
    final style = _getStyle(type, color);
    Get.showSnackbar(
      GetSnackBar(
        titleText: title != null
            ? DsTitle(
                title: DsText(
                  text: title,
                  type: DsTextType.bodyMedium,
                  textColor: textColor ?? style.textColor,
                  isBold: true,
                ),
                prefix: Icon(
                  icon,
                  color: iconColor ?? style.textColor,
                ),
              )
            : null,
        messageText: DsTitle(
          title: DsText(
            text: message,
            type: DsTextType.labelMedium,
            textColor: textColor ?? style.textColor,
          ),
          prefix: title == null
              ? Icon(
                  icon,
                  color: iconColor ?? style.textColor,
                )
              : null,
        ),
        duration: duration,
        backgroundColor: backgroundColor ?? style.innerColor,
        borderColor: borderColor ?? color.blackColor.withAlpha(100),
        borderRadius: DsRadiusSize.radius4,
        margin: margin,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: position,
      ),
    );
  }

  static ({Color textColor, Color innerColor}) _getStyle(final DsSnackbarType type, final DsColor color) => switch (type) {
        DsSnackbarType.success => (textColor: color.blackColor, innerColor: color.success),
        DsSnackbarType.error => (textColor: color.neutral, innerColor: color.alert),
        DsSnackbarType.warning => (textColor: color.blackColor, innerColor: color.warning),
        DsSnackbarType.info => (textColor: color.blackColor, innerColor: color.info),
      };
}
