import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [LibraryBody] is a widget that generates a `SliverGrid`.
///
/// `SliverGrid` is a kind of sliver that places its children in arbitrary positions.
///
/// This widget accepts a few parameters:
///
/// `playlistsFunction`: a function that is responsible for generating the `playlists`.
///
/// `userBloc`: base class for managing states
///
/// `navBloc`: instance responsible for navigation
///
/// `contextMenuBehaviorFunction`: a function that describes the behavior of the
/// context menu.
///
/// [LibraryBody] Calculates the screen width, and uses that value to determine the
/// number of elements (playlists) across the grid.
///
/// For each playlist, it generates a `TappablePlaylistWidget`, which are laid out
/// in a grid format using `SliverGrid`.
class LibraryBody extends StatelessWidget {
  const LibraryBody({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final playlistBloc = context.read<PlaylistBloc>();
    final user = context.read<UserBloc>().state.user;
    final List<Playlist> playlists =
        PlaylistHelper().getYourPlaylists(playlistBloc.state, user.isAnonymous);

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: getCrossAxisCount3(context),
        childAspectRatio: 1 / 1.25,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Playlist playlist = playlists[index];

          return TappablePlaylistWidget(
            playlist: playlist,
          );
        },
        childCount: playlists.length,
      ),
    );
  }
}
