import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'pinned_playlists_provider.dart';

/// Builds the "shell" for the app by building a Scaffold (with a
/// [BottomNavigationBar] on small screens), where [child] is placed
/// in the body of the Scaffold.
///
/// This is used in in both Weezify and Rivify and it is used in both the large
/// and small screens. For the large screen version, the scaffold
/// contains a [LibraryWidget] in the left side of the body, and the [child] in the
/// right side of the body. For the small screen version, the scaffold contains
/// only the [child] in the body.
///
/// The large screen also contains a [LargePlayer] in the bottom of the body,
/// and the small screen contains a [SmallPlayer] in the bottom of the body.
class ScaffoldWithPlayer extends StatelessWidget {
  /// The navigation shell and container for the branch Navigators.
  final Widget navigationShell;

  /// Constructs a [ScaffoldWithPlayer].
  const ScaffoldWithPlayer({
    Key? key,
    required this.navigationShell,
  }) : super(
          key: key ??
              const ValueKey<String>(
                'ScaffoldWithPlayer',
              ),
        );

  void _onItemTapped(int index, BuildContext context) {
    context.read<NavCubit>().updateIndex(index);
    if (Core.app.type == AppType.basic) {
      switch (index) {
        case 0:
          GoRouter.of(context).push('/');
          break;
        case 1:
          GoRouter.of(context).push('/playerSearch');
          break;
        case 2:
          GoRouter.of(context).push('/library');
          break;
      }
    } else if (Core.app.type == AppType.advanced) {
      switch (index) {
        case 1:
          GoRouter.of(context).push('/market');
        case 0:
          GoRouter.of(context).push('/');
          break;
        case 2:
          GoRouter.of(context).push('/playerSearch');
          break;
        case 3:
          GoRouter.of(context).push('/library');
          break;
      }
    }
  }

