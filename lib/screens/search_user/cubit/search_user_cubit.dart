import 'package:bloc/bloc.dart';
import 'package:boxify/app_core.dart';
import 'package:equatable/equatable.dart';
// import 'package:app_core/app_core.dart';  //

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  final UserRepository _userRepository;

  SearchUserCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchUserState.initial());

  void reset() {
    emit(SearchUserState.initial());
  }

  void searchUsers(String query) async {
    emit(state.copyWith(status: SearchUserStatus.loading));
    final searchResults = <User>[];

    try {
      final results = await _userRepository.fetchUsersApi();
      final filtered = results
          .where(
            (element) =>
                element.username.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      searchResults.addAll(filtered);
      if (searchResults.length > 30) {
        searchResults.length = 30;
      }
      emit(state.copyWith(
          users: searchResults, status: SearchUserStatus.loaded));
    } catch (err) {
      state.copyWith(
        status: SearchUserStatus.error,
        failure:
            const Failure(message: 'Fudgsicles. searchUsers() bombed out.'),
      );
    }
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchUserStatus.initial));
  }
}
