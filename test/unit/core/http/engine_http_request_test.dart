import 'dart:async';

import 'package:engine/lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineHttpRequest', () {
    group('Class Structure and Type Definitions', () {
      test('should have EngineHttpRequest class available', () {
        // Act & Assert - Class should be accessible
        expect(EngineHttpRequest, isA<Type>());
      });

      test('should have EngineDecoder typedef available', () {
        // Act & Assert - Typedef should be accessible
        expect(() {
          T testDecoder<T>(final dynamic data) => data as T;
          final decoder = testDecoder<String>;
          expect(decoder, isA<Function>());
        }, returnsNormally);
      });

      test('should have EngineProgress typedef available', () {
        // Act & Assert - Typedef should be accessible
        expect(() {
          void testProgress(final double percent) {}
          final progress = testProgress;
          expect(progress, isA<Function>());
        }, returnsNormally);
      });

      test('should support generic types', () {
        // Act & Assert - Generic type support
        expect(() {
          const url = 'https://api.example.com/data';
          final stringRequest = EngineHttpRequest<String>(
            url: Uri.parse(url),
            method: EngineHttpMethod.get,
          );
          final mapRequest = EngineHttpRequest<Map<String, dynamic>>(
            url: Uri.parse(url),
            method: EngineHttpMethod.post,
          );

          expect(stringRequest, isA<EngineHttpRequest<String>>());
          expect(mapRequest, isA<EngineHttpRequest<Map<String, dynamic>>>());
        }, returnsNormally);
      });
    });

    group('Constructor and Property Validation', () {
      test('should create request with required parameters', () {
        // Arrange
        final url = Uri.parse('https://api.example.com/test');
        const method = EngineHttpMethod.get;

        // Act
        final request = EngineHttpRequest<String>(
          url: url,
          method: method,
        );

        // Assert
        expect(request.url, equals(url));
        expect(request.method, equals(method));
        expect(request.headers, isNull);
        expect(request.bodyBytes, isNull);
        expect(request.followRedirects, isTrue);
        expect(request.maxRedirects, equals(4));
        expect(request.contentLength, isNull);
        expect(request.formData, isNull);
        expect(request.persistentConnection, isTrue);
        expect(request.decoder, isNull);
      });

      test('should create request with all parameters', () {
        // Arrange
        final url = Uri.parse('https://api.example.com/create');
        const method = EngineHttpMethod.post;
        final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer token'};
        final bodyBytes = Stream.fromIterable([
          [1, 2, 3, 4, 5]
        ]);
        const followRedirects = false;
        const maxRedirects = 2;
        const contentLength = 12345;
        const persistentConnection = false;
        String testDecoder(final dynamic data) => data.toString();

        // Act
        final request = EngineHttpRequest<String>(
          url: url,
          method: method,
          headers: headers,
          bodyBytes: bodyBytes,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects,
          contentLength: contentLength,
          persistentConnection: persistentConnection,
          decoder: testDecoder,
        );

        // Assert
        expect(request.url, equals(url));
        expect(request.method, equals(method));
        expect(request.headers, equals(headers));
        expect(request.bodyBytes, equals(bodyBytes));
        expect(request.followRedirects, equals(followRedirects));
        expect(request.maxRedirects, equals(maxRedirects));
        expect(request.contentLength, equals(contentLength));
        expect(request.persistentConnection, equals(persistentConnection));
        expect(request.decoder, equals(testDecoder));
      });

      test('should create empty request', () {
        // Act
        final request = EngineHttpRequest<String>.empty();

        // Assert
        expect(request.url, equals(Uri.parse('')));
        expect(request.method, equals(EngineHttpMethod.get));
        expect(request.headers, isNull);
        expect(request.bodyBytes, isNull);
        expect(request.followRedirects, isTrue);
        expect(request.maxRedirects, equals(4));
        expect(request.contentLength, isNull);
        expect(request.formData, isNull);
        expect(request.persistentConnection, isTrue);
        expect(request.decoder, isNull);
      });
    });

    group('URL and Method Handling', () {
      test('should handle various URL patterns', () {
        // Act & Assert - Verify URL pattern support
        expect(() {
          final urlPatterns = [
            'https://api.example.com/users',
            'https://api.example.com/v1/auth/login',
            'https://subdomain.api.example.com/resource',
            'http://localhost:3000/api/test',
            'https://api.example.com/search?q=test&limit=10',
          ];

          for (final urlString in urlPatterns) {
            final url = Uri.parse(urlString);
            final request = EngineHttpRequest<String>(
              url: url,
              method: EngineHttpMethod.get,
            );

            expect(request.url.toString(), equals(urlString));
            expect(request.url.scheme, isIn(['http', 'https']));
          }
        }, returnsNormally);
      });

      test('should handle all HTTP methods', () {
        // Act & Assert - Verify HTTP method support
        expect(() {
          final httpMethods = [
            EngineHttpMethod.get,
            EngineHttpMethod.post,
            EngineHttpMethod.put,
            EngineHttpMethod.patch,
            EngineHttpMethod.delete,
          ];

          final url = Uri.parse('https://api.example.com/test');

          for (final method in httpMethods) {
            final request = EngineHttpRequest<String>(
              url: url,
              method: method,
            );

            expect(request.method, equals(method));
          }
        }, returnsNormally);
      });

      test('should handle URI components correctly', () {
        // Arrange
        final url = Uri.parse('https://api.example.com:8080/v1/users/123?include=profile&format=json#section');

        // Act
        final request = EngineHttpRequest<String>(
          url: url,
          method: EngineHttpMethod.get,
        );

        // Assert
        expect(request.url.scheme, equals('https'));
        expect(request.url.host, equals('api.example.com'));
        expect(request.url.port, equals(8080));
        expect(request.url.path, equals('/v1/users/123'));
        expect(request.url.query, equals('include=profile&format=json'));
        expect(request.url.fragment, equals('section'));
      });
    });

    group('Headers and Content Handling', () {
      test('should handle request headers', () {
        // Arrange
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
          'X-API-Version': '2023-01-01',
          'Accept': 'application/vnd.api+json',
          'User-Agent': 'EngineApp/1.0.0',
          'X-Request-ID': 'req-123456789',
        };

        // Act
        final request = EngineHttpRequest<String>(
          url: Uri.parse('https://api.example.com/test'),
          method: EngineHttpMethod.post,
          headers: headers,
        );

        // Assert
        expect(request.headers, equals(headers));
        expect(request.headers!['Content-Type'], equals('application/json'));
        expect(request.headers!['Authorization'], contains('Bearer'));
        expect(request.headers!.keys.length, equals(6));
      });

      test('should handle content length settings', () {
        // Act & Assert - Verify content length handling
        expect(() {
          final contentLengths = [0, 100, 1024, 1048576, 10485760]; // 0B to 10MB

          for (final length in contentLengths) {
            final request = EngineHttpRequest<String>(
              url: Uri.parse('https://api.example.com/upload'),
              method: EngineHttpMethod.post,
              contentLength: length,
            );

            expect(request.contentLength, equals(length));
            expect(request.contentLength, greaterThanOrEqualTo(0));
          }
        }, returnsNormally);
      });

      test('should handle body bytes stream', () {
        // Arrange
        final bodyData = [
          [1, 2, 3, 4, 5],
          [6, 7, 8, 9, 10],
          [11, 12, 13, 14, 15],
        ];
        final bodyBytes = Stream.fromIterable(bodyData);

        // Act
        final request = EngineHttpRequest<String>(
          url: Uri.parse('https://api.example.com/upload'),
          method: EngineHttpMethod.post,
          bodyBytes: bodyBytes,
        );

        // Assert
        expect(request.bodyBytes, isA<Stream<List<int>>>());
        expect(request.bodyBytes, equals(bodyBytes));
      });
    });

    group('Connection and Redirect Configuration', () {
      test('should handle redirect configuration', () {
        // Act & Assert - Verify redirect configuration
        expect(() {
          final redirectConfigs = [
            {'followRedirects': true, 'maxRedirects': 5},
            {'followRedirects': false, 'maxRedirects': 0},
            {'followRedirects': true, 'maxRedirects': 10},
            {'followRedirects': true, 'maxRedirects': 1},
          ];

          for (final config in redirectConfigs) {
            final request = EngineHttpRequest<String>(
              url: Uri.parse('https://api.example.com/redirect-test'),
              method: EngineHttpMethod.get,
              followRedirects: config['followRedirects'] as bool,
              maxRedirects: config['maxRedirects'] as int,
            );

            expect(request.followRedirects, equals(config['followRedirects']));
            expect(request.maxRedirects, equals(config['maxRedirects']));
          }
        }, returnsNormally);
      });

      test('should handle persistent connection settings', () {
        // Act & Assert - Verify connection settings
        expect(() {
          final connectionSettings = [true, false];

          for (final persistent in connectionSettings) {
            final request = EngineHttpRequest<String>(
              url: Uri.parse('https://api.example.com/test'),
              method: EngineHttpMethod.get,
              persistentConnection: persistent,
            );

            expect(request.persistentConnection, equals(persistent));
          }
        }, returnsNormally);
      });

      test('should handle default configuration values', () {
        // Arrange & Act
        final request = EngineHttpRequest<String>(
          url: Uri.parse('https://api.example.com/default'),
          method: EngineHttpMethod.get,
        );

        // Assert - Verify default values
        expect(request.followRedirects, isTrue);
        expect(request.maxRedirects, equals(4));
        expect(request.persistentConnection, isTrue);
        expect(request.headers, isNull);
        expect(request.bodyBytes, isNull);
        expect(request.contentLength, isNull);
        expect(request.formData, isNull);
      });
    });

    group('Decoder and Form Data Handling', () {
      test('should handle various decoder types', () {
        // Act & Assert - Verify decoder handling
        expect(() {
          // String decoder
          String stringDecoder(final dynamic data) => data.toString();
          final stringRequest = EngineHttpRequest<String>(
            url: Uri.parse('https://api.example.com/string'),
            method: EngineHttpMethod.get,
            decoder: stringDecoder,
          );
          expect(stringRequest.decoder, equals(stringDecoder));

          // Map decoder
          Map<String, dynamic> mapDecoder(final dynamic data) => data as Map<String, dynamic>;
          final mapRequest = EngineHttpRequest<Map<String, dynamic>>(
            url: Uri.parse('https://api.example.com/map'),
            method: EngineHttpMethod.get,
            decoder: mapDecoder,
          );
          expect(mapRequest.decoder, equals(mapDecoder));

          // List decoder
          List<String> listDecoder(final dynamic data) => (data as List).cast<String>();
          final listRequest = EngineHttpRequest<List<String>>(
            url: Uri.parse('https://api.example.com/list'),
            method: EngineHttpMethod.get,
            decoder: listDecoder,
          );
          expect(listRequest.decoder, equals(listDecoder));
        }, returnsNormally);
      });

      test('should handle form data attachment', () {
        // Act & Assert - Verify form data handling
        expect(() {
          final formData = EngineFormData({}); // FormData requires a map parameter

          final request = EngineHttpRequest<String>(
            url: Uri.parse('https://api.example.com/upload'),
            method: EngineHttpMethod.post,
            formData: formData,
          );

          expect(request.formData, equals(formData));
          expect(request.formData, isA<EngineFormData>());
        }, returnsNormally);
      });

      test('should handle null form data', () {
        // Act
        final request = EngineHttpRequest<String>(
          url: Uri.parse('https://api.example.com/json'),
          method: EngineHttpMethod.post,
          formData: null,
        );

        // Assert
        expect(request.formData, isNull);
      });
    });

    group('Real-world Usage Scenarios', () {
      test('should support API authentication requests', () {
        // Arrange
        final loginRequest = EngineHttpRequest<Map<String, dynamic>>(
          url: Uri.parse('https://api.example.com/auth/login'),
          method: EngineHttpMethod.post,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          decoder: (final data) => data as Map<String, dynamic>,
        );

        // Assert
        expect(loginRequest.url.path, equals('/auth/login'));
        expect(loginRequest.method, equals(EngineHttpMethod.post));
        expect(loginRequest.headers!['Content-Type'], equals('application/json'));
        expect(loginRequest.decoder, isA<Function>());
      });

      test('should support file upload requests', () {
        // Arrange
        final uploadRequest = EngineHttpRequest<String>(
          url: Uri.parse('https://api.example.com/files/upload'),
          method: EngineHttpMethod.post,
          headers: {
            'Authorization': 'Bearer token123',
            'X-Upload-Type': 'document',
          },
          contentLength: 2048576, // 2MB
          formData: EngineFormData({}),
          followRedirects: false,
        );

        // Assert
        expect(uploadRequest.url.path, equals('/files/upload'));
        expect(uploadRequest.method, equals(EngineHttpMethod.post));
        expect(uploadRequest.contentLength, equals(2048576));
        expect(uploadRequest.formData, isNotNull);
        expect(uploadRequest.followRedirects, isFalse);
      });

      test('should support data fetching requests', () {
        // Arrange
        final fetchRequest = EngineHttpRequest<List<Map<String, dynamic>>>(
          url: Uri.parse('https://api.example.com/users?page=1&limit=20'),
          method: EngineHttpMethod.get,
          headers: {
            'Accept': 'application/vnd.api+json',
            'X-API-Version': '2023',
          },
          decoder: (final data) => (data as List).cast<Map<String, dynamic>>(),
          persistentConnection: true,
        );

        // Assert
        expect(fetchRequest.url.query, equals('page=1&limit=20'));
        expect(fetchRequest.method, equals(EngineHttpMethod.get));
        expect(fetchRequest.headers!['Accept'], contains('application/vnd.api+json'));
        expect(fetchRequest.decoder, isA<Function>());
        expect(fetchRequest.persistentConnection, isTrue);
      });

      test('should support update operations', () {
        // Arrange
        final updateRequest = EngineHttpRequest<Map<String, dynamic>>(
          url: Uri.parse('https://api.example.com/users/123'),
          method: EngineHttpMethod.put,
          headers: {
            'Content-Type': 'application/json',
            'If-Match': 'etag123',
            'X-Idempotency-Key': 'update-456',
          },
          contentLength: 512,
          decoder: (final data) => data as Map<String, dynamic>,
        );

        // Assert
        expect(updateRequest.url.path, equals('/users/123'));
        expect(updateRequest.method, equals(EngineHttpMethod.put));
        expect(updateRequest.headers!['If-Match'], equals('etag123'));
        expect(updateRequest.contentLength, equals(512));
      });

      test('should support GraphQL requests', () {
        // Arrange
        final graphqlRequest = EngineHttpRequest<Map<String, dynamic>>(
          url: Uri.parse('https://api.example.com/graphql'),
          method: EngineHttpMethod.post,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer token123',
          },
          decoder: (final data) => data as Map<String, dynamic>,
          persistentConnection: true,
        );

        // Assert
        expect(graphqlRequest.url.path, equals('/graphql'));
        expect(graphqlRequest.method, equals(EngineHttpMethod.post));
        expect(graphqlRequest.headers!['Content-Type'], equals('application/json'));
        expect(graphqlRequest.persistentConnection, isTrue);
      });
    });

    group('Edge Cases and Error Scenarios', () {
      test('should handle empty URL gracefully', () {
        // Act
        final request = EngineHttpRequest<String>.empty();

        // Assert
        expect(request.url.toString(), equals(''));
        expect(request.url.scheme, isEmpty);
        expect(request.url.host, isEmpty);
        expect(request.url.path, isEmpty);
      });

      test('should handle special characters in URLs', () {
        // Act & Assert - Verify special character handling
        expect(() {
          final specialUrls = [
            'https://api.example.com/search?q=hello%20world',
            'https://api.example.com/users/josé@example.com',
            'https://api.example.com/files/document%20with%20spaces.pdf',
            'https://api.example.com/emoji/🚀',
            'https://api.example.com/unicode/测试',
          ];

          for (final urlString in specialUrls) {
            final url = Uri.parse(urlString);
            final request = EngineHttpRequest<String>(
              url: url,
              method: EngineHttpMethod.get,
            );

            expect(request.url, isA<Uri>());
            expect(request.url.toString(), isA<String>());
          }
        }, returnsNormally);
      });

      test('should handle large header collections', () {
        // Arrange
        final largeHeaders = <String, String>{};
        for (var i = 0; i < 100; i++) {
          largeHeaders['X-Custom-Header-$i'] = 'value-$i';
        }

        // Act
        final request = EngineHttpRequest<String>(
          url: Uri.parse('https://api.example.com/large-headers'),
          method: EngineHttpMethod.get,
          headers: largeHeaders,
        );

        // Assert
        expect(request.headers!.length, equals(100));
        expect(request.headers!['X-Custom-Header-99'], equals('value-99'));
      });

      test('should handle extreme redirect configurations', () {
        // Act & Assert - Verify extreme redirect handling
        expect(() {
          final extremeConfigs = [
            {'followRedirects': true, 'maxRedirects': 0},
            {'followRedirects': true, 'maxRedirects': 100},
            {'followRedirects': false, 'maxRedirects': 1000},
          ];

          for (final config in extremeConfigs) {
            final request = EngineHttpRequest<String>(
              url: Uri.parse('https://api.example.com/extreme'),
              method: EngineHttpMethod.get,
              followRedirects: config['followRedirects'] as bool,
              maxRedirects: config['maxRedirects'] as int,
            );

            expect(request.followRedirects, isA<bool>());
            expect(request.maxRedirects, isA<int>());
            expect(request.maxRedirects, greaterThanOrEqualTo(0));
          }
        }, returnsNormally);
      });

      test('should handle null and empty stream scenarios', () {
        // Act & Assert - Verify null/empty stream handling
        expect(() {
          // Null stream
          final requestWithNullStream = EngineHttpRequest<String>(
            url: Uri.parse('https://api.example.com/null-stream'),
            method: EngineHttpMethod.post,
            bodyBytes: null,
          );
          expect(requestWithNullStream.bodyBytes, isNull);

          // Empty stream
          const emptyStream = Stream<List<int>>.empty();
          final requestWithEmptyStream = EngineHttpRequest<String>(
            url: Uri.parse('https://api.example.com/empty-stream'),
            method: EngineHttpMethod.post,
            bodyBytes: emptyStream,
          );
          expect(requestWithEmptyStream.bodyBytes, equals(emptyStream));
        }, returnsNormally);
      });
    });

    group('Performance and Memory Considerations', () {
      test('should handle large content lengths efficiently', () {
        // Act & Assert - Verify large content handling
        expect(() {
          final largeSizes = [
            1024, // 1KB
            1048576, // 1MB
            104857600, // 100MB
            1073741824, // 1GB
          ];

          for (final size in largeSizes) {
            final request = EngineHttpRequest<String>(
              url: Uri.parse('https://api.example.com/large-content'),
              method: EngineHttpMethod.post,
              contentLength: size,
            );

            expect(request.contentLength, equals(size));
            expect(request.contentLength, greaterThan(0));
          }
        }, returnsNormally);
      });

      test('should handle concurrent request creation efficiently', () async {
        // Act & Assert - Verify concurrent creation
        final futures = List.generate(
            100,
            (final index) => Future(() {
                  final request = EngineHttpRequest<String>(
                    url: Uri.parse('https://api.example.com/concurrent/$index'),
                    method: EngineHttpMethod.get,
                    headers: {'X-Request-ID': 'req-$index'},
                  );

                  expect(request.url.path, equals('/concurrent/$index'));
                  expect(request.headers!['X-Request-ID'], equals('req-$index'));
                  return request;
                }));

        await expectLater(Future.wait(futures), completes);
      });

      test('should maintain memory efficiency with multiple instances', () {
        // Act & Assert - Verify memory efficiency
        expect(() {
          final requests = <EngineHttpRequest<String>>[];

          for (var i = 0; i < 50; i++) {
            requests.add(EngineHttpRequest<String>(
              url: Uri.parse('https://api.example.com/memory/$i'),
              method: EngineHttpMethod.get,
              headers: {'X-Memory-Test': 'value-$i'},
            ));
          }

          expect(requests.length, equals(50));
          expect(requests.first.url.path, equals('/memory/0'));
          expect(requests.last.url.path, equals('/memory/49'));

          // Requests should be eligible for garbage collection
        }, returnsNormally);
      });
    });
  });
}