  // Helper function to compare the maps of playlist download statuses
  bool _areMapsEqual(
      Map<String, DownloadStatus>? map1, Map<String, DownloadStatus>? map2) {
    if (map1 == null || map2 == null) return false;
    if (map1.length != map2.length) return false;
    for (String key in map1.keys) {
      if (map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state.status == PlaylistStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        } else if (state.status == PlaylistStatus.playlistsLoading ||
            state.status == PlaylistStatus.followedPlaylistsLoading ||
            state.status == PlaylistStatus.initial) {
          return circularProgressIndicator;
        }

        final userBloc = context.read<UserBloc>();

        bool canDragPlaylists = false; // default to false for Rivify
        // Determine if playlists can be dragged based on conditions
        // don't let Lurkers drag playlists
        /// also, turns out you have to be on web to drag, not large mobile screen
        canDragPlaylists = Core.app.type == AppType.advanced &&
            kIsWeb &&
            !userBloc.state.user.isAnonymous;

        final pinnedPlaylistsWidget =
            PinnedPlaylistsProvider.getPinnedPlaylistsWidgets(
                state, userBloc.state.user);

        List<Playlist> playlists = [];
        final userLibraryWidget = BlocBuilder<PlaylistBloc, PlaylistState>(
          builder: (context, state) {
            if (Core.app.type == AppType.advanced) {
              final userPlaylistIds = userBloc.state.user.playlistIds;

              /// This will provide a list of all playlists that the user follows
              /// in their custom order from the database user.playlistIds
              playlists = userPlaylistIds
                  .map((id) => state.allPlaylists.where((p) => p.id == id))
                  .expand((i) => i)
                  .toList();
            } else if (Core.app.type == AppType.basic) {
              playlists = state.allPlaylists;
            } else {
              logger.i('LibraryWidget: state is neither advanced nor basic');
            }
            if (playlists.isEmpty || playlists[0].id == null) {
              return circularProgressIndicator;
            }
            // The error you're seeing is most likely being caused by the Scrollbar widget you're using at the root of your widget tree.
            //The Scrollbar is trying to attach itself to the PrimaryScrollController, but in your case, it's not able to find one.
            return Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  primary: true,
                  child: Column(
                      children:
                          // Weezify users with a permanent user record
                          canDragPlaylists
                              ? [
                                  ...pinnedPlaylistsWidget,
                                  ...playlists.map((playlist) {
                                    return DraggablePlaylistTile(
                                      playlist: playlist,
                                      i: playlists.indexOf(playlist),
                                    );
                                  })
                                ]
                              : Core.app.type == AppType.basic
                                  ? [
                                      ...pinnedPlaylistsWidget,
                                      ...playlists.map((playlist) {
                                        return LargePlaylistTile(
                                          isDragTarget: false,
                                          isInsertAboveTarget: false,
                                          isInsertBelowTarget: false,
                                          isSelected: playlist.id ==
                                              state.viewedPlaylist?.id,
                                          playlist: playlist,
                                          index: playlists.indexOf(playlist),
                                          itemName: playlist.name ??
                                              'yourLibrary'.translate(),
                                          canAddRemovePlaylist: false,
                                        );
                                      })
                                    ]
                                  :
                                  // Weezify Lurkers
                                  [
                                      ...pinnedPlaylistsWidget,
                                      ...playlists.map((playlist) {
                                        return DraggablePlaylistTile(
                                          playlist: playlist,
                                          i: playlists.indexOf(playlist),
                                        );
                                      })
                                    ]
                      // playlists.map((playlist) {
                      //     return LargePlaylistTile(
                      //       isDragTarget: false,
                      //       isInsertAboveTarget: false,
                      //       isInsertBelowTarget: false,
                      //       isSelected: playlist.id ==
                      //           state.viewedPlaylist?.id,
                      //       playlist: playlist,
                      //       index: playlists.indexOf(playlist),
                      //       itemName: playlist.name ??
                      //           'yourLibrary'.translate(),
                      //       canAddRemovePlaylist: false,
                      //     );
                      //   }).toList(),
                      ),
                ),
              ),
            );
          },
        );
        final width = MediaQuery.of(context).size.width;
        final isLargeScreen = width >= Core.app.largeSmallBreakpoint;

        return BlocBuilder<NavCubit, int>(// Listen to NavCubit changes
            builder: (context, currentIndex) {
          logger.i('currentIndex: ');

          DownloadStatus? _lastHandledStatus;
          Map<String, DownloadStatus> _lastHandledPlaylistStatuses = {};

          bool _isRemovingDownloads =
              false; // Flag to track if a removal action is ongoing
          bool _hasSynced =
              false; // Flag to track if the app has synced on startup
          return Scaffold(
              body:

                  /// This is really the whole screen?
                  Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        if (isLargeScreen)
                          LeftSideWidgets(
                            userLibraryWidget: userLibraryWidget,
                          ),

                        /// On a large screen, the navigationShell is in the right side of the body.
                        /// On a small screen, the navigationShell is the body and takes up the whole screen apart from the bottom player.
                        Expanded(
                          flex: 3,
                          child: Scaffold(
                            extendBodyBehindAppBar: true,
                            body:

                                /// THESE APPEAR TO BE IN MYAPP.DART LISTENERS NOW
                                ///
                                /// Can't put this in myApp.dart because it needs a scaffold?
                                MultiBlocListener(
                              listeners: [
                                BlocListener<LibraryBloc, LibraryState>(
                                  listener: (context, state) {
                                    // /// If a new playlist is created, then we need to update all the participating blocs
                                    if (state.status ==
                                        LibraryStatus.playlistCreated) {
                                      final playlist =
                                          state.playlistJustCreated;
                                      if (playlist == null) {
                                        return;
                                      }
                                      final playlistId = playlist.id;
                                      GoRouter.of(context)
                                          .push('/playlist/$playlistId');
                                      final playlistBloc =
                                          context.read<PlaylistBloc>();
                                      playlistBloc.add(
                                        SetViewedPlaylist(playlist: playlist),
                                      );

                                      playlistBloc.add(SetEditingPlaylist(
                                          playlist: playlist));
                                      final trackBloc =
                                          context.read<TrackBloc>();
                                      trackBloc.add(LoadDisplayedTracks(
                                          playlist: playlist));
                                      showEditPlaylistDialog(context);
                                    } else if (state.status ==
                                        LibraryStatus.error) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ErrorDialog(
                                          content: state.failure.message,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                BlocListener<DownloadBloc, DownloadState>(
                                  listener: (context, state) {
                                    logger.d(
                                        'DownloadBloc.state.status=${state.status}');
                                    logger.d(
                                        'DownloadBloc.state.playlistDownloadStatus=${state.playlistDownloadStatus}');

                                    // Handle global download status changes
                                    if (state.status == DownloadStatus.error) {
                                      showMySnack(context,
                                          message: state.errorMessage!,
                                          color: Colors.red);
                                    } else if (state.status ==
                                        DownloadStatus.syncingDownloads) {
                                      showMySnack(
                                        context,
                                        message: 'Syncing downloads on WiFi'
                                            .translate(),
                                        color: Core.appColor.primary,
                                      );
                                    } else if (state.status ==
                                        DownloadStatus
                                            .syncingDownloadsCompleted) {
                                      // Only show "Downloads synced" if we're not currently removing downloads
                                      if (_lastHandledStatus !=
                                          DownloadStatus.removing) {
                                        showMySnack(
                                          context,
                                          message:
                                              'Downloads synced'.translate(),
                                          color: Core.appColor.primary,
                                        );
                                      }
                                    } else if (state.status ==
                                        DownloadStatus.completed) {
                                      showMySnack(
                                        context,
                                        message:
                                            'Download completed'.translate(),
                                        color: Core.appColor.primary,
                                      );
                                    } else if (state.status ==
                                        DownloadStatus.undownloaded) {
                                      showMySnack(
                                        context,
                                        message: 'Download removed'.translate(),
                                        color: Core.appColor.primary,
                                      );
                                    }

                                    // Update the last handled status
                                    _lastHandledStatus = state.status;
                                  },
                                  listenWhen: (previous, current) =>
                                      previous.status != current.status,
                                ),
                              ],
                              child: navigationShell,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Player(),
                ],
              ),
              bottomNavigationBar: isLargeScreen
                  ? null
                  : BottomNavigationBar(
                      selectedItemColor: Core.appColor.primary,
                      backgroundColor: Colors
                          .transparent, // or Colors.black38 for semi-transparent black color.
                      type: BottomNavigationBarType
                          .fixed, // Needed if you want the backgroundColor to work.
                      // Here, the items of BottomNavigationBar are hard coded. In a real
                      // world scenario, the items would most likely be generated from the
                      // branches of the shell route, which can be fetched using
                      // `navigationShell.route.branches`.
                      items: Core.app.type == AppType.basic
                          ? bottomNavigationBarItemBasic(context)
                          : bottomNavigationBarItemAdvanced(context),
                      currentIndex: currentIndex,
                      onTap: (int idx) => _onItemTapped(idx, context),
                    ));
        });
      },
    );
  }
}

void showEditPlaylistDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(0),
          ),
          child: EditPlaylistScreen(),
        ),
      );
    },
  );
}
