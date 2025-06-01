import 'package:engine/lib.dart';
import 'package:get/get_connect/http/src/request/request.dart';

/// A function that decodes a dynamic value to a specific type.
///
/// [T] is the type of the decoded value.
/// [data] is the dynamic value to be decoded.
typedef EngineDecoder<T> = T Function(dynamic data);

/// A function that updates a progress value.
///
/// [percent] is the progress value to be updated.
typedef EngineProgress = Function(double percent);

class EngineHttpRequest<T> {
  EngineHttpRequest({
    required this.url,
    required this.method,
    this.headers,
    this.bodyBytes,
    this.followRedirects = true,
    this.maxRedirects = 4,
    this.contentLength,
    this.formData,
    this.persistentConnection = true,
    this.decoder,
  });

  EngineHttpRequest.empty()
      : url = Uri.parse(''),
        method = EngineHttpMethod.get,
        headers = null,
        bodyBytes = null,
        followRedirects = true,
        maxRedirects = 4,
        contentLength = null,
        formData = null,
        persistentConnection = true,
        decoder = null;

  factory EngineHttpRequest.fromRequest(final Request request) => EngineHttpRequest<T>(
        url: request.url,
        method: EngineHttpMethod.fromString(request.method),
        headers: request.headers,
        bodyBytes: request.bodyBytes,
        followRedirects: request.followRedirects,
        maxRedirects: request.maxRedirects,
        contentLength: request.contentLength,
        formData: request.files as EngineFormData?,
        persistentConnection: request.persistentConnection,
        decoder: request.decoder as T Function(dynamic)?,
      );

  Request<T> toRequest() => Request<T>(
        url: url,
        method: method.toString(),
        headers: headers ?? {},
        bodyBytes: bodyBytes,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
        contentLength: contentLength,
        files: formData,
        persistentConnection: persistentConnection,
        decoder: decoder,
      );

  /// Headers attach to this [Request]
  final Map<String, String>? headers;

  /// The [Uri] from request
  final Uri url;

  final EngineDecoder<T>? decoder;

  /// The Http Method from this [Request]
  /// ex: `GET`,`POST`,`PUT`,`DELETE`, `PATCH`
  final EngineHttpMethod method;

  final int? contentLength;

  /// The BodyBytesStream of body from this [Request]
  final Stream<List<int>>? bodyBytes;

  /// When true, the client will follow redirects to resolves this [Request]
  final bool followRedirects;

  /// The maximum number of redirects if [followRedirects] is true.
  final int maxRedirects;

  final bool persistentConnection;

  final EngineFormData? formData;
}
