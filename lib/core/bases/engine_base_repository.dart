import 'dart:async';

import 'package:engine/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:get/get_connect/http/src/request/request.dart';

/// A base class for all repositories in the Engine.
///
/// This class provides common features for all repositories such as:
///
/// * [interceptors]: A list of interceptors that can be used to modify the
///   request and response.
/// * [autoAuthorization]: A flag indicating whether the access token should be
///   sent automatically.
/// * [onInit]: A callback that is called when the repository is initialized.
/// * [get], [post], [put], [patch], [request], [delete]: Methods and
/// return an [EngineHttpResponse] instead of a [Response].
///
/// The [interceptors] list is used to add request modifiers and
/// response modifiers.
///
/// The [autoAuthorization] flag is used to determine whether the access token
/// should be sent automatically in the request headers.
///
/// The [onInit] callback is called when the repository is initialized and can
/// be used to add request modifiers and response modifiers.
///
/// The [get], [post], [put], [patch], [request], [delete] methods wrap the
/// methods and return an [EngineHttpResponse]
///
abstract class EngineBaseRepository extends GetConnect {
  /// [allowAutoSignedCert] allows the use of self-signed certificates.
  /// [autoAuthorization] determines if the access token should be sent automatically.
  /// [timeout] specifies the request timeout duration.
  EngineBaseRepository({
    super.allowAutoSignedCert = true,
    this.autoAuthorization = true,
    this.errorSafety = true,
    super.timeout = const Duration(seconds: 30),
    super.withCredentials,
  }) {
    localeService = EngineCoreDependency.instance.find<EngineLocaleService>();
  }

  final bool autoAuthorization;
  final bool errorSafety;

  /// A list of interceptors that can be used to modify the request and response.
  ///
  /// See [IEngineHttpRequestInterceptor] for more information.
  ///
  /// The [interceptors] list is used to add request modifiers and response modifiers.
  /// The [interceptors] list is called in the order that they are added to the list.
  @protected
  List<IEngineHttpRequestInterceptor> get interceptors => [
        EngineHttpRequestInterceptorLogger(),
      ];

  late EngineLocaleService localeService;

  @override
  void onInit() {
    httpClient
      ..timeout = timeout
      ..maxAuthRetries = 4
      ..userAgent = 'https://app.engine.tech'
      ..errorSafety = errorSafety
      ..addRequestModifier<Object?>((final request) async {
        if (autoAuthorization) {
          await _setAuthorizationAndRefreshToken(request);
        }

        for (final interceptor in interceptors) {
          final interceptorRequest = await interceptor.onRequest(EngineHttpRequest.fromRequest(request));
          if (interceptorRequest.headers != null) {
            request.headers.addAll(interceptorRequest.headers!);
          }
        }

        return request;
      })
      ..addAuthenticator<Object?>((final request) async {
        await _setAuthorizationAndRefreshToken(request);
        return request;
      })
      ..addResponseModifier<Object?>((final request, final response) async {
        for (final interceptor in interceptors) {
          await interceptor.onResponse(EngineHttpResponse.fromResponse(response, null));
        }

        return response;
      });
    super.onInit();
  }

  Future<void> _setAuthorizationAndRefreshToken(final Request<Object?> request) async {
    final tokenService = EngineCoreDependency.instance.find<EngineTokenService>();
    //if (autoAuthorization && tokenService.token.accessToken.isNotEmpty && tokenService.token.isExpired) {
    //  await tokenService.refreshToken();
    // }

    if (tokenService.token.isValid) {
      //request.headers['Authorization'] = 'Bearer ${tokenService.token.accessToken}';
      request.headers['Token'] = tokenService.token.accessToken;
    }
  }

