// import 'package:app_core/app_core.dart';  //
import 'package:boxify/app_core.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Used in Small Artist Profile Screen. This widget type does NOT exist in Spotify.
class SmallPlaylistCard extends StatelessWidget {
  const SmallPlaylistCard({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => GoRouter.of(context).push(
        '/playlist/${playlist.id}',
      ),
      child: Card(
        shape: const BeveledRectangleBorder(
          side: BorderSide(
            color: Colors.blueAccent,
            width: .3,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageOrIcon(
              imageUrl: playlist.imageUrl,
              filename: playlist.imageFilename,
            ),
            Text(
              playlist.name!,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Used in Artist Profile Large Screen. This widget type DOES exist in Spotify.
class LargePlaylistCard extends StatelessWidget {
  const LargePlaylistCard({super.key, required this.playlist});
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      color: Colors.black12,
      child: Column(
        children: [
          sizedBox16,
          RoundedCornersImage(
            imageUrl: playlist.imageUrl,
            imageFilename: playlist.imageFilename,
            color: Theme.of(context).primaryColor,
          ),
          sizedBox16,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playlist.name!,
                style: boldWhite14,
              ),
              Text(
                '${playlist.followerCount} Followers',
                style: grey14,
              ),
            ],
          )
        ],
      ),
    );
  }
}
