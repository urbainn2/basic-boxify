import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';

class PlaylistHelper {
  PlaylistHelper();

  /// Returns THE all songs PLAYLIST
  Playlist? createAllSongsPlaylist(User user, List<Rating> ratings,
      [List<Track>? tracks]) {
    logger.i('createAllSongsPlaylist');

    tracks ??= [];

    final sortedTrackIds = sortTracksForAllSongsPlaylist(tracks, ratings);

    return Playlist(
      id: '${user.id}_allsongs',
      trackIds: sortedTrackIds,
      name: 'All Songs',
      displayTitle: 'All Songs',
      description: 'All available songs, sorted by your rating.',
      owner: {
        'username': user.username,
        'id': user.id,
        'type': 'user',
        'profileImageUrl': user.profileImageUrl
      },
      isOwnPlaylist: false,
      imageUrl: Core.app.type == AppType.advanced
          ? user.profileImageUrl
          : Core.app.placeHolderImageUrl,
      imageFilename: Core.app.placeHolderImageFilename,
      total: sortedTrackIds.length,
    );
  }

  /// Returns THE 5 Star PLAYLIST
  Playlist? create5StarPlaylist(User user, List<Rating> ratings,
      [List<Track>? tracks]) {
    // logger.i('_create5StarPlaylist');

    final favoriteRatings = ratings.where((x) => x.value == 5.0).toList();
    List<String> sortedOrUnsortedTrackIds =
        getSortedOrUnsortedTracks(favoriteRatings, tracks);

    String username = getUsername(user);

    return instantiatePlaylist(
      user: user,
      trackIds: sortedOrUnsortedTrackIds,
      username: username,
      starNumber: '5',
      imageUrl: user.profileImageUrl,
    );
  }

  /// Returns THE 4 Star PLAYLIST
  Playlist? create4StarPlaylist(User user, List<Rating> ratings,
      [List<Track>? tracks]) {
    logger.i('create4StarPlaylist');

    final favoriteRatings = ratings.where((x) => x.value! == 4.0).toList();
    List<String> sortedOrUnsortedTrackIds =
        getSortedOrUnsortedTracks(favoriteRatings, tracks);

    String username = getUsername(user);

    return instantiatePlaylist(
      user: user,
      trackIds: sortedOrUnsortedTrackIds,
      username: username,
      starNumber: '4',
      imageUrl: user.profileImageUrl,
    );
  }

  /// Returns THE LIKED SONGS PLAYLIST
  Playlist? createLikedSongsPlaylist(
    User user,
    List<Rating> ratings,
  ) {
    // logger.d('_createLikedSongsPlaylist');

    final favoriteRatings = ratings.where((x) => x.value! >= 4.0).toList();
    final favoriteTrackIdsForThisUser =
        favoriteRatings.map((x) => x.trackUuid).whereType<String>().toList();
    final username =
        Core.app.type == AppType.advanced ? '${user.username} has' : 'you have';

    // return Playlist(
    //   id: user.id,
    //   trackIds: favoriteTrackIdsForThisUser,
    //   name: 'Liked Songs',
    //   displayTitle: 'Liked Songs',
    //   description: 'The songs $username rated as 4 or 5 stars.',
    // );

    return instantiatePlaylist(
      user: user,
      trackIds: favoriteTrackIdsForThisUser,
      username: username,
      playlistName: "Liked Songs",
      playlistDescription: 'The songs $username rated as 4 or 5 stars.',
      playlistId: '${user.id}_liked',
      imageUrl: user.profileImageUrl,
    );
  }

  /// Generates an "Unrated" playlist containing all tracks that the user hasn't rated yet.
  Playlist? createUnratedPlaylist(User user, List<Rating> userRatings,
      [List<Track>? allTracks]) {
    logger.i('createUnratedPlaylist');

    if (allTracks == null) {
      logger.w('createUnratedPlaylist() tracks is null');
      return null;
    }

    final rateableTracks =
        allTracks.where((track) => track.isRateable).toList();

    List<Track> unratedTracks = rateableTracks.where((track) {
      return !userRatings.any((rating) => rating.trackUuid == track.uuid);
    }).toList();

    // // For everyone, remove the Vetro tracks from the unrated playlist
    // unratedTracks = unratedTracks.where((track) {
    //   return track.album == null ||
    //       !track.album!.toLowerCase().contains('vetro');
    // }).toList();

    unratedTracks = filterTracksByRole(unratedTracks, user);

    final unratedTrackIds = unratedTracks.map((track) => track.uuid!).toList();

    unratedTrackIds.shuffle();

    String username = getUsername(user);

    return instantiatePlaylist(
      user: user,
      trackIds: unratedTrackIds,
      username: username,
      playlistName: 'youHaventRatedYet'.translate(),
      playlistDescription: 'Songs you have not rated yet.',
      playlistId: '${user.id}_unrated',
      imageUrl: user.profileImageUrl,
    );
  }

// For RiverTunes
  List<Track> filterTracksByRole(List<Track> unratedTracks, User user) {
    // For non-collaborators, remove the Collaborators tracks from the unrated playlist
    if (!user.roles!.contains('collaborator')) {
      unratedTracks = unratedTracks.where((track) {
        return !track.localpath!.contains(Core.app.collaboratorsPath);
      }).toList();
    }

    // For non-admins, remove the admin tracks from the unrated playlist
    if (!user.roles!.contains('admin') && Core.app.adminPath != null) {
      unratedTracks = unratedTracks.where((track) {
        return !track.localpath!.contains(Core.app.adminPath);
      }).toList();
    }

    // For non-Weezer, remove the Weezer tracks from the unrated playlist
    if (!user.roles!.contains('weezer')) {
      unratedTracks = unratedTracks.where((track) {
        return !track.localpath!.contains(Core.app.weezerPath);
      }).toList();
    }
    return unratedTracks;
  }

