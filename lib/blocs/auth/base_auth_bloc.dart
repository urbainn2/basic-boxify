import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:boxify/app_core.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
//

part 'base_auth_event.dart';
part 'base_auth_state.dart';

class AuthBloc<T extends AuthRepository> extends Bloc<AuthEvent, AuthState> {
  final T authRepository;
  StreamSubscription<auth.User?>? _userSubscription;

  AuthBloc({
    required this.authRepository,
  }) : super(AuthState.unknown()) {
    _userSubscription = authRepository.user.listen(
      (user) => add(
        AuthUserChanged(user: user),
      ),
    );

    on<AuthEvent>(
      (event, emit) async {
        if (event is AuthUserChanged) {
          await _mapAuthUserChangedToState(event, emit);
        } else if (event is AuthLogoutRequested) {
          logger.i('AuthLogoutRequested in bloc');
          await authRepository.logOut();
        }
      },

      /// Specify a custom event transformer from `package:bloc_concurrency`
      /// in this case events will be processed sequentially.
      transformer: sequential(),
    );
  }

  // Every time there is a change in to the auth user, yield 'authenticated'
  // unless there is no user for this event in which case yield unauthenticated
  Future<void> _mapAuthUserChangedToState(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    event.user != null
        ? emit(AuthState.authenticated(user: event.user))
        : emit(AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
