enum EngineHttpMethodTypeEnum {
  get,
  post,
  put,
  delete,
  patch;

  factory EngineHttpMethodTypeEnum.fromString(final String method) => EngineHttpMethodTypeEnum.values.firstWhere(
        (final e) => e.name == method,
        orElse: () => EngineHttpMethodTypeEnum.get,
      );
}
