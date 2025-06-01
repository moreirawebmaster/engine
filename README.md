# Bug Tracking System

This project implements a comprehensive bug tracking system using Firebase Crashlytics integrated with our custom `EngineLog` utility. This document provides an overview of the system and guidelines for effective usage.

## Overview

The bug tracking system offers:

- Multiple log levels (debug, info, warning, error, fatal)
- Crash reporting with detailed context
- Breadcrumb tracking for user journey analysis
- Custom key-value data for crash reports
- User identification for crash reports
- Stacktrace capture and optimization

## Documentation

For detailed information about the bug tracking system, please refer to the following documentation:

- [Bug Tracking Documentation](docs/bug_tracking_documentation.md) - Complete guide on using the EngineLog with Firebase Crashlytics
- [Bug Tracking Implementation Guide](docs/bug_tracking_implementation_guide.md) - Practical advice for implementing efficient bug tracking

## Examples

Check out the [EngineLog Example](lib/examples/engine_log_example.dart) for practical usage examples of the logging system.

## Implementation

The core implementation can be found in [EngineLog](lib/core/helpers/engine_log.dart), which provides the logging functionality integrated with Firebase Crashlytics.
