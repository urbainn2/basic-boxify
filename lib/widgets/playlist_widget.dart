import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'owner_widget.dart';
import 'playlist_name.dart';

class PlaylistWidget extends StatefulWidget {
  const PlaylistWidget({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;
  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isLarge =
        MediaQuery.of(context).size.width > Core.app.largeSmallBreakpoint;

    // final playlistService = context.read<PlaylistService>();
    // final playlistTracks = playlistService.getPlaylistTracks(widget.playlist);
    // final playlistHelper = PlaylistHelper();
    // final bool isFullyDownloaded =
    //     playlistHelper.isFullyDownloaded(playlistTracks);
    // ignore: unused_local_variable
    final downloadBloc = context.watch<
        DownloadBloc>(); // Need this here so the widget rebuilds when the downloadBloc state changes
    return ClipRRect(
      child: MouseRegion(
        onHover: (event) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHovered = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isHovered && isLarge
                ? const Color.fromARGB(255, 61, 59, 59)
                : Core.appColor.cardColor,
            border: Border.all(),
            borderRadius: const BorderRadius.all(Radius.circular(7)),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  SquareImage(
                    imageUrl: widget.playlist.imageUrl,
                    imageFilename: widget.playlist.imageFilename,
                    color: Theme.of(context).primaryColor,
                    padding: 0.0,
                  ),
                  if (isHovered && isLarge)
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: PlayButtonInCircle(
                        playlist: widget.playlist,
                        type: CircleButtonType.home,
                      ),
                    ),
                ],
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlaylistName(playlist: widget.playlist),
                    if (widget.playlist.owner != null)
                      OwnerWidget(playlist: widget.playlist),

                    /// Only on Spotify desktop app
                    // Align(
                    //     alignment: AlignmentDirectional.bottomEnd,
                    //     child: DownloadedIcon(
                    //         isFullyDownloaded: isFullyDownloaded)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
