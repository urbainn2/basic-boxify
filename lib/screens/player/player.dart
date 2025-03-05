import 'package:boxify/app_core.dart';
import 'package:boxify/screens/player/widgets/large_player_skeleton.dart';
import 'package:boxify/screens/player/widgets/small_player_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Player extends StatelessWidget {
  const Player({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, MyPlayerState>(builder: (context, state) {
      final index = state.player.currentIndex;
      final width = MediaQuery.of(context).size.width;
      final isLargeScreen = width >= Core.app.largeSmallBreakpoint;

      if (state.status == PlayerStatus.error) {
        logger.e('SmallPlayer.build() - PlayerStatus == error');
        return ErrorDialog(content: state.status.toString());
      } else if (index != null && index > state.queue.length) {
        logger.e('SmallPlayer.build() - index > state.queue.length');
        return ErrorDialog(content: 'index > state.queue.length');
      } else if (
          // state.status == PlayerStatus.loading ||
          state.status == PlayerStatus.initial || state.queue.isEmpty
          // ||
          // state.status == PlayerStatus.playPressed
          ) {
        logger.i(
            'Player - PlayerStatus == ${state.status} so returning CircularProgressIndicator()');
        return isLargeScreen ? LargePlayerSkeleton() : SmallPlayerSkeleton();
      } else {
        /// Get the [Track] from the player.audiosource that is currently playing,
        /// or the first track in the PlayerState.queue if no track is playing
        Track track = state.queue[index ?? 0];

        // Get current track's backgroundColor
        final backgroundColor = state.backgroundColor;

        logger.d(
            'state.player.currentIndex on Player: ${state.player.currentIndex}');
        logger.d(track.title);

        /// Listen to the playlistBloc to get the imageUrl and imageFilename when the enquedPlaylist changes
        return BlocBuilder<PlaylistBloc, PlaylistState>(
          builder: (context, state) {
            final enquedPlaylist = state.enquedPlaylist;
            final imageUrl =
                assignPlaylistImageUrlToTrack(track, enquedPlaylist);
            final imageFilename =
                assignPlaylistImageFilenameToTrack(track, enquedPlaylist);
            return isLargeScreen
                ? LargePlayer(
                    imageUrl: imageUrl,
                    imageFilename: imageFilename,
                    track: track)
                : SmallPlayer(
                    imageUrl: imageUrl,
                    imageFilename: imageFilename,
                    track: track,
                    backgroundColor: backgroundColor,
                  );
          },
        );
      }
    });
  }
}
