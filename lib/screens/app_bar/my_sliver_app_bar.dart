import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// An expanded appbar with image that collapses as the user scrolls.
///
/// Used in ,  ,
/// [PlaylistTouchScreen] to display the app bar. See also [SmallAppBarForHomeAndLibrary], [SliverAppBarNoExpand]
class SliverAppBarExpandable extends StatelessWidget {
  const SliverAppBarExpandable({
    super.key,
    required this.expandedHeight,
    required this.color,
    this.appBarBackgroundOpacity = 1.0,
    this.titleOpacity = 1.0,
    this.title = '',
    this.imageUrl,
    this.imageFilename,
    this.imageSize = 200.0,
    this.shrinkImage = true,
    this.elevation = 20.0,
    this.isArtistAppBar = false,
    this.actions,
    this.leading,
  });

  final double expandedHeight;
  final Color color;
  final double appBarBackgroundOpacity;
  final double titleOpacity;
  final String title;
  final String? imageUrl;
  final String? imageFilename;
  final double imageSize;
  final bool shrinkImage;
  final double elevation;
  final bool isArtistAppBar;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: leading,
      expandedHeight: expandedHeight,
      scrolledUnderElevation: elevation,
      pinned: true,
      backgroundColor:
          Color.lerp(Colors.transparent, color, appBarBackgroundOpacity),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double imageScale = 1.0;
          if (shrinkImage) {
            imageScale = (constraints.maxHeight - kToolbarHeight) /
                (expandedHeight - kToolbarHeight);
            imageScale = imageScale.clamp(0.0, 1.0);
          }

          double imageOpacity = imageScale;
          double scale = 1.0;
          double topMargin = (expandedHeight - imageSize) / 2;

          return FlexibleSpaceBar(
            title: Opacity(
              opacity: titleOpacity,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color,
                        Core.appColor.widgetBackgroundColor,
                      ],
                    ),
                  ),
                ),
                if (imageUrl != null || imageFilename != null)
                  Positioned(
                    top: topMargin * scale,
                    left: 0.0,
                    right: 0.0,
                    child: Center(
                      child: Container(
                        height: imageSize * imageScale,
                        width: imageSize * imageScale,
                        child: Opacity(
                          opacity: imageOpacity,
                          child: imageOrIcon(
                            imageUrl: imageUrl,
                            filename: imageFilename,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      actions: actions,
    );
  }
}

/// A static image that scrolls under a transparent small app bar.
///
/// Used in [LargeTrackScreen] , [ArtistScreen], [PlaylistMouseScreen]. See also [SmallAppBarForHomeAndLibrary]
class SliverAppBarNoExpand extends StatelessWidget {
  SliverAppBarNoExpand({
    super.key,
    required this.type,
    required this.expandedHeight,
    required this.color,
    this.appBarBackgroundOpacity = 0.0, // so it's transparent when first loaded
    this.titleOpacity = 0.0,
    this.title = '',
    this.imageUrl,
    this.imageFilename,
    this.imageSize = 200.0,
    this.shrinkImage = true,
    this.elevation = 20.0,
    this.actions,
    this.leading,
  });

  final SliverAppBarNoExpandType type;
  final double expandedHeight;
  final Color color;
  final double appBarBackgroundOpacity;
  final double titleOpacity;
  final String title;
  final String? imageUrl;
  final String? imageFilename;
  final double imageSize;
  final bool shrinkImage;
  final double elevation;
  final Widget? leading;
  List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserBloc>().state.user;
    final artistBloc = context.read<ArtistBloc>();
    final playlistBloc = context.read<PlaylistBloc>();
    final trackBloc = context.read<TrackBloc>();
    final profileImageUrl = user.profileImageUrl;

    actions ??= [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleArtistAvatar(
            user: user,
            artistBloc: artistBloc,
            profileImageUrl: profileImageUrl),
      )
    ];

    // logger.w(appBarBackgroundOpacity);
    return SliverAppBar(
      scrolledUnderElevation: elevation,
      pinned: true,
      floating: false,
      backgroundColor:
          Color.lerp(Colors.transparent, color, appBarBackgroundOpacity),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
            title: Opacity(
              opacity: titleOpacity,
              child: type == SliverAppBarNoExpandType.artist
                  ? Text(title)
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PlayButtonInCircle(
                          type: type == SliverAppBarNoExpandType.playlist
                              ? CircleButtonType.playlist
                              : type == SliverAppBarNoExpandType.track
                                  ? CircleButtonType.track
                                  : null,
                          size: 48,
                          playlist: type == SliverAppBarNoExpandType.playlist
                              ? playlistBloc.state.viewedPlaylist
                              : null,
                          track: type == SliverAppBarNoExpandType.track
                              ? trackBloc.state.displayedTracks[0]
                              : null,
                        ),
                        Text(title),
                      ],
                    ),
            ),
          );
        },
      ),
      actions: actions,
    );
  }
}

// enum class for SliverAppBarNoExpand screen type
enum SliverAppBarNoExpandType {
  track,
  playlist,
  artist,
}
