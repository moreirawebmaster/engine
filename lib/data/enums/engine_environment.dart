enum EngineEnvironment {
  dev,
  intg,
  prd;

  factory EngineEnvironment.fromEnv(final String env) => switch (env) {
        'dev' => EngineEnvironment.dev,
        'intg' => EngineEnvironment.intg,
        'prd' => EngineEnvironment.prd,
        _ => EngineEnvironment.dev,
      };
}
