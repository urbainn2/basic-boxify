import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class PinnedPlaylistsProvider {
  static List<Playlist> getPinnedPlaylists(PlaylistState state, User user) {
    if (Core.app.type == AppType.advanced) {
      var playlists = [
        state.newReleasesPlaylist,
      ];
      if (!user.isAnonymous) {
        playlists.add(state.likedSongsPlaylist);
      }
      {}
      return playlists;
    } else {
      return [
        state.likedSongsPlaylist,
        state.unratedPlaylist,
      ];
    }
  }

  // Assuming you need to generate widget list outside as well
  static List<Widget> getPinnedPlaylistsWidgets(
      PlaylistState state, User user) {
    // Determine the pinned playlists
    List<Playlist> pinnedPlaylists = getPinnedPlaylists(state, user);

    // Generate the playlist widgets from the determined pinned playlists
    return pinnedPlaylists.map((playlist) {
      final isSelected = state.viewedPlaylist?.id == playlist.id;
      return LargePlaylistTile(
        isDragTarget: false,
        isInsertAboveTarget: false,
        isInsertBelowTarget: false,
        isSelected: isSelected,
        playlist: playlist,
        index: pinnedPlaylists.indexOf(playlist),
        itemName: playlist.name ?? 'yourLibrary'.translate(),
        canAddRemovePlaylist: false,
      );
    }).toList();
  }

  // Static getter for easy access to the count of pinned playlists
  static int getPinnedPlaylistsCount(PlaylistState state, User user) {
    return getPinnedPlaylists(state, user).length;
  }
}
