import 'dart:async';

import 'package:engine/lib.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class EngineAnalytics {
  EngineAnalytics._();

  /// Firebase Analytics instance
  static FirebaseAnalytics? _analytics;
  static late EngineAnalyticsModel _engineAnalyticsModel;

  /// Initialize Analytics functionality
  ///
  /// [engineAnalyticsModel] is the model that contains the configuration for the analytics
  static Future<void> initAnalytics(final EngineAnalyticsModel engineAnalyticsModel) async {
    _engineAnalyticsModel = engineAnalyticsModel;

    if (_engineAnalyticsModel.firebaseAnalyticsEnabled) {
      _analytics = FirebaseAnalytics.instance;
      await _analytics?.setAnalyticsCollectionEnabled(true);
    }
  }

  /// Log a custom event
  ///
  /// [name] The name of the event (must follow Firebase naming conventions)
  /// [parameters] Optional parameters for the event
  static Future<void> logEvent(final String name, [final Map<String, Object>? parameters]) async {
    if (_engineAnalyticsModel.firebaseAnalyticsEnabled) {
      await _analytics?.logEvent(name: name, parameters: parameters);
    }
  }

  /// Set user ID for analytics
  ///
  /// [userId] The user identifier to set
  static Future<void> setUserId(final String userId) async {
    if (_engineAnalyticsModel.firebaseAnalyticsEnabled) {
      await _analytics?.setUserId(id: userId);
    }
  }

  /// Set user property
  ///
  /// [name] The name of the property
  /// [value] The value of the property
  static Future<void> setUserProperty(final String name, final String value) async {
    if (_engineAnalyticsModel.firebaseAnalyticsEnabled) {
      await _analytics?.setUserProperty(name: name, value: value);
    }
  }

  /// Set current screen name
  ///
  /// [screenName] The name of the screen
  /// [screenClass] Optional screen class identifier
  static Future<void> setCurrentScreen(final String screenName, [final String screenClass = '']) async {
    if (_engineAnalyticsModel.firebaseAnalyticsEnabled) {
      await _analytics?.logScreenView(screenName: screenName, screenClass: screenClass);
    }
  }

  /// Log app open event
  static Future<void> logAppOpen() async {
    if (_engineAnalyticsModel.firebaseAnalyticsEnabled) {
      await _analytics?.logAppOpen();
    }
  }

  /// Reset all analytics data
  static Future<void> resetAnalyticsData() async {
    if (_engineAnalyticsModel.firebaseAnalyticsEnabled) {
      await _analytics?.resetAnalyticsData();
    }
  }

  /// Set default event parameters
  ///
  /// [defaultParameters] Map of default parameters to include in all events
  static Future<void> setDefaultEventParameters(final Map<String, Object> defaultParameters) async {
    if (_engineAnalyticsModel.firebaseAnalyticsEnabled) {
      await _analytics?.setDefaultEventParameters(defaultParameters);
    }
  }
}
