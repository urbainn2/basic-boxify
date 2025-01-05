import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:boxify/screens/artist/widgets/playlist_card.dart';

class PlaylistsBox extends StatelessWidget {
  const PlaylistsBox({
    super.key,
    required this.playlistRowsHeight,
    required this.crossAxisCount,
    required this.playlists,
  });

  final double playlistRowsHeight;
  final int crossAxisCount;
  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    final trackBloc = context.read<TrackBloc>();
    final playlistBloc = context.read<PlaylistBloc>();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SectionHeader(name: 'Playlists', size: 18),
            SizedBox(
              height: playlistRowsHeight,
              child: GridView.builder(
                itemCount: playlists.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                ),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    // playlistBloc.add(
                    //   SetViewedPlaylist(
                    //     playlist: playlists[index],
                    //   ),
                    // );
                    GoRouter.of(context).push(
                      '/playlist/${playlists[index].id!}',
                    );
                  },
                  child: LargePlaylistCard(playlist: playlists[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
