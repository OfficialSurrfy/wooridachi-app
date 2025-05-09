import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/auth_datasource.dart';
import '../../domain/entities/authenticate_with_email_param.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/exceptions/auth_exceptions.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource _authDatasource;

  AuthRepositoryImpl(this._authDatasource);

  @override
  Future<UserCredential> signInWithEmailAndPassword(AuthenticateWithEmailParam param) async {
    try {
      return await _authDatasource.signInWithEmailAndPassword(param);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.fromCode(e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword(AuthenticateWithEmailParam param) async {
    try {
      return await _authDatasource.signUpWithEmailAndPassword(param);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.fromCode(e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authDatasource.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.fromCode(e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authDatasource.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.fromCode(e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _authDatasource.deleteAccount();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.fromCode(e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getCurrentUserId() {
    try {
      return _authDatasource.getCurrentUserId();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _authDatasource.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.fromCode(e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
