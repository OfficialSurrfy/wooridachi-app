import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserByIdUsecase {
  final UserRepository _userRepository;

  GetUserByIdUsecase(this._userRepository);

  Future<UserEntity> call(String userId) async {
    return await _userRepository.getUserById(userId);
  }
}
