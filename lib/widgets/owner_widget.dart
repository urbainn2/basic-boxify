import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class OwnerWidget extends StatelessWidget {
  const OwnerWidget({
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
      padding:
          isLarge ? EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0) : EdgeInsets.all(0.0),
      child: Text(
        playlist.description!.isNotEmpty
            ? playlist.description!
            : playlist.owner!['username']! as String,
        overflow: isLarge ? TextOverflow.visible : TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isLarge ? 16 : 12,
          color: Colors.grey,
        ),
      ),
    ));
  }
}
