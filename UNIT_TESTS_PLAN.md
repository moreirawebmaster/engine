# Engine - Plano de Testes de Unidade

## 🎯 Visão Geral

Este documento apresenta uma análise completa dos testes de unidade necessários para o projeto **Engine**. Os testes estão organizados por camadas, módulos e prioridades para garantir uma cobertura abrangente e desenvolvimento de aplicações mais robustas e testáveis.

## 📊 Resumo Executivo

**Status Atual:** ~25% de cobertura de testes ✅  
**Testes Implementados:** 81 testes passando (+28 novos)  
**Testes Necessários:** 127 arquivos de teste  
**Prioridade Alta:** 45 testes (15 concluídos ✅)  
**Prioridade Média:** 52 testes  
**Prioridade Baixa:** 30 testes  

## 🏗️ Estrutura de Testes Proposta

```
test/
├── unit/                           # Testes unitários
│   ├── core/                      # Testes da camada core
│   │   ├── apps/                  # Testes de aplicação
│   │   ├── bases/                 # Testes das classes base
│   │   ├── bindings/              # Testes de bindings
│   │   ├── extensions/            # Testes de extensões
│   │   ├── helpers/               # Testes de helpers
│   │   ├── http/                  # Testes HTTP
│   │   ├── initializers/          # Testes de inicializadores
│   │   ├── language/              # Testes de idioma
│   │   ├── observers/             # Testes de observers
│   │   ├── repositories/          # Testes de repositórios
│   │   ├── routes/                # Testes de rotas
│   │   ├── services/              # Testes de serviços
│   │   ├── settings/              # Testes de configurações
│   │   └── typedefs/              # Testes de tipos
│   ├── data/                      # Testes da camada de dados
│   │   ├── constants/             # Testes de constantes
│   │   ├── enums/                 # Testes de enums
│   │   ├── extensions/            # Testes de extensões
│   │   ├── models/                # Testes de modelos
│   │   ├── repositories/          # Testes de repositórios
│   │   └── translations/          # Testes de traduções
│   └── helpers/                   # Helpers para testes
│       ├── mocks/                 # Mocks
│       ├── fixtures/              # Dados de teste
│       └── test_utils.dart        # Utilitários
└── integration/                   # Testes de integração
```

## 🔥 PRIORIDADE ALTA (45 testes)

### 1. Core HTTP (12 testes)
**Arquivo: `test/unit/core/http/`**

#### 1.1 engine_http_result_test.dart ⭐⭐⭐ ✅ CONCLUÍDO
```dart
- ✅ Criação de Successful (32 testes implementados)
- ✅ Criação de Failure
- ✅ Métodos isSuccessful e isFailure  
- ✅ Transformações (map, mapFailure, fold)
- ✅ Operações then e thenAsync
- ✅ Tratamento de exceções com tryCatch
- ✅ Operadores de igualdade
- ✅ Operações assíncronas
- ✅ Casos extremos e validação
```

#### 1.2 engine_http_response_test.dart ⭐⭐⭐
```dart
- ✅ Criação a partir de Response
- ✅ Parsing de JSON
- ✅ Status codes
- ✅ Headers
- ✅ Error handling
```

#### 1.3 engine_http_request_test.dart ⭐⭐
```dart
- ✅ Criação de requisições
- ✅ Headers
- ✅ Query parameters
- ✅ Body serialization
```

#### 1.4 engine_http_interceptor_logger_test.dart ⭐⭐
```dart
- ✅ Logging de requests
- ✅ Logging de responses
- ✅ Formatação de logs
```

### 2. Core Services (8 testes)

#### 2.1 engine_navigation_service_test.dart ⭐⭐⭐
```dart
- ✅ toNamed navigation
- ✅ offNamed navigation
- ✅ offNamedUntil navigation
- ✅ Logging de navegação
- ✅ Tratamento de argumentos
```

