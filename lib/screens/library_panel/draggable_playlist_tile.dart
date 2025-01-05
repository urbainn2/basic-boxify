import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget wraps a [LargePlaylistTile] with draggability
/// to rearrange the order of playlists, to add playlists to [Library], and
/// to drop a [TrackMouseRow] into a [Playlist] widget.
/// Used in the userPlaylistLibrary in the LeftSide Widgets.
class DraggablePlaylistTile extends StatelessWidget {
  const DraggablePlaylistTile({
    super.key,
    required this.playlist,
    required this.i,
  });

  final Playlist playlist;
  final int i;

  @override
  Widget build(BuildContext context) {
    final playlistBloc = context.read<PlaylistBloc>();
    final libraryBloc = context.read<LibraryBloc>();
    final playlistTracksBloc = context.read<PlaylistTracksBloc>();
    final state = context.watch<UserBloc>().state;
    bool isDropTarget = false;
    bool insertBelowTarget = false;
    bool insertAboveTarget = false;
    return DragTarget(
      onWillAcceptWithDetails: (DragTargetDetails details) {
        // If you're dropping a track onto a playlist
        if (details.data!.containsKey('track')) {
          if (isOwnPlaylist(
            playlist,
            state.user,
          )) {
            // paint the blue border around the box
            isDropTarget = true;
          }
        }
        // Else if you're inserting a playlist above or below this playlist
        // in a list of playlists
        else if (details.data.containsKey('playlistId')) {
          final oldIndex = details.data['oldIndex'] as int;
          final newIndex = i;

          if (newIndex > oldIndex) {
            // paint the blue border below the box
            insertBelowTarget = true;
          } else if (newIndex < oldIndex) {
            // paint the blue border above the box
            insertAboveTarget = true;
          }
        }
        return true;
      },
      onLeave: (d) {
        // remove the blue border
        isDropTarget = false;
        // _insertBelowTarget = false;
        insertAboveTarget = false;
      },
      onAcceptWithDetails: (DragTargetDetails details) {
        if (details.data.containsKey('track')) {
          final track = details.data['track'] as Track;
          if (isOwnPlaylist(
            playlist,
            state.user,
          )) {
            playlistTracksBloc.add(
              AddTrackToPlaylist(
                playlist: playlist,
                track: track,
              ),
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              width: 100,
              backgroundColor: Core.appColor.primary,
              duration: Duration(seconds: 3),
              content: Text(
                'addedToPlaylist'.translate(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else if (details.data.containsKey('playlistId')) {
          final oldIndex = details.data['oldIndex'];
          final newIndex = i;
          if (oldIndex == newIndex) {
            return;
          }
          libraryBloc.add(ResequencePlaylists(
              followedPlaylists:
                  context.read<PlaylistBloc>().state.followedPlaylists,
              user: state.user,
              oldIndex: oldIndex,
              newIndex: newIndex,
              playlistId: details.data['playlistId']));
        }
        isDropTarget = false;
        insertAboveTarget = false;
        // _insertBelowTarget = false;
      },
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        var largePlaylistTile = LargePlaylistTile(
          isInsertAboveTarget: insertAboveTarget,
          isInsertBelowTarget: insertBelowTarget,
          isDragTarget: isDropTarget,
          isSelected: playlist.id == playlistBloc.state.viewedPlaylist?.id,
          playlist: playlist,
          index: i,
          itemName: playlist.name!,
          userId: state.user.id,
          canAddRemovePlaylist: true,
        );
        return kIsWeb
            ? Draggable(
                data: {'playlistId': playlist.id!, 'oldIndex': i},
                key: Key('userPlaylistsList$i'),
                feedback: DraggingFeedbackWidget(playlist: playlist),
                child: largePlaylistTile,
              )
            : largePlaylistTile;
      },
    );
  }
}

class DraggingFeedbackWidget extends StatelessWidget {
  const DraggingFeedbackWidget({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .65,
      child: Container(
        color: Core.appColor.playerColor,
        height: Core.app.smallRowImageSize,
        width: playlist.name!.length * 11,
        child: Row(
          children: [
            const Icon(Icons.add),
            Text(
              playlist.name!,
              style: TextStyle(
                  fontSize: Core.app.titleFontSize,
                  color: Core.appColor.titleColor),
            ),
          ],
        ),
      ),
    );
  }
}
