import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EngineCore {
  EngineCore._();

  static EngineCore? _instance;

  static EngineCore get instance => _instance ??= EngineCore._();

  BuildContext get currentContext => Get.context!;

  dynamic get arguments => Get.arguments;

  Map<String, String?> get parameters => Get.parameters;

  String get currentRoute => Get.currentRoute;

  bool get isDarkMode => Get.isDarkMode;

  Locale get deviceLocale => Get.deviceLocale ?? const Locale('pt');

  MediaQueryData get mediaQuery => Get.mediaQuery;

  FocusNode? get focusScope => Get.focusScope;

  void forceAppUpdate() => Get.forceAppUpdate();

  void reset() => Get.reset();

  bool get testMode => Get.testMode;
  set testMode(final bool value) => Get.testMode = value;
}
