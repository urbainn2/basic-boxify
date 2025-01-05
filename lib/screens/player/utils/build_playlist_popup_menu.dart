import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/src/provider.dart';

/// Advanced app type only:
/// Returns a list of popup menu items for user playlists.
/// Currently that only includes [AddTrackToPlaylist]
List<PopupMenuItem> buildPlaylistPopupMenu(
  BuildContext context,
  Track demo,
) {
  final playlistBloc = context.read<PlaylistBloc>();
  final playlistTracksBloc = context.read<PlaylistTracksBloc>();
  final userBloc = context.read<UserBloc>();
  return playlistBloc.state.allPlaylists
      .where(
        (element) =>
            element.owner!['username'] == userBloc.state.user.username &&
            element.name != 'Liked Songs' &&
            !Core.app.defaultPlaylistIds.contains(element.id) &&
            element.id != 'private',
      )
      .map(
        (e) => PopupMenuItem<String>(
          onTap: () {
            playlistTracksBloc.add(AddTrackToPlaylist(
              playlist: e,
              track: demo,
            ));
          },
          child: Text(e.name!),
        ),
      )
      .toList();
}
