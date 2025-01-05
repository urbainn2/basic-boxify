// import 'package:app_core/app_core.dart';  //

import 'package:boxify/app_core.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/src/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/tiles.dart';

/// This screen displays an overflow screen for a specific track
/// from a playlist, allowing for additional options such as removing
/// the track from playlist, adding to another playlist, and sharing the track.
///
/// It receives [Track] object to identify the track in question,
/// a [Playlist] object containing the information about the playlist where the track belongs,
/// and an [index] representing the position of the track in the playlist.
class SmallOverflowScreen extends StatefulWidget {
  final Track track;
  final Playlist? playlist;
  final int? index;

  const SmallOverflowScreen({
    super.key,
    required this.track,
    required this.playlist,
    this.index,
  });

  @override
  _SmallOverflowScreenState createState() => _SmallOverflowScreenState();
}

class _SmallOverflowScreenState extends State<SmallOverflowScreen> {
  final TextEditingController _textController = TextEditingController();
  // final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    // _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData device;
    device = MediaQuery.of(context);

    final track = widget.track;
    final imageUrl = track.imageUrl;

    final index = widget.index;
    // final playlistId = widget.playlist.id;
    final trackTitle = widget.track.title;
    final playlist = widget.playlist;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: Container(
            color: Colors.black,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: SizedBox(
                height: device.size.height,
                width: device.size.width,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        imageOrIcon(
                          imageUrl:
                              assignPlaylistImageUrlToTrack(track, playlist),
                          filename: assignPlaylistImageFilenameToTrack(
                              track, playlist),
                          height: 120,
                          width: 120,
                        ),
                        sizedBox12,
                        Text(
                          track.title!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        sizedBox8,
                        Text(
                          track.artist!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        sizedBox36,
                        SizedBox(
                          height: 100,
                          child: ListView(
                            children: [
                              if (playlist != null &&
                                  widget.playlist!.isOwnPlaylist! &&
                                  index != null)
                                RemoveTrackFromPlaylistTile(
                                  playlist: playlist,
                                  trackTitle: trackTitle!,
                                  index: index,
                                )
                              else
                                AddTrackToPlaylistTile(
                                  trackTitle: trackTitle!,
                                  // index: index,
                                ),
                              ShareTile(
                                  url: '${Core.app.trackUrl}${track.uuid}',
                                  title: track.title!),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
