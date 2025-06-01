import 'dart:convert';

class EngineUserModel {
  EngineUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.permissions,
    this.imageUrl =
        'https://static.vecteezy.com/system/resources/previews/024/183/535/original/male-avatar-portrait-of-a-young-man-with-glasses-illustration-of-male-character-in-modern-color-style-vector.jpg',
  });

  factory EngineUserModel.empty() => EngineUserModel.fromMap({});

  EngineUserModel copyWith({
    final int? id,
    final String? name,
    final String? email,
    final List<String>? roles,
    final String? imageUrl,
    final List<String>? permissions,
  }) =>
      EngineUserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        imageUrl: imageUrl ?? this.imageUrl,
        permissions: permissions ?? this.permissions,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
        'permissions': permissions,
      };

  factory EngineUserModel.fromMap(final Map<String, dynamic> map) => EngineUserModel(
        id: map['id']?.toInt() ?? 0,
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        permissions: List<String>.from(map['permissions'] ?? []),
      );

  String toJson() => json.encode(toMap());

  factory EngineUserModel.fromJson(final String source) => EngineUserModel.fromMap(json.decode(source));

  final int id;
  final String name;
  final String email;
  final String imageUrl;
  final List<String> permissions;
}
