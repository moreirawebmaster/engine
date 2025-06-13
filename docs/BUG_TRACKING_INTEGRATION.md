# Bug Tracking Integration - Firebase Crashlytics + Faro

Este documento descreve como usar o sistema integrado de tracking de erros que suporta tanto Firebase Crashlytics quanto Faro da Grafana.

## Visão Geral

O `EngineBugTracking` agora suporta dois sistemas de tracking de erros trabalhando em conjunto:

- **Firebase Crashlytics**: Para tracking tradicional de crashes e erros
- **Faro**: Sistema de observabilidade da Grafana para frontend

### Lógica de Funcionamento

- Se `crashlyticsConfig.enabled = true`: Executa Firebase Crashlytics
- Se `faroConfig.enabled = true`: Executa Faro
- Se ambos `= true`: Executa ambos os sistemas
- Se ambos `= false`: Nenhum sistema é executado

## Configuração

### 1. Dependências

Adicione ao `pubspec.yaml`:

```yaml
dependencies:
  firebase_crashlytics: ^4.3.7
  faro: ^0.3.6
```

### 2. Modelo de Configuração

```dart
// Apenas Firebase Crashlytics
final crashlyticsOnly = EngineBugTrackingModel(
  crashlyticsConfig: CrashlyticsConfig(enabled: true),
  faroConfig: EngineFaroConfig(
    enabled: false,
    endpoint: '',
    appName: '',
    appVersion: '',
    environment: '',
    apiKey: '',
  ),
);

// Apenas Faro
final faroOnly = EngineBugTrackingModel(
  crashlyticsConfig: CrashlyticsConfig(enabled: false),
  faroConfig: EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector.example.com/collect',
    appName: 'my-app',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'your-api-key',
  ),
);

// Ambos os sistemas
final bothEnabled = EngineBugTrackingModel(
  crashlyticsConfig: CrashlyticsConfig(enabled: true),
  faroConfig: EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector.example.com/collect',
    appName: 'my-app',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'your-api-key',
  ),
);

// Nenhum sistema
final disabled = EngineBugTrackingModel(
  crashlyticsConfig: CrashlyticsConfig(enabled: false),
  faroConfig: EngineFaroConfig(
    enabled: false,
    endpoint: '',
    appName: '',
    appVersion: '',
    environment: '',
    apiKey: '',
  ),
);
```

### 3. Configuração do Faro

A classe `EngineFaroConfig` requer:

- `enabled`: Se o Faro está habilitado
- `endpoint`: URL do coletor Faro
- `appName`: Nome da aplicação
- `appVersion`: Versão da aplicação
- `environment`: Ambiente (development, staging, production)
- `apiKey`: Chave de API do Faro

## Uso

### Inicialização

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure o modelo de tracking
  final trackingModel = EngineBugTrackingModel(
    crashlyticsConfig: CrashlyticsConfig(enabled: true),
    faroConfig: EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro.grafana.com/collect',
      appName: 'my-flutter-app',
      appVersion: '1.0.0',
      environment: 'production',
      apiKey: 'your-api-key',
    ),
  );
  
  // Inicialize o tracking
  await EngineBugTracking.init(trackingModel);
  
  runApp(MyApp());
}
```

### Operações Básicas

```dart
// Definir chave customizada
await EngineBugTracking.setCustomKey('user_id', 'user123');
await EngineBugTracking.setCustomKey('feature_flag', true);

// Definir identificador do usuário (novo formato com 3 parâmetros)
await EngineBugTracking.setUserIdentifier('user123', 'user@example.com', 'John Doe');

// Log de mensagens
await EngineBugTracking.log('User performed action X');

// Registrar erro
await EngineBugTracking.recordError(
  Exception('Something went wrong'),
  StackTrace.current,
  reason: 'User action failed',
  data: {
    'action': 'button_click',
    'screen': 'home',
    'timestamp': DateTime.now().toIso8601String(),
  },
);

// Registrar erro fatal
await EngineBugTracking.recordError(
  Exception('Critical error'),
  StackTrace.current,
  isFatal: true,
  reason: 'Critical system failure',
);

// Registrar erro do Flutter
await EngineBugTracking.recordFlutterError(
  FlutterErrorDetails(
    exception: Exception('Widget error'),
    stack: StackTrace.current,
    library: 'my_widget',
    context: ErrorDescription('Widget failed to render'),
  ),
);

