import 'package:engine/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// A class that provides the current theme and the method to change it.
///
/// The class provides a singleton access to the current theme and the method
/// to change it.
///
/// The [currentTheme] property is a getter that returns the current theme.
///
/// The [currentThemeMode] property is a getter that returns the current theme
/// mode.
///
/// The [currentSystemUiOverlayStyle] property is a getter that returns the
/// current system UI overlay style.
///
/// The [changeTheme] method is used to change the current theme. It takes no
/// parameters and returns a [Future] that completes when the theme is changed.
///
/// The [changeTheme] method is async and will update the theme mode in the
/// local storage and call ChangeThemeMode to change the theme mode.
///
/// The [changeTheme] method will also call ForceAppUpdate after 200ms to
/// force the app to update.
class EngineTheme {
  EngineTheme._() {
    final modeStorage = Get.find<IEngineLocalStorageRepository>().getString(EngineConstant.themeModeKey);
    final mode = ThemeMode.values.firstWhere((final e) => e.name == modeStorage, orElse: () => ThemeMode.system);

    currentThemeMode(mode);
  }

  static Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;

  /// The current theme.
  static ThemeData get currentTheme => Get.theme;

  /// The current system UI overlay style.
  static SystemUiOverlayStyle get currentSystemUiOverlayStyle => Get.isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

  /// Change the current theme.
  static Future<void> changeTheme([final ThemeMode? themeMode]) async {
    final storage = Get.find<IEngineLocalStorageRepository>();

    final mode = themeMode ?? (Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);

    await storage.setString(EngineConstant.themeModeKey, mode.name);
    Get.changeThemeMode(mode);
    currentThemeMode(mode);
  }
}
