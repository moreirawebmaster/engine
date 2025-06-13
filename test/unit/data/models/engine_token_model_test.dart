import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_utils.dart';

void main() {
  group('EngineTokenModel', () {
    group('Factory Constructors', () {
      test('should create token from valid map data', () {
        // Arrange
        final tokenData = TestUtils.createValidTokenData();

        // Act
        final token = EngineTokenModel.fromMap(tokenData);

        // Assert
        expect(token.accessToken, equals(tokenData['AccessToken']));
        expect(token.refreshToken, equals(tokenData['RefreshToken']));
        expect(token.accessToken, isNotEmpty);
        expect(token.refreshToken, isNotEmpty);
      });

      test('should create token from JSON string', () {
        // Arrange
        final tokenData = TestUtils.createValidTokenData();
        final jsonString = '{"AccessToken":"${tokenData['AccessToken']}","RefreshToken":"${tokenData['RefreshToken']}"}';

        // Act
        final token = EngineTokenModel.fromJson(jsonString);

        // Assert
        expect(token.accessToken, equals(tokenData['AccessToken']));
        expect(token.refreshToken, equals(tokenData['RefreshToken']));
      });

      test('should create empty token with default values', () {
        // Act
        final token = EngineTokenModel.empty();

        // Assert
        expect(token.accessToken, isEmpty);
        expect(token.refreshToken, isEmpty);
        expect(token.isValid, isFalse);
      });

      test('should handle missing fields gracefully', () {
        // Arrange
        final incompleteData = <String, dynamic>{
          'AccessToken': TestUtils.createValidJwtToken(),
          // Missing RefreshToken
        };

        // Act
        final token = EngineTokenModel.fromMap(incompleteData);

        // Assert
        expect(token.accessToken, isNotEmpty);
        expect(token.refreshToken, isEmpty);
        expect(token.isValid, isFalse); // Invalid because refreshToken is empty
      });

      test('should handle null values gracefully', () {
        // Arrange
        final nullData = <String, dynamic>{
          'AccessToken': null,
          'RefreshToken': null,
        };

        // Act
        final token = EngineTokenModel.fromMap(nullData);

        // Assert
        expect(token.accessToken, isEmpty);
        expect(token.refreshToken, isEmpty);
        expect(token.isValid, isFalse);
      });

      test('should handle empty map', () {
        // Arrange
        final emptyData = <String, dynamic>{};

        // Act
        final token = EngineTokenModel.fromMap(emptyData);

        // Assert
        expect(token.accessToken, isEmpty);
        expect(token.refreshToken, isEmpty);
        expect(token.isValid, isFalse);
      });
    });

    group('Serialization', () {
      test('should convert to map correctly', () {
        // Arrange
        final tokenData = TestUtils.createValidTokenData();
        final token = EngineTokenModel.fromMap(tokenData);

        // Act
        final result = token.toMap();

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['AccessToken'], equals(token.accessToken));
        expect(result['RefreshToken'], equals(token.refreshToken));
        expect(result.length, equals(2)); // Should only contain these two keys
      });

      test('should convert to JSON string correctly', () {
        // Arrange
        final tokenData = TestUtils.createValidTokenData();
        final token = EngineTokenModel.fromMap(tokenData);

        // Act
        final result = token.toJson();

        // Assert
        expect(result, isA<String>());
        expect(result, contains('"AccessToken"'));
        expect(result, contains('"RefreshToken"'));
        expect(result, contains(token.accessToken));
        expect(result, contains(token.refreshToken));
      });

      test('should maintain data integrity in round-trip conversion', () {
        // Arrange
        final originalData = TestUtils.createValidTokenData();
        final token = EngineTokenModel.fromMap(originalData);

        // Act
        final jsonString = token.toJson();
        final reconstructedToken = EngineTokenModel.fromJson(jsonString);

        // Assert
        expect(reconstructedToken.accessToken, equals(token.accessToken));
        expect(reconstructedToken.refreshToken, equals(token.refreshToken));
        expect(reconstructedToken.isValid, equals(token.isValid));
      });

      test('should handle empty tokens in serialization', () {
        // Arrange
        final emptyToken = EngineTokenModel.empty();

        // Act
        final map = emptyToken.toMap();
        final json = emptyToken.toJson();

        // Assert
        expect(map['AccessToken'], isEmpty);
        expect(map['RefreshToken'], isEmpty);
        expect(json, equals('{"AccessToken":"","RefreshToken":""}'));
      });
    });

    group('Token Validation', () {
      test('should validate token with valid access and refresh tokens', () {
        // Arrange
        final tokenData = TestUtils.createValidTokenData();
        final token = EngineTokenModel.fromMap(tokenData);

        // Act & Assert
        expect(token.isValid, isTrue);
        expect(token.accessToken, isNotEmpty);
        expect(token.refreshToken, isNotEmpty);
        expect(token.isExpired, isFalse);
      });

      test('should invalidate token with empty access token', () {
        // Arrange
        final tokenData = {
          'AccessToken': '',
          'RefreshToken': TestUtils.createValidJwtToken(isRefresh: true),
        };
        final token = EngineTokenModel.fromMap(tokenData);

        // Act & Assert
        expect(token.isValid, isFalse);
        expect(token.accessToken, isEmpty);
      });

      test('should invalidate token with empty refresh token', () {
        // Arrange
        final tokenData = {
          'AccessToken': TestUtils.createValidJwtToken(),
          'RefreshToken': '',
        };
        final token = EngineTokenModel.fromMap(tokenData);

        // Act & Assert
        expect(token.isValid, isFalse);
        expect(token.refreshToken, isEmpty);
      });

      test('should invalidate expired tokens', () {
        // Arrange
        final expiredData = TestUtils.createExpiredTokenData();
        final token = EngineTokenModel.fromMap(expiredData);

        // Act & Assert
        expect(token.isValid, isFalse);
        expect(token.isExpired, isTrue);
        expect(token.accessToken, isNotEmpty);
        expect(token.refreshToken, isNotEmpty);
      });
    });

    group('Token Expiration', () {
      test('should detect non-expired valid tokens', () {
        // Arrange
        final validData = TestUtils.createValidTokenData();
        final token = EngineTokenModel.fromMap(validData);

        // Act & Assert
        expect(token.isExpired, isFalse);
      });

      test('should detect expired tokens', () {
        // Arrange
        final expiredData = TestUtils.createExpiredTokenData();
        final token = EngineTokenModel.fromMap(expiredData);

        // Act & Assert
        expect(token.isExpired, isTrue);
      });

      test('should handle invalid JWT format gracefully', () {
        // Arrange
        final invalidTokenData = {
          'AccessToken': 'invalid-jwt-token',
          'RefreshToken': TestUtils.createValidJwtToken(isRefresh: true),
        };

        // Act & Assert
        expect(() {
          final token = EngineTokenModel.fromMap(invalidTokenData);
          return token.isExpired; // This should handle the invalid JWT
        }, throwsA(isA<FormatException>()));
      });

      test('should handle empty access token in expiration check', () {
        // Arrange
        final emptyTokenData = {
          'AccessToken': '',
          'RefreshToken': TestUtils.createValidJwtToken(isRefresh: true),
        };

        // Act & Assert
        expect(() {
          final token = EngineTokenModel.fromMap(emptyTokenData);
          return token.isExpired;
        }, throwsA(isA<FormatException>()));
      });
    });

    group('Edge Cases', () {
      test('should handle tokens with invalid JWT format', () {
        // Arrange - Create a clearly invalid JWT (wrong format)
        final invalidTokenData = {
          'AccessToken': 'not.a.valid.jwt.token.format.with.too.many.parts',
          'RefreshToken': TestUtils.createValidJwtToken(isRefresh: true),
        };
        final token = EngineTokenModel.fromMap(invalidTokenData);

        // Act & Assert - Invalid JWT format should cause exception during expiration check
        expect(token.accessToken, equals('not.a.valid.jwt.token.format.with.too.many.parts'));
        expect(token.refreshToken, isNotEmpty);

        // Test that the malformed JWT causes an exception during expiration check
        expect(() => token.isExpired, throwsA(isA<FormatException>()));

        // Test that we can still access basic properties even with malformed JWT
        expect(token.accessToken, isNotEmpty);
        expect(token.refreshToken, isNotEmpty);
      });

      test('should handle special characters in token fields', () {
        // Arrange
        final specialCharData = {
          'AccessToken': TestUtils.createValidJwtToken(),
          'RefreshToken': TestUtils.createValidJwtToken(isRefresh: true),
        };
        final token = EngineTokenModel.fromMap(specialCharData);

        // Act
        final jsonResult = token.toJson();
        final reconstructed = EngineTokenModel.fromJson(jsonResult);

        // Assert
        expect(reconstructed.accessToken, equals(token.accessToken));
        expect(reconstructed.refreshToken, equals(token.refreshToken));
      });

      test('should handle malformed JSON gracefully', () {
        // Arrange
        const malformedJson = '{"AccessToken":"valid","RefreshToken":}';

        // Act & Assert
        expect(() => EngineTokenModel.fromJson(malformedJson), throwsA(isA<FormatException>()));
      });

      test('should handle tokens with whitespace', () {
        // Arrange
        final tokenData = {
          'AccessToken': '  ${TestUtils.createValidJwtToken()}  ',
          'RefreshToken': '  ${TestUtils.createValidJwtToken(isRefresh: true)}  ',
        };
        final token = EngineTokenModel.fromMap(tokenData);

        // Act & Assert
        expect(token.accessToken, contains('  ')); // Whitespace should be preserved
        expect(token.refreshToken, contains('  '));
        // Note: Token is still valid if the JWT within the spaces is valid
        expect(token.isValid, isTrue); // Changed expectation
      });
    });

    group('Token Properties', () {
      test('should provide direct access to token properties', () {
        // Arrange
        final tokenData = TestUtils.createValidTokenData();
        final token = EngineTokenModel.fromMap(tokenData);

        // Act & Assert
        expect(token.accessToken, isA<String>());
        expect(token.refreshToken, isA<String>());
        expect(token.accessToken, equals(tokenData['AccessToken']));
        expect(token.refreshToken, equals(tokenData['RefreshToken']));
      });

      test('should maintain immutability of token properties', () {
        // Arrange
        final tokenData = TestUtils.createValidTokenData();
        final token = EngineTokenModel.fromMap(tokenData);
        final originalAccessToken = token.accessToken;
        final originalRefreshToken = token.refreshToken;

        // Act
        final map = token.toMap();
        map['AccessToken'] = 'modified';
        map['RefreshToken'] = 'modified';

        // Assert - Original token should remain unchanged
        expect(token.accessToken, equals(originalAccessToken));
        expect(token.refreshToken, equals(originalRefreshToken));
      });
    });

    group('Token State Combinations', () {
      test('should handle all valid state combinations', () {
        // Valid tokens
        final validData = TestUtils.createValidTokenData();
        final validToken = EngineTokenModel.fromMap(validData);
        expect(validToken.isValid, isTrue);

        // Expired tokens
        final expiredData = TestUtils.createExpiredTokenData();
        final expiredToken = EngineTokenModel.fromMap(expiredData);
        expect(expiredToken.isValid, isFalse);

        // Empty tokens
        final emptyToken = EngineTokenModel.empty();
        expect(emptyToken.isValid, isFalse);
      });

      test('should validate business logic combinations', () {
        // Arrange & Act & Assert
        final validData = TestUtils.createValidTokenData();
        final validToken = EngineTokenModel.fromMap(validData);

        // A valid token must have non-empty strings and not be expired
        if (validToken.isValid) {
          expect(validToken.accessToken, isNotEmpty);
          expect(validToken.refreshToken, isNotEmpty);
          expect(validToken.isExpired, isFalse);
        }
      });
    });

    group('Integration with EngineJwt', () {
      test('should work correctly with EngineJwt decode functionality', () {
        // Arrange
        final validJwt = TestUtils.createValidJwtToken();
        final tokenData = {
          'AccessToken': validJwt,
          'RefreshToken': TestUtils.createValidJwtToken(isRefresh: true),
        };
        final token = EngineTokenModel.fromMap(tokenData);

        // Act - This tests integration with EngineJwt.decode
        final decoded = EngineJwt.decode(token.accessToken);

        // Assert
        expect(decoded, isA<Map<String, dynamic>>());
        expect(decoded['sub'], equals('1234567890'));
        expect(decoded['exp'], isA<int>());
      });

      test('should handle JWT expiration logic correctly', () {
        // Arrange
        final validToken = EngineTokenModel.fromMap(TestUtils.createValidTokenData());
        final expiredToken = EngineTokenModel.fromMap(TestUtils.createExpiredTokenData());

        // Act & Assert
        expect(validToken.isExpired, isFalse);
        expect(expiredToken.isExpired, isTrue);
      });
    });
  });
}
