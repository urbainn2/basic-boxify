import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boxify/app_core.dart';

/// Returns the Playlist image, name, and description
/// and the Play button, and the Playlist Queue headers,
/// and the LargeScreenRows

class PlaylistMouseScreen extends StatefulWidget {
  const PlaylistMouseScreen({required this.playlist});
  final Playlist playlist;

  @override
  _PlaylistMouseScreenState createState() => _PlaylistMouseScreenState();

  static List<Widget> buildSlivers(
    BuildContext context,
    PlaylistMouseScreen screenWidget,
    Playlist playlist,
    List<Widget> trackMouseRowItems,
    bool containsAvailable,
  ) {
    return [
      DecoratedPlaylistInfoWidgets(
          widget: screenWidget, containsAvailable: containsAvailable),
      SliverPersistentHeader(
        pinned: true,
        delegate: StickyHeaderDelegate(
          child: LargePlaylistQueueHeaders(),
          minExtentValue: kToolbarHeight - 10,
          maxExtentValue: kToolbarHeight,
          startColor: Core.appColor.widgetBackgroundColor,
          endColor: Core.appColor.hoverColor,
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return trackMouseRowItems[index];
          },
          childCount: trackMouseRowItems.length,
        ),
      ),
      SliverToBoxAdapter(
        child:
            Core.app.type == AppType.advanced && playlist.isOwnPlaylist == true
                ? LetsAddSomething()
                : trackMouseRowItems.isEmpty
                    ? (playlist.id == Core.app.newReleasesPlaylistId
                        ? CenteredText('noNewReleasesMessage'.translate())
                        : (playlist.id?.contains('_4star') == true
                            ? CenteredText('no4StarTracks'.translate())
                            : (playlist.id?.contains('_5star') == true
                                ? CenteredText('no5StarTracks'.translate())
                                : CenteredText('noTracksMessage'.translate()))))
                    : Container(),
      ),
    ];
  }
}

class _PlaylistMouseScreenState extends State<PlaylistMouseScreen> {
  List<Track>? tracks;
  int indexForItemBeingDragged = 0;

  @override
  Widget build(BuildContext context) {
    final trackBloc = context.read<TrackBloc>();
    Track track;
    final playerBloc = context.read<PlayerBloc>();
    final myPlayerState = playerBloc.state;
    track = myPlayerState.player.currentIndex != null &&
            myPlayerState.queue.isNotEmpty
        ? myPlayerState.queue[myPlayerState.player.currentIndex!]
        : Track.empty;
    final playlist = widget.playlist;

    if (skipUnavailableTrack(myPlayerState, track)) {
      context.read<PlayerBloc>().add(const SeekToNext());
    }

    final containsAvailable =
        trackBloc.state.displayedTracks.any((track) => track.available == true);

    // Instantiate TrackMouseRowHelper
    final trackMouseRowHelper = TrackMouseRowHelper();

    // Fetch the list of row items with dragging logic
    final trackMouseRowItems = trackMouseRowHelper.getTrackMouseRowItems(
      context,
      canBeADragTarget: kIsWeb,
      canDrag: kIsWeb,
      trackRowType: TrackRowType.displayedTracks,
    );

    return BlocProvider(
      create: (context) => DraggingCubit(),
      child: CustomScrollView(
        slivers: PlaylistMouseScreen.buildSlivers(
            context, widget, playlist, trackMouseRowItems, containsAvailable),
      ),
    );
  }
}

class DecoratedPlaylistInfoWidgets extends StatelessWidget {
  const DecoratedPlaylistInfoWidgets({
    super.key,
    required this.widget,
    required this.containsAvailable,
  });

  final PlaylistMouseScreen widget;
  final bool containsAvailable;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.playlist.backgroundColor,
              Core.appColor.widgetBackgroundColor,
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            LargePlaylistInfo(),
            Row(
              children: [
                PlayButtonInCircle(
                  playlist: widget.playlist,
                  type: CircleButtonType.playlist,
                ),
                ShuffleButton(size: 36),
                if (containsAvailable && !kIsWeb)
                  ToggleDownloadPlaylistButton(widget.playlist, size: 36)
                else
                  Container(),
                OverflowIconForPlaylist(
                  playlist: widget.playlist,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
