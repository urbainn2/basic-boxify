// import 'package:app_core/app_core.dart';  //
import 'package:bloc/bloc.dart';
import 'package:boxify/app_core.dart';
import 'package:boxify/cubits/login/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class LoginCubit<T extends AuthRepository> extends Cubit<LoginState> {
  final T _authRepository;

  LoginCubit({required T authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  T get authRepository => _authRepository;

  void emailChanged(String value) {
    final trimmedEmail = value.trim();
    emit(state.copyWith(email: trimmedEmail, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  void reset() {
    emit(LoginState.initial());
  }

  void toggleShowPassword() {
    bool newValue = !state.showPassword;
    emit(state.copyWith(showPassword: newValue, status: LoginStatus.initial));
  }

  Future<void> logInWithCredentials() async {
    logger.i('login cubit logInWithCredentials');
    // logger.i(state.status);
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    // logger.i(state.status);
    // logger.i('valid form');
    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password,
      );
      logger.i('logInWithCredentials LoginStatus.success');
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser =
          await googleSignIn.signInSilently(); // Use signInSilently here

      if (googleUser == null) {
        // No user was signed in before, try signIn() to prompt the user
        final googleUserPrompted = await googleSignIn.signIn();
        if (googleUserPrompted == null) {
          // User canceled the sign-in process
          return;
        }
        // Use the prompted user
        googleUser = googleUserPrompted;
      }

      final googleAuth = await googleUser.authentication;

      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      await _authRepository.signInWithCredential(credential);
      logger.i('logInWithGoogle LoginStatus.success');
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    } on PlatformException catch (e) {
      // Handle PlatformException here
      emit(
        state.copyWith(
          failure: Failure(message: 'Google Sign-In failed: ${e.message}'),
          status: LoginStatus.error,
        ),
      );
    }
  }

  Future<void> signInAnonymously() async {
    logger.i('login cubit signInAnonymously');
    // logger.i(state.status);

    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.signInAnonymously();
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  Future<void> resetPassword(String email) async {
    await _authRepository.resetPassword(email);
  }

  /// Complex App methods
  Future<void> logInWithGoogleWeb(GoogleSignInUserData userData) async {
    logger.i('login cubit logInWithGoogleWeb');
    try {
      // Create a credential object using the idToken
      final credential = auth.GoogleAuthProvider.credential(
        idToken: userData.idToken,
      );
      await authRepository.signInWithCredential(credential);
      logger.i('logInWithGoogle LoginStatus.success');
      emit(
        state.copyWith(
          status: LoginStatus.success,
        ),
      );
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    } on PlatformException catch (e) {
      // Handle PlatformException here
      emit(
        state.copyWith(
          failure: Failure(message: 'Google Sign-In failed: ${e.message}'),
          status: LoginStatus.error,
        ),
      );
    }
  }
}