#### 2.2 engine_token_service_test.dart ⭐⭐⭐
```dart
- ✅ Armazenamento de tokens
- ✅ Validação de expiração
- ✅ Refresh token
- ✅ Clear tokens
```

#### 2.3 engine_user_service_test.dart ⭐⭐
```dart
- ✅ Gerenciamento de usuário
- ✅ Permissions
- ✅ User state
```

### 3. Core Bases (8 testes)

#### 3.1 engine_base_repository_test.dart ⭐⭐⭐
```dart
- ✅ HTTP methods (GET, POST, PUT, DELETE)
- ✅ Auto authorization
- ✅ Interceptors
- ✅ Error handling
- ✅ Timeout configuration
```

#### 3.2 engine_base_controller_test.dart ⭐⭐⭐
```dart
- ✅ Loading states
- ✅ Error handling
- ✅ Lifecycle methods
- ✅ Reactive variables
```

#### 3.3 engine_base_page_test.dart ⭐⭐
```dart
- ✅ Page initialization
- ✅ Controller binding
- ✅ Loading indicators
```

### 4. Data Models (6 testes)

#### 4.1 engine_user_model_test.dart ⭐⭐⭐ ✅ CONCLUÍDO
```dart
- ✅ Serialização toMap/fromMap (21 testes implementados)
- ✅ JSON conversion
- ✅ copyWith functionality
- ✅ Factory constructors
- ✅ Validation fields
- ✅ Casos extremos
- ✅ Handling de dados inválidos
```

#### 4.2 engine_token_model_test.dart ⭐⭐⭐ ✅ CONCLUÍDO
```dart
- ✅ Serialização toMap/fromMap (28 testes implementados)
- ✅ Token validation (valid/invalid/expired)
- ✅ JWT expiration check com lógica especial (+7 dias)
- ✅ Factory constructors (fromMap, fromJson, empty)
- ✅ Edge cases (malformed JWT, whitespace, long tokens)
- ✅ Integration com EngineJwt decode
- ✅ Business logic combinations
- ✅ Immutability e round-trip conversions
```

### 5. Core Helpers (11 testes)

#### 5.1 engine_log_test.dart ⭐⭐⭐
```dart
- ✅ Log levels
- ✅ Formatting
- ✅ Debug mode
- ✅ Error logging
- ✅ Data attachment
```

#### 5.2 engine_message_test.dart ⭐⭐
```dart
- ✅ Success messages
- ✅ Error messages
- ✅ Info messages
- ✅ Message queue
```

## 🔶 PRIORIDADE MÉDIA (52 testes)

### 6. Core Extensions (6 testes)

#### 6.1 map_extension_test.dart ⭐⭐
```dart
- ✅ Safe value extraction
- ✅ Type conversions
- ✅ Null safety
- ✅ Nested map access
```

#### 6.2 string_extension_test.dart ⭐⭐
```dart
- ✅ String utilities
- ✅ Validation helpers
- ✅ Formatting
```

### 7. Data Extensions (2 testes)

#### 7.1 engine_result_extension_test.dart ⭐⭐
```dart
- ✅ Result extensions
- ✅ Convenience methods
```

### 8. Core Initializers (8 testes)

#### 8.1 engine_firebase_initializer_test.dart ⭐⭐
```dart
- ✅ Firebase initialization
- ✅ Configuration
- ✅ Error handling
```

#### 8.2 engine_bug_tracking_initializer_test.dart ⭐⭐
```dart
- ✅ Crashlytics setup
- ✅ Bug tracking configuration
```

### 9. Data Repositories (6 testes)

#### 9.1 engine_local_storage_repository_test.dart ⭐⭐
```dart
- ✅ Data storage
- ✅ Data retrieval
- ✅ Data deletion
- ✅ Key management
```

### 10. Core Routes (4 testes)

#### 10.1 engine_page_route_test.dart ⭐⭐
```dart
- ✅ Route creation
- ✅ Parameters
- ✅ Middleware
```

