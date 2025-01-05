import 'package:bloc/bloc.dart';
import 'package:boxify/app_core.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'username_state.dart';

class UsernameCubit extends Cubit<UsernameState> {
  final UserRepository _userRepository;

  UsernameCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(UsernameState.initial());
  void reset() {
    emit(UsernameState.initial());
  }

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: UsernameStatus.initial));
  }

  void saveUserRecord(String username, auth.User user) async {
    // auth.user
    logger.i('usernameCheck');
    logger.i(username);
    // logger.i(_userRepository);

    final cleanedUsername = username.replaceAll(' ', '');

    final forbiddenReason = forbiddenUsername(cleanedUsername);

    if (forbiddenReason != 'NOT_FORBIDDEN') {
      emit(
        state.copyWith(
          usernameIsValid: false,
          failure: Failure(
            message:
                'That username has has forbidden characters: "$forbiddenReason". Please choose a different username.',
          ),
          status: UsernameStatus.error,
        ),
      );
      return;
    }

    final usernameIsValid = await _userRepository.saveUserRecord(
      username: cleanedUsername,
      user: user,
    );

    logger.i('here is result:');
    logger.i(usernameIsValid);

    usernameIsValid
        ? emit(
            state.copyWith(
              status: UsernameStatus.success,
              usernameIsValid: true,
            ),
          )
        : emit(
            state.copyWith(
              usernameIsValid: usernameIsValid,
              failure: const Failure(
                message:
                    'Someone already has an account with that username. Please choose a different username.',
              ),
              status: UsernameStatus.error,
            ),
          );
  }
}
