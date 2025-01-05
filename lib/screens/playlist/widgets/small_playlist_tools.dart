import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallPlaylistTools extends StatelessWidget {
  /// Returns a [Row] with the [Playlist]'s [ToggleFollowUnfollowButton],
  /// [ToggleDownloadPlaylistButton] and a [SmallPlaylistPlayerControls].
  const SmallPlaylistTools({
    super.key,
    required this.containsDownloaded,
    required this.containsAvailable,
  });

  final bool containsDownloaded;
  final bool containsAvailable;

  @override
  Widget build(BuildContext context) {
    // final libraryBloc = context.read<LibraryBloc>();
    final playlistBloc = context.read<PlaylistBloc>();
    final playlist = playlistBloc.state.viewedPlaylist ?? Playlist.empty;
    final userBloc = context.read<UserBloc>();
    final trackBloc = context.read<TrackBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ToggleFollowUnfollowButton(),
              if (containsAvailable && !kIsWeb)
                ToggleDownloadPlaylistButton(
                  playlist,
                )
              else
                Container(),
              ShareButton(
                playlist: playlist,
              ),
              OverflowIconForPlaylist(playlist: playlist),
            ],
          ),
          if (trackBloc.state.displayedTracks.isNotEmpty)
            SmallPlaylistPlayerControls(),
        ],
      ),
    );
  }
}
