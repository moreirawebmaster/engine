import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Map Extensions', () {
    group('MapDynamicExtension - Map<dynamic, dynamic>', () {
      group('toFormattedString()', () {
        test('should return empty braces for empty map', () {
          // Arrange
          final map = <dynamic, dynamic>{};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{}'));
        });

        test('should format single entry map correctly', () {
          // Arrange
          final map = <dynamic, dynamic>{'name': 'Thiago'};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{name: Thiago}'));
        });

        test('should format multiple entries map correctly', () {
          // Arrange
          final map = <dynamic, dynamic>{'name': 'Thiago', 'age': 30};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{name: Thiago, age: 30}'));
        });

        test('should handle nested maps recursively', () {
          // Arrange
          final map = <dynamic, dynamic>{
            'user': {'name': 'Thiago', 'age': 30},
            'active': true,
          };

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{user: {name: Thiago, age: 30}, active: true}'));
        });

        test('should handle various data types', () {
          // Arrange
          final map = <dynamic, dynamic>{
            'string': 'text',
            'number': 42,
            'boolean': true,
            'null': null,
            'list': [1, 2, 3],
          };

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, contains('string: text'));
          expect(result, contains('number: 42'));
          expect(result, contains('boolean: true'));
          expect(result, contains('null: null'));
          expect(result, contains('list: [1, 2, 3]'));
        });

        test('should handle mixed key types', () {
          // Arrange
          final map = <dynamic, dynamic>{
            1: 'number key',
            'text': 'string key',
            true: 'boolean key',
          };

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, contains('1: number key'));
          expect(result, contains('text: string key'));
          expect(result, contains('true: boolean key'));
        });

        test('should handle deeply nested maps', () {
          // Arrange
          final map = <dynamic, dynamic>{
            'level1': {
              'level2': {'level3': 'deep value'}
            }
          };

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{level1: {level2: {level3: deep value}}}'));
        });
      });

      group('toList()', () {
        test('should return empty list for empty map', () {
          // Arrange
          final map = <dynamic, dynamic>{};

          // Act
          final result = map.toList();

          // Assert
          expect(result, isEmpty);
          expect(result, isA<List<String>>());
        });

        test('should convert single entry to list', () {
          // Arrange
          final map = <dynamic, dynamic>{'name': 'Thiago'};

          // Act
          final result = map.toList();

          // Assert
          expect(result, equals(['name: Thiago']));
        });

        test('should convert multiple entries to list', () {
          // Arrange
          final map = <dynamic, dynamic>{'name': 'Thiago', 'age': 30};

          // Act
          final result = map.toList();

          // Assert
          expect(result, hasLength(2));
          expect(result, contains('name: Thiago'));
          expect(result, contains('age: 30'));
        });

        test('should handle various data types in values', () {
          // Arrange
          final map = <dynamic, dynamic>{
            'string': 'text',
            'number': 42,
            'boolean': true,
            'null': null,
          };

          // Act
          final result = map.toList();

          // Assert
          expect(result, contains('string: text'));
          expect(result, contains('number: 42'));
          expect(result, contains('boolean: true'));
          expect(result, contains('null: null'));
        });

        test('should handle mixed key types', () {
          // Arrange
          final map = <dynamic, dynamic>{
            1: 'number',
            'text': 'string',
            true: 'boolean',
          };

          // Act
          final result = map.toList();

          // Assert
          expect(result, contains('1: number'));
          expect(result, contains('text: string'));
          expect(result, contains('true: boolean'));
        });
      });

      group('toListTransform()', () {
        test('should transform empty map to empty list', () {
          // Arrange
          final map = <dynamic, dynamic>{};

          // Act
          final result = map.toListTransform<String>((final key, final value) => '$key=$value');

          // Assert
          expect(result, isEmpty);
          expect(result, isA<List<String>>());
        });

        test('should transform with custom function', () {
          // Arrange
          final map = <dynamic, dynamic>{'name': 'Thiago', 'age': 30};

          // Act
          final result = map.toListTransform<String>((final key, final value) => '$key=$value');

          // Assert
          expect(result, hasLength(2));
          expect(result, contains('name=Thiago'));
          expect(result, contains('age=30'));
        });

        test('should support different return types', () {
          // Arrange
          final map = <dynamic, dynamic>{'a': 1, 'b': 2, 'c': 3};

          // Act
          final result = map.toListTransform<int>((final key, final value) => value * 2);

          // Assert
          expect(result, isA<List<int>>());
          expect(result, contains(2));
          expect(result, contains(4));
          expect(result, contains(6));
        });

        test('should handle complex transformations', () {
          // Arrange
          final map = <dynamic, dynamic>{'item1': 10, 'item2': 20};

          // Act
          final result = map.toListTransform<Map<String, dynamic>>((final key, final value) => {
                'key': key.toString().toUpperCase(),
                'value': value * 3,
                'processed': true,
              });

          // Assert
          expect(result, hasLength(2));
          expect(result.first, isA<Map<String, dynamic>>());
          expect(result.any((final item) => item['key'] == 'ITEM1'), isTrue);
          expect(result.any((final item) => item['value'] == 30), isTrue);
        });

        test('should handle null values in transformation', () {
          // Arrange
          final map = <dynamic, dynamic>{'null_value': null, 'valid_value': 42};

          // Act
          final result = map.toListTransform<String>((final key, final value) => '$key: ${value ?? "DEFAULT"}');

          // Assert
          expect(result, contains('null_value: DEFAULT'));
          expect(result, contains('valid_value: 42'));
        });
      });
    });

    group('MapStringExtension - Map<String, dynamic>', () {
      group('toFormattedString()', () {
        test('should delegate to MapDynamicExtension', () {
          // Arrange
          final map = <String, dynamic>{'name': 'Thiago', 'age': 30};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{name: Thiago, age: 30}'));
        });

        test('should handle empty map', () {
          // Arrange
          final map = <String, dynamic>{};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{}'));
        });

        test('should handle nested objects', () {
          // Arrange
          final map = <String, dynamic>{
            'user': {'name': 'Thiago'},
            'settings': {'theme': 'dark'},
          };

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, contains('user: {name: Thiago}'));
          expect(result, contains('settings: {theme: dark}'));
        });
      });

      group('toList()', () {
        test('should convert string keys correctly', () {
          // Arrange
          final map = <String, dynamic>{'name': 'Thiago', 'age': 30};

          // Act
          final result = map.toList();

          // Assert
          expect(result, hasLength(2));
          expect(result, contains('name: Thiago'));
          expect(result, contains('age: 30'));
        });

        test('should handle empty map', () {
          // Arrange
          final map = <String, dynamic>{};

          // Act
          final result = map.toList();

          // Assert
          expect(result, isEmpty);
        });

        test('should handle various value types', () {
          // Arrange
          final map = <String, dynamic>{
            'string': 'text',
            'number': 42,
            'boolean': true,
            'list': [1, 2, 3],
            'map': {'nested': 'value'},
          };

          // Act
          final result = map.toList();

          // Assert
          expect(result, hasLength(5));
          expect(result.any((final item) => item.contains('string: text')), isTrue);
          expect(result.any((final item) => item.contains('number: 42')), isTrue);
          expect(result.any((final item) => item.contains('boolean: true')), isTrue);
        });
      });

      group('toListTransform()', () {
        test('should transform with typed keys', () {
          // Arrange
          final map = <String, dynamic>{'firstName': 'Thiago', 'lastName': 'Moreira'};

          // Act
          final result = map.toListTransform<String>((final key, final value) => '${key.toUpperCase()}: ${value.toString().toUpperCase()}');

          // Assert
          expect(result, contains('FIRSTNAME: THIAGO'));
          expect(result, contains('LASTNAME: MOREIRA'));
        });

        test('should handle string-specific operations', () {
          // Arrange
          final map = <String, dynamic>{'email': 'test@example.com', 'phone': '123456789'};

          // Act
          final result = map.toListTransform<bool>((final key, final value) => key.contains('email') || value.toString().contains('@'));

          // Assert
          expect(result, contains(true)); // email key and email value
          expect(result, contains(false)); // phone
        });

        test('should support complex string transformations', () {
          // Arrange
          final map = <String, dynamic>{'user_name': 'thiago', 'user_age': 30};

          // Act
          final result = map.toListTransform<String>((final key, final value) {
            final cleanKey = key.replaceAll('_', ' ').split(' ').map((final word) => word[0].toUpperCase() + word.substring(1)).join(' ');
            return '$cleanKey: $value';
          });

          // Assert
          expect(result, contains('User Name: thiago'));
          expect(result, contains('User Age: 30'));
        });
      });
    });

    group('MapIntExtension - Map<int, dynamic>', () {
      group('toFormattedString()', () {
        test('should handle integer keys', () {
          // Arrange
          final map = <int, dynamic>{1: 'first', 2: 'second'};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{1: first, 2: second}'));
        });

        test('should handle negative keys', () {
          // Arrange
          final map = <int, dynamic>{-1: 'negative', 0: 'zero', 1: 'positive'};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, contains('-1: negative'));
          expect(result, contains('0: zero'));
          expect(result, contains('1: positive'));
        });
      });

      group('toList()', () {
        test('should convert integer keys correctly', () {
          // Arrange
          final map = <int, dynamic>{1: 'Thiago', 2: 30};

          // Act
          final result = map.toList();

          // Assert
          expect(result, contains('1: Thiago'));
          expect(result, contains('2: 30'));
        });

        test('should handle large numbers', () {
          // Arrange
          final map = <int, dynamic>{1000000: 'million', -999999: 'negative'};

          // Act
          final result = map.toList();

          // Assert
          expect(result, contains('1000000: million'));
          expect(result, contains('-999999: negative'));
        });
      });

      group('toListTransform()', () {
        test('should transform with integer keys', () {
          // Arrange
          final map = <int, dynamic>{1: 'first', 2: 'second'};

          // Act
          final result = map.toListTransform<String>((final key, final value) => 'Item ${key * 10}: $value');

          // Assert
          expect(result, contains('Item 10: first'));
          expect(result, contains('Item 20: second'));
        });

        test('should support mathematical operations on keys', () {
          // Arrange
          final map = <int, dynamic>{2: 'two', 4: 'four', 6: 'six'};

          // Act
          final result = map.toListTransform<bool>((final key, final value) => key % 2 == 0);

          // Assert
          expect(result, everyElement(isTrue)); // All keys are even
        });

        test('should handle key ranges and conditions', () {
          // Arrange
          final map = <int, dynamic>{5: 'five', 15: 'fifteen', 25: 'twenty-five'};

          // Act
          final result = map.toListTransform<String>((final key, final value) {
            if (key < 10) {
              return 'single digit: $value';
            }
            if (key < 20) {
              return 'teens: $value';
            }
            return 'twenties+: $value';
          });

          // Assert
          expect(result, contains('single digit: five'));
          expect(result, contains('teens: fifteen'));
          expect(result, contains('twenties+: twenty-five'));
        });
      });
    });

    group('MapDoubleExtension - Map<double, dynamic>', () {
      group('toFormattedString()', () {
        test('should handle double keys', () {
          // Arrange
          final map = <double, dynamic>{1.5: 'one and half', 2.7: 'two point seven'};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, contains('1.5: one and half'));
          expect(result, contains('2.7: two point seven'));
        });

        test('should handle precision edge cases', () {
          // Arrange
          final map = <double, dynamic>{0.1: 'point one', 1000.0: 'thousand'};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, contains('0.1: point one'));
          expect(result, contains('1000.0: thousand'));
        });
      });

      group('toList()', () {
        test('should convert double keys correctly', () {
          // Arrange
          final map = <double, dynamic>{3.14: 'pi', 2.71: 'euler'};

          // Act
          final result = map.toList();

          // Assert
          expect(result, contains('3.14: pi'));
          expect(result, contains('2.71: euler'));
        });

        test('should handle negative doubles', () {
          // Arrange
          final map = <double, dynamic>{-1.5: 'negative', 0.0: 'zero'};

          // Act
          final result = map.toList();

          // Assert
          expect(result, contains('-1.5: negative'));
          expect(result, contains('0.0: zero'));
        });
      });

      group('toListTransform()', () {
        test('should transform with double precision operations', () {
          // Arrange
          final map = <double, dynamic>{1.5: 'data', 2.5: 'more data'};

          // Act
          final result = map.toListTransform<double>((final key, final value) => key * 2);

          // Assert
          expect(result, contains(3.0));
          expect(result, contains(5.0));
        });

        test('should handle rounding and formatting', () {
          // Arrange
          final map = <double, dynamic>{3.14159: 'pi', 2.71828: 'e'};

          // Act
          final result = map.toListTransform<String>((final key, final value) => '${key.toStringAsFixed(2)}: $value');

          // Assert
          expect(result, contains('3.14: pi'));
          expect(result, contains('2.72: e'));
        });

        test('should support range checks on double keys', () {
          // Arrange
          final map = <double, dynamic>{0.5: 'half', 1.0: 'one', 1.5: 'one and half'};

          // Act
          final result = map.toListTransform<bool>((final key, final value) => key >= 1.0);

          // Assert
          expect(result[0], isFalse); // 0.5
          expect(result[1], isTrue); // 1.0
          expect(result[2], isTrue); // 1.5
        });
      });
    });

    group('MapBoolExtension - Map<bool, dynamic>', () {
      group('toFormattedString()', () {
        test('should handle boolean keys', () {
          // Arrange
          final map = <bool, dynamic>{true: 'enabled', false: 'disabled'};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{true: enabled, false: disabled}'));
        });

        test('should handle single boolean key', () {
          // Arrange
          final map = <bool, dynamic>{true: 'active'};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, equals('{true: active}'));
        });
      });

      group('toList()', () {
        test('should convert boolean keys correctly', () {
          // Arrange
          final map = <bool, dynamic>{true: 'yes', false: 'no'};

          // Act
          final result = map.toList();

          // Assert
          expect(result, contains('true: yes'));
          expect(result, contains('false: no'));
        });

        test('should handle complex values with boolean keys', () {
          // Arrange
          final map = <bool, dynamic>{
            true: {'status': 'active', 'count': 5},
            false: {'status': 'inactive', 'count': 0},
          };

          // Act
          final result = map.toList();

          // Assert
          expect(result, hasLength(2));
          expect(result.any((final item) => item.startsWith('true:')), isTrue);
          expect(result.any((final item) => item.startsWith('false:')), isTrue);
        });
      });

      group('toListTransform()', () {
        test('should transform with boolean logic', () {
          // Arrange
          final map = <bool, dynamic>{true: 'enabled', false: 'disabled'};

          // Act
          final result = map.toListTransform<String>((final key, final value) => key ? 'Active: $value' : 'Inactive: $value');

          // Assert
          expect(result, contains('Active: enabled'));
          expect(result, contains('Inactive: disabled'));
        });

        test('should invert boolean keys', () {
          // Arrange
          final map = <bool, dynamic>{true: 'on', false: 'off'};

          // Act
          final result = map.toListTransform<bool>((final key, final value) => !key);

          // Assert
          expect(result, contains(false)); // !true
          expect(result, contains(true)); // !false
        });

        test('should handle conditional transformations', () {
          // Arrange
          final map = <bool, dynamic>{true: 100, false: 50};

          // Act
          final result = map.toListTransform<int>((final key, final value) => key ? value * 2 : value ~/ 2);

          // Assert
          expect(result, contains(200)); // true: 100 * 2
          expect(result, contains(25)); // false: 50 / 2
        });
      });
    });

    group('MapDateTimeExtension - Map<DateTime, dynamic>', () {
      group('toFormattedString()', () {
        test('should handle DateTime keys', () {
          // Arrange
          final date1 = DateTime(2023, 1, 1);
          final date2 = DateTime(2023, 12, 31);
          final map = <DateTime, dynamic>{date1: 'new year', date2: 'year end'};

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, contains('2023-01-01 00:00:00.000: new year'));
          expect(result, contains('2023-12-31 00:00:00.000: year end'));
        });
      });

      group('toList()', () {
        test('should convert DateTime keys correctly', () {
          // Arrange
          final date = DateTime(2023, 6, 15, 10, 30);
          final map = <DateTime, dynamic>{date: 'mid year'};

          // Act
          final result = map.toList();

          // Assert
          expect(result, hasLength(1));
          expect(result.first, contains('2023-06-15 10:30:00.000: mid year'));
        });

        test('should handle multiple DateTime entries', () {
          // Arrange
          final map = <DateTime, dynamic>{
            DateTime(2023, 1, 1): 'start',
            DateTime(2023, 6, 15): 'middle',
            DateTime(2023, 12, 31): 'end',
          };

          // Act
          final result = map.toList();

          // Assert
          expect(result, hasLength(3));
          expect(result.any((final item) => item.contains('start')), isTrue);
          expect(result.any((final item) => item.contains('middle')), isTrue);
          expect(result.any((final item) => item.contains('end')), isTrue);
        });
      });

      group('toListTransform()', () {
        test('should transform DateTime with custom formatting', () {
          // Arrange
          final map = <DateTime, dynamic>{
            DateTime(2023, 1, 1): 'event1',
            DateTime(2023, 6, 15): 'event2',
          };

          // Act
          final result = map.toListTransform<String>((final key, final value) => '${key.year}-${key.month.toString().padLeft(2, '0')}: $value');

          // Assert
          expect(result, contains('2023-01: event1'));
          expect(result, contains('2023-06: event2'));
        });

        test('should filter by date ranges', () {
          // Arrange
          final map = <DateTime, dynamic>{
            DateTime(2022, 12, 31): 'old',
            DateTime(2023, 6, 15): 'current',
            DateTime(2024, 1, 1): 'future',
          };

          // Act
          final result = map.toListTransform<bool>((final key, final value) => key.year == 2023);

          // Assert
          expect(result, contains(false)); // 2022
          expect(result, contains(true)); // 2023
          expect(result, contains(false)); // 2024
        });

        test('should calculate date differences', () {
          // Arrange
          final baseDate = DateTime(2023, 1, 1);
          final map = <DateTime, dynamic>{
            DateTime(2023, 1, 1): 'day0',
            DateTime(2023, 1, 8): 'day7',
            DateTime(2023, 1, 15): 'day14',
          };

          // Act
          final result = map.toListTransform<int>((final key, final value) => key.difference(baseDate).inDays);

          // Assert
          expect(result, contains(0)); // same day
          expect(result, contains(7)); // 7 days later
          expect(result, contains(14)); // 14 days later
        });
      });
    });

    group('MapDurationExtension - Map<Duration, dynamic>', () {
      group('toFormattedString()', () {
        test('should handle Duration keys', () {
          // Arrange
          final map = <Duration, dynamic>{
            const Duration(days: 1): 'one day',
            const Duration(hours: 2): 'two hours',
          };

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, contains('24:00:00.000000: one day'));
          expect(result, contains('2:00:00.000000: two hours'));
        });

        test('should handle various duration formats', () {
          // Arrange
          final map = <Duration, dynamic>{
            const Duration(milliseconds: 500): 'half second',
            const Duration(minutes: 30): 'half hour',
            const Duration(days: 7): 'one week',
          };

          // Act
          final result = map.toFormattedString();

          // Assert
          expect(result, contains('0:00:00.500000: half second'));
          expect(result, contains('0:30:00.000000: half hour'));
          expect(result, contains('168:00:00.000000: one week'));
        });
      });

      group('toList()', () {
        test('should convert Duration keys correctly', () {
          // Arrange
          final map = <Duration, dynamic>{
            const Duration(minutes: 5): 'short',
            const Duration(hours: 1): 'medium',
          };

          // Act
          final result = map.toList();

          // Assert
          expect(result, contains('0:05:00.000000: short'));
          expect(result, contains('1:00:00.000000: medium'));
        });

        test('should handle zero and negative durations', () {
          // Arrange
          final map = <Duration, dynamic>{
            Duration.zero: 'instant',
            const Duration(seconds: -30): 'past',
          };

          // Act
          final result = map.toList();

          // Assert
          expect(result, contains('0:00:00.000000: instant'));
          expect(result, contains('-0:00:30.000000: past'));
        });
      });

      group('toListTransform()', () {
        test('should transform Duration to meaningful units', () {
          // Arrange
          final map = <Duration, dynamic>{
            const Duration(seconds: 30): 'short',
            const Duration(minutes: 5): 'medium',
            const Duration(hours: 2): 'long',
          };

          // Act
          final result = map.toListTransform<String>((final key, final value) {
            if (key.inHours > 0) {
              return '${key.inHours}h: $value';
            }
            if (key.inMinutes > 0) {
              return '${key.inMinutes}m: $value';
            }
            return '${key.inSeconds}s: $value';
          });

          // Assert
          expect(result, contains('30s: short'));
          expect(result, contains('5m: medium'));
          expect(result, contains('2h: long'));
        });

        test('should compare durations', () {
          // Arrange
          const threshold = Duration(minutes: 10);
          final map = <Duration, dynamic>{
            const Duration(minutes: 5): 'quick',
            const Duration(minutes: 15): 'slow',
            const Duration(hours: 1): 'very slow',
          };

          // Act
          final result = map.toListTransform<bool>((final key, final value) => key > threshold);

          // Assert
          expect(result, contains(false)); // 5 minutes
          expect(result, contains(true)); // 15 minutes
          expect(result, contains(true)); // 1 hour
        });

        test('should calculate duration ratios', () {
          // Arrange
          const baseUnit = Duration(minutes: 1);
          final map = <Duration, dynamic>{
            const Duration(seconds: 30): 'half',
            const Duration(minutes: 1): 'base',
            const Duration(minutes: 2): 'double',
          };

          // Act
          final result = map.toListTransform<double>((final key, final value) => key.inMilliseconds / baseUnit.inMilliseconds);

          // Assert
          expect(result, contains(0.5)); // 30s / 1m
          expect(result, contains(1.0)); // 1m / 1m
          expect(result, contains(2.0)); // 2m / 1m
        });
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle null values in maps', () {
        // Arrange
        final map = <String, dynamic>{
          'null_value': null,
          'empty_string': '',
          'zero': 0,
          'false': false,
        };

        // Act & Assert
        expect(() => map.toFormattedString(), returnsNormally);
        expect(() => map.toList(), returnsNormally);
        expect(() => map.toListTransform((final k, final v) => '$k:$v'), returnsNormally);
      });

      test('should handle very large maps efficiently', () {
        // Arrange
        final largeMap = <int, String>{};
        for (var i = 0; i < 1000; i++) {
          largeMap[i] = 'value_$i';
        }

        // Act & Assert
        expect(() => largeMap.toFormattedString(), returnsNormally);
        expect(() => largeMap.toList(), returnsNormally);
        expect(largeMap.toList(), hasLength(1000));
      });

      test('should handle special characters in keys and values', () {
        // Arrange
        final map = <String, dynamic>{
          'special!@#\$%^&*()': 'special value',
          'unicode_🚀_test': 'rocket ship',
          'newlines\nand\ttabs': 'formatted text',
        };

        // Act & Assert
        expect(() => map.toFormattedString(), returnsNormally);
        expect(() => map.toList(), returnsNormally);

        final result = map.toList();
        expect(result.any((final item) => item.contains('🚀')), isTrue);
        expect(result.any((final item) => item.contains('special!@#')), isTrue);
      });

      test('should handle deeply nested structures', () {
        // Arrange
        final deepMap = <String, dynamic>{'level_0': {}};
        var current = deepMap['level_0'] as Map<String, dynamic>;

        for (var i = 1; i <= 10; i++) {
          current['level_$i'] = <String, dynamic>{};
          current = current['level_$i'] as Map<String, dynamic>;
        }
        current['final_value'] = 'deep!';

        // Act & Assert
        expect(() => deepMap.toFormattedString(), returnsNormally);
        expect(() => deepMap.toList(), returnsNormally);

        final formatted = deepMap.toFormattedString();
        expect(formatted, contains('final_value: deep!'));
      });

      test('should handle circular references gracefully', () {
        // Arrange
        final map1 = <String, dynamic>{'name': 'map1'};
        final map2 = <String, dynamic>{'name': 'map2', 'ref': map1};
        map1['ref'] = map2; // Create circular reference

        // Act & Assert - Should not cause infinite recursion
        expect(() => map1.toList(), returnsNormally);
        expect(() => map2.toList(), returnsNormally);

        // The toString() method of Map should handle this
        final result = map1.toList();
        expect(result, isNotEmpty);
      });
    });

    group('Performance and Memory', () {
      test('should handle repeated operations efficiently', () {
        // Arrange
        final map = <String, int>{'a': 1, 'b': 2, 'c': 3};

        // Act & Assert - Multiple operations should not cause issues
        for (var i = 0; i < 100; i++) {
          expect(map.toFormattedString(), isA<String>());
          expect(map.toList(), hasLength(3));
          expect(map.toListTransform((final k, final v) => k), hasLength(3));
        }
      });

      test('should maintain memory efficiency with transformations', () {
        // Arrange
        final map = <int, String>{1: 'one', 2: 'two', 3: 'three'};

        // Act - Multiple transformations with different types
        final stringResults = map.toListTransform<String>((final k, final v) => '$k:$v');
        final intResults = map.toListTransform<int>((final k, final v) => k * 2);
        final boolResults = map.toListTransform<bool>((final k, final v) => k > 2);

        // Assert
        expect(stringResults, hasLength(3));
        expect(intResults, hasLength(3));
        expect(boolResults, hasLength(3));
        expect(stringResults, isA<List<String>>());
        expect(intResults, isA<List<int>>());
        expect(boolResults, isA<List<bool>>());
      });
    });
  });
}
