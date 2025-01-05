import 'dart:io';

import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackHelper {
  TrackHelper();

  static Playlist convertTrackToPlaylist(Track track) {
    return Playlist(
      id: track.uuid, // or some unique identifier
      name: track.displayTitle,
      displayTitle: track.displayTitle,
      trackIds: [track.uuid!],
      // description: track.album ?? '',
      owner: {
        'id': Core.app.rivers,
        'username': track.artist ?? 'Rivers Cuomo',
        'profileImageUrl': track.imageUrl,
      },
      imageUrl: track.imageUrl,
      imageFilename: track.imageFilename,
      type: PlaylistType.single,
      year: track.year?.toString() ?? '${DateTime.now().year}',
    );
  }

  static Color getTitleColor({
    required BuildContext context,
    required Track track,
  }) {
    if (!track.available!) {
      return Colors.grey[700]!;
    } else if (context.select(
          (PlayerService service) => service.isPlaying(track),
        ) ==
        true) {
      return Core.appColor.primary;
    } else {
      return Colors.white;
    }
  }

  // /// Determines the color of the title based on the track's state and playlist visibility.
  // static Color getTitleColor({
  //   required BuildContext context,
  //   required int indexWithinPlayableTracks,
  //   required Track track,
  //   PlaylistBloc? playlistBloc,
  //   PlayerBloc? playerBloc,
  // }) {
  //   playlistBloc ??= context.read<PlaylistBloc>();
  //   playerBloc ??= context.watch<PlayerBloc>();

  //   // final player = playerBloc.state.player;
  //   // final viewedPlaylist = playlistBloc.state.viewedPlaylist;
  //   // final enquedPlaylist = playlistBloc.state.enquedPlaylist;
  //   // final currentIndex = player.currentIndex;

  //   TrackPlayingState trackPlayingState =
  //       context.read<PlayerService>().getPlayingState(track);

  //   // If the track is not available, make it grey
  //   if (!track.available!) {
  //     return Colors.grey[700]!;
  //   }

  //   // In most cases, just make it white
  //   else if (
  //       // indexWithinPlayableTracks != currentIndex ||
  //       //   viewedPlaylist?.id != enquedPlaylist?.id ||
  //       trackPlayingState == TrackPlayingState.unselected ||
  //           playerBloc.state.status != PlayerStatus.loaded) {
  //     return Colors.white;
  //   }

  //   // Highlight with the app's primary color if it's the currently playing track,
  //   // and you're viewing the playlist it belongs to.
  //   else {
  //     return Core.appColor.primary;
  //   }
  // }

  static Color? getArtistColor(Track track) {
    return track.available! ? null : Colors.grey[700];
  }

  List<Track> mapTracksToRatings(List<Track> tracks, List<Rating> ratings) {
    logger.i('_mapTracksToRatings');

    // Create a Map with tracks keyed by their ids
    final tracksById = {for (var track in tracks) track.uuid: track};

    // Iterate through ratings and map them to tracks
    for (final r in ratings) {
      final d = tracksById[r.trackUuid];
      if (d != null) {
        d.userRating = r.value;
      }
    }

    return tracks;
  }

  // /// Set the downloadedUrl for each track in a list of tracks if a local file exists.
  // Future<void> updateTrackLinksBulk(List<Track> tracks, String userId) async {
  //   logger.i('updateTrackLinksBulk');

  //   if (kIsWeb) {
  //     return;
  //   }

  //   // start a timer
  //   final stopwatch = Stopwatch()..start();

  //   // Get the app-specific local directory for the user’s downloads.
  //   final String localPath = await findLocalPath(userId);
  //   final Directory localDirectory = Directory(localPath);

  //   // If the directory exists, list all contents and match with tracks.
  //   if (await localDirectory.exists()) {
  //     List<FileSystemEntity> files = await localDirectory.list().toList();

  //     // Use a Set for efficient lookups.
  //     Set<String> downloadedFilenames = files
  //         .whereType<File>()
  //         .map((file) => file.uri.pathSegments.last)
  //         .toSet();

  //     // Update the track's link if the corresponding file is found in the Set.
  //     for (Track track in tracks) {
  //       String expectedFilename = '${track.uuid}.mp3';
  //       if (downloadedFilenames.contains(expectedFilename)) {
  //         track.downloadedUrl = 'file:///$localPath/$expectedFilename';
  //       }
  //     }
  //   } else {
  //     // Handle the case where the directory doesn't exist, if necessary.
  //   }

  //   // No need to wait for asynchronous tasks since listing is performed in bulk.

  //   // Stop the timer and log the elapsed time.
  //   stopwatch.stop();
  //   var t = stopwatch.elapsed.inSeconds.toDouble();
  //   if (t > .1) {
  //     logger.e('SLOW updateTrackLinksBulk took $t seconds');
  //   }
  // }

  /// For debugging purposes, print the filenames, sizes, and modified dates of files in a directory.
  Future<void> printDirectoryFilesInfo(String userId) async {
    logger.i('printDirectoryFilesInfo');
    final String localPath = await findLocalPath(userId);
    final Directory localDirectory = Directory(localPath);

    if (await localDirectory.exists()) {
      List<FileSystemEntity> files = await localDirectory.list().toList();

      logger.i('Files in directory: ${files.length}');

      for (var file in files) {
        if (file is File) {
          String fileName = file.uri.pathSegments.last;
          // int fileSize = await file.length();
          // DateTime fileModified = await file.lastModified();
          print('Filename in dir: $fileName');
        }
      }
    } else {
      print('Directory does not exist: $localPath');
    }
  }

  Future<List<Track>> updateTrackLinksBulkIsolate(
      Map<String, dynamic> params) async {
    print('updateTrackLinksBulkIsolate');
    List<Track> tracks = params['tracks'];
    String localPath = params['localPath'];

    final Directory localDirectory = Directory(localPath);
    if (await localDirectory.exists()) {
      List<FileSystemEntity> files = await localDirectory.list().toList();
      logger.i('Files in directory: ${files.length}');
      Set<String> downloadedFilenames = files
          .whereType<File>()
          .map((file) => file.uri.pathSegments.last)
          .toSet();

      for (Track track in tracks) {
        String expectedFilename = '${track.uuid}.mp3';
        if (downloadedFilenames.contains(expectedFilename)) {
          // logger.i('File found: $expectedFilename');
          track.downloadedUrl = 'file:///$localPath/$expectedFilename';
        }
      }
    }

    // Return the modified list of tracks
    return tracks;
  }

  Future<void> updateTrackLinksBulk(List<Track> tracks, String userId) async {
    logger.i('updateTrackLinksBulk');

    if (kIsWeb) {
      return;
    }

    final start = DateTime.now();
    final String localPath = await findLocalPath(userId);

    // Use compute and capture the returned list of tracks
    List<Track> updatedTracks = await compute(updateTrackLinksBulkIsolate, {
      'tracks': tracks,
      'localPath': localPath,
    });

    // Replace the original tracks with the updated tracks
    tracks.clear();
    tracks.addAll(updatedTracks);

    logRunTime(start, 'updateTrackLinksBulk');
  }
}
