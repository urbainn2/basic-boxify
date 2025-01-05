import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallAppBarForHomeAndLibrary extends PreferredSize {
  SmallAppBarForHomeAndLibrary({
    super.key,
  }) : super(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: const SizedBox.shrink(),
        );

  String parseShortUserId(User user) {
    var shortId = '';
    if (user.id.isNotEmpty && user.id.length > 4) {
      return user.id.substring(0, 3);
    }
    return shortId;
  }

  @override
  Widget build(BuildContext context) {
    final libraryBloc = context.read<LibraryBloc>();
    final userBloc = context.read<UserBloc>();
    final user = userBloc.state.user;

    return AppBar(
      backgroundColor: Core.appColor.widgetBackgroundColor,
      surfaceTintColor: Core.appColor.widgetBackgroundColor,
      // elevation: 20,
      automaticallyImplyLeading:
          false, // false hides leading widget back button
      // scrolledUnderElevation: 20,

      title: Row(
        children: [
          CircleArtistAvatar(
            user: user,
            profileImageUrl: user.profileImageUrl,
            artistBloc: context.read<ArtistBloc>(),
          ),
          SizedBox(
            width: 10,
          ),
          AppBarTitle(text: Core.app.libraryHeader),
        ],
      ),
      actions: <Widget>[
        if (Core.app.type == AppType.basic) Text(user.username),
        SearchButton(),
        if (Core.app.type == AppType.advanced && !user.isAnonymous)
          CreatePlaylistButton(
            onPressed: () async {
              libraryBloc.add(
                CreatePlaylist(
                  user: user,
                ),
              );
            },
          ),
      ],
    );
  }
}

class AppBarTitle extends StatelessWidget {
  final String text;
  AppBarTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
