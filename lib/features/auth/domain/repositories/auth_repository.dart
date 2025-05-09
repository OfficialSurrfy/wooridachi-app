import 'package:firebase_auth/firebase_auth.dart';

import '../entities/authenticate_with_email_param.dart';

abstract class AuthRepository {
  Future<UserCredential> signInWithEmailAndPassword(AuthenticateWithEmailParam param);
  Future<UserCredential> signUpWithEmailAndPassword(AuthenticateWithEmailParam param);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<void> deleteAccount();
  String getCurrentUserId();
  Future<void> sendEmailVerification();
}
