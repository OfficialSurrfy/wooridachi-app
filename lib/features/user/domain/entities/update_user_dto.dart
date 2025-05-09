import 'dart:io';

import 'user_entity.dart';

class UpdateUserDto {
  final UserEntity currentUser;
  final String? newUsername;
  final File? newProfileImage;

  UpdateUserDto({
    required this.currentUser,
    this.newUsername,
    this.newProfileImage,
  });
}
