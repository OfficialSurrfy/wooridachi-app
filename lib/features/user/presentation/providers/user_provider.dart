import 'dart:io';

import 'package:flutter/material.dart';

import '../../../block_report/presentation/widgets/custom_snack_bar.dart';
import '../../domain/entities/update_user_dto.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/exceptions/user_exceptions.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import 'user_data_holder.dart';

class UserProvider extends ChangeNotifier {
  final UserDataHolder _userDataHolder;
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final UpdateUserProfileUsecase _updateUserProfileUsecase;

  UserProvider({
    required UserDataHolder userDataHolder,
    required GetCurrentUserUsecase getCurrentUserUsecase,
    required UpdateUserProfileUsecase updateUserProfileUsecase,
  })  : _userDataHolder = userDataHolder,
        _getCurrentUserUsecase = getCurrentUserUsecase,
        _updateUserProfileUsecase = updateUserProfileUsecase;

  UserEntity? get user => _userDataHolder.user;

  Future<void> fetchUser(BuildContext context) async {
    try {
      final currentUser = await _getCurrentUserUsecase();
      _userDataHolder.setUser(currentUser);
    } on UserException catch (e) {
      print('UserProvider - UserException while fetching user: $e');
      _userDataHolder.setUser(null);
      if (!context.mounted) return;

      if (e is UserNotFoundException) {
        CustomSnackBar.show(context, '유저 정보를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('UserProvider - Unexpected error while fetching user: $e');
      _userDataHolder.setUser(null);
      if (!context.mounted) return;
      CustomSnackBar.show(context, '유저 정보를 불러오는데 실패했습니다.');
    }
  }

  Future<void> updateUser(BuildContext context, String? newUsername, File? newProfileImage) async {
    try {
      final currentUser = _userDataHolder.user;
      if (currentUser == null) return;

      final updateUserDto = UpdateUserDto(
        currentUser: currentUser,
        newUsername: newUsername,
        newProfileImage: newProfileImage,
      );

      final updatedUser = await _updateUserProfileUsecase.call(updateUserDto);
      _userDataHolder.setUser(updatedUser);

      if (!context.mounted) return;
      CustomSnackBar.show(context, '프로필 업데이트 완료');
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '프로필 업데이트 실패');
    }
  }
}
