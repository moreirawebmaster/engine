import 'dart:convert';

import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_utils.dart';

void main() {
  group('EngineUserModel', () {
    late Map<String, dynamic> validUserData;
    late Map<String, dynamic> invalidUserData;

    setUpAll(() {
      // Using fixed data instead of TestUtils to avoid incremental IDs
      validUserData = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'imageUrl': 'https://example.com/avatar.jpg',
        'permissions': ['read', 'write'],
      };
      invalidUserData = TestUtils.createInvalidUserData();
    });

    group('Factory Constructors', () {
      test('should create user from valid map data', () {
        // Act
        final user = EngineUserModel.fromMap(validUserData);

        // Assert
        expect(user.id, equals(1));
        expect(user.name, equals('Test User'));
        expect(user.email, equals('test@example.com'));
        expect(user.imageUrl, equals('https://example.com/avatar.jpg'));
        expect(user.permissions, equals(['read', 'write']));
      });

      test('should create user from JSON string', () {
        // Arrange
        final jsonString = json.encode(validUserData);

        // Act
        final user = EngineUserModel.fromJson(jsonString);

        // Assert
        expect(user.id, equals(1));
        expect(user.name, equals('Test User'));
        expect(user.email, equals('test@example.com'));
        expect(user.permissions, equals(['read', 'write']));
      });

      test('should create empty user with default values', () {
        // Act
        final user = EngineUserModel.empty();

        // Assert
        expect(user.id, equals(0));
        expect(user.name, equals(''));
        expect(user.email, equals(''));
        expect(user.imageUrl, equals('')); // Empty string when created from empty map
        expect(user.permissions, isEmpty);
      });

      test('should handle missing fields gracefully', () {
        // Arrange
        final incompleteData = <String, dynamic>{
          'id': 2,
          'name': 'Partial User',
          // Missing email, imageUrl, permissions
        };

        // Act
        final user = EngineUserModel.fromMap(incompleteData);

        // Assert
        expect(user.id, equals(2));
        expect(user.name, equals('Partial User'));
        expect(user.email, equals('')); // Default value
        expect(user.imageUrl, equals('')); // Default value
        expect(user.permissions, isEmpty); // Default value
      });

      test('should handle null values', () {
        // Act
        final user = EngineUserModel.fromMap(invalidUserData);

        // Assert
        expect(user.id, equals(0)); // null converted to 0
        expect(user.name, equals(''));
        expect(user.email, equals('invalid-email'));
        expect(user.permissions, isEmpty); // null converted to empty list
      });
    });

    group('Serialization', () {
      late EngineUserModel testUser;

      setUp(() {
        testUser = EngineUserModel.fromMap(validUserData);
      });

      test('should convert to map correctly', () {
        // Act
        final map = testUser.toMap();

        // Assert
        expect(map['id'], equals(1));
        expect(map['name'], equals('Test User'));
        expect(map['email'], equals('test@example.com'));
        expect(map['imageUrl'], equals('https://example.com/avatar.jpg'));
        expect(map['permissions'], equals(['read', 'write']));
      });

      test('should convert to JSON string correctly', () {
        // Act
        final jsonString = testUser.toJson();
        final decodedMap = json.decode(jsonString) as Map<String, dynamic>;

        // Assert
        expect(decodedMap['id'], equals(1));
        expect(decodedMap['name'], equals('Test User'));
        expect(decodedMap['email'], equals('test@example.com'));
        expect(decodedMap['permissions'], equals(['read', 'write']));
      });

      test('should maintain data integrity in round-trip conversion', () {
        // Act
        final jsonString = testUser.toJson();
        final recreatedUser = EngineUserModel.fromJson(jsonString);

        // Assert
        expect(recreatedUser.id, equals(testUser.id));
        expect(recreatedUser.name, equals(testUser.name));
        expect(recreatedUser.email, equals(testUser.email));
        expect(recreatedUser.imageUrl, equals(testUser.imageUrl));
        expect(recreatedUser.permissions, equals(testUser.permissions));
      });
    });

    group('copyWith', () {
      late EngineUserModel originalUser;

      setUp(() {
        originalUser = EngineUserModel.fromMap(validUserData);
      });

      test('should copy with updated id', () {
        // Act
        final updatedUser = originalUser.copyWith(id: 999);

        // Assert
        expect(updatedUser.id, equals(999));
        expect(updatedUser.name, equals(originalUser.name));
        expect(updatedUser.email, equals(originalUser.email));
        expect(updatedUser.imageUrl, equals(originalUser.imageUrl));
        expect(updatedUser.permissions, equals(originalUser.permissions));
      });

      test('should copy with updated name', () {
        // Act
        final updatedUser = originalUser.copyWith(name: 'Updated Name');

        // Assert
        expect(updatedUser.id, equals(originalUser.id));
        expect(updatedUser.name, equals('Updated Name'));
        expect(updatedUser.email, equals(originalUser.email));
        expect(updatedUser.imageUrl, equals(originalUser.imageUrl));
        expect(updatedUser.permissions, equals(originalUser.permissions));
      });

      test('should copy with updated email', () {
        // Act
        final updatedUser = originalUser.copyWith(email: 'new@example.com');

        // Assert
        expect(updatedUser.id, equals(originalUser.id));
        expect(updatedUser.name, equals(originalUser.name));
        expect(updatedUser.email, equals('new@example.com'));
        expect(updatedUser.imageUrl, equals(originalUser.imageUrl));
        expect(updatedUser.permissions, equals(originalUser.permissions));
      });

      test('should copy with updated imageUrl', () {
        // Act
        final updatedUser = originalUser.copyWith(imageUrl: 'https://new-image.com/avatar.png');

        // Assert
        expect(updatedUser.id, equals(originalUser.id));
        expect(updatedUser.name, equals(originalUser.name));
        expect(updatedUser.email, equals(originalUser.email));
        expect(updatedUser.imageUrl, equals('https://new-image.com/avatar.png'));
        expect(updatedUser.permissions, equals(originalUser.permissions));
      });

      test('should copy with updated permissions', () {
        // Arrange
        final newPermissions = ['admin', 'delete', 'create'];

        // Act
        final updatedUser = originalUser.copyWith(permissions: newPermissions);

        // Assert
        expect(updatedUser.id, equals(originalUser.id));
        expect(updatedUser.name, equals(originalUser.name));
        expect(updatedUser.email, equals(originalUser.email));
        expect(updatedUser.imageUrl, equals(originalUser.imageUrl));
        expect(updatedUser.permissions, equals(newPermissions));
      });

      test('should copy with multiple updated fields', () {
        // Act
        final updatedUser = originalUser.copyWith(
          id: 555,
          name: 'Multi Update',
          email: 'multi@update.com',
        );

        // Assert
        expect(updatedUser.id, equals(555));
        expect(updatedUser.name, equals('Multi Update'));
        expect(updatedUser.email, equals('multi@update.com'));
        expect(updatedUser.imageUrl, equals(originalUser.imageUrl)); // Unchanged
        expect(updatedUser.permissions, equals(originalUser.permissions)); // Unchanged
      });

      test('should return identical object when no changes provided', () {
        // Act
        final unchangedUser = originalUser.copyWith();

        // Assert
        expect(unchangedUser.id, equals(originalUser.id));
        expect(unchangedUser.name, equals(originalUser.name));
        expect(unchangedUser.email, equals(originalUser.email));
        expect(unchangedUser.imageUrl, equals(originalUser.imageUrl));
        expect(unchangedUser.permissions, equals(originalUser.permissions));
      });
    });

    group('Edge Cases', () {
      test('should handle extremely large id values', () {
        // Arrange
        final largeIdData = {
          'id': 999999999999,
          'name': 'Large ID User',
          'email': 'large@example.com',
          'permissions': <String>[],
        };

        // Act
        final user = EngineUserModel.fromMap(largeIdData);

        // Assert
        expect(user.id, equals(999999999999));
        expect(user.name, equals('Large ID User'));
      });

      test('should handle empty permissions list', () {
        // Arrange
        final noPermissionsData = {
          'id': 1,
          'name': 'No Permissions User',
          'email': 'no-perms@example.com',
          'permissions': <String>[],
        };

        // Act
        final user = EngineUserModel.fromMap(noPermissionsData);

        // Assert
        expect(user.permissions, isEmpty);
      });

      test('should handle very long permission names', () {
        // Arrange
        final longPermission = 'a' * 1000; // 1000 character permission
        final longPermData = {
          'id': 1,
          'name': 'Long Perm User',
          'email': 'long@example.com',
          'permissions': [longPermission],
        };

        // Act
        final user = EngineUserModel.fromMap(longPermData);

        // Assert
        expect(user.permissions.first, equals(longPermission));
        expect(user.permissions.first.length, equals(1000));
      });

      test('should handle special characters in user data', () {
        // Arrange
        final specialCharData = {
          'id': 1,
          'name': 'João da Silva 中文 🚀',
          'email': 'joão+test@domínio.com.br',
          'permissions': ['read/write', 'admin:full', 'special*chars'],
        };

        // Act
        final user = EngineUserModel.fromMap(specialCharData);

        // Assert
        expect(user.name, equals('João da Silva 中文 🚀'));
        expect(user.email, equals('joão+test@domínio.com.br'));
        expect(user.permissions, contains('read/write'));
        expect(user.permissions, contains('admin:full'));
        expect(user.permissions, contains('special*chars'));
      });
    });

    group('Validation Logic', () {
      test('should identify valid user data', () {
        // Act
        final user = EngineUserModel.fromMap(validUserData);

        // Assert
        expect(user.id, isPositive);
        expect(user.name, isNotEmpty);
        expect(user.email, contains('@'));
        expect(user.imageUrl, isNotEmpty);
      });

      test('should handle invalid email formats gracefully', () {
        // Arrange
        final invalidEmailData = {
          'id': 1,
          'name': 'Test User',
          'email': 'not-an-email',
          'permissions': <String>[],
        };

        // Act
        final user = EngineUserModel.fromMap(invalidEmailData);

        // Assert
        expect(user.email, equals('not-an-email')); // Model stores as-is
        // Note: Validation should be handled at business logic layer
      });
    });
  });
}
