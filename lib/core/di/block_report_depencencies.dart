import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import 'app_dependency_injection.dart';
import '../../features/block_report/data/datasources/block_report_datasource.dart';
import '../../features/block_report/data/datasources/block_report_datasource_impl.dart';
import '../../features/block_report/data/repositories/block_report_repository_impl.dart';
import '../../features/block_report/domain/repositories/block_report_repository.dart';
import '../../features/block_report/domain/usecases/block_user_usecase.dart';
import '../../features/block_report/domain/usecases/get_user_blocks_usecase.dart';
import '../../features/block_report/domain/usecases/report_user_usecase.dart';
import '../../features/block_report/presentation/providers/block_report_provider.dart';

class BlockReportDependencies {
  static void initDependencies() {
    getIt.registerSingleton<BlockReportDatasource>(BlockReportDatasourceImpl(
      getIt<FirebaseFirestore>(),
    ));
    getIt.registerSingleton<BlockReportRepository>(BlockReportRepositoryImpl(
      getIt<BlockReportDatasource>(),
    ));

    getIt.registerSingleton<GetUserBlocksUsecase>(GetUserBlocksUsecase(
      getIt<AuthRepository>(),
      getIt<BlockReportRepository>(),
    ));

    getIt.registerSingleton<BlockUserUsecase>(BlockUserUsecase(
      getIt<AuthRepository>(),
      getIt<BlockReportRepository>(),
    ));

    getIt.registerSingleton<ReportUserUsecase>(ReportUserUsecase(
      getIt<AuthRepository>(),
      getIt<BlockReportRepository>(),
    ));

    getIt.registerSingleton<BlockReportProvider>(BlockReportProvider(
      getIt<GetUserBlocksUsecase>(),
      getIt<BlockUserUsecase>(),
      getIt<ReportUserUsecase>(),
    ));
  }
}
