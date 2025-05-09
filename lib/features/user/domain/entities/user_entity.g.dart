// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      id: json['id'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      language: json['language'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      university: json['university'] as String,
      username: json['username'] as String,
      fcmTokens: (json['fcmTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
      'language': instance.language,
      'role': _$UserRoleEnumMap[instance.role]!,
      'university': instance.university,
      'username': instance.username,
      'fcmTokens': instance.fcmTokens,
    };

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.admin: 'admin',
};
