import 'package:boxify/app_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows the overflow menu for a track in a [BasePlaylistScreen] or [SearchResult],
/// and allows the user to perform actions on the track, such as Remove from playlist,
/// Add to other playlist, Share.
class OverflowIconForPlaylist extends StatelessWidget {
  const OverflowIconForPlaylist({
    super.key,
    required this.playlist,
    this.index,
    this.size = 24,
  });

  final Playlist playlist;
  final double? size;
  final int? index;

  @override
  Widget build(BuildContext context) {
    /// get device from mediaquery
    final device = MediaQuery.of(context);
    return IconButton(
      iconSize: size,
      onPressed: () => showPlaylistLongPressBottomSheet(
        context: context,
        playlist: playlist,
        index: index,
      ),
      icon: device.size.width > Core.app.largeSmallBreakpoint
          ? Icon(Icons.more_horiz)
          : Icon(Icons.more_vert),
      color: Colors.grey,
    );
  }
}

/// Shows the overflow menu for a track in a [BasePlaylistScreen] or [SearchResult],
/// and allows the user to perform actions on the track, such as Remove from playlist,
/// Add to other playlist, Share.
class OverflowIconForTrack extends StatelessWidget {
  const OverflowIconForTrack({
    super.key,
    required this.track,
    this.playlist,
    this.index,
  });

  final Track track;
  final Playlist? playlist;
  final int? index;

  @override
  Widget build(BuildContext context) {
    /// get device from mediaquery
    final device = MediaQuery.of(context);
    return IconButton(
      onPressed: () {
        if (track.available == true) {
          showTrackOverflowMenu(context: context, track: track);
          context
              .read<PlaylistTracksBloc>()
              .add(SelectTrackForAddingToPlaylist(track: track));
        } else {
          showTrackSnack(
            context,
            track.bundleName!,
          );
        }
      },
      icon: device.size.width > Core.app.largeSmallBreakpoint
          ? Icon(Icons.more_horiz)
          : Icon(Icons.more_vert),
    );
  }
}
