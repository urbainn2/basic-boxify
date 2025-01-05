import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../playlist/playlist_status_is_loaded.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistBloc = context.read<PlaylistBloc>();
    final user = context.read<UserBloc>().state.user;
    final width = MediaQuery.of(context).size.width;
    final sizeMultiplier = width > Core.app.largeSmallBreakpoint ? 1.8 : 1.0;

    return SliverToBoxAdapter(
      child: Container(
        color: Core.appColor.widgetBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 8.0),
              child: Text(
                'recommendedForYou'.translate(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 170 * sizeMultiplier,
              child: BlocBuilder<PlaylistBloc, PlaylistState>(
                builder: (context, state) {
                  final status = state.status;
                  if (status == PlaylistStatus.error) {
                    logger.e('HomeScreen.build() - PlaylistStatus == error');
                    return ErrorDialog(content: status.toString());
                  } else if (playlistStatusIsLoaded(status)) {
                    final recommendedPlaylists =
                        playlistBloc.state.recommendedPlaylists;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedPlaylists.length,
                      itemBuilder: (BuildContext context, int index) {
                        Playlist playlist = recommendedPlaylists[index];
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 8.0),
                          child: SizedBox(
                            height: 100 * sizeMultiplier,
                            width: 100 * sizeMultiplier,
                            // Add some padding if needed
                            child: TappablePlaylistWidget(
                              playlist: playlist,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    logger.i(
                        'HomeScreen.build() - PlaylistStatus == $status so returning circularProgressIndicator');
                    return circularProgressIndicator;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 8.0),
              child: Text(
                'yourPlaylists'.translate(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 170 * sizeMultiplier,
              child: BlocBuilder<PlaylistBloc, PlaylistState>(
                  builder: (context, state) {
                final status = state.status;
                if (status == PlaylistStatus.error) {
                  logger.e('HomeScreen.build() - PlaylistStatus == error');
                  return ErrorDialog(content: status.toString());
                } else if (playlistStatusIsLoaded(status)) {
                  final List<Playlist> yourPlaylists = PlaylistHelper()
                      .getYourPlaylists(playlistBloc.state, user.isAnonymous);

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: yourPlaylists.length,
                    itemBuilder: (BuildContext context, int index) {
                      Playlist playlist = yourPlaylists[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 8.0),
                        child: SizedBox(
                          height: 100 * sizeMultiplier,
                          width: 100 * sizeMultiplier,
                          // Add some padding if needed
                          child: TappablePlaylistWidget(
                            playlist: playlist,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  logger.i(
                      'HomeScreen.build() - PlaylistStatus == $status so returning circularProgressIndicator');
                  return circularProgressIndicator;
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
