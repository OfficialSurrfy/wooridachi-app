import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/authenticate_with_email_param.dart';

abstract class AuthDatasource {
  String getCurrentUserId();
  Future<UserCredential> signInWithEmailAndPassword(AuthenticateWithEmailParam param);
  Future<UserCredential> signUpWithEmailAndPassword(AuthenticateWithEmailParam param);
  Future<void> signOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordResetEmail(String email);
  Future<bool> isEmailVerified();
  Future<void> deleteAccount();
}
