import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/auth/data/datasources/auth_datasource.dart';
import '../../features/auth/data/datasources/auth_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/delete_account_usecase.dart';
import '../../features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import '../../features/auth/presentation/providers/app_auth_provider.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/user/domain/usecases/create_user_usecase.dart';
import 'app_dependency_injection.dart';

class AuthDependencies {
  static void initAuthDependencies() {
    getIt.registerLazySingleton<AuthDatasource>(() => AuthDatasourceImpl(
          getIt<FirebaseAuth>(),
        ));
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
          getIt<AuthDatasource>(),
        ));

    getIt.registerLazySingleton<SignInWithEmailAndPasswordUsecase>(() => SignInWithEmailAndPasswordUsecase(
          getIt<AuthRepository>(),
          getIt<UserRepository>(),
        ));

    getIt.registerLazySingleton<SignUpWithEmailAndPasswordUsecase>(() => SignUpWithEmailAndPasswordUsecase(
          getIt<AuthRepository>(),
          getIt<CreateUserUsecase>(),
        ));

    getIt.registerLazySingleton<SignOutUsecase>(() => SignOutUsecase(
          getIt<AuthRepository>(),
        ));

    getIt.registerLazySingleton<DeleteAccountUsecase>(() => DeleteAccountUsecase(
          getIt<AuthRepository>(),
          getIt<UserRepository>(),
        ));

    getIt.registerLazySingleton<SendPasswordResetEmailUsecase>(() => SendPasswordResetEmailUsecase(
          getIt<AuthRepository>(),
        ));

    getIt.registerLazySingleton<AppAuthProvider>(() => AppAuthProvider(
          signInWithEmailAndPasswordUsecase: getIt<SignInWithEmailAndPasswordUsecase>(),
          signUpWithEmailAndPasswordUsecase: getIt<SignUpWithEmailAndPasswordUsecase>(),
          signOutUsecase: getIt<SignOutUsecase>(),
          deleteAccountUsecase: getIt<DeleteAccountUsecase>(),
          createUserUsecase: getIt<CreateUserUsecase>(),
          sendPasswordResetEmailUsecase: getIt<SendPasswordResetEmailUsecase>(),
        ));
  }
}
