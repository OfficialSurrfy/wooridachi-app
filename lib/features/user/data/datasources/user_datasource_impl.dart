import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/domain/exceptions/auth_exceptions.dart';
import '../models/user_model.dart';
import 'user_datasource.dart';

class UserDatasourceImpl extends UserDatasource {
  final FirebaseFirestore _firestore;

  UserDatasourceImpl(this._firestore);

  static const String usersCollection = 'users';
  static const String emailField = 'email';
  static const String idField = 'id';
  static const String usernameField = 'username';

  @override
  Future<UserModel> getUserById(String userId) async {
    final snap = await _firestore
        .collection(usersCollection)
        .doc(userId)
        .get();

    if (!snap.exists || snap.data() == null) {
      throw UserNotFoundException();
    }

    return UserModel.fromJson(snap.data()!);
  }


  @override
  Future<UserModel> getUserByEmail(String email) async {
    try {
      final user = await _firestore.collection(usersCollection).where(emailField, isEqualTo: email).get();
      return UserModel.fromJson(user.docs.first.data());
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserByUsername(String username) async {
    try {
      final user = await _firestore.collection(usersCollection).where(usernameField, isEqualTo: username).get();
      return UserModel.fromJson(user.docs.first.data());
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> setUser(UserModel user) async {
    try {
      await _firestore.collection(usersCollection).doc(user.id).set(user.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
