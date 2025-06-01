import 'dart:async';

import 'package:engine/lib.dart';
import 'package:firebase_core/firebase_core.dart';

/// A class that provides a way to initialize the Firebase app.
///
/// This class is an implementation of the [IEngineBaseInitializer] interface.
///
/// It provides a way to initialize the Firebase app using the [Firebase.initializeApp]
/// method.
///
/// The [onInit] method takes a [EngineFirebaseModel] object as a parameter and
/// initializes the Firebase app with the given options.
///
/// The [onDispose] method is not implemented and is a no-op.
class EngineFirebaseInitializer implements IEngineBaseInitializer<EngineFirebaseModel> {
  EngineFirebaseInitializer(this.params);

  @override
  final EngineFirebaseModel? params;

  @override
  final int priority = 100;

  /// Disposes the Firebase app.
  ///
  /// This method is not implemented and is a no-op.
  @override
  FutureOr<void> onDispose() {}

  /// Initializes the Firebase app.
  ///
  /// This method takes a [EngineFirebaseModel] object as a parameter and
  /// initializes the Firebase app with the given options.
  ///
  /// If the [params] parameter is null or is not a [EngineFirebaseModel] object,
  /// this method logs a warning and does not initialize the Firebase app.
  @override
  FutureOr<void> onInit() async {
    if (params == null) {
      EngineLog.info('EngineFirebaseInitializer: Not initialized. params is not FirebaseModel ${params?.toString}');
      return Future.value();
    }

    final model = params;
    final firebaseApp = await Firebase.initializeApp(options: _makeOptions(model!));
    EngineFirebase.init(firebaseApp);
  }

  /// Creates a [FirebaseOptions] object from the given [EngineFirebaseModel] object.
  ///
  /// This method creates a [FirebaseOptions] object with the given options
  /// and returns it.
  FirebaseOptions _makeOptions(final EngineFirebaseModel model) => FirebaseOptions(
        apiKey: model.apiKey,
        appId: model.appId,
        messagingSenderId: model.messagingSenderId,
        projectId: model.projectId,
        storageBucket: model.storageBucket,
        measurementId: model.measurementId,
        trackingId: model.trackingId,
        deepLinkURLScheme: model.deepLinkURLScheme,
        androidClientId: model.androidClientId,
        iosClientId: model.iosClientId,
        iosBundleId: model.iosBundleId,
        appGroupId: model.appGroupId,
      );
}
