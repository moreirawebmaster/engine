import 'dart:convert';

import 'package:engine/lib.dart';
import 'package:get/get.dart';

class EngineHttpResponse<T> extends Response<T> {
  final EngineHttpRequest? httpRequest;
  EngineHttpResponse({
    this.httpRequest,
    super.statusCode,
    super.bodyBytes,
    super.bodyString,
    super.statusText,
    super.headers,
    super.body,
  });

  factory EngineHttpResponse.fromResponse(final Response response, final EngineDecoder<T>? decoder) {
    var body = response.body;

    if (response.isOk && body is String) {
      try {
        body = jsonDecode(body);
      } catch (e, stackTrace) {
        EngineLog.warning(
          'Error decoding response body: ${e.toString()}',
          stackTrace: stackTrace,
          error: e,
          data: {
            'response': response.bodyString,
            'decoder': decoder?.toString(),
          },
        );
      }
    }

    final isValidResponse = body is Map || body is List;

    return EngineHttpResponse<T>(
      httpRequest: response.request != null ? EngineHttpRequest.fromRequest(response.request!) : EngineHttpRequest.empty(),
      statusCode: response.statusCode,
      bodyBytes: response.bodyBytes,
      bodyString: (response.bodyString ?? '').isEmpty ? null : response.bodyString,
      statusText: response.statusText,
      headers: response.headers,
      body: isValidResponse
          ? decoder != null
              ? decoder.call(body)
              : body
          : null,
    );
  }

  factory EngineHttpResponse.fromException(final Object obj, final EngineDecoder<T>? decoder) {
    final error = obj is Exception ? obj : Exception(obj.toString());
    return EngineHttpResponse(
      httpRequest: EngineHttpRequest.empty(),
      statusCode: 999,
      statusText: error.toString(),
      bodyString: error.toString(),
      body: null,
    );
  }
}

class EngineHttpGraphQLResponse<T> extends GraphQLResponse<T> {}
