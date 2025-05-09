import '../../features/translation/data/datasources/translation_datasource.dart';
import '../../features/translation/data/datasources/translation_datasource_impl.dart';
import '../../features/translation/data/repositories/translation_repository_impl.dart';
import '../../features/translation/domain/repositories/translation_repository.dart';
import 'app_dependency_injection.dart';

class TranslationDependencies {
  static void initialize() {
    getIt.registerLazySingleton<TranslationDatasource>(() => TranslationDatasourceImpl());
    getIt.registerLazySingleton<TranslationRepository>(() => TranslationRepositoryImpl(
          getIt<TranslationDatasource>(),
        ));
  }
}
