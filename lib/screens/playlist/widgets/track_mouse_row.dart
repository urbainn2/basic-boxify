import 'package:boxify/app_core.dart';
import 'package:boxify/screens/playlist/widgets/album_or_artist.dart';
import 'package:boxify/screens/playlist/widgets/downloading_icon.dart';
import 'package:boxify/screens/playlist/widgets/duration_and_rating.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TrackMouseRow extends StatefulWidget {
  final Track track;
  final int i;
  final Color fontColor;
  final Color? tileColor;
  final bool isInsertAboveTarget;
  final bool isInsertBelowTarget;
  final bool isTappingRow;
  final bool isDoubleTappingRow;
  final bool showYear;
  final bool showDurationAndRating;
  final bool showAddButton;
  final bool showShareButton;
  final bool showLeadingWidget;
  final bool showOverflowIcon;
  final Function(
    Track track,
    int i,
    BuildContext context,
  ) onDoubleTapRow;

  final Function(
    Track track,
    int i,
    BuildContext context,
  ) onTapRow;

  TrackMouseRow({
    required this.track,
    required this.i,
    required this.fontColor,
    this.tileColor,
    this.isInsertAboveTarget = false,
    this.isInsertBelowTarget = false,
    this.isTappingRow = false,
    this.isDoubleTappingRow = false,
    required this.onDoubleTapRow,
    required this.onTapRow,
    this.showYear = false,
    this.showDurationAndRating = true,
    this.showAddButton = false,
    this.showShareButton = false,
    this.showLeadingWidget = true,
    this.showOverflowIcon = true,
  });

  @override
  _TrackMouseRowState createState() => _TrackMouseRowState();
}

class _TrackMouseRowState extends State<TrackMouseRow> {
  bool isHovering = false;
  bool isTappingRow = false;
  Widget _getDownloadIcon(
    DownloadState state,
    String uuid,
  ) {
    final isDownloading = state.isTrackDownloading(uuid);
    final isDownloaded = state.isTrackDownloaded(uuid);
    final progress = state.trackDownloadProgress(uuid);
    return isDownloaded
        ? DownloadedIcon(isFullyDownloaded: true)
        : isDownloading
            ? DownloadingIcon(progress: progress)
            : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final tileColor = widget.tileColor ?? Core.appColor.widgetBackgroundColor;
    final track = widget.track;
    final index = widget.i;
    final playlistBloc = context.read<PlaylistBloc>();
    // final trackBloc = context.read<TrackBloc>();
    final draggingCubit = BlocProvider.of<DraggingCubit>(context);
    final showRating = widget.track.isRateable &&
        (isHovering ||
            widget.isTappingRow ||
            widget.isDoubleTappingRow ||
            (track.userRating != null && track.userRating! > 0));

    return BlocBuilder<TrackBloc, TrackState>(
      builder: (context, state) {
        final isMouseClicked = state.mouseClickedTrackId == track.uuid;

        return Container(
          decoration: BoxDecoration(
            color: isMouseClicked
                ? Colors.grey.shade600
                : isHovering
                    ? Colors.grey.shade900
                    : tileColor,
            border:

                /// For inserting a [TrackMouseRow] above this [TrackMouseRow]
                widget.isInsertAboveTarget
                    ? Border(
                        top: BorderSide(width: 4, color: Core.appColor.primary),
                      )
                    :

                    /// For inserting a [TrackMouseRow] below this [TrackMouseRow]
                    widget.isInsertBelowTarget
                        ? Border(
                            bottom: BorderSide(
                                width: 4, color: Core.appColor.primary),
                          )
                        : null,
          ),
          height: Core.app.largeScreenRowHeight - 5,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              // enableFeedback: true,
              excludeFromSemantics: true,
              // Play on double tap
              onDoubleTap: () {
                draggingCubit.updateDoubleTappingRow(true, index);
                widget.onDoubleTapRow(track, index, context);
              },
              // // Select on tap
              onTap: () {
                widget.onTapRow(track, index, context);
              },
              onHover: (value) {
                setState(() {
                  isHovering = value;
                });
              },
              child: Row(
                children: [
                  // SEQUENCE NUMBER (OR PLAY BUTTON) AND IMAGE
                  Row(
                    children: [
                      LeadingWidgetForTrackMouseRow(
                        showLeadingWidget: widget.showLeadingWidget,
                        index: index,
                        isHovering: isHovering,
                        isMouseClicked: isMouseClicked,
                        isPlaying:
                            context.read<PlayerService>().isPlaying(track),
                      ),
                    ],
                  ),
                  // IMAGE TITLE BUNDLE ARTIST
                  Expanded(
                    flex: FlexValues.titleColumnFlex,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          // Image
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: RoundedCornersImage(
                              imageUrl: assignPlaylistImageUrlToTrack(
                                  track, playlistBloc.state.viewedPlaylist),
                              imageFilename: assignPlaylistImageFilenameToTrack(
                                  track, playlistBloc.state.viewedPlaylist),
                              height: 42.0,
                              width: 42.0,
                            ),
                          ),
                          // Title and Artist - Ensure Flexible/Expanded usage
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child:
                                      kIsWeb // Titles are only underlined and clickable on web
                                          ? GestureDetector(
                                              onTap: () {
                                                context.push(
                                                    '/track/${track.uuid}');
                                              },
                                              child: HoverText(
                                                text: track.displayTitle
                                                    .toString(),
                                                fontColor: widget.fontColor,
                                                fontSize:
                                                    Core.app.titleFontSize,
                                                underlineOnHover: true,
                                                changeColorOnHover: false,
                                              ),
                                            )
                                          : Text(
                                              track.displayTitle.toString(),
                                              overflow: TextOverflow
                                                  .ellipsis, // Ensuring overflow is handled
                                            ),
                                ),
                                // Subtitle (Downloaded, Bundle or artist name)
                                BlocBuilder<DownloadBloc, DownloadState>(
                                  builder: (context, state) {
                                    return Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Ensure it takes minimal space
                                        children: [
                                          _getDownloadIcon(
                                              state, track.uuid ?? ''),
                                          Flexible(
                                            child: BundleArtistTextWidget(
                                              track: track,
                                              fontSize: 12,
                                              parentIsMouseClicked:
                                                  isMouseClicked,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AlbumOrArtist(widget: widget, isHovering: isHovering),

                  // DURATION and RATING
                  DurationAndRating(
                      widget: widget,
                      playlistBloc: playlistBloc,
                      showRating: showRating,
                      index: index),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
