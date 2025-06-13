import 'dart:async';

import 'package:design_system/lib.dart';
import 'package:engine/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A widget that configures the top-level [MaterialApp].
///
/// This widget is the root of the Engine and it's responsible for
/// initializing the Engine and setting up the [MaterialApp].
///
/// It also provides a way to customize the [MaterialApp] with
/// the following properties:
///
/// * [title]: The title of the app.
/// * [theme]: The theme of the app.
/// * [darkTheme]: The dark theme of the app.
/// * [themeMode]: The theme mode of the app.
/// * [locale]: The locale of the app.
/// * [fallbackLocale]: The fallback locale of the app.
/// * [localizationsDelegates]: The localization delegates of the app.
/// * [localeListResolutionCallback]: The locale list resolution callback of the app.
/// * [localeResolutionCallback]: The locale resolution callback of the app.
/// * [supportedLocales]: The supported locales of the app.
/// * [debugShowMaterialGrid]: A boolean indicating whether to show the material grid.
/// * [debugShowCheckedModeBanner]: A boolean indicating whether to show the checked mode banner.
/// * [showPerformanceOverlay]: A boolean indicating whether to show the performance overlay.
/// * [checkerboardOffscreenLayers]: A boolean indicating whether to show the checkerboard offscreen layers.
/// * [checkerboardRasterCacheImages]: A boolean indicating whether to show the checkerboard raster cache images.
/// * [showSemanticsDebugger]: A boolean indicating whether to show the semantics debugger.
/// * [scrollBehavior]: The scroll behavior of the app.
/// * [textDirection]: The text direction of the app.
/// * [shortcuts]: The shortcuts of the app.
/// * [highContrastTheme]: The high contrast theme of the app.
/// * [highContrastDarkTheme]: The high contrast dark theme of the app.
/// * [actions]: The actions of the app.
/// * [defaultTransition]: The default transition of the app.
/// * [smartManagement]: The smart management of the app.
/// * [initialBinding]: The initial binding of the app.
/// * [transitionDuration]: The transition duration of the app.
/// * [defaultGlobalState]: The default global state of the app.
/// * [getPages]: The pages of the app.
/// * [unknownRoute]: The unknown route of the app.
/// * [useInheritedMediaQuery]: A boolean indicating whether to use the inherited media query.
/// * [enableLog]: A boolean indicating whether to enable the log.
/// * [logWriterCallback]: The log writer callback of the app.
/// * [popGesture]: A boolean indicating whether to enable the pop gesture.
class EngineMaterialApp extends StatelessWidget {
  const EngineMaterialApp({
    required this.appBinding,
    required this.translations,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    Map<String, Widget Function(BuildContext)> this.routes = const <String, WidgetBuilder>{},
    this.useInheritedMediaQuery = false,
    List<NavigatorObserver> this.navigatorObservers = const <NavigatorObserver>[],
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.smartManagement = SmartManagement.full,
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.builder,
    this.textDirection,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.locale,
    this.fallbackLocale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.shortcuts,
    this.scrollBehavior,
    this.customTransition,
    this.translationsKeys,
    this.onInit,
    this.onReady,
    this.onDispose,
    this.routingCallback,
    this.defaultTransition,
    this.getPages,
    this.opaqueRoute,
    this.enableLog = kDebugMode,
    this.logWriterCallback,
    this.popGesture,
    this.transitionDuration,
    this.defaultGlobalState,
    this.initialBinding,
    this.unknownRoute,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.actions,
    final Key? key,
  });

  /// The binding of the app.
  final EngineBaseBinding appBinding;

  /// The key of the [Navigator].
  final GlobalKey<NavigatorState>? navigatorKey;

  /// The key of the [ScaffoldMessenger].
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// The widget of the home page.
  final Widget? home;

  /// The routes of the app.
  final Map<String, WidgetBuilder>? routes;

  /// The initial route of the app.
  final String? initialRoute;

  /// The callback to generate a route.
  final RouteFactory? onGenerateRoute;

  /// The callback to generate initial routes.
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// The callback to generate unknown routes.
  final RouteFactory? onUnknownRoute;

  /// The list of [NavigatorObserver].
  final List<NavigatorObserver>? navigatorObservers;

  /// The builder of the app.
  final TransitionBuilder? builder;

  /// The title of the app.
  final String title;

  /// The callback to generate the title of the app.
  final GenerateAppTitle? onGenerateTitle;

  /// The theme of the app.
  final ThemeData? theme;

  /// The dark theme of the app.
  final ThemeData? darkTheme;

  /// The theme mode of the app.
  final ThemeMode? themeMode;

  /// The custom transition of the app.
  final CustomTransition? customTransition;

  /// The color of the app.
  final Color? color;

  /// The translations keys of the app.
  final Map<String, Map<String, String>>? translationsKeys;

  /// The translations of the app.
  final EngineBaseAppTranslation translations;

  /// The text direction of the app.
  final TextDirection? textDirection;

  /// The locale of the app.
  final Locale? locale;

  /// The fallback locale of the app.
  final Locale? fallbackLocale;

  /// The localizations delegates of the app.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// The locale list resolution callback of the app.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// The locale resolution callback of the app.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// The supported locales of the app.
  final Iterable<Locale> supportedLocales;

  /// A boolean indicating whether to show the performance overlay.
  final bool showPerformanceOverlay;

  /// A boolean indicating whether to show the checkerboard raster cache images.
  final bool checkerboardRasterCacheImages;

  /// A boolean indicating whether to show the checkerboard offscreen layers.
  final bool checkerboardOffscreenLayers;

  /// A boolean indicating whether to show the semantics debugger.
  final bool showSemanticsDebugger;

  /// A boolean indicating whether to show the checked mode banner.
  final bool debugShowCheckedModeBanner;

