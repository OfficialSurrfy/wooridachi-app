import '../../../user/domain/repositories/user_repository.dart';
import '../repositories/auth_repository.dart';

class DeleteAccountUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  DeleteAccountUsecase(this._authRepository, this._userRepository);

  Future<void> call() async {
    final userId = _authRepository.getCurrentUserId();

    // delete user data from firestore,
    // then delete account from firebase auth
    await _userRepository.deleteUser(userId);
    await _authRepository.deleteAccount();

    return;
  }
}