  Playlist instantiatePlaylist({
    required User user,
    required List<String> trackIds,
    required String username,
    String? playlistName,
    String? playlistId,
    String? playlistDescription,
    String? starNumber,
    String? imageUrl,
  }) {
    if (starNumber != null) {
      playlistName = '$starNumber Star Songs';
      playlistId = '${user.id}_${starNumber}star';
      playlistDescription = 'The songs $username rated as $starNumber stars.';
    }
    return Playlist(
      id: playlistId,
      trackIds: trackIds,
      name: playlistName,
      displayTitle: playlistName,
      description: playlistDescription,
      owner: {
        'username': user.username,
        'id': user.id,
        'type': 'user',
        'profileImageUrl': user.profileImageUrl
      },
      isOwnPlaylist: false,
      imageUrl: imageUrl ??
          (Core.app.type == AppType.advanced
              ? user.profileImageUrl
              : Core.app.placeHolderImageUrl),
      imageFilename:
          imageUrl != null ? null : Core.app.placeHolderImageFilename,
      total: trackIds.length,
    );
  }

  /// Returns a list of track IDs sorted based on their rating value, with unrated tracks on top.
  /// The function then sorts rated tracks by their rating value in descending order.
  /// Finally, if the total number of tracks exceeds 200, the list is truncated to the first 200 tracks.
  ///
  /// Parameters:
  /// - [tracks] is a list of [Track] instances that will be sorted.
  /// - [ratings] is a list of [Rating] instances corresponding to the ratings of the tracks.
  ///
  /// Returns:
  /// A [List<String>] of track IDs, sorted and potentially truncated according to the described logic.
  ///
  /// Note:
  /// - Unrated tracks are prioritized at the top of the list.
  /// - If there are more than 200 tracks after sorting, only the top 200 are returned.
  List<String> sortTracksForAllSongsPlaylist(
      List<Track> tracks, List<Rating> ratings) {
    // // shuffling the tracks to make sure the order is not the same every time
    // tracks.shuffle();

    // // if advanced app, truncate the list to 200
    // if (Core.app.type == AppType.advanced) {
    //   tracks = tracks.sublist(0, 200);
    // }

    // Mapping of track IDs to their rating values
    final Map<String, double?> trackRatings = {
      for (var r in ratings)
        if (r.trackUuid != null && r.trackUuid!.isNotEmpty)
          r.trackUuid!: r.value
    };

    // Separate tracks into rated and unrated, then process each list accordingly
    final List<Track> unratedTracks = [];
    final List<Track> ratedTracks = [];
    for (var track in tracks) {
      trackRatings.containsKey(track.uuid)
          ? ratedTracks.add(track)
          : unratedTracks.add(track);
    }

    // // Sort unrated tracks by title as a neutral criteria (optional)
    // unratedTracks.sort((a, b) => a.displayTitle.compareTo(b.displayTitle));

    // Sort rated tracks by rating descending
    ratedTracks.sort((a, b) {
      final ratingA = trackRatings[a.uuid]!;
      final ratingB = trackRatings[b.uuid]!;
      return ratingB.compareTo(ratingA); // For descending order
    });

    // Combine lists with unrated tracks first, and rated tracks next
    final combinedList = [...unratedTracks, ...ratedTracks];

    // // Truncate list to the first 200 elements if it exceeds that length
    // final truncatedList =
    //     combinedList.length > 200 ? combinedList.sublist(0, 200) : combinedList;

    // Return the final sorted and trimmed list of track IDs
    return combinedList.map((track) => track.uuid!).toList();
  }

