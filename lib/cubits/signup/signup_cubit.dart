import 'package:bloc/bloc.dart';
import 'package:boxify/app_core.dart';
import 'package:equatable/equatable.dart';
// import 'package:app_core/app_core.dart';  //
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignupCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(SignupState.initial());

  // void usernameChanged(String value) {
  //   emit(state.copyWith(username: value, status: SignupStatus.initial));
  // }
  Future<void> reset() async {
    emit(SignupState.initial());
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  // @override
  Future<void> signUpWithCredentials() async {
    logger.i(state.isFormValid);
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      logger.i('signUpWithCredentials()');
      await _authRepository.signUpWithEmailAndPassword(
        // username: state.username,
        email: state.email,
        password: state.password,
      );

      emit(state.copyWith(status: SignupStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: SignupStatus.error));
    } on PlatformException catch (e) {
      // Handle PlatformException here
      emit(
        state.copyWith(
          failure: Failure(message: 'Google Sign-Up failed: ${e.message}'),
          status: SignupStatus.error,
        ),
      );
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      await _authRepository.signInWithCredential(credential);
      emit(state.copyWith(status: SignupStatus.success));
    } on Failure catch (err) {
      logger.i('final googleSignIn = GoogleSignIn(); error ${err.message}');
      emit(state.copyWith(failure: err, status: SignupStatus.error));
    } on PlatformException catch (e) {
      logger.i('final googleSignIn = GoogleSignIn(); error ${e.message}');
      // Handle PlatformException here
      emit(
        state.copyWith(
          failure: Failure(
            message: 'final googleSignIn = GoogleSignIn(); error: ${e.message}',
          ),
          status: SignupStatus.error,
        ),
      );
    }
  }

  // Future<bool> usernameCheck(String username) async {
  //   logger.i('usernameCheck');
  //   logger.i(username);
  //   logger.i(_userRepository);
  //   bool usernameIsValid =
  //       await _userRepository.checkIfUsernameExists(username);

  //   logger.i('here is result:');
  //   logger.i(usernameIsValid);

  //   usernameIsValid
  //       ? emit(state.copyWith(
  //           usernameIsValid: usernameIsValid, status: SignupStatus.initial))
  //       : emit(state.copyWith(
  //           usernameIsValid: usernameIsValid,
  //           failure: Failure(
  //               message:
  //                   'Someone already has an account with that username. Please choose a different username.'),
  //           status: SignupStatus.error));
  //   return usernameIsValid;

  //   // emit(state.copyWith(
  //   //     usernameIsValid: usernameIsValid, status: SignupStatus.initial));
  // }
}
