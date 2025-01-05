import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class PlaylistName extends StatelessWidget {
  const PlaylistName({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    bool isLarge =
        MediaQuery.of(context).size.width > Core.app.largeSmallBreakpoint;
    return Flexible(
      child: Padding(
        padding: isLarge ? EdgeInsets.all(8.0) : EdgeInsets.all(0.0),
        child: Text(
          playlist.displayTitle ?? playlist.name!,
          softWrap: true,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: isLarge ? 18.0 : 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