  /// Returns a list of track UUIDs either sorted by track title or by the 'updated' field
  /// of [favoriteRatings], depending on the presence and status of [tracks].
  ///
  /// The function first determines the favorite track IDs from [favoriteRatings] and then
  /// operates in one of two modes depending on the state of [tracks]:
  ///
  /// - If [tracks] is not null and contains elements, the function filters these tracks
  ///   to include only the favorite ones (based on the previously determined favorite track IDs).
  ///   These tracks are then sorted by their title in ascending order before their UUIDs
  ///   are returned.
  ///
  /// - If [tracks] is null or empty, the function sorts [favoriteRatings] based on the
  ///   'updated' field in descending order (assuming newer updates are more relevant).
  ///   This sort takes into account the possibility of null values in the 'updated' field,
  ///   placing such entries last. Only the UUIDs of tracks from the sorted [favoriteRatings] are returned.
  ///
  /// Parameters:
  /// - [favoriteRatings] is a list of [Rating] instances representing the user's favorite tracks,
  ///    potentially including a 'updated' timestamp which can be used for sorting.
  /// - [tracks] (optional) is a list of [Track] instances that can be sorted by title if provided.
  ///
  /// Returns:
  /// A [List<String>] of track UUIDs, sorted according to the described logic.
  ///
  /// Note:
  /// - This function handles null and empty [tracks] by defaulting to sort [favoriteRatings]
  ///   by 'updated' field.
  /// - It's assumed that all provided IDs are unique; deduplication is not performed within
  ///   this function.
  List<String> getSortedOrUnsortedTracks(
      List<Rating> favoriteRatings, List<Track>? tracks) {
    final favoriteTrackIdsForThisUser =
        favoriteRatings.map((x) => x.trackUuid).whereType<String>().toSet();

    List<String> sortedTrackIds;

    /// In the basic app, we've passed tracks to this method so we can sort them by title.
    if (tracks != null && tracks.isNotEmpty) {
      // Filter to only include favorite tracks then sort them by title.
      final favoriteTracksForThisUser = tracks
          .where((track) => favoriteTrackIdsForThisUser.contains(track.uuid))
          .toList()
        ..sort((a, b) => a.displayTitle.compareTo(b.displayTitle));

      // Use the sorted tracks' IDs.
      sortedTrackIds = favoriteTracksForThisUser
          .map((track) => track.uuid)
          .whereType<String>()
          .toList();
    }

    /// In the advanced app, we'll sort the favoriteRatings by the 'updated' field descending.
    else {
      // Sort the favoriteRatings by the 'updated' field descending, then extract the trackUuids.
      // The `toList()` call is important to materialize the sorted result into a list.

      final sortedFavoriteRatingsBasedOnUpdated = favoriteRatings
          .where((rating) =>
              favoriteTrackIdsForThisUser.contains(rating.trackUuid))
          .toList()
        ..sort((a, b) {
          // Handle cases where `updated` is null by defining custom sort logic
          if (a.updated == null && b.updated == null) {
            return 0; // Both ratings have null 'updated', considered equal
          } else if (a.updated == null) {
            return 1; // `a` should come after `b` if `a.updated` is null
          } else if (b.updated == null) {
            return -1; // `b` should come after `a` if `b.updated` is null
          } else {
            return b.updated!
                .compareTo(a.updated!); // Actual comparison for non-null dates
          }
        });

// Extract the sorted trackUuids
      sortedTrackIds = sortedFavoriteRatingsBasedOnUpdated
          .map((rating) => rating.trackUuid)
          .whereType<
              String>() // This ensures the result list contains only non-null strings
          .toList();
    }

    return sortedTrackIds;
  }

  String getUsername(User user) {
    final username =
        Core.app.type == AppType.advanced ? '${user.username} has' : 'you have';
    return username;
  }

  /// Returns THE NEW RELEASES PLAYLIST
  /// This is a playlist of all the tracks that have been released in the last 60 days.
  /// It's a playlist that is created by the server and is not owned by any user.

  Playlist? createNewReleasesPlaylist(
    List<Playlist> allPlaylists,
  ) {
    logger.i('createNewReleasesPlaylist');
    final newReleasesPlaylist = allPlaylists.firstWhere(
        (element) => element.id == Core.app.newReleasesPlaylistId);
    try {
      return newReleasesPlaylist;
    } catch (e) {
      return null;
    }
  }

