import 'package:boxify/app_core.dart';
import 'package:boxify/screens/playlist/widgets/track_mouse_row.dart';
import 'package:flutter/material.dart';

class DurationAndRating extends StatelessWidget {
  const DurationAndRating({
    super.key,
    required this.widget,
    required this.playlistBloc,
    required this.showRating,
    required this.index,
  });

  final TrackMouseRow widget;
  final PlaylistBloc playlistBloc;
  final bool showRating;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: FlexValues.durationAndRatingColumnFlex,
      child: Row(
        children: [
          widget.showDurationAndRating
              ? DurationWidgetForRow(track: widget.track)
              : const SizedBox(),
          widget.showShareButton
              ? ShareButton(
                  url: '${Core.app.trackUrl}${widget.track.uuid}',
                  title: widget.track.title!,
                )
              : const SizedBox(),
          widget.showAddButton
              ? AddThisTrackButton(
                  track: widget.track,
                  playlist: playlistBloc.state.viewedPlaylist!,
                )
              : const SizedBox(),
          StarRating(
            track: widget.track,
            showRating: showRating,
          ),
          widget.showOverflowIcon
              ? OverflowIconForTrack(
                  track: widget.track,
                  playlist: playlistBloc.state.viewedPlaylist,
                  index: index,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
