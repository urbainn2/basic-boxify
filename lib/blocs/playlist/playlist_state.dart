part of 'playlist_bloc.dart';

enum PlaylistStatus {
  initial,
  playlistsLoading,
  playlistsLoaded,
  playlistsDownloaded,
  allSongsPlaylistLoading, // Indicates all songs playlist is being loaded
  allSongsPlaylistLoaded, // Indicates all songs playlist is loaded
  enqueuedPlaylistLoading, // Indicates enqueued playlist is being loaded
  enqueuedPlaylistLoaded, // Indicates enqueued playlist is loaded
  followedPlaylistsLoading, // Indicates followed playlists are being loaded
  followedPlaylistsLoaded, // Indicates followed playlists are loaded
  foundBadPlaylistIds,
  fourAndFiveStarPlaylistsLoading, // Indicates liked songs playlist is being loaded
  fourAndFiveStarPlaylistsLoaded, // Indicates liked songs playlist is loaded
  likedSongsPlaylistLoading, // Indicates liked songs playlist is being loaded
  likedSongsPlaylistLoaded, // Indicates liked songs playlist is loaded
  newReleasesPlaylistLoading, // Indicates new releases playlist is being loaded
  newReleasesPlaylistLoaded, // Indicates new releases playlist is loaded
  viewedPlaylistLoading, // Indicates a specific playlist is being loaded for viewing
  viewedPlaylistLoaded, // Indicates the viewing playlist is loaded
  playlistsUpdated,
  playlistsRemoved,
  unratedPlaylistLoaded,
  unratedPlaylistLoading,
  error,
  // success,
  // updated,
}

class PlaylistState extends Equatable {
  final PlaylistStatus status;
  final Failure failure;
  Playlist? viewedPlaylist; // The viewedPlaylist you're currently viewing
  Playlist?
      enquedPlaylist; // The playlist you're currently loaded to play. This is needed for deciding where a playbutton is related or not.
  Playlist? editingPlaylist; // The playlist you're currently editing
  List<Playlist> allPlaylists;
  List<Playlist> followedPlaylists;
  List<Playlist> recommendedPlaylists;
  Playlist fiveStarPlaylist;
  Playlist fourStarPlaylist;
  Playlist allSongsPlaylist;
  Playlist unratedPlaylist;
  Playlist likedSongsPlaylist;
  Playlist newReleasesPlaylist;
  String playlistToRemove;
  String? playlistIdPassedToUrl;
  List<String>? badPlaylistIds;

  PlaylistState({
    required this.status,
    required this.failure,
    required this.viewedPlaylist,
    required this.enquedPlaylist,
    required this.editingPlaylist,
    required this.allPlaylists,
    required this.followedPlaylists,
    required this.recommendedPlaylists,
    required this.fiveStarPlaylist,
    required this.fourStarPlaylist,
    required this.allSongsPlaylist,
    required this.unratedPlaylist,
    required this.newReleasesPlaylist,
    required this.playlistToRemove,
    required this.playlistIdPassedToUrl,
    required this.likedSongsPlaylist,
    this.badPlaylistIds,
  });

  factory PlaylistState.initial() {
    return PlaylistState(
      status: PlaylistStatus.initial,
      failure: const Failure(),
      viewedPlaylist: null,
      enquedPlaylist: null,
      editingPlaylist: null,
      allPlaylists: [],
      followedPlaylists: [],
      recommendedPlaylists: [],
      playlistToRemove: '',
      fiveStarPlaylist: Playlist.empty,
      fourStarPlaylist: Playlist.empty,
      allSongsPlaylist: Playlist.empty,
      unratedPlaylist: Playlist.empty,
      likedSongsPlaylist: Playlist.empty,
      newReleasesPlaylist: Playlist.empty,
      playlistIdPassedToUrl: null,
      badPlaylistIds: null,
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        viewedPlaylist,
        enquedPlaylist,
        editingPlaylist,
        allPlaylists,
        followedPlaylists,
        recommendedPlaylists,
        fiveStarPlaylist,
        fourStarPlaylist,
        allSongsPlaylist,
        unratedPlaylist,
        newReleasesPlaylist,
        playlistToRemove,
        playlistIdPassedToUrl,
        likedSongsPlaylist,
        badPlaylistIds,
      ];

  PlaylistState copyWith({
    PlaylistStatus? status,
    Failure? failure,
    Playlist? viewedPlaylist,
    Playlist? enquedPlaylist,
    Playlist? editingPlaylist,
    List<Playlist>? allPlaylists,
    List<Playlist>? followedPlaylists,
    List<Playlist>? recommendedPlaylists,
    Playlist? fiveStarPlaylist,
    Playlist? fourStarPlaylist,
    Playlist? allSongsPlaylist,
    Playlist? unratedPlaylist,
    Playlist? newReleasesPlaylist,
    String? playlistToRemove,
    String? playlistIdPassedToUrl,
    List<String>? badPlaylistIds,
    Playlist? likedSongsPlaylist,
  }) {
    return PlaylistState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      viewedPlaylist: viewedPlaylist ?? this.viewedPlaylist,
      enquedPlaylist: enquedPlaylist ?? this.enquedPlaylist,
      editingPlaylist: editingPlaylist ?? this.editingPlaylist,
      followedPlaylists: followedPlaylists ?? this.followedPlaylists,
      recommendedPlaylists: recommendedPlaylists ?? this.recommendedPlaylists,
      allPlaylists: allPlaylists ?? this.allPlaylists,
      fiveStarPlaylist: fiveStarPlaylist ?? this.fiveStarPlaylist,
      fourStarPlaylist: fourStarPlaylist ?? this.fourStarPlaylist,
      allSongsPlaylist: allSongsPlaylist ?? this.allSongsPlaylist,
      unratedPlaylist: unratedPlaylist ?? this.unratedPlaylist,
      newReleasesPlaylist: newReleasesPlaylist ?? this.newReleasesPlaylist,
      playlistToRemove: playlistToRemove ?? this.playlistToRemove,
      playlistIdPassedToUrl:
          playlistIdPassedToUrl ?? this.playlistIdPassedToUrl,
      badPlaylistIds: badPlaylistIds ?? this.badPlaylistIds,
      likedSongsPlaylist: likedSongsPlaylist ?? this.likedSongsPlaylist,
    );
  }
}
