import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/image/domain/repositories/image_repository.dart';
import '../../features/user/data/datasources/user_datasource.dart';
import '../../features/user/data/datasources/user_datasource_impl.dart';
import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/user/domain/usecases/create_user_usecase.dart';
import '../../features/user/domain/usecases/get_current_user_usecase.dart';
import '../../features/user/domain/usecases/get_user_by_id_usecase.dart';
import '../../features/user/domain/usecases/update_user_profile_usecase.dart';
import '../../features/user/presentation/providers/user_data_holder.dart';
import '../../features/user/presentation/providers/user_provider.dart';
import 'app_dependency_injection.dart';

class UserDependencies {
  static void initDependencies() {
    getIt.registerLazySingleton<UserDatasource>(() => UserDatasourceImpl(
          getIt<FirebaseFirestore>(),
        ));

    getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
          getIt<UserDatasource>(),
        ));

    getIt.registerLazySingleton<UpdateUserProfileUsecase>(() => UpdateUserProfileUsecase(
          getIt<UserRepository>(),
          getIt<ImageRepository>(),
        ));
    getIt.registerLazySingleton<GetCurrentUserUsecase>(() => GetCurrentUserUsecase(
          getIt<AuthRepository>(),
          getIt<UserRepository>(),
        ));
    getIt.registerLazySingleton<GetUserByIdUsecase>(() => GetUserByIdUsecase(
          getIt<UserRepository>(),
        ));
    getIt.registerLazySingleton<CreateUserUsecase>(() => CreateUserUsecase(
          getIt<UserRepository>(),
        ));

    getIt.registerLazySingleton<UserDataHolder>(
      () => UserDataHolder(),
    );

    getIt.registerLazySingleton<UserProvider>(() => UserProvider(
          userDataHolder: getIt<UserDataHolder>(),
          getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
          updateUserProfileUsecase: getIt<UpdateUserProfileUsecase>(),
        ));
  }
}
