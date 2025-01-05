// import 'package:app_core/app_core.dart';  //

import 'package:boxify/app_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:charcode/charcode.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:go_router/go_router.dart';

/// Returns a row with the owner's image, name, and playlist follower count.
/// Also, handles following and unfollowing. Used in [LargePlaylistInfo].
class PlaylistOwnerRow extends StatelessWidget {
  PlaylistOwnerRow({
    super.key,
    required this.isFollowing,
    this.followerCount,
    required this.ownerImage,
    required this.ownerName,
    this.userId,
    required this.playlist,
  });
  final int? followerCount;
  final bool isFollowing;
  final String ownerImage;
  String ownerName;
  String? userId;
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final isAnonymous = context.read<UserBloc>().state.user.isAnonymous;
    final userBloc = context.read<UserBloc>();
    final libraryBloc = context.read<LibraryBloc>();
    userId = userId ?? userBloc.state.user.id;
    final isSmall =
        MediaQuery.of(context).size.width < Core.app.largeSmallBreakpoint;

    if (!isSmall) {
      ownerName += ' ${String.fromCharCode($bull)} $followerCount followers';
    }
    var additionalWidgetsForLargeOwnerRow = [
      if (isFollowing)
        IconButton(
          onPressed: () {
            if (isAnonymous) {
              logger.i('to login');
              GoRouter.of(context).push('/login');
            } else {
              libraryBloc.add(RemovePlaylist(
                  playlist: playlist, user: userBloc.state.user));
              ScaffoldMessenger.of(context)
                  .showSnackBar(buildSnackbar('Removed From Your Library'));
            }
          },
          icon: const Icon(Icons.favorite),
        )
      else
        IconButton(
          onPressed: () {
            if (isAnonymous) {
              logger.i('to login');
              // context.read<AuthBloc>().add(AuthLogoutRequested());
              GoRouter.of(context).push('/login');
            } else {
              libraryBloc.add(AddPlaylistToLibrary(
                  playlistId: playlist.id!, user: userBloc.state.user));
              ScaffoldMessenger.of(context)
                  .showSnackBar(buildSnackbar('Added to your library'));
            }
          },
          icon: const Icon(Icons.favorite_border_outlined),
        ),
    ];
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
      child: Row(children: [
        OwnerAvatarAndName(
          imageUrl: ownerImage,
          ownerName: ownerName,
          type: OwnerAvatarAndNameType.largePlaylistInfo,
          userId: userId!,
        ),
        if (!isSmall) ...additionalWidgetsForLargeOwnerRow,
      ]),
    );
  }
}

/// enum for the OwnerAvatarAndName widget
/// [smallPlaylistInfo], [largePlaylistInfo], [bottomOfSmallTrackScreen]
enum OwnerAvatarAndNameType {
  smallPlaylistInfo,
  largePlaylistInfo,
  bottomOfSmallTrackScreen,
}

class OwnerAvatarAndName extends StatelessWidget {
  final String imageUrl;
  final String ownerName;
  final OwnerAvatarAndNameType type;
  final String userId;

  const OwnerAvatarAndName({
    Key? key,
    required this.imageUrl,
    required this.ownerName,
    this.type = OwnerAvatarAndNameType.largePlaylistInfo,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // a switch block to set [size] based on type
    double imageSize;
    double fontSize;
    FontWeight fontWeight;
    switch (type) {
      case OwnerAvatarAndNameType.smallPlaylistInfo:
        imageSize = 20;
        fontSize = 12;
        fontWeight = FontWeight.bold;
        break;
      case OwnerAvatarAndNameType.largePlaylistInfo:
        imageSize = 25;
        fontSize = 14;
        fontWeight = FontWeight.bold;
        break;
      case OwnerAvatarAndNameType.bottomOfSmallTrackScreen:
        imageSize = 40;
        fontSize = 15;
        fontWeight = FontWeight.normal;
        break;
    }
    return GestureDetector(
      onTap: () => GoRouter.of(context).push(
        '/user/$userId',
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: CachedNetworkImage(
              height: imageSize,
              width: imageSize,
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              ownerName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
