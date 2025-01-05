part of 'username_cubit.dart';

enum UsernameStatus { initial, submitting, success, error }

class UsernameState extends Equatable {
  final String username;
  final String email;
  final String password;
  final bool usernameIsValid;
  final UsernameStatus status;
  final Failure failure;

  bool get isFormValid =>
      username.isNotEmpty && email.isNotEmpty && password.isNotEmpty;

  const UsernameState({
    required this.username,
    required this.email,
    required this.password,
    required this.usernameIsValid,
    required this.status,
    required this.failure,
  });

  factory UsernameState.initial() {
    return const UsernameState(
      username: '',
      email: '',
      password: '',
      usernameIsValid: false,
      status: UsernameStatus.initial,
      failure: Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props =>
      [username, email, password, usernameIsValid, status, failure];

  UsernameState copyWith({
    String? username,
    String? email,
    String? password,
    bool? usernameIsValid,
    UsernameStatus? status,
    Failure? failure,
  }) {
    return UsernameState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      usernameIsValid: usernameIsValid ?? this.usernameIsValid,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