  /// Sends a GET request to the specified [url].
  ///
  /// [url] is the endpoint where the request is sent.
  /// [headers] are optional HTTP headers to be included in the request.
  /// [contentType] specifies the content type of the request, defaulting to JSON.
  /// [query] is a map of query parameters to be included in the URL.
  /// [decoder] is an optional function to decode the response body.
  ///
  /// Returns an [EngineHttpResponse] containing the response data.
  @override
  Future<EngineHttpResponse<T>> get<T>(
    final String url, {
    final Map<String, String>? headers,
    final String? contentType = EngineConstant.jsonContentType,
    final Map<String, dynamic>? query,
    final EngineDecoder<T>? decoder,
  }) async {
    try {
      final response = await super.get<T>(
        url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
      );

      return EngineHttpResponse<T>.fromResponse(response, decoder);
    } catch (e, stackTrace) {
      EngineLog.debug('Error getting $url', error: e, stackTrace: stackTrace, data: {
        'url': url,
        'headers': headers,
        'contentType': contentType,
        'query': query,
        'decoder': decoder?.toString(),
      });
      return EngineHttpResponse<T>.fromException(e, decoder);
    }
  }

  /// Sends a POST request to the specified [url].
  ///
  /// [url] is the endpoint where the request is sent.
  /// [body] is the data to be sent in the request.
  /// [contentType] specifies the content type of the request, defaulting to JSON.
  /// [headers] are optional HTTP headers to be included in the request.
  /// [query] is a map of query parameters to be included in the URL.
  /// [decoder] is an optional function to decode the response body.
  /// [uploadProgress] is a callback function to track upload progress.
  ///
  /// Returns an [EngineHttpResponse] containing the response data.
  @override
  Future<EngineHttpResponse<T>> post<T>(
    final String? url,
    final body, {
    final String? contentType = EngineConstant.jsonContentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final EngineDecoder<T>? decoder,
    final Progress? uploadProgress,
  }) async {
    try {
      final response = await super.post(
        url,
        body,
        headers: headers,
        contentType: contentType,
        query: query,
        uploadProgress: uploadProgress,
      );

      return EngineHttpResponse<T>.fromResponse(response, decoder);
    } catch (e, stackTrace) {
      EngineLog.debug('Error posting to $url', error: e, stackTrace: stackTrace);
      return EngineHttpResponse<T>.fromException(e, decoder);
    }
  }

  /// Sends a PUT request to the specified [url].
  ///
  /// [url] is the endpoint where the request is sent.
  /// [body] is the data to be sent in the request.
  /// [contentType] specifies the content type of the request, defaulting to JSON.
  /// [headers] are optional HTTP headers to be included in the request.
  /// [query] is a map of query parameters to be included in the URL.
  /// [decoder] is an optional function to decode the response body.
  /// [uploadProgress] is a callback function to track upload progress.
  ///
  /// Returns an [EngineHttpResponse] containing the response data.
  @override
  Future<EngineHttpResponse<T>> put<T>(
    final String url,
    final body, {
    final String? contentType = EngineConstant.jsonContentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final EngineDecoder<T>? decoder,
    final EngineProgress? uploadProgress,
  }) async {
    try {
      final response = await super.put<T>(
        url,
        body,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );

      return EngineHttpResponse<T>.fromResponse(response, decoder);
    } catch (e, stackTrace) {
      EngineLog.debug('Error putting to $url', error: e, stackTrace: stackTrace);
      return EngineHttpResponse<T>.fromException(e, decoder);
    }
  }

  /// Sends a PATCH request to the specified [url].
  ///
  /// [url] is the endpoint where the request is sent.
  /// [body] is the data to be sent in the request.
  /// [contentType] specifies the content type of the request, defaulting to JSON.
  /// [headers] are optional HTTP headers to be included in the request.
  /// [query] is a map of query parameters to be included in the URL.
  /// [decoder] is an optional function to decode the response body.
  /// [uploadProgress] is a callback function to track upload progress.
  ///
  /// Returns an [EngineHttpResponse] containing the response data.
  @override
  Future<EngineHttpResponse<T>> patch<T>(
    final String url,
    final body, {
    final String? contentType = EngineConstant.jsonContentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
    final Progress? uploadProgress,
  }) async {
    try {
      final response = await super.patch<T>(
        url,
        body,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );

      return EngineHttpResponse<T>.fromResponse(response, decoder);
    } catch (e, stackTrace) {
      EngineLog.debug('Error patching $url', error: e, stackTrace: stackTrace);
      return EngineHttpResponse<T>.fromException(e, decoder);
    }
  }

