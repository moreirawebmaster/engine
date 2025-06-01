import 'dart:async';
import 'dart:developer' as developer;

import 'package:engine/lib.dart';

/// Utility class for logging and crash reporting in the Engine framework.
///
/// This class provides methods for logging at different levels (debug, info, warning, error, fatal)
/// and integrates with Firebase Crashlytics for crash reporting or other logging services.
class EngineLog {
  /// The name used for all log messages
  static const String _name = 'ENGINE_LOG';

  static void _logWithLevel(
    final String message, {
    final String? logName,
    final EngineLogLevel? level,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) {
    final levelLog = level ?? EngineLogLevel.info;
    final prefix = _getLevelPrefix(levelLog);
    final dataString = data == null ? '' : '- [Data]: ${data.toFormattedString()}';

    final logMessage = '$prefix $message $dataString';

    developer.log(
      logMessage,
      name: logName ?? _name,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
      level: _getLogLevelInt(levelLog),
    );

    unawaited(EngineBugTracking.log(logMessage));

    if (levelLog == EngineLogLevel.error || levelLog == EngineLogLevel.fatal) {
      EngineBugTracking.recordError(
        error ?? Exception(logMessage),
        stackTrace ?? StackTrace.current,
        isFatal: levelLog == EngineLogLevel.fatal,
        reason: logMessage,
        data: data,
      );
    }
  }

  /// Log debug level message
  ///
  /// [message] The message to log
  /// [logName] Optional custom log name
  /// [error] Optional error object
  /// [stackTrace] Optional stack trace
  /// [data] Optional additional data to include with the log
  static void debug(
    final String message, {
    final String? logName,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) =>
      _logWithLevel(message, logName: logName, level: EngineLogLevel.debug, error: error, stackTrace: stackTrace, data: data);

  /// Log info level message
  ///
  /// [message] The message to log
  /// [logName] Optional custom log name
  /// [error] Optional error object
  /// [stackTrace] Optional stack trace
  /// [data] Optional additional data to include with the log
  static void info(final String message, {final String? logName, final Object? error, final StackTrace? stackTrace, final Map<String, dynamic>? data}) =>
      _logWithLevel(message, logName: logName, level: EngineLogLevel.info, error: error, stackTrace: stackTrace, data: data);

  /// Log warning level message
  ///
  /// [message] The message to log
  /// [logName] Optional custom log name
  /// [error] Optional error object
  /// [stackTrace] Optional stack trace
  /// [data] Optional additional data to include with the log
  static void warning(final String message, {final String? logName, final Object? error, final StackTrace? stackTrace, final Map<String, dynamic>? data}) =>
      _logWithLevel(message, logName: logName, level: EngineLogLevel.warning, error: error, stackTrace: stackTrace, data: data);

  /// Log error level message
  ///
  /// [message] The message to log
  /// [logName] Optional custom log name
  /// [error] Optional error object
  /// [stackTrace] Optional stack trace
  /// [data] Optional additional data to include with the log
  static void error(final String message, {final String? logName, final Object? error, final StackTrace? stackTrace, final Map<String, dynamic>? data}) =>
      _logWithLevel(message, logName: logName, level: EngineLogLevel.error, error: error, stackTrace: stackTrace, data: data);

  /// Log fatal level message
  ///
  /// [message] The message to log
  /// [logName] Optional custom log name
  /// [error] Optional error object
  /// [stackTrace] Optional stack trace
  /// [data] Optional additional data to include with the log
  static void fatal(final String message, {final String? logName, final Object? error, final StackTrace? stackTrace, final Map<String, dynamic>? data}) =>
      _logWithLevel(message, logName: logName, level: EngineLogLevel.fatal, error: error, stackTrace: stackTrace, data: data);

  static String _getLevelPrefix(final EngineLogLevel level) => switch (level) {
        EngineLogLevel.debug => '🔍 DEBUG:',
        EngineLogLevel.info => 'ℹ️ INFO:',
        EngineLogLevel.warning => '⚠️ WARNING:',
        EngineLogLevel.error => '❌ ERROR:',
        EngineLogLevel.fatal => '☠️ FATAL:',
      };

  static int _getLogLevelInt(final EngineLogLevel level) => switch (level) {
        EngineLogLevel.debug => 0,
        EngineLogLevel.info => 800,
        EngineLogLevel.warning => 900,
        EngineLogLevel.error => 1000,
        EngineLogLevel.fatal => 1200,
      };
}
