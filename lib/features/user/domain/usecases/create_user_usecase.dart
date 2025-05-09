import 'package:uuid/uuid.dart';

import '../entities/create_user_dto.dart';
import '../entities/user_entity.dart';
import '../entities/user_role.dart';
import '../repositories/user_repository.dart';

class CreateUserUsecase {
  final UserRepository _userRepository;

  CreateUserUsecase(this._userRepository);

  Future<UserEntity> call(CreateUserDto dto) async {
    try {
      print('CreateUserUsecase - Starting user creation');
      print('User details - Email: ${dto.email}, Username: ${dto.username}, University: ${dto.university}, Language: ${dto.language}');

      final userRole = UserRole.user;

      final user = UserEntity(
        id: dto.id,
        email: dto.email,
        username: dto.username,
        university: dto.university,
        language: dto.language,
        profileImageUrl: '',
        role: userRole,
      );

      await _userRepository.setUser(user);
      print('CreateUserUsecase - User document created successfully');

      return user;
    } catch (e) {
      print('CreateUserUsecase - Error creating user: $e');
      rethrow;
    }
  }
}
