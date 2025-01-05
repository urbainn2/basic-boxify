part of 'search_user_cubit.dart';

enum SearchUserStatus { initial, loading, loaded, error }

class SearchUserState extends Equatable {
  final List<User> users;
  final SearchUserStatus status;
  final Failure failure;

  const SearchUserState({
    required this.users,
    required this.status,
    required this.failure,
  });

  factory SearchUserState.initial() {
    return const SearchUserState(
      users: [],
      status: SearchUserStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [users, status, failure];

  SearchUserState copyWith({
    List<User>? users,
    SearchUserStatus? status,
    Failure? failure,
  }) {
    return SearchUserState(
      users: users ?? this.users,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
