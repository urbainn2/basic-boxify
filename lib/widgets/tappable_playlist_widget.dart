import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'playlist_widget.dart';

/// Returns a [PlaylistWidget] wrapped in a [GestureDetector] for display in your [HomeBody] LibraryBodys
/// Large and Small screens.
class TappablePlaylistWidget extends StatelessWidget {
  const TappablePlaylistWidget({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final playlistBloc = context.read<PlaylistBloc>();
    return GestureDetector(
      onTap: () {
        playlistBloc.add(SetViewedPlaylist(
            playlist: playlist)); // Just turned this back on??
        GoRouter.of(context).push('/playlist/${playlist.id}');
      },
      onSecondaryTapDown: (details) {
        PopupMenuActions.showContextMenuForPlaylist(
          context,
          details.globalPosition,
          playlist.id!,
          playlist: playlist,
          addPlaylistToLibrary: playlist.isFollowable,
          createPlaylist: false,
          editDetails: playlist.isEditable,
          removePlaylistFromLibrary: playlist.isRemoveable,
          deletePlaylist: playlist.isDeleteable,
        );
      },
      onLongPressStart: (details) {
        showPlaylistLongPressBottomSheet(
            context: context,
            playlist:
                playlist); // Long press on Spotify app shows a bottom sheet. Probably tablets too?
      },
      child: PlaylistWidget(
        playlist: playlist,
      ),
    );
  }
}
