import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LyricsScreen extends StatelessWidget {
  LyricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerState = context.watch<PlayerBloc>().state;
    final track = playerState.queue[playerState.player.currentIndex!];
    final user = context.read<UserBloc>().state.user;
    final profileImageUrl = context.read<UserBloc>().state.user.profileImageUrl;
    final artistBloc = context.read<ArtistBloc>();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          // scrolledUnderElevation: 10,
          pinned: true,
          backgroundColor: Colors.transparent,
          actions: [
            CircleArtistAvatar(
              user: user,
              profileImageUrl: profileImageUrl,
              artistBloc: artistBloc,
            )
          ],
        ),
        SliverToBoxAdapter(
          child: LyricsWidget(track: track),
        ),
      ],
    );
  }
}

class LyricsWidget extends StatelessWidget {
  const LyricsWidget({Key? key, required this.track}) : super(key: key);

  final Track track;

  @override
  Widget build(BuildContext context) {
    // Determine the correct string to display based on the app type
    final noLyricsText = Core.app.type == AppType.advanced
        ? 'noLyricsFound'.translate() // for advanced app type
        : 'noLyricsFoundBasic'
            .translate(); // for other app types including basic

    final isSmallScreen =
        MediaQuery.of(context).size.width < Core.app.largeSmallBreakpoint;

    final padding = isSmallScreen
        ? EdgeInsets.all(10)
        : EdgeInsets.fromLTRB(isSmallScreen ? 100 : 100, 0, 0, 0);

    return Container(
      // give it rounded corners
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: track.backgroundColor,
      ),

      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align to the start of cross axis
          children: [
            if (track.lyrics != '' && track.lyrics != null)
              Text(
                track.lyrics.toString(),
                style: Core.appStyle.title.copyWith(color: Colors.black),
              )
            else
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (Core.app.type == AppType.advanced) {
                      GoRouter.of(context)
                          .push('profile/${userIds['kingTomId']}');
                    }
                  },
                  child: MyLinkify(
                    text: noLyricsText,
                    textStyle:
                        Core.appStyle.title.copyWith(color: Colors.black),
                    linkStyle: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
