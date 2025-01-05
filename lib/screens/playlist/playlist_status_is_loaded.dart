import 'package:boxify/app_core.dart';

bool playlistStatusIsLoaded(PlaylistStatus status) {
  return status == PlaylistStatus.viewedPlaylistLoaded ||
      status == PlaylistStatus.playlistsUpdated ||
      status == PlaylistStatus.playlistsRemoved ||
      status == PlaylistStatus.followedPlaylistsLoaded ||
      status == PlaylistStatus.fourAndFiveStarPlaylistsLoaded ||
      status == PlaylistStatus.likedSongsPlaylistLoaded ||
      status == PlaylistStatus.newReleasesPlaylistLoaded ||
      status == PlaylistStatus.playlistsLoaded ||
      status == PlaylistStatus.enqueuedPlaylistLoaded ||
      status == PlaylistStatus.allSongsPlaylistLoaded ||
      status == PlaylistStatus.unratedPlaylistLoaded;
}