### 11. Remaining Models (10 testes)

#### 11.1 engine_firebase_model_test.dart ⭐⭐
#### 11.2 engine_credential_token_model_test.dart ⭐⭐
#### 11.3 engine_update_info_model_test.dart ⭐⭐
#### 11.4 engine_bug_tracking_model_test.dart ⭐⭐

### 12. Additional Services (8 testes)

#### 12.1 engine_analytics_service_test.dart ⭐⭐
#### 12.2 engine_locale_service_test.dart ⭐⭐
#### 12.3 engine_check_status_service_test.dart ⭐⭐

### 13. Core Apps (8 testes)

#### 13.1 engine_core_dependency_test.dart ⭐⭐
#### 13.2 engine_material_app_test.dart ⭐⭐

## 🔵 PRIORIDADE BAIXA (30 testes)

### 14. Remaining Helpers (8 testes)
#### 14.1 engine_theme_test.dart ⭐
#### 14.2 engine_bottomsheet_test.dart ⭐
#### 14.3 engine_feature_flag_test.dart ⭐
#### 14.4 engine_firebase_test.dart ⭐

### 15. Data Constants/Enums (8 testes)
#### 15.1 engine_environment_test.dart ⭐
#### 15.2 engine_http_method_test.dart ⭐
#### 15.3 engine_log_level_test.dart ⭐

### 16. Core Bindings (4 testes)
#### 16.1 engine_binding_test.dart ⭐

### 17. Core Observers (2 testes)
#### 17.1 engine_route_observer_test.dart ⭐

### 18. Translations (4 testes)
#### 18.1 engine_translation_test.dart ⭐
#### 18.2 engine_form_validator_language_test.dart ⭐

### 19. Core Settings (4 testes)
#### 19.1 engine_app_settings_test.dart ⭐

## 📋 PLANO DE EXECUÇÃO PASSO A PASSO

### **FASE 1: Fundação Crítica (Semana 1-2) ✅ CONCLUÍDA**
1. **✅ Configurar estrutura de testes**
   ```bash
   ✅ Estrutura completa criada
   ✅ Dependências configuradas (mockito, build_runner, etc.)
   ✅ flutter_test_config.dart implementado
   ```

2. **✅ Criar helpers de teste base**
   ```bash
   ✅ TestUtils completo com 12+ métodos utilitários
   ✅ Fixtures JSON para dados de teste
   ✅ Configuração GetX para testes
   ✅ Mocks base implementados
   ```

3. **✅ Implementar testes HTTP fundamentais**
   ```bash
   ✅ engine_http_result_test.dart (32 testes passando)
   ✅ engine_user_model_test.dart (21 testes passando)
   ✅ Total: 53 testes passando em ~3s
   ```

### **FASE 2A: Models Críticos (Semana 3-4) ✅ CONCLUÍDA**
4. **✅ Models de segurança implementados**
   ```bash
   ✅ engine_token_model_test.dart (28 testes implementados)
   ✅ Integração com EngineJwt funcionando
   ✅ Lógica de expiração +7 dias testada
   ✅ Edge cases e validação completa
   ```

### **FASE 2B: Extensions e Helpers (Semana 5-6) 🔄 EM PROGRESSO**
5. **Próximas implementações (Estratégia Revisada)**
   ```bash
   🎯 Próximas implementações priorizadas:
   # 1. map_extension_test.dart (Extensões utilitárias)
   # 2. engine_log_test.dart (Sistema de logging)
   # 3. string_extension_test.dart (Extensões de string)
   # 4. engine_message_test.dart (Sistema de mensagens)
   ```

### **FASE 3: Base Classes (Semana 5-6)**
5. **Testes das classes base**
   ```bash
   # Executar: engine_base_repository_test.dart
   # Executar: engine_base_controller_test.dart
   # Executar: engine_base_page_test.dart
   flutter test test/unit/core/bases/
   ```

