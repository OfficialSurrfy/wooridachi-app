import 'package:firebase_storage/firebase_storage.dart';

import '../../features/image/data/datasources/image_datasource.dart';
import '../../features/image/data/datasources/image_datasource_impl.dart';
import '../../features/image/data/repositories/image_repository_impl.dart';
import '../../features/image/domain/repositories/image_repository.dart';
import '../../features/image/domain/usecases/delete_image_usecase.dart';
import 'app_dependency_injection.dart';

class ImageDependencies {
  static void initialize() {
    getIt.registerLazySingleton<ImageDatasource>(() => ImageDatasourceImpl(
          getIt<FirebaseStorage>(),
        ));
    getIt.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl(
          getIt<ImageDatasource>(),
        ));

    getIt.registerLazySingleton<DeleteImageUsecase>(() => DeleteImageUsecase(
          getIt<ImageRepository>(),
        ));
  }
}
