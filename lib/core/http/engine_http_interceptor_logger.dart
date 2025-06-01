import 'dart:async';
import 'dart:convert';

import 'package:engine/lib.dart';

class EngineHttpRequestInterceptorLogger implements IEngineHttpRequestInterceptor {
  @override
  FutureOr<EngineHttpRequest> onRequest(final EngineHttpRequest request) async {
    final url = request.url.toString();
    final method = request.method.name;
    final log = '$method $url';
    var logMessage = '';
    try {
      final data = request.bodyBytes;
      if (data != null) {
        final byteList = <int>[];

        // ignore: prefer_foreach
        await for (final bytes in data) {
          byteList.addAll(bytes);
        }

        if (byteList.isNotEmpty) {
          try {
            final decodedString = utf8.decode(byteList);
            final dynamic jsonBody = json.decode(decodedString);

            if (jsonBody is Map<String, dynamic>) {
              final sanitized = Map<String, dynamic>.from(jsonBody);

              if (sanitized.containsKey('data') && sanitized['data'] is Map<String, dynamic>) {
                final innerData = Map<String, dynamic>.from(sanitized['data']);
                if (innerData.containsKey('password')) {
                  innerData['password'] = '**********';
                }
                sanitized['data'] = innerData;
              }

              logMessage = json.encode(sanitized);
            } else {
              logMessage = '[UNEXPECTED NON-MAP JSON STRUCTURE]';
            }
          } catch (e) {
            logMessage = '[INVALID JSON BODY]';
          }
        }
      }
    } catch (e) {
      EngineLog.error(log, logName: 'NETWORK_REQUEST', data: {'requestData': 'Error reading body'});
    }

    EngineLog.debug(log, logName: 'NETWORK_REQUEST', data: {'requestData': logMessage.removeSpacesAndLineBreaks});

    return request;
  }

  @override
  FutureOr<EngineHttpResponse> onResponse(final EngineHttpResponse response) {
    final url = response.httpRequest?.url.toString();
    final method = response.httpRequest?.method.name;
    final code = response.statusCode.toString();
    final log = '$method $url [$code]';

    final body = response.bodyString;
    var sanitizedBody = 'Unknown response';

    if (body != null && body.isNotEmpty) {
      try {
        final dynamic jsonBody = json.decode(body);

        if (jsonBody is Map<String, dynamic>) {
          final sanitized = Map<String, dynamic>.from(jsonBody);

          if (sanitized.containsKey('Data') && sanitized['Data'] is Map<String, dynamic>) {
            final innerData = Map<String, dynamic>.from(sanitized['Data']);

            if (innerData.containsKey('Token')) {
              innerData['Token'] = '**********';
            }

            sanitized['Data'] = innerData;
          }

          sanitizedBody = json.encode(sanitized);
        } else {
          sanitizedBody = body;
        }
      } catch (e) {
        sanitizedBody = '[INVALID JSON RESPONSE]: $body';
      }
    }

    EngineLog.debug(log, logName: response.hasError ? 'NETWORK_ERROR' : 'NETWORK_RESPONSE', data: {
      'responseData': sanitizedBody.removeSpacesAndLineBreaks,
    });

    return response;
  }
}
