import '../entities/authenticate_with_email_param.dart';
import '../repositories/auth_repository.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../../user/domain/repositories/user_repository.dart';

class SignInWithEmailAndPasswordUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignInWithEmailAndPasswordUsecase(this._authRepository, this._userRepository);

  Future<UserEntity> call(AuthenticateWithEmailParam param) async {
    final userCredential = await _authRepository.signInWithEmailAndPassword(param);

    final user = await _userRepository.getUserById(userCredential.user!.uid);

    return user;
  }
}
