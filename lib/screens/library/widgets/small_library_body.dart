import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pinned_playlists_provider.dart';

/// enum for the type of library screen
enum LibraryScreenType { basic, advanced, addToPlaylist }

/// Builds the list of playlists in various screens, such as
/// [SmallLibaryScreen], [SmallLibraryScreenForAddingPlaylists].
/// Basically, use it anytime you need to show a list of playlists.
class SmallLibraryBody extends StatelessWidget {
  final LibraryScreenType? type;
  const SmallLibraryBody({
    super.key,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final playlistBloc = context.read<PlaylistBloc>();
    final user = context.read<UserBloc>().state.user;

    if (type == LibraryScreenType.addToPlaylist) {
      return _buildAddToPlaylistListView(playlistBloc, user);
    } else if (Core.app.type == AppType.basic) {
      return _buildBasicListView(playlistBloc, user);
    } else {
      return _buildAdvancedListView(playlistBloc, user);
    }
  }

  Widget _buildAddToPlaylistListView(PlaylistBloc playlistBloc, User user) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.followedPlaylists.length,
          itemBuilder: (context, index) {
            final playlist = state.followedPlaylists[index];
            if (!isOwnPlaylist(
              state.followedPlaylists[index],
              user,
            )) {
              return Container();
            }
            return _buildAddToPlaylistListItem(playlist);
          },
        );
      },
    );
  }

  Widget _buildBasicListView(PlaylistBloc playlistBloc, User user) {
    return ListView.builder(
      itemCount: playlistBloc.state.allPlaylists.length +
          PinnedPlaylistsProvider.getPinnedPlaylistsCount(
              playlistBloc.state, user), // liked songs
      itemBuilder: (context, index) {
        return _buildBasicListItem(playlistBloc, user, index);
      },
    );
  }

  Widget _buildAdvancedListView(PlaylistBloc playlistBloc, User user) {
    return ListView.builder(
      itemCount: playlistBloc.state.followedPlaylists.length +
          PinnedPlaylistsProvider.getPinnedPlaylistsCount(
              playlistBloc.state, user), // liked songs and new releases
      itemBuilder: (context, index) {
        return _buildAdvancedListItem(playlistBloc, user, index);
      },
    );
  }

  Widget _buildBasicListItem(PlaylistBloc playlistBloc, User user, int index) {
    if (index == 0) {
      //   return PlaylistTile(
      //     playlist: playlistBloc.state.fiveStarPlaylist,
      //   );
      // } else if (index == 1) {
      //   return PlaylistTile(
      //     playlist: playlistBloc.state.fourStarPlaylist,
      //   );
      // return PlaylistTile(
      //   playlist: playlistBloc.state.allSongsPlaylist,
      // );
      return PlaylistTile(
        playlist: playlistBloc.state.likedSongsPlaylist,
      );
    } else if (index == 1) {
      return PlaylistTile(
        playlist: playlistBloc.state.unratedPlaylist,
      );
    } else {
      return PlaylistTile(
        playlist: playlistBloc.state.allPlaylists[index -
            PinnedPlaylistsProvider.getPinnedPlaylistsCount(
                playlistBloc.state, user)],
      );
    }
  }

  Widget _buildAdvancedListItem(
      PlaylistBloc playlistBloc, User user, int index) {
    final pinnedPlaylistsLength =
        PinnedPlaylistsProvider.getPinnedPlaylistsCount(
            playlistBloc.state, user);
    if (index == 0) {
      // return PlaylistTile(
      //   playlist: playlistBloc.state.allSongsPlaylist,
      // );
      // return PlaylistTile(
      //   playlist: playlistBloc.state.fiveStarPlaylist,
      // );
      return PlaylistTile(
        playlist: playlistBloc.state.likedSongsPlaylist,
      );
    } else if (index == 1) {
      // return PlaylistTile(
      //   playlist: playlistBloc.state.fourStarPlaylist,
      // );

      return PlaylistTile(
        playlist: playlistBloc.state.newReleasesPlaylist,
      );
    }
    else if (index ==
        playlistBloc.state.followedPlaylists.length + pinnedPlaylistsLength) {
      return UrlLaunchTile(
        size: 12,
        url: Core.app.weezifyPrivacyPolicyUrl,
        userId: '8',
        text: 'Privacy Policy',
      );
    } else {
      return PlaylistTile(
        playlist:
            playlistBloc.state.followedPlaylists[index - pinnedPlaylistsLength],
      );
    }
  }

  Widget _buildAddToPlaylistListItem(Playlist playlist) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        return PlaylistToBeAddedToTile(playlist: playlist);
      },
    );
  }
}
