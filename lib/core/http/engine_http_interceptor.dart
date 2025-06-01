import 'dart:async';

import 'package:engine/lib.dart';

abstract class IEngineHttpRequestInterceptor<T> {
  FutureOr<EngineHttpRequest<T>> onRequest(final EngineHttpRequest<T> request);
  FutureOr<EngineHttpResponse<T>> onResponse(final EngineHttpResponse<T> response);
}
