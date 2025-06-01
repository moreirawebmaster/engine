import 'package:engine/lib.dart';
import 'package:flutter/material.dart';

/// This example demonstrates how to use the EngineLog
/// for efficient bug tracking with Firebase Crashlytics
class EngineLogExample extends StatelessWidget {
  const EngineLogExample({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Log Service Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _logDebugMessage,
                child: const Text('Log Debug Message'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _logInfoMessage,
                child: const Text('Log Info Message'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _logWarningMessage,
                child: const Text('Log Warning Message'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _logErrorMessage,
                child: const Text('Log Error Message'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _logFatalMessage,
                child: const Text('Log Fatal Message'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addBreadcrumb,
                child: const Text('Add Breadcrumb'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _simulateException,
                child: const Text('Simulate Exception'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Only for testing - will crash the app
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('App will crash in 3 seconds')),
                    );
                    Future.delayed(const Duration(seconds: 3), EngineBugTracking.testCrash);
                  }
                },
                child: const Text('Test Crash'),
              ),
            ],
          ),
        ),
      );

  void _logDebugMessage() {
    EngineLog.debug('This is a debug message');
    _showToast('Debug message logged');
  }

  void _logInfoMessage() {
    EngineLog.info('User viewed the log example screen');
    _showToast('Info message logged');
  }

  void _logWarningMessage() {
    EngineLog.warning(
      'This is a warning message',
      data: {'source': 'example', 'warning_type': 'demo'},
    );
    _showToast('Warning message logged');
  }

  void _logErrorMessage() {
    try {
      // Simulate error
      final list = <int>[];
      // This will throw an error
      list[10];
    } catch (e, stack) {
      EngineLog.error(
        'Error accessing list item',
        error: e,
        stackTrace: stack,
        data: {'operation': 'list_access'},
      );
      _showToast('Error message logged');
    }
  }

  void _logFatalMessage() {
    EngineLog.fatal(
      'This is a fatal error simulation',
      error: Exception('Critical system failure simulated'),
      data: {'critical': true, 'component': 'core_system'},
    );
    _showToast('Fatal message logged');
  }

  void _addBreadcrumb() {
    EngineLog.info('User tapped the Add Breadcrumb button');
    _trackUserJourney('Button tapped: Add Breadcrumb');
    _showToast('Breadcrumb added');
  }

  void _simulateException() {
    // Create breadcrumbs to track user journey
    _trackUserJourney('Starting exception simulation');

    try {
      // Simulate a more complex error
      _performRiskyOperation();
    } catch (error, stackTrace) {
      // Track the exception with context
      EngineLog.fatal(
        'Exception in example app',
        error: error,
        stackTrace: stackTrace,
        data: {
          'operation': 'risky_operation',
          'user_activity': 'demo',
          'app_screen': 'log_example',
        },
      );

      _trackUserJourney('Exception handled gracefully');
      _showToast('Exception recorded to Crashlytics');
    }
  }

  void _performRiskyOperation() {
    _trackUserJourney('Performing risky operation');

    // This will throw an exception
    throw Exception('This is a simulated exception for demonstration');
  }

  // Helper method to track user journey with breadcrumbs
  void _trackUserJourney(final String step) {
    EngineLog.info('JOURNEY: $step');
  }

  // Helper method to show feedback to user
  void _showToast(final String message) {
    // In a real app, you would show a toast or snackbar here
    debugPrint('TOAST: $message');
  }
}
