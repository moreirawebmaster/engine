import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Map Extensions', () {
    group('MapDynamicExtension', () {
      group('toFormattedString', () {
        test('should format empty map correctly', () {
          // Arrange
          final emptyMap = <dynamic, dynamic>{};

          // Act
          final result = emptyMap.toFormattedString();

          // Assert
          expect(result, equals('{}'));
        });

        test('should format single entry map correctly', () {
          // Arrange
          final singleMap = <dynamic, dynamic>{'name': 'Thiago'};

          // Act
          final result = singleMap.toFormattedString();

          // Assert
          expect(result, equals('{name: Thiago}'));
        });

        test('should format multiple entries map correctly', () {
          // Arrange
          final multiMap = <dynamic, dynamic>{'name': 'Thiago', 'age': 30, 'active': true};

          // Act
          final result = multiMap.toFormattedString();

          // Assert
          expect(result, contains('name: Thiago'));
          expect(result, contains('age: 30'));
          expect(result, contains('active: true'));
          expect(result, startsWith('{'));
          expect(result, endsWith('}'));
        });

        test('should format nested maps correctly', () {
          // Arrange
          final nestedMap = <dynamic, dynamic>{
            'user': {
              'name': 'Thiago',
              'age': 30,
            },
            'config': {
              'theme': 'dark',
            }
          };

          // Act
          final result = nestedMap.toFormattedString();

          // Assert
          expect(result, contains('user: {name: Thiago, age: 30}'));
          expect(result, contains('config: {theme: dark}'));
          expect(result, startsWith('{'));
          expect(result, endsWith('}'));
        });

        test('should handle null values correctly', () {
          // Arrange
          final mapWithNull = <dynamic, dynamic>{'name': 'Thiago', 'middle': null, 'age': 30};

          // Act
          final result = mapWithNull.toFormattedString();

          // Assert
          expect(result, contains('middle: null'));
          expect(result, contains('name: Thiago'));
          expect(result, contains('age: 30'));
        });

        test('should handle complex data types', () {
          // Arrange
          final now = DateTime.now();
          final complexMap = <dynamic, dynamic>{
            'date': now,
            'duration': const Duration(hours: 2),
            'list': [1, 2, 3],
            'number': 42.5,
          };

          // Act
          final result = complexMap.toFormattedString();

          // Assert
          expect(result, contains('date: $now'));
          expect(result, contains('duration: 2:00:00.000000'));
          expect(result, contains('list: [1, 2, 3]'));
          expect(result, contains('number: 42.5'));
        });
      });

      group('toList', () {
        test('should convert empty map to empty list', () {
          // Arrange
          final emptyMap = <dynamic, dynamic>{};

          // Act
          final result = emptyMap.toList();

          // Assert
          expect(result, isEmpty);
          expect(result, isA<List<String>>());
        });

        test('should convert single entry map to list', () {
          // Arrange
          final singleMap = <dynamic, dynamic>{'name': 'Thiago'};

          // Act
          final result = singleMap.toList();

          // Assert
          expect(result, hasLength(1));
          expect(result, contains('name: Thiago'));
        });

        test('should convert multiple entries to list', () {
          // Arrange
          final multiMap = <dynamic, dynamic>{'name': 'Thiago', 'age': 30, 'active': true};

          // Act
          final result = multiMap.toList();

          // Assert
          expect(result, hasLength(3));
          expect(result, containsAll(['name: Thiago', 'age: 30', 'active: true']));
        });

        test('should maintain order for LinkedHashMap', () {
          // Arrange
          final orderedMap = <dynamic, dynamic>{};
          orderedMap['first'] = 1;
          orderedMap['second'] = 2;
          orderedMap['third'] = 3;

          // Act
          final result = orderedMap.toList();

          // Assert
          expect(result, equals(['first: 1', 'second: 2', 'third: 3']));
        });

        test('should handle null and complex values', () {
          // Arrange
          final complexMap = <dynamic, dynamic>{
            'null_value': null,
            'list_value': [1, 2, 3],
            'map_value': {'nested': 'value'},
          };

          // Act
          final result = complexMap.toList();

          // Assert
          expect(result, hasLength(3));
          expect(result, contains('null_value: null'));
          expect(result, contains('list_value: [1, 2, 3]'));
          expect(result, contains('map_value: {nested: value}'));
        });
      });

      group('toListTransform', () {
        test('should transform with custom function', () {
          // Arrange
          final map = <dynamic, dynamic>{'name': 'Thiago', 'age': 30};

          // Act
          final result = map.toListTransform<String>((final key, final value) => '$key = $value');

          // Assert
          expect(result, hasLength(2));
          expect(result, containsAll(['name = Thiago', 'age = 30']));
        });

        test('should transform to different types', () {
          // Arrange
          final map = <dynamic, dynamic>{'a': 1, 'b': 2, 'c': 3};

          // Act
          final result = map.toListTransform<int>((final key, final value) => (value as int) * 2);

          // Assert
          expect(result, isA<List<int>>());
          expect(result, containsAll([2, 4, 6]));
        });

        test('should work with complex transformations', () {
          // Arrange
          final userData = <dynamic, dynamic>{
            'users': ['Thiago', 'Maria'],
            'count': 2,
            'active': true,
          };

          // Act
          final result = userData.toListTransform<Map<String, dynamic>>((final key, final value) => {
                'field': key.toString(),
                'value': value.toString(),
                'type': value.runtimeType.toString(),
              });

          // Assert
          expect(result, hasLength(3));
          expect(result[0], isA<Map<String, dynamic>>());
          expect(result.any((final item) => item['field'] == 'users'), isTrue);
          expect(result.any((final item) => item['field'] == 'count'), isTrue);
          expect(result.any((final item) => item['field'] == 'active'), isTrue);
        });

        test('should handle empty map transform', () {
          // Arrange
          final emptyMap = <dynamic, dynamic>{};

          // Act
          final result = emptyMap.toListTransform<String>((final key, final value) => '$key-$value');

          // Assert
          expect(result, isEmpty);
          expect(result, isA<List<String>>());
        });
      });
    });

    group('MapStringExtension', () {
      group('toFormattedString', () {
        test('should format string key map correctly', () {
          // Arrange
          final stringMap = <String, dynamic>{'name': 'Thiago', 'age': 30};

          // Act
          final result = stringMap.toFormattedString();

          // Assert
          expect(result, equals('{name: Thiago, age: 30}'));
        });

        test('should handle empty string map', () {
          // Arrange
          final emptyMap = <String, dynamic>{};

          // Act
          final result = emptyMap.toFormattedString();

          // Assert
          expect(result, equals('{}'));
        });
      });

      group('toList', () {
        test('should convert string map to list', () {
          // Arrange
          final stringMap = <String, dynamic>{'name': 'Thiago', 'age': 30};

          // Act
          final result = stringMap.toList();

          // Assert
          expect(result, containsAll(['name: Thiago', 'age: 30']));
        });
      });

      group('toListTransform', () {
        test('should transform with string keys', () {
          // Arrange
          final stringMap = <String, dynamic>{'firstName': 'Thiago', 'lastName': 'Moreira'};

          // Act
          final result = stringMap.toListTransform<String>((final key, final value) => '$key=$value');

          // Assert
          expect(result, containsAll(['firstName=Thiago', 'lastName=Moreira']));
        });

        test('should maintain string key type safety', () {
          // Arrange
          final stringMap = <String, dynamic>{'a': 1, 'b': 2};

          // Act
          final result = stringMap.toListTransform<String>((final key, final value) {
            // key is guaranteed to be String here
            expect(key, isA<String>());
            return '${key.toUpperCase()}:$value';
          });

          // Assert
          expect(result, containsAll(['A:1', 'B:2']));
        });
      });
    });

    group('MapIntExtension', () {
      group('toFormattedString', () {
        test('should format int key map correctly', () {
          // Arrange
          final intMap = <int, dynamic>{1: 'First', 2: 'Second'};

          // Act
          final result = intMap.toFormattedString();

          // Assert
          expect(result, equals('{1: First, 2: Second}'));
        });
      });

      group('toList', () {
        test('should convert int map to list', () {
          // Arrange
          final intMap = <int, dynamic>{1: 'First', 2: 'Second'};

          // Act
          final result = intMap.toList();

          // Assert
          expect(result, containsAll(['1: First', '2: Second']));
        });
      });

      group('toListTransform', () {
        test('should transform with int keys', () {
          // Arrange
          final intMap = <int, dynamic>{1: 'One', 2: 'Two'};

          // Act
          final result = intMap.toListTransform<String>((final key, final value) => 'Item $key is $value');

          // Assert
          expect(result, containsAll(['Item 1 is One', 'Item 2 is Two']));
        });

        test('should perform mathematical operations on int keys', () {
          // Arrange
          final intMap = <int, dynamic>{1: 10, 2: 20, 3: 30};

          // Act
          final result = intMap.toListTransform<int>((final key, final value) => key * (value as int));

          // Assert
          expect(result, containsAll([10, 40, 90])); // 1*10, 2*20, 3*30
        });
      });
    });

    group('MapDoubleExtension', () {
      group('toFormattedString', () {
        test('should format double key map correctly', () {
          // Arrange
          final doubleMap = <double, dynamic>{1.5: 'One and half', 2.0: 'Two'};

          // Act
          final result = doubleMap.toFormattedString();

          // Assert
          expect(result, contains('1.5: One and half'));
          expect(result, contains('2.0: Two'));
        });
      });

      group('toList', () {
        test('should convert double map to list', () {
          // Arrange
          final doubleMap = <double, dynamic>{1.5: 'One and half', 2.0: 'Two'};

          // Act
          final result = doubleMap.toList();

          // Assert
          expect(result, containsAll(['1.5: One and half', '2.0: Two']));
        });
      });

      group('toListTransform', () {
        test('should transform with double keys', () {
          // Arrange
          final doubleMap = <double, dynamic>{1.5: 100, 2.5: 200};

          // Act
          final result = doubleMap.toListTransform<double>((final key, final value) => key * (value as int));

          // Assert
          expect(result, containsAll([150.0, 500.0])); // 1.5*100, 2.5*200
        });
      });
    });

    group('MapBoolExtension', () {
      group('toFormattedString', () {
        test('should format bool key map correctly', () {
          // Arrange
          final boolMap = <bool, dynamic>{true: 'Enabled', false: 'Disabled'};

          // Act
          final result = boolMap.toFormattedString();

          // Assert
          expect(result, contains('true: Enabled'));
          expect(result, contains('false: Disabled'));
        });
      });

      group('toList', () {
        test('should convert bool map to list', () {
          // Arrange
          final boolMap = <bool, dynamic>{true: 'Yes', false: 'No'};

          // Act
          final result = boolMap.toList();

          // Assert
          expect(result, containsAll(['true: Yes', 'false: No']));
        });
      });

      group('toListTransform', () {
        test('should transform with bool keys', () {
          // Arrange
          final boolMap = <bool, dynamic>{true: 'Active', false: 'Inactive'};

          // Act
          final result = boolMap.toListTransform<String>((final key, final value) => key ? value.toString().toUpperCase() : value.toString().toLowerCase());

          // Assert
          expect(result, containsAll(['ACTIVE', 'inactive']));
        });
      });
    });

    group('MapDateTimeExtension', () {
      group('toFormattedString', () {
        test('should format DateTime key map correctly', () {
          // Arrange
          final date1 = DateTime(2024, 1, 1);
          final date2 = DateTime(2024, 1, 2);
          final dateMap = <DateTime, dynamic>{date1: 'New Year', date2: 'Second Day'};

          // Act
          final result = dateMap.toFormattedString();

          // Assert
          expect(result, contains('$date1: New Year'));
          expect(result, contains('$date2: Second Day'));
        });
      });

      group('toList', () {
        test('should convert DateTime map to list', () {
          // Arrange
          final date = DateTime(2024, 1, 1);
          final dateMap = <DateTime, dynamic>{date: 'Event'};

          // Act
          final result = dateMap.toList();

          // Assert
          expect(result, contains('$date: Event'));
        });
      });

      group('toListTransform', () {
        test('should transform with DateTime keys', () {
          // Arrange
          final date1 = DateTime(2024, 1, 1);
          final date2 = DateTime(2024, 1, 2);
          final dateMap = <DateTime, dynamic>{date1: 'Event1', date2: 'Event2'};

          // Act
          final result = dateMap.toListTransform<String>((final key, final value) => '${key.toIso8601String()}: $value');

          // Assert
          expect(result, hasLength(2));
          expect(result, contains('${date1.toIso8601String()}: Event1'));
          expect(result, contains('${date2.toIso8601String()}: Event2'));
        });

        test('should work with DateTime operations', () {
          // Arrange
          final now = DateTime.now();
          final tomorrow = now.add(const Duration(days: 1));
          final dateMap = <DateTime, dynamic>{now: 'today', tomorrow: 'tomorrow'};

          // Act
          final result = dateMap.toListTransform<String>((final key, final value) => '${key.day}/${key.month}: $value');

          // Assert
          expect(result, hasLength(2));
          expect(result, contains('${now.day}/${now.month}: today'));
          expect(result, contains('${tomorrow.day}/${tomorrow.month}: tomorrow'));
        });
      });
    });

    group('MapDurationExtension', () {
      group('toFormattedString', () {
        test('should format Duration key map correctly', () {
          // Arrange
          const duration1 = Duration(hours: 1);
          const duration2 = Duration(minutes: 30);
          final durationMap = <Duration, dynamic>{duration1: 'One hour', duration2: 'Half hour'};

          // Act
          final result = durationMap.toFormattedString();

          // Assert
          expect(result, contains('$duration1: One hour'));
          expect(result, contains('$duration2: Half hour'));
        });
      });

      group('toList', () {
        test('should convert Duration map to list', () {
          // Arrange
          const duration = Duration(hours: 2, minutes: 30);
          final durationMap = <Duration, dynamic>{duration: 'Meeting'};

          // Act
          final result = durationMap.toList();

          // Assert
          expect(result, contains('$duration: Meeting'));
        });
      });

      group('toListTransform', () {
        test('should transform with Duration keys', () {
          // Arrange
          const short = Duration(minutes: 15);
          const long = Duration(hours: 2);
          final durationMap = <Duration, dynamic>{short: 'Break', long: 'Meeting'};

          // Act
          final result = durationMap.toListTransform<String>((final key, final value) => '${key.inMinutes} min: $value');

          // Assert
          expect(result, containsAll(['15 min: Break', '120 min: Meeting']));
        });

        test('should work with Duration arithmetic', () {
          // Arrange
          const dur1 = Duration(hours: 1);
          const dur2 = Duration(hours: 2);
          final durationMap = <Duration, dynamic>{dur1: 10, dur2: 20};

          // Act
          final result = durationMap.toListTransform<int>((final key, final value) => key.inHours * (value as int));

          // Assert
          expect(result, containsAll([10, 40])); // 1*10, 2*20
        });
      });
    });

    group('Edge Cases and Integration', () {
      test('should handle very large maps', () {
        // Arrange
        final largeMap = <String, dynamic>{};
        for (var i = 0; i < 1000; i++) {
          largeMap['key$i'] = 'value$i';
        }

        // Act
        final formatted = largeMap.toFormattedString();
        final list = largeMap.toList();
        final transformed = largeMap.toListTransform<String>((final key, final value) => '$key=$value');

        // Assert
        expect(formatted, isNotEmpty);
        expect(list, hasLength(1000));
        expect(transformed, hasLength(1000));
      });

      test('should handle mixed type values consistently', () {
        // Arrange
        final mixedMap = <String, dynamic>{
          'string': 'text',
          'int': 42,
          'double': 3.14,
          'bool': true,
          'null': null,
          'list': [1, 2, 3],
          'map': {'nested': 'value'},
        };

        // Act
        final formatted = mixedMap.toFormattedString();
        final list = mixedMap.toList();

        // Assert
        expect(formatted, contains('string: text'));
        expect(formatted, contains('int: 42'));
        expect(formatted, contains('double: 3.14'));
        expect(formatted, contains('bool: true'));
        expect(formatted, contains('null: null'));
        expect(list, hasLength(7));
      });

      test('should maintain referential integrity in transforms', () {
        // Arrange
        final original = <String, dynamic>{'a': 1, 'b': 2};

        // Act
        final transformed = original.toListTransform<Map<String, dynamic>>((final key, final value) => {
              'original_key': key,
              'original_value': value,
              'computed': (value as int) * 2,
            });

        // Assert
        expect(transformed, hasLength(2));
        for (final item in transformed) {
          expect(item, containsPair('computed', item['original_value'] * 2));
        }
      });
    });
  });
}
