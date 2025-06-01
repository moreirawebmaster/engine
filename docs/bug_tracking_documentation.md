# Firebase Crashlytics Bug Tracking with EngineLog

This document provides information on how to use the enhanced `EngineLog` class and `EngineBugTracking` system for efficient bug tracking with Firebase Crashlytics.

## Overview

The enhanced bug tracking system integrates EngineLog with EngineBugTracking to provide comprehensive error tracking, logging, and debugging capabilities. Key features include:

- Multiple log levels (debug, info, warning, error, fatal)
- Automatic crash reporting with detailed context
- Breadcrumb tracking for user journey analysis
- Custom key-value data for crash reports
- User identification for crash reports
- Stacktrace capture and optimization
- Automatic Flutter error and platform error capture
- PlatformDispatcher.onError integration for native platform errors

## Setup

The bug tracking system is initialized using the `EngineBugTrackingInicializer`. The system is configured to:

1. Enable/disable Crashlytics collection based on your app's configuration
2. Capture Flutter errors automatically through FlutterError.onError
3. Capture platform errors through PlatformDispatcher.onError
4. Track logs as breadcrumbs for comprehensive debugging

The initialization process involves two steps:

### 1. Firebase Initialization

First, initialize Firebase which is required for Crashlytics:

```dart
// In your app initialization
final firebaseModel = EngineFirebaseModel(
  name: 'app_name',
  apiKey: 'your_api_key',
  appId: 'your_app_id',
  messagingSenderId: 'your_messaging_sender_id',
  projectId: 'your_project_id',
  // Other Firebase configuration
);

final firebaseInitializer = EngineFirebaseInitializer(firebaseModel);
await firebaseInitializer.onInit();
```

### 2. Bug Tracking Initialization

Then initialize the bug tracking system using the EngineBugTrackingInicializer:

```dart
// Create a bug tracking model
final bugTrackingModel = EngineBugTrackingModel(
  crashlyticsEnabled: true, // Enable or disable Crashlytics
);

// Initialize bug tracking with the model
final bugTrackingInitializer = EngineBugTrackingInicializer(bugTrackingModel);
await bugTrackingInitializer.onInit();
```

You can also use the default model if you want to disable crashlytics by default:

```dart
// Default model with crashlytics disabled
final bugTrackingModel = EngineBugTrackingModelDefault();
final bugTrackingInitializer = EngineBugTrackingInicializer(bugTrackingModel);
await bugTrackingInitializer.onInit();
```

## Basic Usage

### Logging with Different Levels

EngineLog provides different log levels that are automatically integrated with crash reporting:

```dart
// Debug level - verbose information for developers
EngineLog.debug('Loading user data');

// Info level - general information about app operation
EngineLog.info('User viewed the profile screen');

// Warning level - potential issues that aren't critical
EngineLog.warning('API response slow', data: {'responseTime': '5.2s'});

// Error level - problems that need attention
EngineLog.error('Failed to load profile data', 
  error: exception, 
  stackTrace: stackTrace,
  data: {'userId': '12345'}
);

// Fatal level - critical issues
EngineLog.fatal('Grahql connection failed', 
  error: exception, 
  stackTrace: stackTrace
);
```

### Recording Crashes

You can explicitly record crashes using either EngineLog or EngineBugTracking:

```dart
try {
  // Risky operation
  performRiskyOperation();
} catch (error, stackTrace) {
  // Option 1: Using EngineBugTracking directly
  EngineBugTracking.recordError(
    error,
    stackTrace,
    reason: 'Error during Picking processing',
    data: {
      'Picking': 'item submit',
      'amount': '50.00',
      'productId': '12345',
    },
    isFatal: false, // Set to true for fatal errors
  );
  
  // Option 2: Using EngineLog (which uses EngineBugTracking internally)
  EngineLog.error(
    'Picking processing failed',
    error: error,
    stackTrace: stackTrace,
    data: {
      'Picking': 'item submit',
      'amount': '50.00',
    }
  );
  
  // Handle the error appropriately
  showErrorToUser('Picking failed. Please try again.');
}
```

### Automatic Error Capture

The system automatically captures uncaught Flutter errors and platform errors:

```dart
// These are automatically captured by the EngineBugTracking system:
// 1. FlutterError.onError for Flutter framework errors
// 2. PlatformDispatcher.instance.onError for platform errors
```

### Additional Context for Crashes

Add custom keys to provide more context for crash reports:

```dart
// Set user identifier
EngineBugTracking.setUserIdentifier('user123');

// Add custom key-value data
EngineBugTracking.setCustomKey('subscription_type', 'premium');
EngineBugTracking.setCustomKey('app_version', '1.2.3');
EngineBugTracking.setCustomKey('device_type', 'tablet');
```

## Advanced Usage

### Logging with Custom Names

You can specify custom log names for better organization:

```dart
EngineLog.info('Picking processed', logName: 'Picking_SERVICE');
```

### Adding Breadcrumbs

Add breadcrumbs to track user journey before a crash:

```dart
// Add a breadcrumb that will be included in crash reports
await EngineBugTracking.log('User initiated checkout process');
```

```dart
// Add a breadcrumb that will be included in crash reports
EngineLog.info('User initiated checkout process');
```

### Crash Testing (Development Only)

For testing crash reporting in debug mode:

```dart
// This will force a crash - only available in debug mode
EngineBugTracking.testCrash();
```

## Best Practices

1. **Use Appropriate Log Levels**: Choose the right level based on the severity:
   - Debug: Detailed information for development
   - Info: Normal application flow
   - Warning: Potential issues that don't impact functionality
   - Error: Issues that affect functionality but don't crash the app
   - Fatal: Critical issues that might lead to app instability

2. **Add Context Data**: Always include relevant data with your logs to make debugging easier.

3. **Handle Exceptions Properly**: Catch exceptions at appropriate levels and log them with context.

4. **Identify Users**: Set user identifiers to correlate crashes with specific users.

5. **Protect Privacy**: Never log sensitive personal or financial information.

## Example

Here's a comprehensive example of using the bug tracking system:

```dart
void processPicking(String pickingId, double amount) {
  try {
    // Track the user journey
    EngineLog.info('Picking processing started');
    EngineLog.info('Processing Picking', 
      data: {'pickingId': pickingId, 'amount': amount.toString()}
    );
    
    // Add a breadcrumb
    EngineLog.info('Picking being processed');
    
    final result = collectOrderService.processPicking(pickingId, amount);
    
    if (result.isSuccessful) {
      EngineLog.info('Picking successful', 
        data: {'transactionId': result.transactionId}
      );
    } else {
      EngineLog.warning('Picking failed', 
        data: {'reason': result.failureReason}
      );
    }
  } catch (error, stackTrace) {
    EngineBugTracking.recordError(
      error,
      stackTrace, 
      reason: 'Exception during picking processing',
      data: {
        'pickingId': pickingId,
        'amount': amount.toString(),
      }
    );
    
    // You can also add custom crash metadata
    EngineBugTracking.setCustomKey('last_picking_attempt', DateTime.now().toIso8601String());
  }
}
``` 