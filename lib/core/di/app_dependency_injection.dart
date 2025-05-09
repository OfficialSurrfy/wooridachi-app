import 'package:get_it/get_it.dart';

import 'auth_dependencies.dart';
import 'block_report_depencencies.dart';
import 'core_dependencies.dart';
import 'image_dependencies.dart';
import 'post_dependencies.dart';
import 'translation_dependencies.dart';
import 'user_dependencies.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // Core Dependencies
  CoreDependencies.initDependencies();

  AuthDependencies.initAuthDependencies();
  BlockReportDependencies.initDependencies();
  UserDependencies.initDependencies();
  PostDependencies.initDependencies();
  ImageDependencies.initialize();
  TranslationDependencies.initialize();
}
