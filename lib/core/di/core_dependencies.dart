import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'app_dependency_injection.dart';

class CoreDependencies {
  static void initDependencies() {
    getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
    getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
    getIt.registerSingleton<Uuid>(Uuid());
  }
}
