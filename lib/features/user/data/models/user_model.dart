import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String profileImageUrl;
  final String language;
  final UserRole role;
  final String university;
  final String username;
  final List<String>? fcmTokens;

  UserModel({
    required this.id,
    required this.email,
    required this.profileImageUrl,
    required this.language,
    required this.role,
    required this.university,
    required this.username,
    this.fcmTokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        profileImageUrl: profileImageUrl,
        language: language,
        role: role,
        university: university,
        username: username,
        fcmTokens: fcmTokens,
      );
}
