import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [HomeScreen] is a widget that represents a large library screen in the application.
///
/// It uses several different types of widgets to generate its view including `CustomScrollView`,  `SliverToBoxAdapter`, and so on.
///
/// For the scrollable areas, we are using a `CustomScrollView` which allows us to create various scrolling effects, like lists, grids, and expanding headers.
///
/// `Slivers` are portions of scrollable areas that are on-screen or off-screen. Slivers are preferred over other methods like ListView, when there is a need to have more control over the scrolling behavior and elements.
///
/// This screen accepts five parameters:
///
/// An instance of `UserBloc`, `NavBloc`, `playlistsFunction`,
/// `contextMenuBehaviorFunction` and a optional boolean flag `showPrivacyPolicyTile` which is false by default.
class HomeScreen extends StatelessWidget {
  final bool showPrivacyPolicyTile;

  const HomeScreen({
    this.showPrivacyPolicyTile = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final userBloc = context.watch<UserBloc>();
    final user = userBloc.state.user;
    final playlistBloc = context.read<PlaylistBloc>();
    final isLarge =
        MediaQuery.of(context).size.width > Core.app.largeSmallBreakpoint;
    final appBarColor = isLarge
        ? playlistBloc.state.viewedPlaylist?.backgroundColor ??
            Core.appColor.widgetBackgroundColor
        : Core.appColor.widgetBackgroundColor;

    return Container(
      color: Core.appColor.widgetBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        // Instead of a traditional ListView/Column, we are using a CustomScrollView
        // A CustomScrollView lets you supply slivers directly to create various
        // scrolling effects, like lists, grids, and expanding headers.
        // Slivers are portions of a scrollable area that allows for advanced scrolling effects.
        child: CustomScrollView(
          slivers: [
            SliverAppBarExpandable(
              // The background color of the app bar.
              color: appBarColor,
              appBarBackgroundOpacity: 1.0,
              // pinned: true,
              expandedHeight: kToolbarHeight,

              /// I've been unable to reduce the size of the image.
              /// The image is too large and it's not possible to reduce it.
              /// Try something in [SliverAppBarExpandable]?
              leading: // Check if the user's information has been loaded.
                  userBloc.state.status != UserStatus.loaded
                      ? Center(child: CircularProgressIndicator())
                      : CircleArtistAvatar(
                          user: user,
                          artistBloc: context.read<ArtistBloc>(),
                          profileImageUrl: user.profileImageUrl,
                        ),
            ),
            // List/gird of items rendered using slivers for smooth performance.
            // The HomeBody generates a series of widgets using SliverGrid which
            // are provided to the CustomScrollView.
            HomeBody(),
            // The PrivacyPolicyTile (or a SizedBox) needs to be wrapped with a SliverToBoxAdapter.
            showPrivacyPolicyTile
                ? SliverToBoxAdapter(child: PrivacyPolicyTile())
                : SliverToBoxAdapter(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyTile extends StatelessWidget {
  const PrivacyPolicyTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return UrlLaunchTile(
      size: 12,
      url: Core.app.weezifyPrivacyPolicyUrl,
      userId: '8',
      text: 'Privacy Policy',
    );
  }
}
