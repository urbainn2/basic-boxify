import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:boxify/app_core.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final UserRepository _userRepository;
  final PlaylistRepository _playlistRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;
  @override
  Future<void> close() {
    return super.close();
  }

  SettingsBloc({
    required UserRepository userRepository,
    required StorageRepository storageRepository,
    required PlaylistRepository playlistRepository,
    required AuthBloc authBloc,
    required MarketBloc marketBloc,
  })  : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _playlistRepository = playlistRepository,
        _authBloc = authBloc,
        super(SettingsState.initial()) {
    on<SettingsReset>(_profileReset);
    on<LoadSettings>(_onloadSettings);
    on<SettingsConnectDiscord>(_mapSettingsConnectDiscordToState);
    on<ReauthenticateAndDeleteAccount>(reauthenticateAndDeleteAccount);
  }

  Future<void> _profileReset(
      SettingsReset event, Emitter<SettingsState> emit) async {
    emit(SettingsState.initial());
  }

  Future<void> _onloadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    logger.i('SettingsBloc received _onloadSettings');
    emit(state.copyWith(status: SettingsStatus.loading));

    emit(
      state.copyWith(
        user: event.user,
        status: SettingsStatus.loaded,
      ),
    );
  }

  Future<void> reauthenticateAndDeleteAccount(
    ReauthenticateAndDeleteAccount event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.submitting));

      // First, delete user data from Firestore
      await _userRepository.deleteUser(event.id);

      // Clear cache
      final cacheHelper = CacheHelper();
      cacheHelper.clearSpecific('user');
      cacheHelper.clearSpecific('playlists');

      logger.i('User data deleted from Firestore.');

      logger.i('Reauthenticating and deleting auth user');

      // Use the email and password provided by the user
      String email = event.email;
      String password = event.password;

      // Create email and password credentials
      firebase_auth.AuthCredential credential =
          firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // Reauthenticate the user
      await _authBloc.state.user!.reauthenticateWithCredential(credential);

      logger.i('User reauthenticated.');

      // Now delete the user from Firebase Authentication
      await _authBloc.state.user!.delete();

      logger.i('User account deleted from Firebase Authentication.');

      emit(state.copyWith(status: SettingsStatus.accountDeleted));
    } catch (e) {
      logger.e('Error in reauthenticateAndDeleteAccount: $e');

      // Handle specific errors
      String errorMessage;
      if (e is firebase_auth.FirebaseAuthException) {
        if (e.code == 'wrong-password') {
          errorMessage = 'The password is incorrect.';
        } else if (e.code == 'user-mismatch') {
          errorMessage =
              'The provided credentials do not match the current user.';
        } else {
          errorMessage = e.message ?? 'An unknown error occurred.';
        }
      } else {
        errorMessage = 'An error occurred: $e';
      }

      emit(
        state.copyWith(
          status: SettingsStatus.error,
          failure: Failure(message: errorMessage),
        ),
      );
    }
  }

  Future<void> _mapSettingsConnectDiscordToState(
    SettingsConnectDiscord event,
    Emitter<SettingsState> emit,
  ) async {
    logger.i('profile bloc _mapSettingsConnectDiscordToState');
    // logger.i(event);
    try {
      await _userRepository.connectDiscord(
        user: event.user,
        discordId: event.discordId,
      );

      CacheHelper().saveUser(event.user.copyWith(discordId: event.discordId));
      emit(state.copyWith(
          user: event.user.copyWith(discordId: event.discordId)));
    } catch (err) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          failure:
              const Failure(message: 'Something went wrong! Please try again.'),
        ),
      );
    }
  }
}