### **FASE 4: Models e Data (Semana 7-8)**
6. **Testes dos modelos de dados**
   ```bash
   # Executar: engine_user_model_test.dart
   # Executar: engine_token_model_test.dart
   # Executar: Demais models
   flutter test test/unit/data/models/
   ```

### **FASE 5: Helpers e Utilitários (Semana 9-10)**
7. **Testes dos helpers**
   ```bash
   # Executar: engine_log_test.dart
   # Executar: engine_message_test.dart
   # Executar: Demais helpers
   flutter test test/unit/core/helpers/
   ```

### **FASE 6: Complementares (Semana 11-12)**
8. **Testes complementares**
   ```bash
   # Executar: Extensions, Initializers, Routes
   # Executar: Repositories, Settings
   flutter test
   ```

## 🎯 Objetivos de Cobertura

| Fase | Cobertura Alvo | Módulos | Status |
|------|----------------|---------|--------|
| 1 | 15% | HTTP + Setup | ✅ Concluída (53 testes) |
| 2A | 25% | Models Críticos | ✅ Concluída (81 testes) |
| 2B | 35% | Extensions + Helpers | 🔄 Em progresso |
| 3 | 55% | Helpers + Extensions | 📋 Planejada |
| 4 | 70% | Repositories + Services | 📋 Planejada |
| 5 | 85% | Initializers + Routes | 📋 Planejada |
| 6 | 95%+ | Todos + Integração | 📋 Planejada |

## 🔧 Configuração Necessária

### 1. Dependências de Teste (pubspec.yaml)
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.7
  mocktail: ^1.0.3
  fake_async: ^1.3.1
  test: ^1.24.9
```

### 2. Arquivo de Configuração (test/flutter_test_config.dart)
```dart
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(() async {
    // Configuração global para testes
  });
  
  await testMain();
}
```

## 📊 Métricas de Sucesso

- **Cobertura mínima:** 90%
- **Tempo de execução:** < 60 segundos
- **Testes quebrados:** 0
- **Flaky tests:** < 5%

## 🎓 Lições Aprendidas da FASE 1

### ✅ Sucessos
- **Infraestrutura robusta:** TestUtils com 12+ métodos utilitários
- **Cobertura sólida:** 53 testes passando em ~3 segundos
- **Arquitetura testável:** EngineHttpResult e EngineUserModel 100% cobertos
- **Fixtures organizadas:** Dados de teste JSON estruturados

### ⚠️ Desafios Identificados  
- **Mocking GetX complexo:** Serviços com dependências GetX são desafiadores
- **Navegação contextless:** Testes de navegação requerem setup GetMaterialApp
- **Repositórios com DI:** Injeção de dependência complexa nos services

### 📋 Estratégia Revisada para FASE 2
**Foco em:** Lógica de negócio pura, modelos e classes base
**Evitar por ora:** Services com GetX, navegação contextless
**Priorizar:** Testes que agregam mais valor com menos complexidade

---

## 🚀 PRÓXIMOS PASSOS RECOMENDADOS

### **IMEDIATO (Fase 2B) - EXTENSIONS:**
1. **map_extension_test.dart** - Extensões utilitárias importantes ⭐⭐
2. **string_extension_test.dart** - Extensões de string ⭐⭐

### **MÉDIO PRAZO (Fase 2C) - HELPERS:**
3. **engine_log_test.dart** - Sistema de logging crítico ⭐⭐⭐
4. **engine_message_test.dart** - Sistema de mensagens ⭐⭐

### **LONGO PRAZO (Fase 3) - REPOSITORIES:**
5. **engine_base_repository_test.dart** - Métodos HTTP sem GetX ⭐⭐⭐

### **COMANDO PARA CONTINUAR:**
```bash
# Implementar próximo conjunto de testes
flutter test test/unit/core/extensions/ --reporter=expanded
```

---

**⚡ PRÓXIMA AÇÃO:** Implementar **map_extension_test.dart** como próximo teste de utilidade. 