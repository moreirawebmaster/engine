# Engine - Advanced Flutter Plugin for Development

## 🚀 Overview

**Engine** is a comprehensive and robust Flutter plugin, designed to abstract external libraries and provide a solid foundation for complex Flutter applications. This plugin acts as an abstraction layer that allows developers to create more robust, testable, and scalable applications.

## 📋 Table of Contents

- [Plugin Importance](#-plugin-importance)
- [Project Structure](#-project-structure)
- [Dependencies](#-dependencies)
- [Installation](#-installation)
- [Architecture](#-architecture)
- [Key Features](#-key-features)
- [How to Use](#-how-to-use)
- [Testing](#-testing)
- [Contributing](#-contributing)

## 🎯 Plugin Importance

**Engine** is essential for complex Flutter projects because:

### ✅ **External Dependencies Abstraction**
- Encapsulates libraries like Firebase, GetX, Get Storage, and others
- Provides consistent interfaces regardless of underlying implementation
- Facilitates migration and dependency updates

### ✅ **Solid Foundation for Development**
- Well-defined architecture following SOLID principles
- Implemented design patterns (Repository, Service Layer, etc.)
- Modular structure that promotes code reusability

### ✅ **More Robust Applications**
- Centralized error management system
- Advanced logging for debugging and monitoring
- HTTP interceptors for request control

### ✅ **Enhanced Testability**
- Abstractions that facilitate mock creation
- Clear separation of responsibilities
- Well-defined interfaces for dependency injection

### ✅ **Increased Productivity**
- Pre-built reusable components
- Automatic configurations for common functionalities
- Significant reduction of boilerplate code

## 🏗️ Project Structure

```
engine/
├── lib/
│   ├── core/                          # Engine main core
│   │   ├── apps/                      # Application configuration
│   │   │   ├── engine_core.dart              # Main core
│   │   │   ├── engine_core_dependency.dart   # Dependency management
│   │   │   ├── engine_material_app.dart      # Main application widget
│   │   │   └── engine_route_core.dart        # Route management
│   │   ├── bases/                     # Abstract base classes
│   │   │   ├── engine_base_binding.dart      # Base binding
│   │   │   ├── engine_base_controller.dart   # Base controller
│   │   │   ├── engine_base_initializer.dart  # Base initializer
│   │   │   ├── engine_base_model.dart        # Base model
│   │   │   ├── engine_base_page.dart         # Base page
│   │   │   ├── engine_base_repository.dart   # Base repository
│   │   │   ├── engine_base_service.dart      # Base service
│   │   │   ├── engine_base_state.dart        # Base state
│   │   │   ├── engine_base_transalation.dart # Base translation
│   │   │   └── engine_base_validator.dart    # Base validator
│   │   ├── bindings/                  # Dependency injection configurations
│   │   │   └── engine_binding.dart           # Main binding
│   │   ├── extensions/                # Functionality extensions
│   │   │   ├── map_extension.dart            # Map extensions
│   │   │   └── string.dart                   # String extensions
│   │   ├── helpers/                   # Utilities and helpers
│   │   │   ├── engine_bottomsheet.dart       # Bottom sheet helper
│   │   │   ├── engine_bug_tracking.dart      # Bug tracking
│   │   │   ├── engine_feature_flag.dart      # Feature flag management
│   │   │   ├── engine_firebase.dart          # Firebase helper
│   │   │   ├── engine_log.dart               # Logging system
│   │   │   ├── engine_message.dart           # Message system
│   │   │   └── engine_theme.dart             # Theme management
│   │   ├── http/                      # HTTP communication layer
│   │   │   ├── engine_form_data.dart         # Form data manipulation
│   │   │   ├── engine_http_exception.dart    # HTTP exceptions
│   │   │   ├── engine_http_interceptor.dart  # Base interceptor
│   │   │   ├── engine_http_interceptor_logger.dart # Request logger
│   │   │   ├── engine_http_request.dart      # Request wrapper
│   │   │   ├── engine_http_response.dart     # Response wrapper
│   │   │   ├── engine_http_result.dart       # HTTP operation result
│   │   │   └── engine_jwt.dart               # JWT manipulation
│   │   ├── initializers/              # Module initializers
│   │   │   ├── engine_bug_tracking_initializer.dart # Bug tracking init
│   │   │   ├── engine_feature_flag_initializer.dart # Feature flags init
│   │   │   ├── engine_firebase_initializer.dart     # Firebase init
│   │   │   └── engine_initializer.dart               # Base initializer
│   │   ├── language/                  # Internationalization system
│   │   │   └── engine_form_validator_language.dart  # i18n validations
│   │   ├── observers/                 # Event observers
│   │   │   └── engine_route_observer.dart            # Route observer
│   │   ├── repositories/              # Repository layer
│   │   │   ├── dtos/                         # Data Transfer Objects
│   │   │   │   ├── requests/                 # Request DTOs
│   │   │   │   └── responses/                # Response DTOs
│   │   │   ├── engine_token_repository.dart  # Token repository
│   │   │   └── i_engine_token_repository.dart # Repository interface
│   │   ├── routes/                    # Routing system
│   │   │   ├── engine_middleware.dart        # Route middleware
│   │   │   └── engine_page_route.dart        # Route configuration
│   │   ├── services/                  # Service layer
│   │   │   ├── engine_analytics_service.dart    # Analytics service
│   │   │   ├── engine_check_status_service.dart # Status checking
│   │   │   ├── engine_locale_service.dart       # Localization service
│   │   │   ├── engine_navigation_service.dart   # Navigation service
│   │   │   ├── engine_token_service.dart        # Token management
│   │   │   └── engine_user_service.dart         # User service
│   │   ├── settings/                  # Application settings
│   │   │   └── engine_app_settings.dart      # Main settings
│   │   └── typedefs/                  # Type definitions
│   │       └── engine_typedef.dart           # Custom types
│   └── data/                          # Data layer
│       ├── constants/                 # Application constants
│       │   └── engine_constant.dart          # Engine constants
│       ├── enums/                     # Enumerations
│       │   ├── engine_environment.dart      # Execution environments
│       │   ├── engine_http_method.dart      # HTTP methods
│       │   ├── engine_log_level.dart        # Log levels
│       │   └── engine_translation_type_enum.dart # Translation types
│       ├── extensions/                # Data extensions
│       │   └── engine_result_extension.dart # Result extensions
│       ├── models/                    # Data models
│       │   ├── engine_bug_tracking_model.dart # Bug tracking model
│       │   ├── engine_credential_token_model.dart # Credential model
│       │   ├── engine_firebase_model.dart         # Firebase model
│       │   ├── engine_token_model.dart             # Token model
│       │   ├── engine_update_info_model.dart       # Update info model
│       │   └── engine_user_model.dart              # User model
│       ├── repositories/              # Repository implementations
│       │   └── engine_local_storage/         # Local storage repository
│       │       ├── engine_local_storage_get_storage_repository.dart
│       │       └── i_engine_local_storage_repository.dart
│       └── translations/              # Translations
│           └── engine_transalarion.dart      # Translation system
├── engine.dart                        # Main entry point
├── pubspec.yaml                       # Configurations and dependencies
└── README.md                          # This file
```

## 📦 Dependencies

### **Main Dependencies**
- `flutter` - Main framework
- `get` ^4.7.2 - State management and navigation
- `get_storage` ^2.1.1 - Local storage
- `firebase_analytics` ^11.5.0 - Analytics
- `firebase_core` ^3.14.0 - Firebase core
- `firebase_crashlytics` ^4.3.7 - Error tracking
- `firebase_messaging` ^15.2.7 - Push notifications
- `firebase_remote_config` ^5.4.5 - Remote configuration
- `lucid_validation` ^1.3.1 - Form validation
- `intl` ^0.20.2 - Internationalization
- `package_info_plus` ^8.3.0 - App information
- `url_launcher` ^6.3.1 - URL launcher
- `internet_connection_checker_plus` ^2.7.2 - Connectivity checking

### **Design System**
- `design_system` - Custom design system (external repository)

### **Development Dependencies**
- `flutter_test` - Testing
- `flutter_lints` ^6.0.0 - Linting

## 🛠️ Installation

### 1. Add to `pubspec.yaml`

```yaml
dependencies:
  engine:
    git:
      url: https://github.com/moreirawebmaster/engine.git
```

### 2. Run the command

```bash
flutter pub get
```

### 3. Import in your project

```dart
import 'package:engine/engine.dart';
```

## 🏛️ Architecture

Engine follows a well-defined layered architecture:

### **Core Layer** 
Contains main functionalities and base abstractions

### **Data Layer**
Manages models, repositories, and data sources

### **Apps Layer**
Application configuration and initialization

### **Used Patterns**
- **Repository Pattern** - For data abstraction
- **Service Layer** - For business logic
- **Dependency Injection** - For inversion of control
- **Observer Pattern** - For event monitoring

## ⚡ Key Features

### 🔧 **Configuration System**
- Centralized application configuration
- Environment management (dev, prod, staging)
- Dynamic feature flags

### 🌐 **HTTP Communication**
- HTTP client configured with interceptors
- Automatic token management
- Automatic retry for failures
- Detailed request logging

### 🏪 **Local Storage**
- Abstraction for different storage providers
- GetStorage implementation
- Consistent interface for local data

### 🌍 **Internationalization**
- Complete translation system
- Localized validations
- Multi-language support

### 📊 **Analytics and Monitoring**
- Firebase Analytics integration
- Automatic crash reporting
- Remote feature flags

### 🎯 **Advanced Navigation**
- Typed route system
- Middleware for access control
- Navigation observers

## 📱 How to Use

### **1. Initial Configuration**

```dart
Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await EngineMaterialApp.initialize(
      firebaseModel: DefaultFirebaseOptionsConfig.currentPlatform,
      bugTrackingModel: EngineBugTrackingModel(crashlyticsEnabled: true),
      themeMode: ThemeMode.light,
    );

    runApp(
      EngineMaterialApp(
        appBinding: AppBindings(),
        debugShowCheckedModeBanner: false,
        title: 'App',
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        initialBinding: AppBindings(),
        translations: AppTranslation(),
      ),
    );
  },
      (final error, final stack) => EngineLog.fatal(
            'Error occurred in runZonedGuarded',
            error: error,
            stackTrace: stack,
          ));
}
```

### **2. Application Configuration**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EngineMaterialApp(
      appBinding: MyAppBinding(),
      translations: MyTranslations(),
      title: 'My Application',
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      getPages: AppRoutes.pages,
    );
  }
}
```

### **3. Creating a Repository**

```dart
abstract class IUserRepository{
 Future<EngineHttpResponse<String,UserResponseDto>> getUser(String id);
}

class UserRepository extends EngineBaseRepository implements IUserRepository {
  final String _pathUser = '/user/data';

  @override
  void onInit() {
    EngineLog.debug('UserRepository has been initialized');
    super.baseUrl = AppSettings().userBaseUrl;
    super.onInit();
  }

  Future<EngineHttpResponse<String, UserResponseDto>> getUser(String id) async {
     try {
      final response = await get('$_pathUser/$id');

      if (response.isOk) {
        try {
          final order = OrderResponseDto.fromMap(response.body);
          return Successful(order);
        } catch (e) {
          return Failure('Failed to parse UserResponseDto: $e');
        }
      }

      return Failure(response.bodyString ?? GlobalTranslation.internalServerErrorServer.tr);
    } catch (e) {
      return Failure(e);
    }
   }
}
```

## 🧪 Testing

### **Test Status**
- ✅ **Implemented:** 53 tests passing
- ✅ **Coverage:** PHASE 1 initial implementation
- ✅ **Tested modules:** HTTP Result, User Model
- 🔄 **In development:** Base Repository, Services

### **Implemented Test Structure**

```
test/
├── unit/                          # Unit tests
│   ├── core/                     # Core tests
│   │   └── http/                 # ✅ HTTP - 32 tests
│   │       └── engine_http_result_test.dart
│   └── data/                     # Data layer tests
│       └── models/               # ✅ Models - 21 tests
│           └── engine_user_model_test.dart
├── helpers/                      # ✅ Test utilities
│   ├── test_utils.dart          # Common helpers
│   └── fixtures/                # Test data
│       ├── user_data.json
│       └── http_responses.json
├── integration/                  # Integration tests
└── flutter_test_config.dart     # ✅ Global configuration
```

### **Running Tests**

```bash
# All tests
flutter test

# Specific unit tests
flutter test test/unit/

# With coverage
flutter test --coverage

# Specific test
flutter test test/unit/core/http/engine_http_result_test.dart
```

### **Next Tests (PHASE 2)**
- EngineBaseRepository (HTTP methods, interceptors)
- EngineNavigationService (navigation)
- EngineTokenService (authentication)
- EngineBaseController (states, lifecycle)

## 🤝 Contributing

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🚀 Version

**v1.0.0** - Initial version with main functionalities implemented

---

**Developed with ❤️ by Thiago Moreira** 