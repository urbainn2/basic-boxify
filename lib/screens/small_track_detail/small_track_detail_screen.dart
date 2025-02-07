import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/widgets.dart';

class PlayerSmallTrackDetailScreen extends StatefulWidget {
  const PlayerSmallTrackDetailScreen({super.key});

  @override
  _PlayerSmallTrackDetailScreenState createState() =>
      _PlayerSmallTrackDetailScreenState();
}

class _PlayerSmallTrackDetailScreenState<Track>
    extends State<PlayerSmallTrackDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, MyPlayerState>(
      builder: (context, state) {
        final playerBlocState = context.read<PlayerBloc>().state;
        final playlistBloc = context.read<PlaylistBloc>();
        final track =
            playerBlocState.queue[playerBlocState.player.currentIndex!];

        final enquedPlaylist = playlistBloc.state.enquedPlaylist;

        final imageUrl = assignPlaylistImageUrlToTrack(track, enquedPlaylist);
        final imageFilename =
            assignPlaylistImageFilenameToTrack(track, enquedPlaylist);

        if (imageUrl != null &&
            imageUrl.isNotEmpty &&
            imageUrl != 'assets/images/rc.png') {}
        final size = MediaQuery.of(context).size;
        final height = size.height;
        final width = size.width;

        return Material(
          child: Container(
            decoration: BoxDecoration(
              // add the same color gradient
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  track.backgroundColor,
                  Core.appColor.widgetBackgroundColor,
                ],
              ),
            ),
            height: height,
            child: ListView(
              children: [
                // const SizedBox(height: 20),
                SmallDetailTopListTile(
                  playlist: playlistBloc.state.enquedPlaylist,
                  track: track,
                  source: 'PLAYLIST',
                ),
                const SizedBox(height: 10),

                /// This is the actual up front image for the track
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    children: [
                      imageOrIcon(
                        imageUrl: imageUrl,
                        filename: imageFilename,
                        height: width - 100, // Notice these are both from width
                        width: width - 100,
                        roundedCorners: 8,
                      ),
                      const SizedBox(height: 20),
                      SongInfoWidget(track: track),
                      const SizedBox(height: 20),
                      SeekBarWidget(),
                      const SizedBox(height: 20),
                      PlayerControls(
                        track: track,
                      ),
                      const SizedBox(height: 10),
                      LyricsWidget(track: track),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
