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
        'accessToken': 'valid-access-token',
        'refreshToken': 'valid-refresh-token',
        'expiresIn': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
        'tokenType': 'Bearer',
      };

  /// Cria um token de teste expirado
  static Map<String, dynamic> createExpiredTokenData() => {
        'accessToken': 'expired-access-token',
        'refreshToken': 'expired-refresh-token',
        'expiresIn': DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        'tokenType': 'Bearer',
      };

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
