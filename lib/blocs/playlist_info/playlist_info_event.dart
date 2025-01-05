part of 'playlist_info_bloc.dart';

abstract class PlaylistInfoEvent extends Equatable {
  const PlaylistInfoEvent();

  @override
  List<Object?> get props => [];
}

class InitialPlaylistInfoState extends PlaylistInfoEvent {
  @override
  List<Object?> get props => [];
}

class PlaylistImageChangedOnWeb extends PlaylistInfoEvent {
  final PlatformFile? playlistImageOnWeb;
  final dynamic pngByteData;
  const PlaylistImageChangedOnWeb({
    required this.playlistImageOnWeb,
    required this.pngByteData,
  });

  @override
  List<Object?> get props => [playlistImageOnWeb, pngByteData];
}

class PlaylistImageChanged extends PlaylistInfoEvent {
  final CroppedFile? playlistImage;

  const PlaylistImageChanged({required this.playlistImage});

  @override
  List<Object?> get props => [
        playlistImage,
      ];
}

// class ChangeDescription extends PlaylistInfoEvent {
//   final Playlist playlist;
//   final String? description;
//   const ChangeDescription({required this.playlist, this.description});
//   @override
//   List<Object?> get props => [playlist, description];
// }

class Submit extends PlaylistInfoEvent {
  final Playlist playlist;
  final String? description;
  final String? name;
  final String userId;
  const Submit(
      {required this.playlist,
      required this.description,
      required this.name,
      required this.userId});

  @override
  List<Object?> get props => [playlist, description, name, userId];
}

class SubmitOnWeb extends PlaylistInfoEvent {
  final Playlist playlist;
  final String? description;
  final String? name;
  final String userId;
  const SubmitOnWeb(
      {required this.playlist,
      required this.description,
      required this.name,
      required this.userId});

  @override
  List<Object?> get props => [playlist, description, name, userId];
}
