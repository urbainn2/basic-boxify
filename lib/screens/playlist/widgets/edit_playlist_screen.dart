import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This is for reording the tracks in a playlist as well as editing the details of the playlist.
/// The user can change the name, description, and image of the playlist.
class EditPlaylistScreen extends StatefulWidget {
  @override
  _EditPlaylistScreenState createState() => _EditPlaylistScreenState();
}

class _EditPlaylistScreenState extends State<EditPlaylistScreen>
    with EditPlaylistMixin {
  @override
  Widget build(BuildContext context) {
    final playlistBloc = context.watch<PlaylistBloc>();
    final playlistTracksBloc = context.read<PlaylistTracksBloc>();
    final trackBloc = context.read<TrackBloc>();
    final playlist = playlistBloc.state.editingPlaylist ?? Playlist.empty;
    final tracks = trackBloc.state.displayedTracks;
    titleController.text = playlist.displayTitle ?? 'Playlist name';
    descriptionController.text = playlist.description!.isNotEmpty
        ? playlist.description.toString()
        : 'Add description';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Core.appColor.widgetBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "editPlaylist".translate(),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (titleController.text == '') {
                return;
              }
              kIsWeb
                  ? context.read<PlaylistInfoBloc>().add(
                        SubmitOnWeb(
                          playlist: playlist,
                          description: descriptionController.text,
                          name: titleController.text,
                          userId: context.read<UserBloc>().state.user.id,
                        ),
                      )
                  : context.read<PlaylistInfoBloc>().add(
                        Submit(
                          playlist: playlist,
                          description: descriptionController.text,
                          name: titleController.text,
                          userId: context.read<UserBloc>().state.user.id,
                        ),
                      );
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              "save".translate(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // Logic to change playlist image
                selectPlaylistImage(context);
              },
              child: Column(
                children: [
                  // PLAYLIST IMAGE
                  BlocBuilder<PlaylistBloc, PlaylistState>(
                    builder: (context, state) {
                      return Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey[900],
                        child: imageForEditDetails(playlist),
                      );
                    },
                  ),
                  sizedBox12,
                  Text(
                    "changeImage".translate(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            sizedBox12,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<PlaylistBloc, PlaylistState>(
              builder: (context, state) {
                // if (state.status != PlaylistStatus.viewedPlaylistLoaded) {
                //   logger.d('playlistbloc.status: ${state.status}');
                //   return CircularProgressIndicator();
                // }

                return ReorderableListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false, // Set this to false
                  shrinkWrap: true,
                  onReorder: (int oldIndex, int newIndex) {
                    // Adjust for ReorderableListView's behavior of incrementing newIndex by one if dragging down the list
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    // print('oldIndex: $oldIndex newIndex: $newIndex');

                    // Assuming playlistTracksBloc is accessible here. If not, obtain it from the context
                    playlistTracksBloc.add(
                      MoveTrack(
                          playlist: playlist,
                          oldIndex: oldIndex,
                          newIndex: newIndex),
                    );
                    // Spotify always takes you to the edited playlist after you edit it?
                    playlistBloc.add(SetViewedPlaylist(playlist: playlist));
                    trackBloc.add(LoadDisplayedTracks(playlist: playlist));
                  },
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    return ListTile(
                      key: ValueKey(
                          "value$index"), // Ensure this key is unique for each item for proper reordering
                      leading: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          playlistTracksBloc.add(RemoveTrackFromPlaylist(
                              playlist: playlist, index: index));
                          trackBloc
                              .add(LoadDisplayedTracks(playlist: playlist));
                        },
                      ),
                      title: Text(track.displayTitle),
                      subtitle: Text(track.artist ?? ''),
                      // Wrap trailing icon with ReorderableDragStartListener
                      trailing: ReorderableDragStartListener(
                        index: index,
                        // You can customize the child widget to your needs
                        child: Icon(Icons.drag_handle),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
