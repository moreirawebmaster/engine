# Bug Tracking Integration - Firebase Crashlytics + Faro

Este documento descreve como usar o sistema integrado de tracking de erros que suporta tanto Firebase Crashlytics quanto Faro da Grafana.

## Visão Geral

O `EngineBugTracking` agora suporta dois sistemas de tracking de erros trabalhando em conjunto:

- **Firebase Crashlytics**: Para tracking tradicional de crashes e erros
- **Faro**: Sistema de observabilidade da Grafana para frontend

### Lógica de Funcionamento

- Se `crashlyticsEnabled = true`: Executa Firebase Crashlytics
- Se `faroEnabled = true`: Executa Faro
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
  crashlyticsEnabled: true,
  faroEnabled: false,
);

// Apenas Faro
final faroOnly = EngineBugTrackingModel(
  crashlyticsEnabled: false,
  faroEnabled: true,
  faroConfig: EngineFaroConfig(
    endpoint: 'https://faro-collector.example.com/collect',
    appName: 'my-app',
    appVersion: '1.0.0',
    environment: 'production',
  ),
);

// Ambos os sistemas
final bothEnabled = EngineBugTrackingModel(
  crashlyticsEnabled: true,
  faroEnabled: true,
  faroConfig: EngineFaroConfig(
    endpoint: 'https://faro-collector.example.com/collect',
    appName: 'my-app',
    appVersion: '1.0.0',
    environment: 'production',
  ),
);

// Nenhum sistema
final disabled = EngineBugTrackingModel(
  crashlyticsEnabled: false,
  faroEnabled: false,
);
```

### 3. Configuração do Faro

A classe `EngineFaroConfig` requer:

- `endpoint`: URL do coletor Faro
- `appName`: Nome da aplicação
- `appVersion`: Versão da aplicação
- `environment`: Ambiente (development, staging, production)

## Uso

### Inicialização

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure o modelo de tracking
  final trackingModel = EngineBugTrackingModel(
    crashlyticsEnabled: true,
    faroEnabled: true,
    faroConfig: EngineFaroConfig(
      endpoint: 'https://faro.grafana.com/collect',
      appName: 'my-flutter-app',
      appVersion: '1.0.0',
      environment: 'production',
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

// Definir identificador do usuário
await EngineBugTracking.setUserIdentifier('user@example.com');

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

// Obter configuração do Faro
EngineFaroConfig? faroConfig = EngineBugTracking.getFaroConfig();
```

## Cenários de Uso

### 1. Desenvolvimento Local
```dart
final devModel = EngineBugTrackingModel(
  crashlyticsEnabled: false, // Firebase pode não estar configurado
  faroEnabled: true,
  faroConfig: EngineFaroConfig(
    endpoint: 'http://localhost:3000/collect',
    appName: 'my-app-dev',
    appVersion: '1.0.0-dev',
    environment: 'development',
  ),
);
```

### 2. Staging
```dart
final stagingModel = EngineBugTrackingModel(
  crashlyticsEnabled: true,
  faroEnabled: true,
  faroConfig: EngineFaroConfig(
    endpoint: 'https://faro-staging.example.com/collect',
    appName: 'my-app',
    appVersion: '1.0.0-staging',
    environment: 'staging',
  ),
);
```

### 3. Produção
```dart
final prodModel = EngineBugTrackingModel(
  crashlyticsEnabled: true,
  faroEnabled: true,
  faroConfig: EngineFaroConfig(
    endpoint: 'https://faro.grafana.com/collect',
    appName: 'my-app',
    appVersion: '1.0.0',
    environment: 'production',
  ),
);
```

### 4. Testes
```dart
final testModel = EngineBugTrackingModel(
  crashlyticsEnabled: false,
  faroEnabled: false,
);
```

## Tratamento de Erros

O sistema é robusto e lida graciosamente com falhas:

- Se o Firebase não estiver inicializado, apenas o Faro funcionará
- Se o Faro não conseguir se conectar, apenas o Firebase funcionará
- Se ambos falharem, as operações completam sem erro
- Todos os erros são logados para debug

## Logs de Debug

Durante o desenvolvimento, você verá logs como:

```
Firebase Crashlytics initialized successfully
Faro configuration ready for app initialization
App Name: my-app
Endpoint: https://faro.grafana.com/collect
Faro initialized successfully
```

Ou em caso de erro:

```
Failed to initialize Firebase Crashlytics: [core/no-app] No Firebase App '[DEFAULT]' has been created
Failed to initialize Faro: Connection refused
```

## Testes

O sistema inclui testes abrangentes:

- `engine_bug_tracking_test.dart`: Testes básicos de funcionalidade
- `engine_bug_tracking_with_mocks_test.dart`: Testes com Firebase desabilitado
- `engine_bug_tracking_with_faro_test.dart`: Testes de integração Firebase + Faro

Execute os testes:

```bash
flutter test test/unit/core/helpers/engine_bug_tracking*
```

## Considerações de Performance

- As operações são assíncronas e não bloqueiam a UI
- O sistema suporta operações concorrentes
- Dados grandes são tratados eficientemente
- Operações de alta frequência são otimizadas

## Migração

Se você já usa apenas Firebase Crashlytics:

1. Adicione a dependência `faro: ^0.3.6`
2. Atualize seu modelo para incluir `faroEnabled: false`
3. Gradualmente habilite o Faro conforme necessário

```dart
// Antes
final model = EngineBugTrackingModel(crashlyticsEnabled: true);

// Depois
final model = EngineBugTrackingModel(
  crashlyticsEnabled: true,
  faroEnabled: false, // Adicione esta linha
);
``` 