import 'dart:async';

import 'package:engine/lib.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class EngineBugTracking {
  EngineBugTracking._() {
    FlutterError.onError = (final details) async {
      await recordFlutterError(details);
    };

    PlatformDispatcher.instance.onError = (final error, final stack) {
      unawaited(recordError(error, stack));
      return true;
    };
  }

  /// Firebase Crashlytics instance for crash reporting
  static FirebaseCrashlytics? _crashlytics;
  static EngineBugTrackingModel? _engineBugTrackingModel;

  /// Initialize crash reporting functionality
  ///
  /// [engineBugTrackingModel] is the model that contains the configuration for the bug tracking
  static Future<void> initCrashReporting(final EngineBugTrackingModel engineBugTrackingModel) async {
    _engineBugTrackingModel = engineBugTrackingModel;

    if (_engineBugTrackingModel?.crashlyticsEnabled == true) {
      _crashlytics = FirebaseCrashlytics.instance;
      await _crashlytics?.setCrashlyticsCollectionEnabled(true);
    }
  }

  /// Set custom key-value data that will be visible in crash reports
  ///
  /// [key] The key for the custom data
  /// [value] The value for the custom data
  static Future<void> setCustomKey(final String key, final dynamic value) async {
    if (_engineBugTrackingModel?.crashlyticsEnabled == true) {
      await _crashlytics?.setCustomKey(key, value.toString());
    }
  }

  /// Set user identifier for crash reports
  ///
  /// [identifier] The user identifier to set
  static Future<void> setUserIdentifier(final String identifier) async {
    if (_engineBugTrackingModel?.crashlyticsEnabled == true) {
      await _crashlytics?.setUserIdentifier(identifier);
    }
  }

  /// Force a test crash (only for testing)
  static Future<void> testCrash() async {
    if (kDebugMode) {
      if (_engineBugTrackingModel?.crashlyticsEnabled == true) {
        _crashlytics?.crash();
      }
    }
  }

  static Future<void> log(final String message) async {
    if (_engineBugTrackingModel?.crashlyticsEnabled == true) {
      await _crashlytics?.log(message);
    }
  }

  static Future<void> recordError(
    final Object error,
    final StackTrace stackTrace, {
    final bool isFatal = false,
    final String? reason,
    final Map<String, dynamic>? data,
  }) async {
    if (_engineBugTrackingModel?.crashlyticsEnabled == true) {
      await _crashlytics?.recordError(
        error,
        stackTrace,
        reason: reason,
        printDetails: true,
        fatal: isFatal,
        information: data?.toList() ?? [],
      );
    }
  }

  static Future<void> recordFlutterError(final FlutterErrorDetails details) async {
    if (_engineBugTrackingModel?.crashlyticsEnabled == true) {
      await _crashlytics?.recordFlutterError(details);
    }
  }
}
