part of 'base_auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged({required this.user});
  final auth.User? user;

  @override
  List<Object?> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {}
