import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../block_report/presentation/widgets/custom_snack_bar.dart';
import '../../../user/domain/usecases/create_user_usecase.dart';
import '../../../user/presentation/providers/user_data_holder.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../domain/entities/authenticate_with_email_param.dart';
import '../../domain/usecases/sign_in_with_email_and_password_usecase.dart';
import '../../domain/usecases/sign_up_with_email_and_password_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import '../../domain/exceptions/auth_exceptions.dart';

class AppAuthProvider extends ChangeNotifier {
  final SignInWithEmailAndPasswordUsecase _signInWithEmailAndPasswordUsecase;
  final SignUpWithEmailAndPasswordUsecase _signUpWithEmailAndPasswordUsecase;
  final SignOutUsecase _signOutUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;
  final SendPasswordResetEmailUsecase _sendPasswordResetEmailUsecase;

  AppAuthProvider({
    required SignInWithEmailAndPasswordUsecase signInWithEmailAndPasswordUsecase,
    required SignUpWithEmailAndPasswordUsecase signUpWithEmailAndPasswordUsecase,
    required SignOutUsecase signOutUsecase,
    required DeleteAccountUsecase deleteAccountUsecase,
    required CreateUserUsecase createUserUsecase,
    required SendPasswordResetEmailUsecase sendPasswordResetEmailUsecase,
  })  : _signInWithEmailAndPasswordUsecase = signInWithEmailAndPasswordUsecase,
        _signUpWithEmailAndPasswordUsecase = signUpWithEmailAndPasswordUsecase,
        _signOutUsecase = signOutUsecase,
        _deleteAccountUsecase = deleteAccountUsecase,
        _sendPasswordResetEmailUsecase = sendPasswordResetEmailUsecase;

  Future<void> signInWithEmailAndPassword(BuildContext context, AuthenticateWithEmailParam param) async {
    try {
      await _signInWithEmailAndPasswordUsecase.call(param);
      if (!context.mounted) return;

      final userDataHolder = Provider.of<UserDataHolder>(context, listen: false);
      userDataHolder.setUser(null);

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUser(context);

      notifyListeners();
    } on AuthException catch (e) {
      if (!context.mounted) return;
      if (e is UserNotFoundException) {
        CustomSnackBar.show(context, '사용자를 찾을 수 없습니다.');
      } else if (e is EmailNotVerifiedException) {
        CustomSnackBar.show(context, '이메일 인증을 완료해주세요.');
      } else if (e is InvalidCredentialException) {
        CustomSnackBar.show(context, '이메일 또는 비밀번호가 올바르지 않습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> signUpWithEmailAndPassword(
    BuildContext context,
    AuthenticateWithEmailParam param,
    String university,
    String language,
  ) async {
    try {
      await _signUpWithEmailAndPasswordUsecase.call(
        param,
        university: university,
        language: language,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        CustomSnackBar.show(context, '회원가입이 완료되었습니다. 이메일 인증을 완료해주세요.');
      }

      notifyListeners();
    } on AuthException catch (e) {
      if (!context.mounted) return;
      if (e is EmailAlreadyInUseException) {
        CustomSnackBar.show(context, '이미 사용 중인 이메일입니다.');
      } else if (e is WeakPasswordException) {
        CustomSnackBar.show(context, '비밀번호가 너무 약합니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _signOutUsecase.call();
      notifyListeners();
    } on AuthException {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '로그아웃 중 오류가 발생했습니다.');
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _deleteAccountUsecase.call();
      notifyListeners();
    } on AuthException {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '계정 삭제 중 오류가 발생했습니다.');
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await _sendPasswordResetEmailUsecase.call(email);
      if (!context.mounted) return;
      CustomSnackBar.show(context, '비밀번호 재설정 이메일을 전송했습니다.');
    } on AuthException catch (e) {
      if (!context.mounted) return;
      if (e is UserNotFoundException) {
        CustomSnackBar.show(context, '사용자를 찾을 수 없습니다.');
      } else if (e is InvalidEmailException) {
        CustomSnackBar.show(context, '올바르지 않은 이메일 형식입니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }
}