  /// Sends a request to the specified [url] using the provided [method].
  ///
  /// [url] is the endpoint where the request is sent.
  /// [method] is the HTTP method to be used (e.g., EngineHttpMethod.get.name).
  /// [body] is the data to be sent in the request.
  /// [contentType] specifies the content type of the request, defaulting to JSON.
  /// [headers] are optional HTTP headers to be included in the request.
  /// [query] is a map of query parameters to be included in the URL.
  /// [decoder] is an optional function to decode the response body.
  /// [uploadProgress] is a callback function to track upload progress.
  ///
  /// Returns an [EngineHttpResponse] containing the response data.
  @override
  Future<EngineHttpResponse<T>> request<T>(
    final String url,
    final String method, {
    final dynamic body,
    final String? contentType = EngineConstant.jsonContentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final EngineDecoder<T>? decoder,
    final EngineProgress? uploadProgress,
  }) async {
    try {
      final response = await super.request<T>(
        url,
        method,
        body: body,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );

      return EngineHttpResponse<T>.fromResponse(response, decoder);
    } catch (e, stackTrace) {
      EngineLog.debug('Error requesting $url', error: e, stackTrace: stackTrace);
      return EngineHttpResponse<T>.fromException(e, decoder);
    }
  }

  /// Sends a DELETE request to the specified [url].
  ///
  /// [url] is the endpoint where the request is sent.
  /// [headers] are optional HTTP headers to be included in the request.
  /// [contentType] specifies the content type of the request, defaulting to JSON.
  /// [query] is a map of query parameters to be included in the URL.
  /// [decoder] is an optional function to decode the response body.
  ///
  /// Returns an [EngineHttpResponse] containing the response data.
  @override
  Future<EngineHttpResponse<T>> delete<T>(
    final String url, {
    final Map<String, String>? headers,
    final String? contentType = EngineConstant.jsonContentType,
    final Map<String, dynamic>? query,
    final EngineDecoder<T>? decoder,
  }) async {
    try {
      final response = await super.delete<T>(
        url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
      );

      return EngineHttpResponse<T>.fromResponse(response, decoder);
    } catch (e, stackTrace) {
      EngineLog.debug('Error deleting $url', error: e, stackTrace: stackTrace);
      return EngineHttpResponse<T>.fromException(e, decoder);
    }
  }

  /// Sends a GraphQL query request.
  ///
  /// This method wraps a standard GraphQL query execution in the Engine repository layer.
  ///
  /// [query] is the GraphQL query string.
  /// [variables] is an optional map of variables used in the query.
  /// [url] is an optional GraphQL endpoint URL.
  /// [headers] allows custom HTTP headers to be included in the request.
  ///
  /// Returns a [GraphQLResponse] containing the query result. If the response contains
  /// GraphQL `errors`, they will be present in the `errors` field of the returned object.
  ///
  /// Example:
  /// ```dart
  /// final response = await query('query { orders { id } }');
  /// if (response.hasErrors) {
  ///   // handle errors
  /// } else {
  ///   // handle data
  /// }
  /// ```
  @override
  Future<GraphQLResponse<T>> query<T>(
    final String query, {
    final Map<String, dynamic>? variables,
    final String? url,
    final Map<String, String>? headers,
  }) async {
    try {
      final res = await post(
        url,
        {'query': query, 'variables': variables},
        headers: headers,
      );

      // All the rest is the same implementation as the original
      // In case the API returns a 400 for instance
      if (res.hasError) {
        return GraphQLResponse<T>(
          graphQLErrors: [
            GraphQLError(
              code: res.statusCode.toString(),
              message: res.statusText,
            ),
          ],
        );
      }

      final listError = res.body['errors'];
      if ((listError is List) && listError.isNotEmpty) {
        return GraphQLResponse<T>(
          graphQLErrors: listError
              .map((final e) => GraphQLError(
                    code: e['extensions']['code']?.toString(),
                    message: e['message']?.toString(),
                  ))
              .toList(),
        );
      }
      return GraphQLResponse<T>.fromResponse(res);
    } catch (e) {
      return GraphQLResponse<T>(graphQLErrors: [
        GraphQLError(
          code: null,
          message: e.toString(),
        )
      ]);
    }
  }
}
