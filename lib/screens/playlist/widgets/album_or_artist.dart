import 'package:boxify/app_core.dart';
import 'package:boxify/screens/playlist/widgets/track_mouse_row.dart';
import 'package:flutter/material.dart';

class AlbumOrArtist extends StatelessWidget {
  const AlbumOrArtist({
    super.key,
    required this.widget,
    required this.isHovering,
  });

  final TrackMouseRow widget;
  final bool isHovering;

  String _getAlbum(Track track) {
    if (track.album != null) {
      return track.album.toString();
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: FlexValues.artistColumnFlex,
      child: Text(
        _getAlbum(widget.track),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isHovering ? FontWeight.bold : null,
          // color: Colors.grey[400],
          color: isHovering ? Colors.white : Colors.grey[400],
          fontSize: 12,
        ),
      ),
    );
  }
}
