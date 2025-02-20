import 'package:boxify/app_core.dart';
import 'package:boxify/enums/load_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Currently returns the 3 [ElevatedButton] and the  [ListView] of search results.
class SearchMusicScreen extends StatefulWidget {
  SearchMusicScreen({super.key});

  @override
  _SearchMusicScreenState createState() => _SearchMusicScreenState();
}

class _SearchMusicScreenState extends State<SearchMusicScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    final playlistBloc = context.read<PlaylistBloc>();
    final userBloc = context.read<UserBloc>();
    final trackBloc = context.read<TrackBloc>();

    return Scaffold(
        appBar: SearchPlayerBar(userBloc: userBloc),
        body: BlocListener<TrackBloc, TrackState>(
          listenWhen: (previous, current) =>
              previous.tracksLoadStatus != current.tracksLoadStatus,
          listener: (context, trackState) {
            if (trackState.tracksLoadStatus == LoadStatus.loaded) {
              searchBloc.add(ExecutePendingSearch());
            }
          },
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              final screenType = Utils.getScreenType(context);
              final allPlaylists = playlistBloc.state.allPlaylists;
              final songsSelected = searchBloc.state.searchTypeIndex == 0;
              final playlistsSelected = searchBloc.state.searchTypeIndex == 1;
              final artistsSelected = searchBloc.state.searchTypeIndex == 2;

              if (playlistsSelected) {
                // If you're already following a playlist, let's put it at the bottom of the list.
                for (final element in allPlaylists) {
                  if (userBloc.state.user.playlistIds.contains(element.id) ||
                      element.id == Core.app.newReleasesPlaylistId) {
                    element.sortScore = -1000;
                  } else {
                    element.sortScore = element.score;
                  }
                }
                allPlaylists.sort(
                    (b, a) => (a.sortScore ?? 0).compareTo(b.sortScore ?? 0));
              }

              var itemCount = 0;
              if (songsSelected) {
                itemCount = state.searchResultsTracks.length;
              } else if (playlistsSelected) {
                itemCount = state.searchResultsPlaylists.length;
              } else if (artistsSelected) {
                itemCount = state.searchResultsUsers.length;
              }
              logger.i('item count: $itemCount');

              // Are tracks being fetched from the server?
              final showLoadingState = state.status == SearchStatus.loading ||
                  trackBloc.state.tracksLoadStatus == LoadStatus.notLoaded ||
                  trackBloc.state.tracksLoadStatus == LoadStatus.loading;

              MediaQueryData device;
              device = MediaQuery.of(context);
              final isLargeScreen =
                  device.size.width > Core.app.largeSmallBreakpoint;
              switch (state.status) {
                case SearchStatus.error:
                  return ErrorDialog(
                    content: state.failure.message!,
                  );
                case SearchStatus
                      .loading: //TODO: use skeletons instead (only use showLoadingState as a 'is-loading' flag)
                  return const Center(child: CircularProgressIndicator());
                case SearchStatus.loaded:
                  // If you have some search results already
                  if (state.searchResultsTracks.isNotEmpty ||
                      state.searchResultsPlaylists.isNotEmpty ||
                      state.searchResultsUsers.isNotEmpty ||
                      showLoadingState) {
                    /// This was firing even when user was on playlist screen, not search screen. Oh maybe we're not even
                    /// accessing displayedTracks in the search screen. We're just accessing searchResultsTracks.
                    // trackBloc.add(SetDisplayedTracksWithTracks(
                    //     tracks: state.searchResultsTracks));
                    // logger.w(state.status);
                    return Stack(children: [
                      /// Paint search results first so they will be at the bottom of the stack
                      songsSelected &&
                              (state.searchResultsTracks.isNotEmpty ||
                                  showLoadingState)
                          ? isLargeScreen && kIsWeb
                              ? LargeTrackSearchResults(
                                  screenType: screenType,
                                  isLargeScreen: isLargeScreen,
                                  itemCount: itemCount,
                                  showLoadingState: showLoadingState)
                              :

                              /// TOUCH OR SMALL SCREEN SEARCH RESULT SONGS ROWS
                              // If tracks selected
                              Column(
                                  children: [
                                    SizedBox(
                                      height: 65,
                                    ),
                                    Expanded(
                                        child: SmallTrackSearchResults(
                                      showLoadingState: showLoadingState,
                                    )),
                                  ],
                                )
                          : playlistsSelected &&
                                  state.searchResultsPlaylists.isNotEmpty
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 65,
                                    ),
                                    Expanded(
                                        child: SmallPlaylistSearchResults(
                                            itemCount: itemCount)),
                                  ],
                                )
                              : (artistsSelected &&
                                      state.searchResultsUsers.isNotEmpty)
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 65,
                                        ),
                                        Expanded(
                                          child: SmallArtistsSearchResult(
                                              itemCount: itemCount,
                                              userBloc: userBloc),
                                        ),
                                      ],
                                    )
                                  : Container(),

                      /// Search Type selector pills painted last so they will be on top
                      SearchTypeSelectorPills(
                          screenType: screenType,
                          searchBloc: searchBloc,
                          songsSelected: songsSelected,
                          playlistsSelected: playlistsSelected,
                          artistsSelected: artistsSelected),
                    ]);
                  } else {
                    return SizedBox.shrink();
                  }
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ));
  }
}

class SmallArtistsSearchResult extends StatelessWidget {
  const SmallArtistsSearchResult({
    super.key,
    required this.itemCount,
    required this.userBloc,
  });

  final int itemCount;
  final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int i) {
            final user = state.searchResultsUsers[i];
            // return Text('l;');

            return ListTile(
              leading: CircularImage(
                radius: 22,
                imageString: user.profileImageUrl,
              ),
              title: Text(
                user.username,
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                if (Core.app.type == AppType.advanced) {
                  context.read<ArtistBloc>().add(
                      LoadArtist(viewer: userBloc.state.user, userId: user.id));
                  GoRouter.of(context).push(
                    '/user/${user.id}',
                  );
                } else {
                  // show a dialog that says Artist viewing is unavailable in ${Core.app.name}
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('featureNotAvailable'.translate()),
                        content: Text(
                            'Artist viewing is unavailable in ${Core.app.name}.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('ok'.translate()),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            );
          }
          // },
          );
    });
  }
}

class SmallPlaylistSearchResults extends StatelessWidget {
  const SmallPlaylistSearchResults({
    super.key,
    required this.itemCount,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int i) {
          // return Text('lkj');
          final playlist = state.searchResultsPlaylists[i];
          final url = '${Core.app.playlistUrl}${playlist.id}';
          final title = playlist.name.toString();
          return ListTile(
            onLongPress: () {
              ShareHelper.shareContent(
                context: context,
                url: url,
                title: title,
              );
            },
            leading: imageOrIcon(
              imageUrl: playlist.imageUrl,
              filename: playlist.imageFilename,
              height: Core.app.smallRowImageSize, // TODO
              width: Core.app.smallRowImageSize,
            ),
            title: Text(
              playlist.name.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            onTap: () {
              GoRouter.of(context).push(
                '/playlist/${playlist.id}',
              );

              final playlistBloc = context.read<PlaylistBloc>();

              playlistBloc.add(
                SetViewedPlaylist(
                  playlist: playlist,
                ),
              );
            },
          );
        },
      );
    });
  }
}
