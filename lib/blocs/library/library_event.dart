part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class AddPlaylistToLibrary extends LibraryEvent {
  final String playlistId;
  final User user;
  const AddPlaylistToLibrary({required this.playlistId, required this.user});
  @override
  List<Object?> get props => [playlistId, user];
}

class InitialLibraryState extends LibraryEvent {
  const InitialLibraryState();
  @override
  List<Object?> get props => [];
}

class CreatePlaylist extends LibraryEvent {
  final Track? trackToAdd;
  final User user;
  const CreatePlaylist({
    required this.user,
    this.trackToAdd,
  });
  @override
  List<Object?> get props => [user, trackToAdd];
}

class RemovePlaylist extends LibraryEvent {
  final User user;
  final Playlist playlist;
  const RemovePlaylist({required this.playlist, required this.user});
  @override
  List<Object?> get props => [playlist, user];
}

class DeletePlaylist extends LibraryEvent {
  final String playlistId;
  const DeletePlaylist({required this.playlistId});
  @override
  List<Object?> get props => [playlistId];
}

// class ResetYouJustCreatedANewPlaylist extends LibraryEvent {
//   const ResetYouJustCreatedANewPlaylist();
//   @override
//   List<Object?> get props => [];
// }

class ResequencePlaylists extends LibraryEvent {
  final List<Playlist> followedPlaylists;
  final int oldIndex;
  final int newIndex;
  final String playlistId;
  final User user;

  const ResequencePlaylists(
      {required this.oldIndex,
      required this.followedPlaylists,
      required this.user,
      required this.newIndex,
      required this.playlistId});
  @override
  List<Object?> get props =>
      [followedPlaylists, oldIndex, newIndex, user, playlistId];
}
