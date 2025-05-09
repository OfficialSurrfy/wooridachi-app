import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/authenticate_with_email_param.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import 'auth_datasource.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final FirebaseAuth _auth;

  AuthDatasourceImpl(this._auth);

  User _getCurrentUser() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw UserNotFoundException();
    }
    return currentUser;
  }

  @override
  String getCurrentUserId() {
    try {
      return _getCurrentUser().uid;
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword(AuthenticateWithEmailParam param) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: param.email, password: param.password);
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(AuthenticateWithEmailParam param) async {
    try {
      print('signInWithEmailAndPassword');
      final userCredential = await _auth.signInWithEmailAndPassword(email: param.email, password: param.password);
      print('signInWithEmailAndPassword success');

      if (userCredential.user!.emailVerified) {
        return userCredential;
      } else {
        throw EmailNotVerifiedException();
      }
    } on FirebaseException catch (e) {
      print('signInWithEmailAndPassword error');
      print(e);
      rethrow;
    } catch (e) {
      print('signInWithEmailAndPassword error');
      print(e);
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      return await _getCurrentUser().sendEmailVerification();
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      return _getCurrentUser().emailVerified;
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      return await _getCurrentUser().delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
