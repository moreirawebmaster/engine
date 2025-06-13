enum EngineEnvironmentTypeEnum {
  dev,
  intg,
  prd;

  factory EngineEnvironmentTypeEnum.fromName(final String name) => EngineEnvironmentTypeEnum.values.firstWhere(
        (final e) => e.name.toLowerCase() == name.toLowerCase(),
        orElse: () => EngineEnvironmentTypeEnum.prd,
      );
}