  /// The shortcuts of the app.
  final Map<LogicalKeySet, Intent>? shortcuts;

  /// The scroll behavior of the app.
  final ScrollBehavior? scrollBehavior;

  /// The high contrast theme of the app.
  final ThemeData? highContrastTheme;

  /// The high contrast dark theme of the app.
  final ThemeData? highContrastDarkTheme;

  /// The actions of the app.
  final Map<Type, Action<Intent>>? actions;

  /// A boolean indicating whether to show the grid of the material.
  final bool debugShowMaterialGrid;

  /// The callback to generate the title of the app.
  final ValueChanged<Routing?>? routingCallback;

  /// The default transition of the app.
  final Transition? defaultTransition;

  /// A boolean indicating whether the route is opaque.
  final bool? opaqueRoute;

  /// The callback to initialize the app.
  final VoidCallback? onInit;

  /// The callback to ready the app.
  final VoidCallback? onReady;

  /// The callback to dispose the app.
  final VoidCallback? onDispose;

  /// A boolean indicating whether to enable the log.
  final bool? enableLog;

  /// The log writer callback of the app.
  final LogWriterCallback? logWriterCallback;

  /// A boolean indicating whether to enable the pop gesture.
  final bool? popGesture;

  /// The smart management of the app.
  final SmartManagement smartManagement;

  /// The initial binding of the app.
  final Bindings? initialBinding;

  /// The transition duration of the app.
  final Duration? transitionDuration;

  /// A boolean indicating whether to use the default global state.
  final bool? defaultGlobalState;

  /// The list of [GetPage].
  final List<GetPage>? getPages;

  /// The unknown route of the app.
  final GetPage? unknownRoute;

  /// A boolean indicating whether to use the inherited media query.
  final bool useInheritedMediaQuery;

  /// Initializes the app.
  ///
  /// This method is called when the app is first started.
  ///
  /// it initializes the Firebase app.
  ///
  /// [firebaseModel] is a boolean indicating whether to initialize
  /// the Firebase app.
  ///
  /// Returns true if the app is successfully initialized, otherwise
  /// throws an exception.
  static Future<void> initialize({
    final EngineFirebaseModel? firebaseModel,
    final EngineBugTrackingModel? bugTrackingModel,
    final EngineAnalyticsModel? analyticsModel,
    final EngineFeatureFlagModel? featureFlagModel,
    final ThemeMode? themeMode,
  }) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await EngineBinding.initStorage();
      EngineBinding().dependencies();

      await EngineInitializer(initializers: [
        EngineFirebaseInitializer(firebaseModel),
        EngineBugTrackingInitializer(bugTrackingModel),
        EngineFeatureFlagInitializer(featureFlagModel),
        EngineAnalyticsInitializer(analyticsModel),
      ]).init();

      // TODO: Implement token service
      //if (EngineCoreDependency.instance.isRegistered<EngineTokenService>()) {
      //final tokenService = EngineCoreDependency.instance.find<EngineTokenService>();
      //if (tokenService.token.accessToken.isNotEmpty && tokenService.token.isExpired) {
      //  await tokenService.refreshToken();
      //}
      //}
      final deviceLocale = Get.deviceLocale ?? const Locale('pt');
      Intl.defaultLocale = deviceLocale.toString();
      await initializeDateFormatting(deviceLocale.toString());
      await EngineTheme.changeTheme(themeMode);
    } catch (e, stack) {
      EngineLog.fatal('Error initializing app', error: e, stackTrace: stack);
    }
  }

  @override
  Widget build(final BuildContext context) => _makeMaterialApp();

  Widget _makeMaterialApp() {
    EngineLog.debug('App Started');
    final deviceLocale = Get.deviceLocale ?? const Locale('pt');
    LucidValidation.global.culture = Culture(deviceLocale.languageCode);
    LucidValidation.global.languageManager = EngineFormValidatorLanguage();
    final observer = (navigatorObservers ?? []);

    final translationsKeys = translations.keys;
    for (final key in EngineTranslation().keys.entries) {
      translationsKeys[key.key]?.addAll(key.value);
    }

    return Obx(
      () => GetMaterialApp(
        actions: actions,
        debugShowMaterialGrid: debugShowMaterialGrid,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: home,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        theme: DsSystemStyle.lightTheme,
        darkTheme: DsSystemStyle.darkTheme,
        themeMode: EngineTheme.currentThemeMode(),
        customTransition: customTransition,
        locale: locale ?? deviceLocale,
        fallbackLocale: fallbackLocale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        scrollBehavior: scrollBehavior,
        textDirection: textDirection,
        shortcuts: shortcuts,
        opaqueRoute: opaqueRoute,
        onInit: onInit,
        onReady: () {
          onReady?.call();
          if (themeMode != null) {
            EngineTheme.currentThemeMode(themeMode);
          }
        },
        onDispose: onDispose,
        routingCallback: routingCallback,
        defaultTransition: defaultTransition,
        smartManagement: smartManagement,
        initialBinding: initialBinding,
        transitionDuration: transitionDuration,
        defaultGlobalState: defaultGlobalState,
        getPages: getPages,
        unknownRoute: unknownRoute,
        useInheritedMediaQuery: useInheritedMediaQuery,
        enableLog: enableLog,
        logWriterCallback: (final text, {final isError = false}) {
          logWriterCallback?.call(text, isError: isError);
        },
        popGesture: popGesture,
        navigatorObservers: [EngineRouteObserver(), ...observer],
        routes: routes ?? const <String, WidgetBuilder>{},
        highContrastTheme: highContrastTheme,
        highContrastDarkTheme: highContrastDarkTheme,
        translationsKeys: translationsKeys,
        key: key,
      ),
    );
  }
}
