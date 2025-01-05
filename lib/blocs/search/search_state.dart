part of 'search_bloc.dart';

enum SearchStatus {
  initial,
  loading,
  loaded,
  submitting,
  error,
}

class SearchState extends Equatable {
  final SearchStatus status;
  final Failure failure;
  int searchTypeIndex; // Player Search: 0 for tracks, 1 for playlists, 2 for artists
  List<Track> searchResultsTracks; // or List<Track>?
  String query;
  List<Playlist> searchResultsPlaylists;
  List<User> searchResultsUsers;

  SearchState({
    required this.status,
    required this.failure,
    required this.searchTypeIndex,
    required this.searchResultsTracks,
    required this.searchResultsPlaylists,
    required this.searchResultsUsers,
    this.query = '',
  });

  factory SearchState.initial() {
    return SearchState(
      status: SearchStatus.initial,
      failure: const Failure(),
      searchTypeIndex: 0,
      searchResultsTracks: [],
      searchResultsPlaylists: const [],
      searchResultsUsers: const [],
      query: '',
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        searchTypeIndex,
        searchResultsTracks,
        searchResultsPlaylists,
        searchResultsUsers,
        query
      ];

  SearchState copyWith({
    SearchStatus? status,
    Failure? failure,
    int? searchTypeIndex,
    List<Track>? searchResultsTracks,
    List<Playlist>? searchResultsPlaylists,
    List<User>? searchResultsUsers,
    String? query,
  }) {
    return SearchState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      searchTypeIndex: searchTypeIndex ?? this.searchTypeIndex,
      searchResultsTracks: searchResultsTracks ?? this.searchResultsTracks,
      searchResultsPlaylists:
          searchResultsPlaylists ?? this.searchResultsPlaylists,
      searchResultsUsers: searchResultsUsers ?? this.searchResultsUsers,
      query: query ?? this.query,
    );
  }

  // /// Define getter for Playlist.empty
  // static SearchState get empty => SearchState.initial();
}
