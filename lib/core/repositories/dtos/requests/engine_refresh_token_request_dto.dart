import 'dart:convert';

class EngineRefreshTokenRequestDto {
  EngineRefreshTokenRequestDto({
    required this.email,
    required this.refreshToken,
    this.scope = 'nop_api offline_access',
  });

  Map<String, dynamic> toMap() => {
        'refreshToken': refreshToken,
        'email': email,
        'scope': scope,
      };

  factory EngineRefreshTokenRequestDto.fromMap(final Map<String, dynamic> map) => EngineRefreshTokenRequestDto(
        refreshToken: map['refreshToken'] ?? '',
        email: map['email'] ?? '',
        scope: map['scope'] ?? '',
      );

  String toJson() => json.encode(toMap());

  factory EngineRefreshTokenRequestDto.fromJson(final String source) => EngineRefreshTokenRequestDto.fromMap(json.decode(source));

  final String refreshToken;
  final String email;
  final String scope;
}
