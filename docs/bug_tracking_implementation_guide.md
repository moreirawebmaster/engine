# Bug Tracking Implementation Guide

This guide provides practical advice for implementing efficient bug tracking in your Flutter app using the enhanced EngineBugTracking system with EngineLog and Firebase Crashlytics.

## Integration Steps

1. **Firebase Setup**: The system integrates Firebase Crashlytics with `EngineBugTracking`. Make sure Firebase is properly configured in your app with the appropriate Firebase options.

2. **Initialization**: The bug tracking system is initialized in a two-step process:

   a. First, initialize Firebase (required for Crashlytics):

   ```dart
   final firebaseModel = EngineFirebaseModel(
     name: 'your_app_name',
     apiKey: 'your_api_key',
     appId: 'your_app_id',
     messagingSenderId: 'your_messaging_sender_id',
     projectId: 'your_project_id',
     // Other Firebase configuration properties
   );

   // Initialize Firebase with the model
   final firebaseInitializer = EngineFirebaseInitializer(firebaseModel);
   await firebaseInitializer.onInit();
   ```

   b. Then initialize the bug tracking system with a separate model:

   ```dart
   // Create a bug tracking configuration model
   final bugTrackingModel = EngineBugTrackingModel(
     crashlyticsEnabled: true, // Enable or disable Crashlytics
   );

   // Initialize bug tracking with the model
   final bugTrackingInitializer = EngineBugTrackingInicializer(bugTrackingModel);
   await bugTrackingInitializer.onInit();
   ```

   You can also use a default model with Crashlytics disabled:

   ```dart
   // Default model with Crashlytics disabled
   final bugTrackingModel = EngineBugTrackingModelDefault();
   final bugTrackingInitializer = EngineBugTrackingInicializer(bugTrackingModel);
   await bugTrackingInitializer.onInit();
   ```

3. **Automatic Error Handlers**: The system sets up error handlers automatically during initialization:
   - `FlutterError.onError` captures Flutter framework errors
   - `PlatformDispatcher.instance.onError` captures platform-specific errors

## Implementation Guidelines

### Where to Add Logs

Place logs at strategic points in your code:

- **Entry/Exit Points**: Add logs at the beginning and end of important functions
- **Decision Points**: Log when important decisions or state changes occur
- **Error Handling**: Always log exceptions and errors with context
- **User Actions**: Track significant user interactions

### Log Level Usage

Use the appropriate log level for each situation:

- **Debug**: Detailed information for development/debugging
  ```dart
  EngineLog.debug('Raw API response: $responseData');
  ```

- **Info**: General information about normal operation
  ```dart
  EngineLog.info('User ${user.id} logged in successfully');
  ```

- **Warning**: Potential issues that don't cause failures
  ```dart
  EngineLog.warning('API response time exceeded threshold', 
    data: {'responseTime': '3.5s', 'threshold': '2.0s'});
  ```

- **Error**: Errors that need attention but don't crash the app
  ```dart
  EngineLog.error('Failed to load image', 
    error: exception, 
    stackTrace: stackTrace,
    data: {'imageUrl': url});
  ```

- **Fatal**: Critical errors that might lead to app instability
  ```dart
  EngineLog.fatal('Database corruption detected', 
    error: exception, 
    stackTrace: stackTrace);
  ```

### Custom Log Names

You can use custom log names to better organize your logs:

```dart
// Use a custom log name for a specific component or service
EngineLog.info(
  'API request successful', 
  logName: 'AUTH_SERVICE',
  data: {'endpoint': '/login'}
);
```

### Direct Bug Tracking Methods

EngineBugTracking provides direct methods for crash reporting and error tracking:

```dart
// Add a breadcrumb (helpful for tracing user steps before a crash)
await EngineLog.info('User tapped checkout button');

// Set user identifier
EngineBugTracking.setUserIdentifier('user_123');

// Add custom metadata
EngineBugTracking.setCustomKey('subscription_tier', 'premium');

// Record an error (non-fatal)
EngineBugTracking.recordError(
  error,
  stackTrace,
  reason: 'Failed to load profile data',
  data: {'userId': '123'},
  isFatal: false
);
```

### Exception Handling Pattern

Follow this pattern for consistent exception handling:

```dart
Future<void> performOperation() async {
  try {
    // Optional: Add a breadcrumb
    EngineLog.info('Starting operation');

    // Perform the operation
    await apiService.doSomething();

    // Log success
    EngineLog.info('Operation completed successfully');

    // Log operation details
    EngineLog.info('Performing operation',
      data: {'param1': 'value1', 'param2': 'value2'}
    );
  } catch (error, stackTrace) {
    // Log the error with context
    EngineBugTracking.recordError(
      error,
      stackTrace,
      reason: 'Error during operation',
      data: {'operation': 'doSomething', 'context': 'userProfile'},
    );
    
    // Handle the error appropriately
    handleError(error);
  }
}
```

## Advanced Usage

### Adding Key-Value Data to Logs

Add contextual data to any log to make troubleshooting easier:

```dart
EngineLog.info(
  'User changed settings',
  data: {
    'setting': 'notifications',
    'oldValue': 'enabled',
    'newValue': 'disabled',
    'timestamp': DateTime.now().toIso8601String(),
  }
);
```

### Recording Flutter Errors Manually

The system automatically captures Flutter errors, but you can handle them manually if needed:

```dart
// This is done automatically by EngineBugTracking, but you can use it manually if needed
final flutterErrorDetails = FlutterErrorDetails(
  exception: error,
  stack: stackTrace,
  library: 'your_library',
  context: ErrorDescription('Error during widget build'),
);

await EngineBugTracking.recordFlutterError(flutterErrorDetails);
```

### Testing Crash Reporting

Test your crash reporting setup in debug mode:

```dart
// Only works in debug mode, will be ignored in release mode
EngineBugTracking.testCrash();
```

## Troubleshooting Tips

If you're not seeing crash reports in Firebase:

1. Verify Firebase is properly initialized with `EngineFirebaseInitializer`
2. Ensure `crashlyticsEnabled` is set to `true` in the `EngineBugTrackingModel`
3. Check that the device has an internet connection when crashes occur
4. For testing, use `EngineBugTracking.testCrash()` to verify reporting works (debug mode only)
5. Check the Firebase console settings to ensure collection is enabled
6. Look for initialization logs in the console with `EngineLog.debug` statements

## Privacy Considerations

- Never log personally identifiable information (PII)
- Don't log full credit card numbers, passwords, or auth tokens
- Be careful with user-generated content
- Consider GDPR and other privacy regulations 

## Error Categorization

Add custom keys to categorize errors in your app:

```dart
// Set a custom key for the error category
EngineBugTracking.setCustomKey('error_category', 'network_error');
EngineBugTracking.setCustomKey('api_version', '2.1');

// Then log the specific error
EngineLog.error(
  'Failed to connect to API',
  error: networkException,
  stackTrace: stackTrace,
  data: {'endpoint': '/users', 'method': 'GET'}
);
```