import '../../../user/domain/entities/create_user_dto.dart';
import '../../../user/domain/usecases/create_user_usecase.dart';
import '../entities/authenticate_with_email_param.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailAndPasswordUsecase {
  final AuthRepository _authRepository;
  final CreateUserUsecase _createUserUsecase;

  SignUpWithEmailAndPasswordUsecase(this._authRepository, this._createUserUsecase);

  Future<void> call(AuthenticateWithEmailParam param, {required String university, required String language}) async {
    final userCredential = await _authRepository.signUpWithEmailAndPassword(param);
    final userId = userCredential.user!.uid;

    await _createUserUsecase.call(
      CreateUserDto(
        id: userId,
        email: param.email,
        username: param.email.split('@')[0],
        university: university,
        language: language,
      ),
    );

    await _authRepository.sendEmailVerification();
  }
}
