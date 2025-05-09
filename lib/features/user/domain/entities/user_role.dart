import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  @JsonKey(name: 'User')
  user,
  @JsonKey(name: 'Admin')
  admin,
}
