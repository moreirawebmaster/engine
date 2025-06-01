import 'package:engine/lib.dart';
import 'package:firebase_core/firebase_core.dart';

/// A class that provides a singleton access to the current Firebase app.
///
/// The constructor is private and the class can only be instantiated by
/// calling the [init] method.
///
/// The [init] method takes a [FirebaseApp] as a parameter and sets it as the
/// current app.
///
/// The [current] property is a getter that returns the current Firebase app.
///
/// The [EngineFirebase] class is a singleton and can be accessed by calling
/// the default constructor.
///
/// The [init] method should be called once and only once in the app. It is
class EngineFirebase {
  EngineFirebase._(final FirebaseApp? app) {
    if (app == null) {
      const firebaseNull = 'EngineFirebase: app is null. Using Firebase EngineFirebaseInitializer to initialize.';
      EngineLog.debug(firebaseNull);
    }

    current = app!;
    _i = this;
  }

  factory EngineFirebase() {
    if (_i == null) {
      const firebaseNotInitialized = 'EngineFirebase: not initialized.';
      EngineLog.debug(firebaseNotInitialized);
    }
    return _i!;
  }

  factory EngineFirebase.init(final FirebaseApp app) => _i ?? EngineFirebase._(app);

  void init(final FirebaseApp app) => current = app;
  static EngineFirebase? _i;
  late final FirebaseApp current;
}
