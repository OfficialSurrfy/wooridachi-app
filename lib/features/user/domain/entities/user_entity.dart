import 'package:json_annotation/json_annotation.dart';

import '../../data/models/user_model.dart';
import 'user_role.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  final String id;
  final String email;
  final String profileImageUrl;
  final String language;
  final UserRole role;
  final String university;
  final String username;
  final List<String>? fcmTokens;

  UserEntity({
    required this.id,
    required this.email,
    required this.profileImageUrl,
    required this.language,
    required this.role,
    required this.university,
    required this.username,
    this.fcmTokens,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  UserModel toModel() => UserModel(
        id: id,
        email: email,
        profileImageUrl: profileImageUrl,
        language: language,
        role: role,
        university: university,
        username: username,
        fcmTokens: fcmTokens,
      );

  UserEntity copyWith({
    String? username,
    String? profileImageUrl,
  }) {
    return UserEntity(
      id: id,
      email: email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      language: language,
      role: role,
      university: university,
      username: username ?? this.username,
      fcmTokens: fcmTokens,
    );
  }
}
