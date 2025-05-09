import '../../../image/domain/repositories/image_repository.dart';
import '../entities/update_user_dto.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfileUsecase {
  final UserRepository _userRepository;
  final ImageRepository _imageRepository;

  UpdateUserProfileUsecase(this._userRepository, this._imageRepository);

  Future<UserEntity> call(UpdateUserDto updateUserDto) async {
    String? profileImageUrl;

    if (updateUserDto.newProfileImage != null) {
      final imagePath = 'users/${updateUserDto.currentUser.id}/profile';

      profileImageUrl = await _imageRepository.uploadImage(
        updateUserDto.newProfileImage!,
        imagePath,
      );
    }

    final updatedUser = updateUserDto.currentUser.copyWith(
      username: updateUserDto.newUsername ?? updateUserDto.currentUser.username,
      profileImageUrl: profileImageUrl ?? updateUserDto.currentUser.profileImageUrl,
    );

    return await _userRepository.setUser(updatedUser);
  }
}
