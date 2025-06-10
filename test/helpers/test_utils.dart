import 'dart:convert';
import 'dart:io';

import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// Utilitários comuns para testes do Engine
class TestUtils {
  /// Carrega um arquivo JSON de fixture
  static Map<String, dynamic> loadJsonFixture(final String fileName) {
    final file = File('test/helpers/fixtures/$fileName');
    final jsonString = file.readAsStringSync();
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Cria dados de teste válidos para EngineUserModel
  static Map<String, dynamic> createValidUserData() => {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'imageUrl': 'https://example.com/avatar.jpg',
        'permissions': ['read', 'write'],
      };

  /// Cria dados de teste inválidos para EngineUserModel
  static Map<String, dynamic> createInvalidUserData() => {
        'id': null,
        'name': '',
        'email': 'invalid-email',
        'permissions': null,
      };

  /// Cria um token de teste válido
  static Map<String, dynamic> createValidTokenData() => {
        'AccessToken': createValidJwtToken(),
        'RefreshToken': createValidJwtToken(isRefresh: true),
      };

  /// Cria um JWT token válido para testes
  static String createValidJwtToken({final bool isRefresh = false}) {
    final now = DateTime.now();
    final exp = now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000;
    final iat = now.millisecondsSinceEpoch ~/ 1000;

    // Header (typ: JWT, alg: HS256)
    const header = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';

    // Payload
    final payload = {
      'sub': '1234567890',
      'name': isRefresh ? 'Refresh Token' : 'Access Token',
      'iat': iat,
      'exp': exp,
      'scope': isRefresh ? 'refresh' : 'access',
    };

    final payloadJson = json.encode(payload);
    final payloadBase64 = base64Url.encode(utf8.encode(payloadJson));

    // Signature (fake - só para testes)
    const signature = 'SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

    return '$header.$payloadBase64.$signature';
  }

  /// Cria um token de teste expirado
  static Map<String, dynamic> createExpiredTokenData() => {
        'AccessToken': createExpiredJwtToken(),
        'RefreshToken': createExpiredJwtToken(isRefresh: true),
      };

  /// Cria um JWT token expirado para testes
  static String createExpiredJwtToken({final bool isRefresh = false}) {
    final now = DateTime.now();
    // Precisa estar expirado MESMO com os 7 dias de extensão do EngineTokenModel
    final exp = now.subtract(const Duration(days: 8)).millisecondsSinceEpoch ~/ 1000;
    final iat = now.subtract(const Duration(days: 9)).millisecondsSinceEpoch ~/ 1000;

    // Header (typ: JWT, alg: HS256)
    const header = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';

    // Payload
    final payload = {
      'sub': '1234567890',
      'name': isRefresh ? 'Expired Refresh Token' : 'Expired Access Token',
      'iat': iat,
      'exp': exp,
      'scope': isRefresh ? 'refresh' : 'access',
    };

    final payloadJson = json.encode(payload);
    final payloadBase64 = base64Url.encode(utf8.encode(payloadJson));

    // Signature (fake - só para testes)
    const signature = 'SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

    return '$header.$payloadBase64.$signature';
  }

  /// Configura o GetX para testes
  static void setupGetxForTesting() {
    Get
      ..reset()
      ..testMode = true
      ..config(enableLog: false);
  }

  /// Limpa o GetX após testes
  static void tearDownGetx() {
    Get.reset();
  }

  /// Cria uma resposta HTTP de sucesso simulada
  static Response<T> createSuccessResponse<T>({
    required final T body,
    final int statusCode = 200,
    final Map<String, String>? headers,
  }) =>
      Response<T>(
        body: body,
        statusCode: statusCode,
        statusText: 'OK',
        headers: headers ?? {'Content-Type': 'application/json'},
      );

  /// Cria uma resposta HTTP de erro simulada
  static Response<T> createErrorResponse<T>({
    final int statusCode = 400,
    final String statusText = 'Bad Request',
    final T? body,
    final Map<String, String>? headers,
  }) =>
      Response<T>(
        body: body,
        statusCode: statusCode,
        statusText: statusText,
        headers: headers ?? {'Content-Type': 'application/json'},
      );

  /// Executa um teste com timeout
  static Future<void> runWithTimeout(
    final Future<void> Function() testFunction, {
    final Duration timeout = const Duration(seconds: 5),
  }) async {
    await testFunction().timeout(timeout);
  }

  /// Verifica se um objeto é do tipo Successful
  static bool isSuccessful<L, R>(final EngineResult<L, R> result) => result.isSuccessful;

  /// Verifica se um objeto é do tipo Failure
  static bool isFailure<L, R>(final EngineResult<L, R> result) => result.isFailure;

  /// Extrai dados de um Successful de forma segura
  static R? getSuccessfulData<L, R>(final EngineResult<L, R> result) => result.isSuccessful ? result.data : null;

  /// Extrai erro de um Failure de forma segura
  static L? getFailureError<L, R>(final EngineResult<L, R> result) => result.isFailure ? result.failure : null;
}
