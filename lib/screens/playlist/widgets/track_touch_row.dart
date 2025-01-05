import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Used in [SmallTrackSearchResults], [PlaylistTouchScreen]
class TrackTouchRow extends StatelessWidget {
  final int i;
  final int indexWithinPlayableTracks;
  final Track track;
  final Playlist? playlist;
  final Function onTap;
  final Function? onLongPress;
  final bool showOverflowScreen;
  final bool showBundleArtistText;
  final bool showAddButton;
  final bool canLongPress;

  TrackTouchRow({
    required this.i,
    required this.indexWithinPlayableTracks,
    required this.track,
    this.playlist,
    required this.onTap,
    this.onLongPress,
    this.showOverflowScreen = true,
    this.showBundleArtistText = true,
    this.showAddButton = false,
    this.canLongPress = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, MyPlayerState>(
      builder: (context, playerState) {
        final currentIndex = playerState.player.currentIndex;

        final trackPlayingState =
            context.read<PlayerService>().getPlayingState(track);
        bool isLarge =
            MediaQuery.of(context).size.width > Core.app.largeSmallBreakpoint;
        return ListTile(
          tileColor: Core.appColor.widgetBackgroundColor,
          leading: imageOrIcon(
            imageUrl: assignPlaylistImageUrlToTrack(track, playlist),
            filename: assignPlaylistImageFilenameToTrack(track, playlist),
            height: Core.app.smallRowImageSize,
            width: Core.app.smallRowImageSize,
          ),
          enableFeedback: true,
          dense: true,
          title: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 7, 7),
                  child: Row(
                    children: [
                      LeadingWidgetForTrackTouchRow(
                        isLarge: isLarge,
                        trackPlayingState: trackPlayingState,
                      ),
                      Expanded(
                        child: Text(
                          track.displayTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: TrackHelper.getTitleColor(
                              context: context,
                              track: track,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: NewRelease(track: track),
              ),
            ],
          ),
          subtitle: showBundleArtistText
              ? BlocBuilder<DownloadBloc, DownloadState>(
                  builder: (context, state) {
                    final isDownloading = state.isTrackDownloading(track.uuid!);
                    final isDownloaded = state.isTrackDownloaded(track.uuid!) ||
                        (track.downloadedUrl != null &&
                            track.downloadedUrl!.isNotEmpty);
                    final progress = state.trackDownloadProgress(track.uuid!);
                    return Row(
                      children: [
                        if (isDownloaded)
                          DownloadedIcon(isFullyDownloaded: true),
                        if (isDownloading)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 2.0,
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Core.appColor.primary),
                              ),
                            ),
                          ),
                        Expanded(
                          child: BundleArtistTextWidget(
                            track: track,
                            fontSize: 11,
                            isInteractive: true,
                          ),
                        ),
                      ],
                    );
                  },
                )
              : DisplayTrackLink(track: track),
          trailing: showOverflowScreen
              ? OverflowIconForTrack(
                  track: track,
                  playlist: playlist,
                  index: i,
                )
              : showAddButton && playlist != null
                  ? AddThisTrackButton(
                      track: track,
                      playlist: playlist!,
                      showTextInsteadOfIcon: false,
                    )
                  : ShareButton(
                      url: '${Core.app.trackUrl}${track.uuid}',
                      title: track.title!,
                    ),
          onLongPress: () {
            if (!canLongPress) {
              return;
            }
            if (track.available == true) {
              showTrackOverflowMenu(context: context, track: track);
            } else {
              showTrackSnack(context, track.bundleName!);
            }
          },
          onTap: () {
            onTap();
          },
        );
      },
    );
  }
}

class LeadingWidgetForTrackTouchRow extends StatelessWidget {
  final TrackPlayingState trackPlayingState;
  final bool isLarge;

  LeadingWidgetForTrackTouchRow({
    required this.trackPlayingState,
    required this.isLarge,
  });

  @override
  Widget build(BuildContext context) {
    if (trackPlayingState == TrackPlayingState.playing && isLarge) {
      return Row(
        children: [
          Icon(
            Icons.graphic_eq,
            color: Core.appColor.primary,
            size: 16,
          ),
          const SizedBox(width: 5),
        ],
      );
    } else if (trackPlayingState == TrackPlayingState.paused && isLarge) {
      return Row(
        children: [
          Icon(
            Icons.more_horiz,
            color: Core.appColor.primary,
            size: 16,
          ),
          const SizedBox(width: 5),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

/// Returns the track's link, for debugging purposes
class DisplayTrackLink extends StatelessWidget {
  const DisplayTrackLink({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  Widget build(BuildContext context) {
    return Text(
      track.downloadedUrl ?? track.link!,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 10,
      ),
    );
  }
}

class NewRelease extends StatelessWidget {
  const NewRelease({
    super.key,
    required this.track,
  });

  final track;

  @override
  Widget build(BuildContext context) {
    return Text(
      track.newRelease! ? 'New!' : '',
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.orange[800],
        fontSize: 10,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