  /// Returns a list of [Playlist]s the [User] follows (or owns) (including Core.app.defaultPlaylistIds)
  /// after converting them from a list of playlist Ids (strings) passed to the function.
  /// Let's not include the Liked Songs playlist or the New Releases playlists because those are pinned
  /// and not able to be followed or unfollowed. We'll get those separately.
  ///
  /// This method also looks to be responsible for setting the isFollowable, isRemoveable, and isDeleteable
  /// properties of the playlists.
  PlaylistHelperResult getFollowedPlaylists(
      User user, List<Playlist> allPlaylists) {
    logger.i(' PlaylistHelper.getFollowedPlaylists for user: ${user.id}');
    final playlists = <Playlist>[];
    final allPlaylistIds = <String>[];
    final badPlaylistIds = <String>[];
    try {
      if (Core.app.type == AppType.basic) {
        return PlaylistHelperResult(allPlaylists, []);
      }

      /// ADVANCED APP ONLY

      /// Make a list of all the playlist ids
      for (final element in allPlaylists) {
        allPlaylistIds.add(element.id!);
      }

      /// Make a list of all the playlists the user follows
      for (final id in user.playlistIds) {
        if (allPlaylistIds.contains(id)) {
          var p = allPlaylists.where((element) => element.id == id).first;
          p.isFollowable = false;
          if (p.owner!['id'] == user.id) {
            p.isRemoveable = false;
            p.isDeleteable = true;
          } else {
            p.isRemoveable = true;
            p.isDeleteable = false;
          }
          playlists.add(p);
        } else {
          if (Core.app.defaultPlaylistIds.contains(id)) {
            logger.w(
                'User is following a default playlist id $id that is in Core.app.defaultPlaylistIds but is not in allPlaylists');
          } else {
            logger.e(
                'User is following a playlist id $id not found in allPlaylists');
            badPlaylistIds.add(id);
          }
        }
      }
      logger.i('returning ${playlists.length} followed playlists');
      if (badPlaylistIds.isNotEmpty) {
        logger.e(
            'getFollowedPlaylists() badPlaylistIds: ${badPlaylistIds.join(',')}');
      }

      // Instead of trying to delete badPlaylistIds here, return them with valid playlists
      return PlaylistHelperResult(playlists, badPlaylistIds);
    } catch (err) {
      logger.i('_getFollowedPlaylists() error: $err');
      return PlaylistHelperResult(playlists, badPlaylistIds); //empty
    }
  }

  List<Playlist> getYourPlaylists(PlaylistState state, bool isAnonymous) {
    return Core.app.type == AppType.basic
        ? <Playlist>[
            // state.fiveStarPlaylist,
            // state.fourStarPlaylist,
            // state.allSongsPlaylist,
            state.likedSongsPlaylist,
            state.unratedPlaylist,
            ...state.allPlaylists
          ]
        : isAnonymous
            ? <Playlist>[state.newReleasesPlaylist, ...state.followedPlaylists]
            : <Playlist>[
                state.likedSongsPlaylist,
                state.newReleasesPlaylist,
                ...state.followedPlaylists
              ];
  }

  List<Playlist> getRecommendedPlaylists(
      User user, List<Playlist> allPlaylists) {
    logger.i(' _getRecommendedPlaylists() for user.id: ${user.id}');
    try {
      if (Core.app.type == AppType.basic) {
        return allPlaylists;
      }

      /// Make a list of all the playlists that are
      /// - not owned by the user
      /// - not followed by the user
      /// - not owned by Rivers
      /// - that have a score > 10
      final recommendedPlaylists = <Playlist>[];

      for (final element in allPlaylists) {
        if (element.owner!['id'] != user.id &&
            !user.playlistIds.contains(element.id) &&
            element.owner!['id'] != Core.app.rivers &&
            element.score! > 30) {
          recommendedPlaylists.add(element);
        }
      }

      /// Sort the recommended playlists by score (descending)
      recommendedPlaylists.sort((a, b) => b.score!.compareTo(a.score!));

      logger.i('returning ${recommendedPlaylists.length} recommendedPlaylists');

      return recommendedPlaylists;
    } catch (err) {
      logger.i('recommendedPlaylists() error: $err');
      return [];
    }
  }

  /// Checks if all tracks in the given list are fully downloaded.
  ///
  /// Returns `true` if all tracks are fully downloaded, otherwise `false`.
  bool isFullyDownloaded(List<Track> tracks) {
    // bool isFullyDownloaded = false;
    if (kIsWeb) {
      return false;
    }
    for (var track in tracks) {
      if (track.available == false) {
        return false;
      } else if (!track.downloadedUrl!.toLowerCase().contains('file://')) {
        return false;
      }
    }
    return true;
  }

  bool isDownloadable(List<Track> tracks) {
    return !isFullyDownloaded(tracks);
  }
}

class PlaylistHelperResult {
  final List<Playlist> validPlaylists;
  final List<String> badPlaylistIds;

  PlaylistHelperResult(this.validPlaylists, this.badPlaylistIds);
}
