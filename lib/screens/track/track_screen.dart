import 'package:boxify/app_core.dart';
import 'package:boxify/blocs/blocs.dart';
import 'package:boxify/data/background_colors.dart';
import 'package:charcode/charcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import 'widgets/large_track_screen.dart';
import 'widgets/small_track_screen.dart';

/// For large screen apps: returns a [LargeTrackScreen]
/// For small screen apps: generates a [Playlist] for the track on the fly and
/// returns a [SmallTrackScreen] which is a [BasePlaylistScreen]
class TrackScreen extends StatefulWidget {
  final String trackId;
  const TrackScreen({
    super.key,
    required this.trackId,
  });

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> with ScrollListenerMixin {
  late Track track;

  @override
  Widget build(BuildContext context) {
    MediaQueryData device;
    device = MediaQuery.of(context);
    final allTracks = context.read<TrackBloc>().state.allTracks;
    final trackId = widget.trackId;
    final Track? track = allTracks.firstWhereOrNull((t) => t.uuid == trackId);
    if (track == null) {
      return ErrorPage();
    }
    final trackBloc = context.read<TrackBloc>();
    trackBloc.add(SetDisplayedTracksWithTracks(tracks: [track]));

    return WillPopScope(
      onWillPop: () async {
        /// Handle the case where the user taps the back button in the appbar
        /// to return to the parent playlist screen.
        /// https://github.com/riverscuomo/flutter-apps/issues/392
        final playlist = context.read<PlaylistBloc>().state.viewedPlaylist;
        if (playlist != null) {
          // Reload the displayedTracks with the playlistTracks
          trackBloc.add(LoadDisplayedTracks(playlist: playlist));
        }
        // final playlistBloc = context.read<PlaylistBloc>();
        // final trackIds = playlistBloc.state.viewedPlaylist!.trackIds;

        // if (Core.app.type == AppType.basic) {
        //   List<Track> tracks;
        //   tracks = allTracks.where((t) => trackIds.contains(t.uuid)).toList();

        //   // If the app is Boxify, sort the tracks by their displayTitle
        //   tracks.sort((a, b) => a.displayTitle.compareTo(b.displayTitle));
        //   // Dispatch an event to update the displayedTracks before popping
        //   trackBloc.add(SetDisplayedTracksWithTracks(
        //     tracks: tracks,
        //   ));
        // } else {
        //   trackBloc.add(LoadDisplayedTracks(playlist: playlist));
        // }

        // Allow pop
        return true;
      },
      child: BlocBuilder<TrackBloc, TrackState>(
        builder: (context, state) {
          // logger.f(state.status);
          if (state.status == TrackStatus.displayedTracksLoaded &&
              state.displayedTracks.length ==
                  1) // This is a hack to fix the bug where the
          // user is clicking from a Track screen to a Playlist screen, the displayedTracks
          // are loaded with all the new playlistTracks, but we're still on the TrackScreen
          // for some reason so we briefly see a TrackScreen with the first track of the
          // new playlist.

          {
            return device.size.width < Core.app.largeSmallBreakpoint
                ? SmallTrackScreen(
                    track: track,
                  )
                : LargeTrackScreen(
                    track: track,
                    backgroundColor: backgroundColors[
                        state.allTracks.indexOf(track) %
                            backgroundColors.length],
                    appBarBackgroundOpacity: appBarBackgroundOpacity,
                    titleOpacity: titleOpacity,
                  );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
