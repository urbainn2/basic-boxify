import 'package:boxify/app_core.dart';
// import 'package:boxify/repositories/auth/base_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';

class AuthRepository {
  final auth.FirebaseAuth firebaseAuth;

  AuthRepository({
    auth.FirebaseAuth? firebaseAuth,
  }) : firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  Future<auth.User?> signInWithCredential(
    auth.AuthCredential credential,
  ) async {
    try {
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      return user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  // Create Anonymous User
  Future<auth.User?> signInAnonymously() async {
    logger.i('authRepository signInAnonymously');
    logger.i(firebaseAuth);
    auth.UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.signInAnonymously();
      logger.i(userCredential);
      final user = userCredential.user;
      logger.i(user!);
      return user;
    } catch (e) {
      logger.e(
        e,
      );
      throw Failure(
          code: 'authRepository signInAnonymously', message: e.toString());
    }
  }

  Stream<auth.User?> get user => firebaseAuth.userChanges();

  Future<auth.User?> logInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) async {
    logger.i('base auth repository: logInWithEmailAndPassword');
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      return credential.user;
    } on auth.FirebaseAuthException catch (err) {
      logger.e(err);
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      logger.e(err);
      throw Failure(code: err.code, message: err.message);
    }
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Complex App Methods
  Future<auth.User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    logger.i('authRepo: signUpWithEmailAndPassword()');
    email = email.trim();
    // logger.i(email);
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      logger.i('returning user: $user');
      return user;
    } on auth.FirebaseAuthException catch (err) {
      logger.i(
        'authRepo: signUpWithEmailAndPassword() auth.FirebaseAuthException err: $err',
      );
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      logger.i(
        'authRepo: signUpWithEmailAndPassword() PlatformException err: $err',
      );
      throw Failure(code: err.code, message: err.message);
    }
  }
}
