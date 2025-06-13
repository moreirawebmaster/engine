import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const header = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';
  const signature = 'c2lnbmF0dXJl';
  const validPayload = 'eyJleHAiOjk5OTk5OTk5OTksImlhdCI6OTk5OTk5MDAwMH0';
  const expiredPayload = 'eyJleHAiOjEsImlhdCI6MH0';
  const invalidExpPayload = 'eyJleHAiOiJhYmMiLCJpYXQiOjB9';

  const validToken = '$header.$validPayload.$signature';
  const expiredToken = '$header.$expiredPayload.$signature';
  const invalidExpToken = '$header.$invalidExpPayload.$signature';
  const malformedToken = 'invalidtoken';
  const invalidPayloadToken = '$header.invalid.$signature';

  group('EngineJwt.decode', () {
    test('decodes a valid token', () {
      final decoded = EngineJwt.decode(validToken);
      expect(decoded['exp'], 9999999999);
      expect(decoded['iat'], 9999990000);
    });

    test('throws FormatException for malformed token', () {
      expect(() => EngineJwt.decode(malformedToken), throwsFormatException);
    });

    test('throws FormatException for invalid payload', () {
      expect(() => EngineJwt.decode(invalidPayloadToken), throwsFormatException);
    });
  });

  group('EngineJwt.getExpirationDate', () {
    test('returns epoch when token is empty', () {
      final date = EngineJwt.getExpirationDate('');
      expect(date, DateTime.fromMillisecondsSinceEpoch(0));
    });

    test('returns the expiration date from a valid token', () {
      final date = EngineJwt.getExpirationDate(validToken);
      expect(date, DateTime.fromMillisecondsSinceEpoch(0).add(const Duration(seconds: 9999999999)));
    });

    test('throws FormatException for token with invalid exp', () {
      expect(() => EngineJwt.getExpirationDate(invalidExpToken), throwsFormatException);
    });
  });

  group('EngineJwt.isExpired', () {
    test('returns false when token is not expired', () {
      expect(EngineJwt.isExpired(validToken), isFalse);
    });

    test('returns true when token is expired', () {
      expect(EngineJwt.isExpired(expiredToken), isTrue);
    });

    test('throws FormatException for malformed token', () {
      expect(() => EngineJwt.isExpired(malformedToken), throwsFormatException);
    });
  });
}
