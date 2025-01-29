part of 'search_bloc.dart';

// import 'package:boxify/app_core.dart';
// import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class ResetSearch extends SearchEvent {
  @override
  List<Object?> get props => [];
}

class ChangeQuery extends SearchEvent {
  final String query;
  const ChangeQuery({required this.query});
  @override
  List<Object?> get props => [query];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
  @override
  List<Object?> get props => [];
}

class SearchPlaylists extends SearchEvent {
  final List<Playlist> allPlaylists;
  const SearchPlaylists(this.allPlaylists);
  @override
  List<Object?> get props => [allPlaylists];
}

class SearchArtists extends SearchEvent {
  final List<User> allArtists;
  const SearchArtists(this.allArtists);
  @override
  List<Object?> get props => [allArtists];
}

class SearchTracks extends SearchEvent {
  final List<Track> tracks;
  const SearchTracks(this.tracks);
  @override
  List<Object?> get props => [tracks];
}

class SetSearchType extends SearchEvent {
  final int index;

  /// This event sets search type to either Songs, playlists, or Artists.
  SetSearchType(this.index);

  @override
  List<Object?> get props => [index];
}
