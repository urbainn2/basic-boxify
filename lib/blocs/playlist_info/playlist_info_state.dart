part of 'playlist_info_bloc.dart';

enum PlaylistInfoStatus {
  initial,
  updating,
  updated,

  error,
}

class PlaylistInfoState extends Equatable {
  final PlaylistInfoStatus status;
  final Failure failure;
  final File? playlistImage;
  final PlatformFile playlistImageOnWeb;
  final dynamic pngByteData;
  final Playlist? updatedPlaylist;

  PlaylistInfoState({
    required this.status,
    required this.failure,
    required this.playlistImage,
    required this.playlistImageOnWeb,
    required this.pngByteData,
    this.updatedPlaylist,
  });

  factory PlaylistInfoState.initial() {
    return PlaylistInfoState(
      status: PlaylistInfoStatus.initial,
      failure: const Failure(),
      playlistImage: null,
      playlistImageOnWeb: PlatformFile(size: 0, name: ''),
      pngByteData: 0,
      updatedPlaylist: null,
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        playlistImage,
        playlistImage,
        playlistImageOnWeb,
        pngByteData,
      ];

  PlaylistInfoState copyWith({
    PlaylistInfoStatus? status,
    Failure? failure,
    Playlist? updatedPlaylist,
    File? playlistImage,
    PlatformFile? playlistImageOnWeb,
    dynamic pngByteData,
  }) {
    return PlaylistInfoState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      playlistImage: playlistImage ?? this.playlistImage,
      playlistImageOnWeb: playlistImageOnWeb ?? this.playlistImageOnWeb,
      pngByteData: pngByteData ?? this.pngByteData,
      updatedPlaylist: updatedPlaylist ?? this.updatedPlaylist,
    );
  }
}
