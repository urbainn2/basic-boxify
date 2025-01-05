import 'package:boxify/app_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This class interacts with userBloc to handle download and remove download
class PlaylistService {
  final Connectivity _connectivity = Connectivity();
  final DownloadBloc _downloadBloc;
  final TrackBloc _trackBloc;

  PlaylistService(
    this._downloadBloc,
    this._trackBloc,
  );

  Future<void> handleDownloadButtonPressed(
      BuildContext context, Playlist? playlist) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final user = context.read<UserBloc>().state.user;
    if (connectivityResult == ConnectivityResult.mobile) {
      showMySnack(context,
          message: 'Downloading playlist on mobile data is not yet supported');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (playlist != null && playlist.isFollowable) {
        context
            .read<LibraryBloc>()
            .add(AddPlaylistToLibrary(playlistId: playlist.id!, user: user));
      }

      final tracksToDownload = playlist != null
          ? getPlaylistTracks(playlist)
          : _trackBloc.state.allTracks;

      _downloadBloc.add(DownloadTracks(
          tracksToDownload: tracksToDownload,
          userId: user.id,
          playlistId: playlist!.id!));

      showMySnack(context, message: 'Downloading playlist on wifi');
    } else {
      showMySnack(context, message: 'No internet connection');
    }
  }

  /// Here we have to prove the sort order in the playlist.trackIds
  List<Track> getPlaylistTracks(Playlist playlist) {
    List<Track> playlistTracks = [];
    for (var trackId in playlist.trackIds) {
      Track? track = _trackBloc.state.allTracks.firstWhere(
        (track) => track.uuid == trackId,
        orElse: () =>
            Track.empty, // Return a default Track object instead of null
      );
      if (track != Track.empty) {
        playlistTracks.add(track);
      }
    }
    return playlistTracks;
  }

  void handleRemoveDownloadButtonPressed(
      BuildContext context, Playlist? playlist) async {
    // Show a warning dialog before proceeding
    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove Download'),
          content: Text(
            'If you remove this playlist, you won\'t be able to listen to it offline. Do you want to proceed?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context)
                  .pop(false), // Return false when "Cancel" is pressed
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .pop(true), // Return true when "Remove" is pressed
              child: Text('Remove'),
            ),
          ],
        );
      },
    );

    // If the user cancels, return early
    if (proceed != true) {
      return;
    }

    // Proceed with the removal
    final tracksToUnDownload = playlist != null
        ? getPlaylistTracks(playlist)
        : _trackBloc.state.displayedTracks;
    final user = context.read<UserBloc>().state.user;

    _downloadBloc.add(RemoveDownloadedTracks(
      tracksToUnDownload: tracksToUnDownload,
      userId: user.id,
      playlistId: playlist!.id!,
    ));

    showMySnack(
      context,
      message: 'Removed downloaded playlist from device',
    );
  }
}
