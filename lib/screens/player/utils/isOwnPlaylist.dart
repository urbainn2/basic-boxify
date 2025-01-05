import 'package:boxify/app_core.dart';

/// if you're the owner, if it's not a default (best of) playlist, liked songs,
/// or by the people playlist, and if it's not private
bool isOwnPlaylist(Playlist playlist, User user) {
  if ((playlist.owner?['id'] == user.id) &&
      !Core.app.defaultPlaylistIds.contains(playlist.id) &&
      !(Core.app.byThePeoplePlaylistId == playlist.id) &&
      !(playlist.id!.contains(user.id)) && // 4 and 5 star playlists
      (playlist.id == null || playlist.id != 'private')) {
    return true;
  } else {
    return false;
  }
}
