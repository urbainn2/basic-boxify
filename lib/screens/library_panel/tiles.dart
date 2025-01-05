import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: const Key('toLib'),
      tileColor: Core.appColor.panelColor,
      leading: const Icon(
        Icons.home,
        color: Colors.grey,
      ),
      onTap: () {
        logger.i('navigating to home');
        GoRouter.of(context).push('/');
      },
      title: HoverText(
          text: Core.app.homeTitle.translate(),
          fontSize: Core.app.titleFontSize),
    );
  }
}

class MarketTile extends StatelessWidget {
  const MarketTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: const Key('Market'),
      leading: const Icon(
        Icons.shopping_bag,
        color: Colors.grey,
      ),
      onTap: () {
        GoRouter.of(context).push(
          '/market',
        );
      },
      tileColor: Core.appColor.panelColor,
      title: HoverText(
          text: 'market'.translate(), fontSize: Core.app.titleFontSize),
    );
  }
}

class SearchTile extends StatelessWidget {
  const SearchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: const Key('search'),
      leading: const Icon(
        Icons.search,
        color: Colors.grey,
      ),
      onTap: () {
        GoRouter.of(context).push(
          '/playerSearch',
        );
      },
      tileColor: Core.appColor.panelColor,
      title: HoverText(
          text: 'search'.translate(), fontSize: Core.app.titleFontSize),
    );
  }
}

/// An unteractive widget that simply displays the text 'Your Library'
class YourLibraryTitle extends StatelessWidget {
  const YourLibraryTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final playlistBloc = context.read<PlaylistBloc>();
    final libraryBloc = context.read<LibraryBloc>();
    return ListTile(
      key: const Key('toLib'),
      tileColor: Core.appColor.panelColor,
      leading: const Icon(
        Icons.library_books,
        color: Colors.grey,
      ),
      onTap: () {
        // logger.i('navigating to home');
        // GoRouter.of(context).push('/');
        //
        //
      },
      title: HoverText(
          text: 'yourLibrary'.translate(), fontSize: Core.app.titleFontSize),
      //  / Need to add 'Your Library' tile to the top of the list
      //       / on Weezify this will also have a trailing
      trailing: Core.app.type == AppType.advanced
          ? CreatePlaylistButton(
              iconColor: Colors.grey,
              onPressed: () {
                final userBloc = context.read<UserBloc>();
                if (userBloc.state.user.username == 'Lurker') {
                  GoRouter.of(context).go('/login');

                  return;
                }
                libraryBloc.add(
                  CreatePlaylist(
                    user: userBloc.state.user,
                  ),
                );
              },
            )
          : null,
    );
  }
}
