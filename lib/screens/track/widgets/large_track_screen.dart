import 'package:boxify/app_core.dart';
import 'package:boxify/data/background_colors.dart';
import 'package:charcode/charcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LargeTrackScreen extends StatefulWidget {
  final Track track;
  final Color backgroundColor;
  final double appBarBackgroundOpacity;
  final double titleOpacity;

  const LargeTrackScreen({
    super.key,
    required this.track,
    required this.backgroundColor,
    required this.appBarBackgroundOpacity,
    required this.titleOpacity,
  });

  @override
  State<LargeTrackScreen> createState() => _LargeTrackScreenState();
}

class _LargeTrackScreenState extends State<LargeTrackScreen>
    with ScrollListenerMixin {
  @override
  Widget build(BuildContext context) {
    final trackBloc = context.read<TrackBloc>();
    final state = trackBloc.state;
    final displayedTracks = state.displayedTracks;
    final track = displayedTracks[0];
    final shareUrl = '${Core.app.trackUrl}${track.uuid}';

    /// pick a random color from the list of background colors
    final backgroundColor = backgroundColors[
        state.allTracks.indexOf(track) % backgroundColors.length];

    logger.i(titleOpacity);

    return CustomScrollView(controller: scrollController, slivers: [
      SliverAppBarNoExpand(
        type: SliverAppBarNoExpandType.track,
        appBarBackgroundOpacity: appBarBackgroundOpacity,
        titleOpacity: titleOpacity,
        title: track.displayTitle,
        color: backgroundColor,
        expandedHeight: kToolbarHeight,
      ),
      SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [backgroundColor, Core.appColor.cardColor],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PLAYLIST INFO
              LargeTrackInfo(
                track: track,
                imageUrl: track.imageUrl,
                imageFilename: track.imageFilename,
              ),
              PlayButtonInCircle(
                track: track,
                type: CircleButtonType.track,
              ),

              const Divider(
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () => ShareHelper.shareContent(
                    context: context,
                    url: shareUrl,
                    title: track.displayTitle,
                  ),
                  icon: const Icon(Icons.share),
                  iconSize: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Text(
                  'Lyrics',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: track.lyrics != '' && track.lyrics != null
                    ? Text(
                        track.lyrics.toString(),
                        style: TextStyle(color: Colors.grey[400], fontSize: 24),
                      )
                    : MyLinkify(
                        text: 'noLyricsFound'.translate(),
                        textStyle: TextStyle(fontStyle: FontStyle.italic),
                        linkStyle: TextStyle(color: Colors.blue),
                      ),
              )
            ],
          ),
        ),
      )
    ]);
  }
}

class LargeTrackInfo extends StatelessWidget {
  final Track track;
  final String? imageUrl;
  final String? imageFilename;

  LargeTrackInfo({
    Key? key,
    required this.track,
    this.imageUrl,
    this.imageFilename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // logger.i('buildLargeTrackInfo');
    final trackBloc = context.read<TrackBloc>();
    if (trackBloc.state.displayedTracks.isEmpty ||
        trackBloc.state.status != TrackStatus.displayedTracksLoaded) {
      return Padding(
          padding: const EdgeInsets.all(0), child: CircularProgressIndicator());
    }
    // else if (trackBloc.state.displayedTracks.length == 1) {
    //   final track = trackBloc.state.displayedTracks[0];
    // } else {
    //   final playerBloc = context.read<PlayerBloc>();
    // final index = playerBloc.state.player.currentIndex ?? 0;
    //   final track = trackBloc.state.displayedTracks[index];
    // }

    final title = track.title;
    String trackString = 'SONG: $title';

    final playlistBloc = context.read<PlaylistBloc>();
    var imageUrl =
        assignPlaylistImageUrlToTrack(track, playlistBloc.state.viewedPlaylist);
    var imageFilename = assignPlaylistImageFilenameToTrack(
        track, playlistBloc.state.enquedPlaylist);

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
      child: SizedBox(
        height: 320,
        child: Row(
          children: [
            // IMAGE
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black12,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(1, 1), //(x,y)
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          height: 260,
                          width: 260,
                          child: imageOrIcon(
                            imageUrl: imageUrl,
                            filename: imageFilename,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // INFO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Scrollbar(
                  // isAlwaysShown: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SelectableText(
                          trackString,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            track.title!,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              track.artist ?? 'Rivers Cuomo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(String.fromCharCode($bull)),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(track.year.toString()),
                          ),
                          Text(String.fromCharCode($bull)),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(printCustomDuration(track.length!)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
