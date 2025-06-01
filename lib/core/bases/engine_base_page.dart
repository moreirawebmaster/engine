import 'package:design_system/lib.dart';
import 'package:engine/lib.dart';
import 'package:flutter/material.dart';

/// A base class for all pages in the Engine.
///
/// This class provides common features for all pages such as:
///
/// * [body]: The content of the page.
/// * [scaffoldKey]: The key of the [Scaffold].
/// * [color]: The current system color the [DsColor].
/// * [padding]: The padding of the page.
/// * [backgroundColor]: The background color of the page.
/// * [appBar]: The app bar of the page.
/// * [bottomNavigationBar]: The bottom navigation bar of the page.
/// * [drawer]: The drawer of the page.
/// * [endDrawer]: The end drawer of the page.
/// * [floatingActionButton]: The floating action button of the page.
/// * [floatingActionButtonAnimator]: The animator of the floating action
///   button.
/// * [floatingActionButtonLocation]: The location of the floating action
///   button.
/// * [extendBody]: A boolean indicating whether the body of the page should
///   extend beyond the bottom of the [Scaffold].
/// * [extendBodyBehindAppBar]: A boolean indicating whether the body of the
///   page should extend behind the app bar.
/// * [resizeToAvoidBottomInset]: A boolean indicating whether the page should
///   resize to avoid the bottom inset.
abstract class EngineBasePage<TController extends EngineBaseController> extends GetView<TController> {
  EngineBasePage({super.key}) : scaffoldKey = GlobalKey<ScaffoldState>();

  /// The key of the [Scaffold].
  ///
  /// This key is used to identify the [Scaffold] in the widget tree.
  final GlobalKey<ScaffoldState> scaffoldKey;

  /// The current system color the [DsColor].
  ///
  /// This color is used to retrieve the current color of the app.
  DsColor get color => DsColor.currentColor(EngineCore.instance.currentContext);

  /// The padding of the page.
  ///
  /// This padding is used to pad the content of the page.
  @protected
  EdgeInsets get padding => const EdgeInsets.symmetric(horizontal: DsSize.md);

  /// The background color of the page.
  ///
  /// This color is used to set the background color of the page.
  @protected
  Color get backgroundColor => color.background;

  /// The app bar of the page.
  ///
  /// This app bar is used to set the app bar of the page.
  @protected
  PreferredSizeWidget? appBar(final BuildContext context) => null;

  /// The bottom navigation bar of the page.
  ///
  /// This bottom navigation bar is used to set the bottom navigation bar of
  /// the page.
  @protected
  Widget? bottomNavigationBar(final BuildContext context) => null;

  /// The content of the page.
  ///
  /// This content is used to set the content of the page.
  Widget body(final BuildContext context);

  /// The drawer of the page.
  ///
  /// This drawer is used to set the drawer of the page.
  @protected
  Widget? drawer(final BuildContext context) => null;

  /// The end drawer of the page.
  ///
  /// This end drawer is used to set the end drawer of the page.
  @protected
  Widget? endDrawer(final BuildContext context) => null;

  /// The floating action button of the page.
  ///
  /// This floating action button is used to set the floating action button of
  /// the page.
  @protected
  Widget? floatingActionButton(final BuildContext context) => null;

  /// The animator of the floating action button.
  ///
  /// This animator is used to set the animator of the floating action button.
  /// Defaults to [FloatingActionButtonAnimator.scaling].
  @protected
  FloatingActionButtonAnimator get floatingActionButtonAnimator => FloatingActionButtonAnimator.scaling;

  /// The location of the floating action button.
  ///
  /// This location is used to set the location of the floating action button.
  /// Defaults to [FloatingActionButtonLocation.endFloat].
  @protected
  FloatingActionButtonLocation get floatingActionButtonLocation => FloatingActionButtonLocation.endFloat;

  /// A boolean indicating whether the body of the page should extend beyond the
  /// bottom of the [Scaffold].
  ///
  /// If this value is true, the body of the page will extend beyond the bottom
  /// of the [Scaffold].
  @protected
  bool get extendBody => false;

  /// A boolean indicating whether the body of the page should extend behind the
  /// app bar.
  ///
  /// If this value is true, the body of the page will extend behind the app
  /// bar.
  @protected
  bool get extendBodyBehindAppBar => false;

  /// A boolean indicating whether the page should resize to avoid the bottom
  /// inset.
  ///
  /// If this value is true, the page will resize to avoid the bottom inset.
  @protected
  bool get resizeToAvoidBottomInset => false;

  /// The function to be called when the refresh indicator is triggered.
  ///
  /// Defaults to [Future.value].
  @protected
  Future<void> onRefresh() => Future.value();

  @protected
  bool get canBackNativeMode => true;

  @override
  Widget build(final BuildContext context) => DsBodyPage(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() {
              if (!controller.checkStatus.hasConnection()) {
                return DsCard(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: const EdgeInsets.all(DsSize.md),
                  child: DsTitle(
                    prefix: Icon(
                      Symbols.warning,
                      color: color.neutral,
                    ),
                    title: DsText(
                      text: EngineTranslation.noInternetConnection.tr,
                      type: DsTextType.labelMedium,
                      isBold: true,
                      textColor: color.neutral,
                    ),
                  ),
                  elevation: 0,
                  color: color.alert,
                );
              }
              return const SizedBox.shrink();
            }),
            Expanded(child: body(context)),
          ],
        ),
        scaffoldKey: scaffoldKey,
        appBar: appBar(context),
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar(context),
        drawer: drawer(context),
        endDrawer: endDrawer(context),
        extendBody: extendBody,
        floatingActionButton: floatingActionButton(context),
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        floatingActionButtonLocation: floatingActionButtonLocation,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        padding: padding,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        onRefresh: onRefresh,
        canBackNativeMode: canBackNativeMode,
        key: key,
      );
}
