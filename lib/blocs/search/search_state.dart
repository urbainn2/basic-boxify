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
  List<Playlist> searchResultsPlaylists;
  List<User> searchResultsUsers;
  String query;
  String pendingQuery; // Pending query (while tracks are loading)

  SearchState({
    required this.status,
    required this.failure,
    required this.searchTypeIndex,
    required this.searchResultsTracks,
    required this.searchResultsPlaylists,
    required this.searchResultsUsers,
    this.query = '',
    this.pendingQuery = '',
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
      pendingQuery: 'EMPTY',
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
        query,
        pendingQuery
      ];

  SearchState copyWith({
    SearchStatus? status,
    Failure? failure,
    int? searchTypeIndex,
    List<Track>? searchResultsTracks,
    List<Playlist>? searchResultsPlaylists,
    List<User>? searchResultsUsers,
    String? query,
    String? pendingQuery,
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
      pendingQuery: pendingQuery ?? this.pendingQuery,
    );
  }

  // /// Define getter for Playlist.empty
  // static SearchState get empty => SearchState.initial();
}
