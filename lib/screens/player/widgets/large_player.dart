import 'dart:math';

import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Used in [Player]
class LargePlayer extends StatelessWidget {
  const LargePlayer({
    super.key,
    required this.track,
    this.imageFilename,
    this.imageUrl,
  });

  final Track track;
  final String? imageFilename;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    // logger.i('track in large_player.dart: ${track.title}');
    final MediaQueryData device = MediaQuery.of(context);
    return Container(
      color: Core.appColor.scaffoldBackgroundColor,
      height: Core.app.playerHeight,
      width: device.size.width - 26,
      child: Row(
        children: [
          LargeImageTitleRating(
            track: track,
            imageFilename: imageFilename,
            imageUrl: imageUrl,
          ),
          LargeControls(track: track),
          Expanded(
            child: track.lyrics != null && track.lyrics!.isNotEmpty
                ? LyricsButton(track: track)
                : Container(), // Use an empty Container to occupy the space
          ),
        ],
      ),
    );
  }
}
