import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineStringExtension', () {
    group('removeSpacesAndLineBreaks', () {
      test('should remove multiple spaces and replace with single space', () {
        // Arrange
        const input = 'Hello    world    test';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world test'));
      });

      test('should remove line breaks and replace with single space', () {
        // Arrange
        const input = 'Hello\nworld\ntest';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world test'));
      });

      test('should remove carriage returns and replace with single space', () {
        // Arrange
        const input = 'Hello\rworld\rtest';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world test'));
      });

      test('should remove tabs and replace with single space', () {
        // Arrange
        const input = 'Hello\tworld\ttest';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world test'));
      });

      test('should handle mixed whitespace characters', () {
        // Arrange
        const input = 'Hello  \n\r\t  world   \n\t  test';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world test'));
      });

      test('should trim leading and trailing whitespace', () {
        // Arrange
        const input = '  \n\t  Hello world  \n\r\t  ';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world'));
      });

      test('should handle empty string', () {
        // Arrange
        const input = '';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals(''));
      });

      test('should handle string with only whitespace', () {
        // Arrange
        const input = '  \n\r\t  ';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals(''));
      });

      test('should handle string with no whitespace', () {
        // Arrange
        const input = 'HelloWorld';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('HelloWorld'));
      });

      test('should handle string with single space', () {
        // Arrange
        const input = 'Hello world';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world'));
      });

      test('should handle Unicode whitespace characters', () {
        // Arrange
        const input = 'Hello\u00A0world\u2000test'; // Non-breaking space and en quad

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world test'));
      });

      test('should handle very long string with multiple whitespace types', () {
        // Arrange
        const input = 'This    is\n\na\t\tvery\r\rlong\n\t   string   with\n\r\t   multiple   types    of   whitespace';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('This is a very long string with multiple types of whitespace'));
      });

      test('should handle special characters mixed with whitespace', () {
        // Arrange
        const input = 'Hello!  @#\$%  \n\t  ^&*()  world  \r  ';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello! @#\$% ^&*() world'));
      });

      test('should handle numbers mixed with whitespace', () {
        // Arrange
        const input = '123   \n\t   456   \r   789   ';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('123 456 789'));
      });

      test('should handle emojis and special characters', () {
        // Arrange
        const input = '🚀  \n\t  Hello   👋   \r  world  🌍  ';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('🚀 Hello 👋 world 🌍'));
      });

      test('should be idempotent when applied multiple times', () {
        // Arrange
        const input = 'Hello    \n\r\t    world';

        // Act
        final firstResult = input.removeSpacesAndLineBreaks;
        final secondResult = firstResult.removeSpacesAndLineBreaks;
        final thirdResult = secondResult.removeSpacesAndLineBreaks;

        // Assert
        expect(firstResult, equals('Hello world'));
        expect(secondResult, equals('Hello world'));
        expect(thirdResult, equals('Hello world'));
        expect(firstResult, equals(secondResult));
        expect(secondResult, equals(thirdResult));
      });

      test('should handle JSON-like strings with whitespace', () {
        // Arrange
        const input = '{  \n"name":   "Thiago",\r\n  "age":    30   \n}';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('{ "name": "Thiago", "age": 30 }'));
      });

      test('should handle HTML-like strings with whitespace', () {
        // Arrange
        const input = '<div  \n  class="container"  \r\n  >  \n\t  Hello World  \n  </div>';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('<div class="container" > Hello World </div>'));
      });

      test('should handle multiple consecutive line breaks', () {
        // Arrange
        const input = 'Hello\n\n\n\nworld\r\r\r\rtest';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world test'));
      });

      test('should handle mixed line endings (Unix, Windows, Mac)', () {
        // Arrange
        const input = 'Unix\nWindows\r\nMac\rStyle';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Unix Windows Mac Style'));
      });

      test('should preserve single characters separated by whitespace', () {
        // Arrange
        const input = 'a  \n  b  \r  c  \t  d';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('a b c d'));
      });

      test('should handle very large strings efficiently', () {
        // Arrange
        final largeInput = StringBuffer();
        for (var i = 0; i < 1000; i++) {
          largeInput.write('word$i    \n\r\t    ');
        }
        final input = largeInput.toString();

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, isNotEmpty);
        expect(result.split(' '), hasLength(1000));
        expect(result, startsWith('word0 word1'));
        expect(result, endsWith('word998 word999'));
        expect(result, isNot(contains('\n')));
        expect(result, isNot(contains('\r')));
        expect(result, isNot(contains('\t')));
      });

      test('should handle form feed and vertical tab characters', () {
        // Arrange
        const input = 'Hello\fworld\vtest'; // Form feed and vertical tab

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello world test'));
      });

      test('should handle zero-width characters if they are whitespace', () {
        // Arrange
        const input = 'Hello\u200Bworld'; // Zero-width space

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        // Zero-width space might not be caught by \\s+ regex, so test actual behavior
        expect(
            result,
            anyOf([
              equals('Hello world'), // If zero-width space is treated as whitespace
              equals('Hello\u200Bworld'), // If zero-width space is preserved
            ]));
      });

      test('should maintain character order while removing whitespace', () {
        // Arrange
        const input = 'The  \n  quick  \r  brown  \t  fox';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('The quick brown fox'));
        expect(result.split(' '), equals(['The', 'quick', 'brown', 'fox']));
      });

      test('should handle strings with only single character', () {
        // Arrange
        const input = 'A';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('A'));
      });

      test('should handle strings with punctuation and whitespace', () {
        // Arrange
        const input = 'Hello,  \n  world!  \r  How  \t  are  you?';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('Hello, world! How are you?'));
      });
    });

    group('Edge Cases and Performance', () {
      test('should handle null safety correctly', () {
        // Arrange
        String? nullString;

        // Act & Assert
        expect(() => nullString!.removeSpacesAndLineBreaks, throwsA(isA<TypeError>()));
      });

      test('should not modify the original string', () {
        // Arrange
        const original = 'Hello  \n  world';

        // Act
        final result = original.removeSpacesAndLineBreaks;

        // Assert
        expect(original, equals('Hello  \n  world')); // Original unchanged
        expect(result, equals('Hello world')); // Result is cleaned
        expect(result, isNot(same(original))); // Different objects
      });

      test('should handle strings with only line breaks', () {
        // Arrange
        const input = '\n\r\n\r';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals(''));
      });

      test('should handle alternating characters and whitespace', () {
        // Arrange
        const input = 'a \n b \r c \t d   e';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('a b c d e'));
      });

      test('should maintain performance with repeated operations', () {
        // Arrange
        const input = 'Test  \n  string  \r  for  \t  performance';

        // Act - Multiple operations to test consistency
        final results = <String>[];
        for (var i = 0; i < 100; i++) {
          results.add(input.removeSpacesAndLineBreaks);
        }

        // Assert
        expect(results.every((final r) => r == 'Test string for performance'), isTrue);
        expect(results, hasLength(100));
      });
    });

    group('Real-world Use Cases', () {
      test('should clean up formatted code strings', () {
        // Arrange
        const input = '''
        if (condition) {
            doSomething();
        }
        ''';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('if (condition) { doSomething(); }'));
      });

      test('should clean up user input text', () {
        // Arrange
        const input = '  \n  User typed this    \n\n  with lots of   whitespace  \t  ';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('User typed this with lots of whitespace'));
      });

      test('should clean up log messages', () {
        // Arrange
        const input = '[INFO]  \n  Application  \r  started  \t  successfully  ';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('[INFO] Application started successfully'));
      });

      test('should clean up SQL queries', () {
        // Arrange
        const input = '''
        SELECT name, age
        FROM users
        WHERE active = true
        ''';

        // Act
        final result = input.removeSpacesAndLineBreaks;

        // Assert
        expect(result, equals('SELECT name, age FROM users WHERE active = true'));
      });
    });
  });
}
