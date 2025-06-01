enum EngineHttpMethod {
  get,
  post,
  put,
  delete,
  patch;

  factory EngineHttpMethod.fromString(final String method) => EngineHttpMethod.values.firstWhere(
        (final e) => e.name == method,
        orElse: () => EngineHttpMethod.get,
      );
}
