/// Extension on Map to provide string transformation capabilities.
extension MapDynamicExtension on Map<dynamic, dynamic> {
  /// Transforms the map into a formatted string representation.
  ///
  /// This is useful for debugging, logging, or displaying map contents.
  ///
  /// Example:
  /// ```dart
  /// final map = {'name': 'Thiago', 'age': 0};
  /// print(map.toFormattedString()); // {name: Thiago, age: 0}
  /// ```
  String toFormattedString() {
    if (isEmpty) {
      return '{}';
    }

    final buffer = StringBuffer('{');
    var isFirst = true;

    forEach((final key, final value) {
      if (!isFirst) {
        buffer.write(', ');
      } else {
        isFirst = false;
      }

      final valueStr = value is Map ? (value).toFormattedString() : value.toString();
      buffer.write('$key: $valueStr');
    });

    buffer.write('}');
    return buffer.toString();
  }

  /// Converts a map to a list of strings where each string is in the format "key: value".
  ///
  /// This is useful for debugging, logging, or displaying map contents in a list format.
  ///
  /// Example:
  /// ```dart
  /// final map = {'name': 'Thiago', 'age': 30};
  /// print(map.toList()); // ['name: Thiago', 'age: 30']
  /// ```
  List<String> toList() {
    if (isEmpty) {
      return [];
    }
    return entries.map((final entry) => '${entry.key}: ${entry.value}').toList();
  }

  /// Transforms the map into a list with a custom transform function.
  ///
  /// This allows for flexible conversion of map entries to any type.
  ///
  /// Example:
  /// ```dart
  /// final map = {'name': 'Thiago', 'age': 30};
  /// // Convert to list of custom objects
  /// final customList = map.toListTransform((key, value) => MyObject(key, value));
  /// // Convert to list of formatted strings
  /// final stringList = map.toListTransform((key, value) => '$key = $value');
  /// ```
  List<T> toListTransform<T>(final T Function(dynamic key, dynamic value) transform) =>
      entries.map((final entry) => transform(entry.key, entry.value)).toList();
}

extension MapStringExtension on Map<String, dynamic> {
  /// Transforms the map into a formatted string representation.
  ///
  /// This is useful for debugging, logging, or displaying map contents.
  ///
  /// Example:
  /// ```dart
  /// final map = {'name': 'Thiago', 'age': 0};
  /// print(map.toFormattedString()); // {name: Thiago, age: 0}
  /// ```
  String toFormattedString() => (this as Map<dynamic, dynamic>).toFormattedString();

  /// Converts a map to a list of strings where each string is in the format "key: value".
  ///
  /// Example:
  /// ```dart
  /// final map = {'name': 'Thiago', 'age': 30};
  /// print(map.toList()); // ['name: Thiago', 'age: 30']
  /// ```
  List<String> toList() => entries.map((final entry) => '${entry.key}: ${entry.value}').toList();

  /// Transforms the map into a list with a custom transform function.
  ///
  /// Example:
  /// ```dart
  /// final map = {'name': 'Thiago', 'age': 30};
  /// final result = map.toListTransform((key, value) => '$key = $value');
  /// print(result); // ['name = Thiago', 'age = 30']
  /// ```
  List<T> toListTransform<T>(final T Function(String key, dynamic value) transform) => entries.map((final entry) => transform(entry.key, entry.value)).toList();
}

extension MapIntExtension on Map<int, dynamic> {
  /// Transforms the map into a formatted string representation.
  ///
  /// This is useful for debugging, logging, or displaying map contents.
  ///
  /// Example:
  /// ```dart
  /// final map = {1: 'Thiago', 2: 0};
  /// print(map.toFormattedString()); // {1: Thiago, 2: 0}
  /// ```
  String toFormattedString() => (this as Map<dynamic, dynamic>).toFormattedString();

  /// Converts a map to a list of strings where each string is in the format "key: value".
  ///
  /// Example:
  /// ```dart
  /// final map = {1: 'Thiago', 2: 30};
  /// print(map.toList()); // ['1: Thiago', '2: 30']
  /// ```
  List<String> toList() => entries.map((final entry) => '${entry.key}: ${entry.value}').toList();

  /// Transforms the map into a list with a custom transform function.
  ///
  /// Example:
  /// ```dart
  /// final map = {1: 'Thiago', 2: 30};
  /// final result = map.toListTransform((key, value) => '$key = $value');
  /// print(result); // ['1 = Thiago', '2 = 30']
  /// ```
  List<T> toListTransform<T>(final T Function(int key, dynamic value) transform) => entries.map((final entry) => transform(entry.key, entry.value)).toList();
}

extension MapDoubleExtension on Map<double, dynamic> {
  /// Transforms the map into a formatted string representation.
  ///
  /// This is useful for debugging, logging, or displaying map contents.
  ///
  /// Example:
  /// ```dart
  /// final map = {1.0: 'Thiago', 2.0: 0};
  /// print(map.toFormattedString()); // {1.0: Thiago, 2.0: 0}
  /// ```
  String toFormattedString() => (this as Map<dynamic, dynamic>).toFormattedString();

