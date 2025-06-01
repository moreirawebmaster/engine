import 'dart:convert';

class EngineTokenRequestDto {
  EngineTokenRequestDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
      };

  factory EngineTokenRequestDto.fromMap(final Map<String, dynamic> map) => EngineTokenRequestDto(
        email: map['email'] ?? '',
        password: map['password'] ?? '',
      );

  String toJson() => json.encode(toMap());

  factory EngineTokenRequestDto.fromJson(final String source) => EngineTokenRequestDto.fromMap(json.decode(source));

  final String email;
  final String password;
}
