import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A widget representing a [ListTile] particularly for showing playlist.
///
/// It includes a back IconButton as leading, a text 'PLAYING FROM PLAYLIST' as
/// title and playlist's name as subtitle.
class SmallDetailTopListTile extends StatelessWidget {
  final String? source;
  final Track track;
  final Playlist? playlist;

  const SmallDetailTopListTile({
    super.key,
    this.source = 'UNKNOWN',
    required this.track,
    this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    final title = 'PLAYING FROM $source';
    return ListTile(
      leading: IconButton(
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            /// If they opened a deeplink and there is no route to pop to,
            GoRouter.of(context).go('/');
          }
        },
        icon: const Icon(Icons.arrow_downward),
      ),
      title: Center(child: Text(title)),
      subtitle: Center(child: Text(playlist?.name ?? '')),
      trailing: OverflowIconForTrack(track: track, playlist: playlist),
      titleTextStyle: TextStyle(fontSize: 11),
      subtitleTextStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
    );
  }
}
