part of 'library_bloc.dart';

enum LibraryStatus {
  initial,
  addingPlaylistToLibrary,
  creatingPlaylist,
  resequencingPlaylists,
  submitting,
  error,
  success,
  playlistAddedToLibrary,
  playlistCreated,
  playlistRemoved,
  playlistsResequenced,
  removingPlaylist,
  updated,
}

class LibraryState extends Equatable {
  final LibraryStatus status;
  final Failure failure;
  Playlist? playlistToRemove;
  Playlist? playlistJustCreated;
  int lastPlaylistNumber;

  LibraryState({
    required this.status,
    required this.failure,
    this.playlistToRemove,
    this.playlistJustCreated,
    this.lastPlaylistNumber = 0,
  });

  factory LibraryState.initial() {
    return LibraryState(
      status: LibraryStatus.initial,
      failure: const Failure(),
      playlistToRemove: null,
      playlistJustCreated: null,
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        playlistToRemove,
        playlistJustCreated,
        lastPlaylistNumber,
      ];

  LibraryState copyWith({
    LibraryStatus? status,
    Failure? failure,
    File? playlistImage,
    Playlist? playlistToRemove,
    Playlist? playlistJustCreated,
    int? lastPlaylistNumber,
  }) {
    return LibraryState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      playlistToRemove: playlistToRemove ?? this.playlistToRemove,
      playlistJustCreated: playlistJustCreated ?? this.playlistJustCreated,
      lastPlaylistNumber: lastPlaylistNumber ?? this.lastPlaylistNumber,
    );
  }

  // /// Define getter for Playlist.empty
  // static LibraryState get empty => LibraryState.initial();
}