  /// Converts a map to a list of strings where each string is in the format "key: value".
  ///
  /// Example:
  /// ```dart
  /// final map = {1.0: 'Thiago', 2.0: 30};
  /// print(map.toList()); // ['1.0: Thiago', '2.0: 30']
  /// ```
  List<String> toList() => entries.map((final entry) => '${entry.key}: ${entry.value}').toList();

  /// Transforms the map into a list with a custom transform function.
  ///
  /// Example:
  /// ```dart
  /// final map = {1.0: 'Thiago', 2.0: 30};
  /// final result = map.toListTransform((key, value) => '$key = $value');
  /// print(result); // ['1.0 = Thiago', '2.0 = 30']
  /// ```
  List<T> toListTransform<T>(final T Function(double key, dynamic value) transform) => entries.map((final entry) => transform(entry.key, entry.value)).toList();
}

extension MapBoolExtension on Map<bool, dynamic> {
  /// Transforms the map into a formatted string representation.
  ///
  /// This is useful for debugging, logging, or displaying map contents.
  ///
  /// Example:
  /// ```dart
  /// final map = {true: 'Thiago', false: 0};
  /// print(map.toFormattedString()); // {true: Thiago, false: 0}
  /// ```
  String toFormattedString() => (this as Map<dynamic, dynamic>).toFormattedString();

  /// Converts a map to a list of strings where each string is in the format "key: value".
  ///
  /// Example:
  /// ```dart
  /// final map = {true: 'Thiago', false: 30};
  /// print(map.toList()); // ['true: Thiago', 'false: 30']
  /// ```
  List<String> toList() => entries.map((final entry) => '${entry.key}: ${entry.value}').toList();

  /// Transforms the map into a list with a custom transform function.
  ///
  /// Example:
  /// ```dart
  /// final map = {true: 'Thiago', false: 30};
  /// final result = map.toListTransform((key, value) => '$key = $value');
  /// print(result); // ['true = Thiago', 'false = 30']
  /// ```
  List<T> toListTransform<T>(final T Function(bool key, dynamic value) transform) => entries.map((final entry) => transform(entry.key, entry.value)).toList();
}

extension MapDateTimeExtension on Map<DateTime, dynamic> {
  /// Transforms the map into a formatted string representation.
  ///
  /// This is useful for debugging, logging, or displaying map contents.
  ///
  /// Example:
  /// ```dart
  /// final map = {DateTime.now(): 'Thiago', DateTime.now().add(Duration(days: 1)): 0};
  /// print(map.toFormattedString()); // {2021-01-01 00:00:00: 000: Thiago, 2021-01-02 00:00:00: 000: 0}
  /// ```
  String toFormattedString() => (this as Map<dynamic, dynamic>).toFormattedString();

  /// Converts a map to a list of strings where each string is in the format "key: value".
  ///
  /// Example:
  /// ```dart
  /// final map = {DateTime.now(): 'Thiago', DateTime.now().add(Duration(days: 1)): 30};
  /// print(map.toList()); // ['2021-01-01 00:00:00.000: Thiago', '2021-01-02 00:00:00.000: 30']
  /// ```
  List<String> toList() => entries.map((final entry) => '${entry.key}: ${entry.value}').toList();

  /// Transforms the map into a list with a custom transform function.
  ///
  /// Example:
  /// ```dart
  /// final map = {DateTime.now(): 'Thiago', DateTime.now().add(Duration(days: 1)): 30};
  /// final result = map.toListTransform((key, value) => '${key.toIso8601String()} = $value');
  /// ```
  List<T> toListTransform<T>(final T Function(DateTime key, dynamic value) transform) =>
      entries.map((final entry) => transform(entry.key, entry.value)).toList();
}

extension MapDurationExtension on Map<Duration, dynamic> {
  /// Transforms the map into a formatted string representation.
  ///
  /// This is useful for debugging, logging, or displaying map contents.
  ///
  /// Example:
  /// ```dart
  /// final map = {Duration(days: 1): 'Thiago', Duration(days: 2): 0};
  /// print(map.toFormattedString()); // {1 day: Thiago, 2 days: 0}
  /// ```
  String toFormattedString() => (this as Map<dynamic, dynamic>).toFormattedString();

  /// Converts a map to a list of strings where each string is in the format "key: value".
  ///
  /// Example:
  /// ```dart
  /// final map = {Duration(days: 1): 'Thiago', Duration(days: 2): 30};
  /// print(map.toList()); // ['1 day: Thiago', '2 days: 30']
  /// ```
  List<String> toList() => entries.map((final entry) => '${entry.key}: ${entry.value}').toList();

  /// Transforms the map into a list with a custom transform function.
  ///
  /// Example:
  /// ```dart
  /// final map = {Duration(days: 1): 'Thiago', Duration(days: 2): 30};
  /// final result = map.toListTransform((key, value) => '${key.inDays} days = $value');
  /// ```
  List<T> toListTransform<T>(final T Function(Duration key, dynamic value) transform) =>
      entries.map((final entry) => transform(entry.key, entry.value)).toList();
}
