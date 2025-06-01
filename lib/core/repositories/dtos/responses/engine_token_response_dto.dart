import 'dart:convert';

class EngineTokenResponseDto {
  EngineTokenResponseDto({
    required this.customerInfo,
    required this.token,
    required this.errorList,
  });

  Map<String, dynamic> toMap() => {
        'customerInfo': customerInfo.toMap(),
        'token': token,
        'errorList': errorList,
      };

  factory EngineTokenResponseDto.fromMap(final Map<String, dynamic> map) => EngineTokenResponseDto(
        customerInfo: CustomerInfo.fromMap(map['Data']?['CustomerInfo'] ?? {}),
        token: map['Data']?['Token'] ?? '',
        errorList: List<String>.from(map['ErrorList'] ?? const []),
      );

  String toJson() => json.encode(toMap());

  factory EngineTokenResponseDto.fromJson(final String source) => EngineTokenResponseDto.fromMap(json.decode(source));

  final CustomerInfo customerInfo;
  final String token;
  final List<String> errorList;
}

class CustomerInfo {
  CustomerInfo({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.permissions,
    required this.customProperties,
  });

  Map<String, dynamic> toMap() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'permissions': permissions.map((final x) => x.toMap()).toList(),
        'customProperties': customProperties.toMap(),
      };

  factory CustomerInfo.fromMap(final Map<String, dynamic> map) => CustomerInfo(
        email: map['Email'] ?? '',
        firstName: map['FirstName'] ?? '',
        lastName: map['LastName'] ?? '',
        permissions: List<Permission>.from(map['Permissions']?.map((final x) => Permission.fromMap(x)) ?? const []),
        customProperties: CustomProperties.fromMap(map['CustomProperties'] ?? {}),
      );

  String toJson() => json.encode(toMap());

  factory CustomerInfo.fromJson(final String source) => CustomerInfo.fromMap(json.decode(source));

  final String email;
  final String firstName;
  final String lastName;
  final List<Permission> permissions;
  final CustomProperties customProperties;
}

class CustomProperties {
  CustomProperties({
    required this.tenantMappings,
    required this.customerId,
  });

  Map<String, dynamic> toMap() => {
        'TenantMappings': tenantMappings.map((final x) => x.toMap()).toList(),
        'CustomerId': customerId,
      };

  factory CustomProperties.fromMap(final Map<String, dynamic> map) => CustomProperties(
        tenantMappings: List<TenantMapping>.from(map['TenantMappings']?.map((final x) => TenantMapping.fromMap(x)) ?? const []),
        customerId: map['CustomerId']?.toInt() ?? 0,
      );

  String toJson() => json.encode(toMap());

  factory CustomProperties.fromJson(final String source) => CustomProperties.fromMap(json.decode(source));

  final List<TenantMapping> tenantMappings;
  final int customerId;
}

class TenantMapping {
  TenantMapping({
    required this.permissionId,
    required this.permissionName,
    required this.tenantId,
  });

  Map<String, dynamic> toMap() => {
        'PermissionId': permissionId,
        'PermissionName': permissionName,
        'TenantId': tenantId,
      };

  factory TenantMapping.fromMap(final Map<String, dynamic> map) => TenantMapping(
        permissionId: map['PermissionId']?.toInt() ?? 0,
        permissionName: map['PermissionName'] ?? '',
        tenantId: map['TenantId'] ?? '',
      );

  String toJson() => json.encode(toMap());

  factory TenantMapping.fromJson(final String source) => TenantMapping.fromMap(json.decode(source));

  final int permissionId;
  final String permissionName;
  final String tenantId;
}

class Permission {
  Permission({
    required this.id,
    required this.name,
    required this.systemName,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
        'Id': id,
        'Name': name,
        'SystemName': systemName,
        'Category': category,
      };

  factory Permission.fromMap(final Map<String, dynamic> map) => Permission(
        id: map['Id']?.toInt() ?? 0,
        name: map['Name'] ?? '',
        systemName: map['SystemName'] ?? '',
        category: map['Category'] ?? '',
      );

  String toJson() => json.encode(toMap());

  factory Permission.fromJson(final String source) => Permission.fromMap(json.decode(source));

  final int id;
  final String name;
  final String systemName;
  final String category;
}
