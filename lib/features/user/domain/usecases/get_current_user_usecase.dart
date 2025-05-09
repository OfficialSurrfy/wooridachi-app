import '../../../auth/domain/repositories/auth_repository.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  GetCurrentUserUsecase(this._authRepository, this._userRepository);

  Future<UserEntity> call() async {
    try {
      final userId = _authRepository.getCurrentUserId();
      return await _userRepository.getUserById(userId);
    } catch (e) {
      rethrow;
    }
  }
}
