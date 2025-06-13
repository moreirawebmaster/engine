import 'dart:convert';

import 'package:engine/lib.dart';

/// Common utilities for Engine tests
class TestUtils {
  TestUtils._();

  static const String _invalidToken = 'invalid';

  static int _lastGeneratedId = 0;

  /// Creates valid test data for EngineUserModel
  static Map<String, dynamic> createValidUserData() {
    _lastGeneratedId++;
    return {
      'id': _lastGeneratedId,
      'name': 'Test User $_lastGeneratedId',
      'email': 'test@example.com',
      'imageUrl': 'https://example.com/avatar.jpg',
    };
  }

  /// Creates invalid test data for EngineUserModel
  static Map<String, dynamic> createInvalidUserData() => {
        'id': null,
        'name': '',
        'email': 'invalid-email',
        'imageUrl': null,
      };

  /// Creates a valid test token with AccessToken and RefreshToken
  static Map<String, dynamic> createValidTokenData() => {
        'AccessToken': createValidJwtToken(),
        'RefreshToken': createValidJwtToken(isRefresh: true),
      };

  /// Creates a valid JWT token for tests
  static String createValidJwtToken({final bool isRefresh = false}) {
    final header = {'alg': 'HS256', 'typ': 'JWT'};
    final payload = {
      'sub': '1234567890',
      'name': isRefresh ? 'Refresh Token' : 'Access Token',
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      'scope': isRefresh ? 'refresh' : 'access',
    };

    final headerEncoded = base64Url.encode(utf8.encode(json.encode(header)));
    final payloadEncoded = base64Url.encode(utf8.encode(json.encode(payload)));

    // Signature (fake - just for tests)
    const signature = 'fake_signature_for_tests';

    return '$headerEncoded.$payloadEncoded.$signature';
  }

  /// Creates an expired test token with AccessToken and RefreshToken
  static Map<String, dynamic> createExpiredTokenData() => {
        'AccessToken': createExpiredJwtToken(),
        'RefreshToken': createExpiredJwtToken(isRefresh: true),
      };

  /// Creates an expired JWT token for tests
  static String createExpiredJwtToken({final bool isRefresh = false}) {
    final header = {'alg': 'HS256', 'typ': 'JWT'};
    final payload = {
      'sub': '1234567890',
      'name': isRefresh ? 'Expired Refresh Token' : 'Expired Access Token',
      // Needs to be expired EVEN with the 7-day extension of EngineTokenModel
      'iat': DateTime.now().subtract(const Duration(days: 10)).millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().subtract(const Duration(days: 8)).millisecondsSinceEpoch ~/ 1000,
      'scope': isRefresh ? 'refresh' : 'access',
    };

    final headerEncoded = base64Url.encode(utf8.encode(json.encode(header)));
    final payloadEncoded = base64Url.encode(utf8.encode(json.encode(payload)));

    // Signature (fake - just for tests)
    const signature = 'fake_signature_for_tests';

    return '$headerEncoded.$payloadEncoded.$signature';
  }

  /// Creates an invalid test token
  static Map<String, dynamic> createInvalidTokenData() => {
        'AccessToken': _invalidToken,
        'RefreshToken': _invalidToken,
      };

  /// Sets up GetX for tests
  static void setupGetx() {
    EngineCore.instance.testMode = true;
  }

  /// Cleans up GetX after tests
  static void tearDownGetx() {
    EngineCore.instance.reset();
  }

  /// Creates a simulated successful HTTP response using GetConnect Response
  static EngineHttpResponse<T> createSuccessResponse<T>({
    final T? body,
    final int statusCode = 200,
    final String? statusText = 'OK',
    final Map<String, String>? headers,
  }) =>
      EngineHttpResponse<T>(
        body: body,
        statusCode: statusCode,
        statusText: statusText,
        headers: headers ?? {},
      );

  /// Creates a simulated HTTP error response using GetConnect Response
  static EngineHttpResponse<T> createErrorResponse<T>({
    final int statusCode = 400,
    final String statusText = 'Bad Request',
    final T? body,
    final Map<String, String>? headers,
  }) =>
      EngineHttpResponse<T>(
        body: body,
        statusCode: statusCode,
        statusText: statusText,
        headers: headers ?? {},
      );

  /// Runs a test with timeout
  static Future<void> runWithTimeout(
    final Future<void> Function() testFunction, {
    final Duration timeout = const Duration(seconds: 5),
  }) async {
    await testFunction().timeout(timeout);
  }

  /// Verifies if an object is of type Successful
  static bool isSuccessful<L, R>(final EngineResult<L, R> result) => result.isSuccessful;

  /// Verifies if an object is of type Failure
  static bool isFailure<L, R>(final EngineResult<L, R> result) => result.isFailure;

  /// Safely extracts data from a Successful
  static R? getSuccessfulData<L, R>(final EngineResult<L, R> result) => result.isSuccessful ? result.data : null;

  /// Safely extracts error from a Failure
  static L? getFailureError<L, R>(final EngineResult<L, R> result) => result.isFailure ? result.failure : null;
}