// Teste de crash (apenas em debug)
await EngineBugTracking.testCrash();
```

### Verificação de Status

```dart
// Verificar se os sistemas estão ativos
bool crashlyticsActive = EngineBugTracking.isCrashlyticsEnabled;
bool faroActive = EngineBugTracking.isFaroEnabled;

// Verificar se o bug tracking está habilitado (novo)
bool isEnabled = EngineBugTracking.isEnabled;
```

## Cenários de Uso

### 1. Desenvolvimento Local
```dart
final devModel = EngineBugTrackingModel(
  crashlyticsConfig: CrashlyticsConfig(enabled: false), // Firebase pode não estar configurado
  faroConfig: EngineFaroConfig(
    enabled: true,
    endpoint: 'http://localhost:3000/collect',
    appName: 'my-app-dev',
    appVersion: '1.0.0-dev',
    environment: 'development',
    apiKey: 'dev-api-key',
  ),
);
```

### 2. Staging
```dart
final stagingModel = EngineBugTrackingModel(
  crashlyticsConfig: CrashlyticsConfig(enabled: true),
  faroConfig: EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-staging.example.com/collect',
    appName: 'my-app',
    appVersion: '1.0.0-staging',
    environment: 'staging',
    apiKey: 'staging-api-key',
  ),
);
```

### 3. Produção
```dart
final prodModel = EngineBugTrackingModel(
  crashlyticsConfig: CrashlyticsConfig(enabled: true),
  faroConfig: EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro.grafana.com/collect',
    appName: 'my-app',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'prod-api-key',
  ),
);
```

## Integração com EngineLog

O `EngineLog` agora se integra automaticamente com o `EngineBugTracking` quando este está habilitado:

```dart
// O EngineLog automaticamente enviará logs para o bug tracking se estiver habilitado
EngineLog.info('User logged in', data: {'userId': 'user123'});
EngineLog.error('API call failed', error: exception, stackTrace: stackTrace);
EngineLog.fatal('Critical system error', error: criticalException);
```

### Comportamento da Integração

- **Logs de INFO, DEBUG, WARNING**: Enviados apenas como logs
- **Logs de ERROR**: Enviados como logs + registrados como erros não-fatais
- **Logs de FATAL**: Enviados como logs + registrados como erros fatais

## Testes

### Estrutura de Testes

O sistema de bug tracking possui uma suíte abrangente de testes:

1. **Testes Unitários Básicos** (`engine_bug_tracking_test.dart`):
   - 54 testes cobrindo todas as funcionalidades
   - Testa com serviços desabilitados para evitar dependências do Firebase
   - Cobertura de 95%+ de todas as funcionalidades

2. **Testes de Integração com Faro** (`engine_bug_tracking_with_faro_test.dart`):
   - 17 testes focados na integração com Faro
   - Testa diferentes configurações de serviços

3. **Testes com Mocks** (`engine_bug_tracking_with_mocks_test.dart`):
   - 15 testes usando mocks do Firebase
   - Testa comportamento com Firebase desabilitado

### Executando os Testes

```bash
# Todos os testes de bug tracking
flutter test test/unit/core/helpers/engine_bug_tracking_test.dart

# Testes de integração com Faro
flutter test test/unit/core/helpers/engine_bug_tracking_with_faro_test.dart

# Testes com mocks
flutter test test/unit/core/helpers/engine_bug_tracking_with_mocks_test.dart

# Todos os testes
flutter test
```

## Limitações e Considerações

### 1. Inicialização Única
- O `EngineBugTracking` usa um campo `late final` que só pode ser inicializado uma vez
- Certifique-se de chamar `init()` apenas uma vez durante o ciclo de vida da aplicação

### 2. Dependências do Firebase
- Em ambiente de teste, use configurações com Firebase desabilitado
- O Firebase deve estar configurado no projeto para usar Crashlytics

### 3. Configuração do Faro
- Certifique-se de que o endpoint do Faro está acessível
- A API key deve ser válida para o ambiente configurado

## Troubleshooting

### Erro: LateInitializationError
```
LateInitializationError: Field '_engineBugTrackingModel' has not been initialized.
```

**Solução**: Certifique-se de chamar `EngineBugTracking.init()` antes de usar qualquer método.

### Firebase não inicializado
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: [core/no-app] No Firebase App '[DEFAULT]' has been created
```

**Solução**: Configure o Firebase ou use `crashlyticsConfig: CrashlyticsConfig(enabled: false)`.

### Faro endpoint não acessível
**Solução**: Verifique se o endpoint está correto e acessível, ou desabilite o Faro com `enabled: false`.