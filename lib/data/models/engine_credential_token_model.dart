import 'dart:convert';

class EngineCredentialTokenModel {
  final String clientId;
  final String clientSecret;
  EngineCredentialTokenModel({
    required this.clientId,
    required this.clientSecret,
  });

  EngineCredentialTokenModel copyWith({
    final String? clientId,
    final String? clientSecret,
  }) =>
      EngineCredentialTokenModel(
        clientId: clientId ?? this.clientId,
        clientSecret: clientSecret ?? this.clientSecret,
      );

  Map<String, dynamic> toMap() => {
        'clientId': clientId,
        'clientSecret': clientSecret,
      };

  factory EngineCredentialTokenModel.fromMap(final Map<String, dynamic> map) => EngineCredentialTokenModel(
        clientId: map['clientId'] ?? '',
        clientSecret: map['clientSecret'] ?? '',
      );

  String toJson() => json.encode(toMap());

  factory EngineCredentialTokenModel.fromJson(final String source) => EngineCredentialTokenModel.fromMap(json.decode(source));
}
