import 'dart:convert';

import 'package:engine/lib.dart';

class EngineTokenModel {
  EngineTokenModel({
    required this.accessToken,
    required this.refreshToken,
  });

  bool get isExpired {
    final decoded = EngineJwt.decode(accessToken);
    final dateTimeExp = DateTime.fromMillisecondsSinceEpoch(decoded['exp'].toInt() * 1000)
        .add(const Duration(days: 7)); //Add to 7 days for refresh token not working in backend. Remove this when backend is ok.
    return dateTimeExp.isBefore(DateTime.now());
  }

  bool get isValid => accessToken.isNotEmpty && refreshToken.isNotEmpty && !isExpired;

  factory EngineTokenModel.empty() => EngineTokenModel.fromMap({});

  factory EngineTokenModel.fromMap(final Map<String, dynamic> map) => EngineTokenModel(
        accessToken: map['AccessToken'] ?? '',
        refreshToken: map['RefreshToken'] ?? '',
      );

  factory EngineTokenModel.fromJson(final String source) => EngineTokenModel.fromMap(json.decode(source));

  Map<String, dynamic> toMap() => {
        'AccessToken': accessToken,
        'RefreshToken': refreshToken,
      };
  String toJson() => json.encode(toMap());

  final String accessToken;
  final String refreshToken;
}
