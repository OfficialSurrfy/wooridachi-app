import '../repositories/auth_repository.dart';

class SendPasswordResetEmailUsecase {
  final AuthRepository _authRepository;

  SendPasswordResetEmailUsecase(this._authRepository);

  Future<void> call(String email) async {
    return await _authRepository.sendPasswordResetEmail(email);
  }
}
