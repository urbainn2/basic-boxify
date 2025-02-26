import 'dart:convert';
// import 'package:app_core/app_core.dart';  //
import 'package:boxify/app_core.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CacheHelper {
  /// CACHES COMMON TO ALL USERS ON A DEVICE
  static const String KEY_BUNDLES = 'bundles';
  // static const String KEY_TRACKS = 'tracks';
  static const String KEY_ARTISTS = 'artists';
  // static const String KEY_PLAYLISTS_LAST_FETCH = 'playlists_last_fetch';
  // static const String KEY_CACHED_USER_ID = 'cached_user_id';

  /// Returns keys for users SPECIFIC CACHES with userId prepended to ensure uniqueness
  static String keyForUser(String userId) => 'user_$userId';
  static String keyForPlaylists(String userId) => 'playlists_$userId';
  static String keyForRatings(String userId) => 'ratings_$userId';
  static String keyForPlaylistsLastFetch(String userId) =>
      'playlists_last_fetch_$userId';
  static String keyForTracks(String userId) => 'tracks_$userId';
  static const String KEY_SERVER_TIMESTAMPS = 'server_timestamps';

  // Clear all Cache
  Future<void> clearAll(String userId) async {
    logger.i('clearAll from cache');
    try {
      // Ensure the boxes are open or open them before clearing
      logger.i('clearing bundles');
      var box = await Hive.openBox(KEY_BUNDLES);
      await box.clear();
      logger.i('clearing artists');
      box = await Hive.openBox(KEY_ARTISTS);
      await box.clear();
      logger.i('clearing user');
      box = await Hive.openBox(keyForPlaylists(userId));
      await box.clear();
      logger.i('clearing ratings');
      box = await Hive.openBox(keyForRatings(userId));
      await box.clear();
      logger.i('clearing tracks');
      box = await Hive.openBox(keyForTracks(userId));
      await box.clear();
      logger.i('clearing playlists_last_fetch');
      box = await Hive.openBox(keyForPlaylistsLastFetch(userId));
      await box.clear();

      // logger.i('clearing bundles');
      // await Hive.box(KEY_BUNDLES).clear();
      // logger.i('clearing artists');
      // await Hive.box(KEY_ARTISTS).clear();
      // logger.i('clearing user');
      // await Hive.box(keyForPlaylists(userId)).clear();
      // logger.i('clearing ratings');
      // await Hive.box(keyForRatings(userId)).clear();
      // logger.i('clearing tracks');
      // await Hive.box(keyForTracks(userId)).clear();
      // logger.i('clearing playlists_last_fetch');
      // await Hive.box(keyForPlaylistsLastFetch(userId)).clear();

      // try {
      //   await Hive.deleteFromDisk();
      // } catch (e) {
      //   logger.e(e);
      // }
      // try {
      // // Iterate through all open boxes and clear their contents
      // final openBoxes = Hive.boxNames.where(Hive.isBoxOpen);
      // for (final boxName in openBoxes) {
      //   final box = Hive.box(boxName);
      //   await box.clear();  // This clears all data in the box but does not delete the box.
      // }
    } catch (e) {
      logger.e('Failed to clear caches: $e');
    }
  }

  // Save user data to cache
  Future<void> saveUser(User user) async {
    logger.i('saveUser cache');
    // logger.d(user.playlistIds);
    final key = keyForUser(user.id);
    final box = await Hive.openBox(key);
    final jsonString = json.encode(user.toJson());
    await box.put(key, jsonString);
  }

  // // Get user data from cache
  // Future<User?> getUser(DateTime serverTimestamp, String userId) async {
  //   logger.i('getUser cache');
  //   final key = keyForUser(userId);
  //   final box = await Hive.openBox(key);
  //   final jsonString = box.get(key) as String?;
  //   if (jsonString != null) {
  //     final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
  //     return User.fromJson(jsonMap);
  //   }
  //   return null;
  // }
  // Get user data from cache
  // Get user data from cache
  Future<User?> getUser(String userId) async {
    logger.i('getUser cache');
    final key = keyForUser(userId);
    final box = await Hive.openBox(key);
    final jsonString = box.get(key) as String?;
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return User.fromJson(jsonMap);
    }
    return null;
  }

  // Future<User?> getUser(String userId) async {
  //   logger.i('getUser cache');
  //   final key = keyForUser(userId);
  //   final box = await Hive.openBox(key);
  //   final jsonString = box.get(key) as String?;
  //   if (jsonString != null) {
  //     final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
  //     return User.fromJson(jsonMap);
  //   }
  //   return null;
  // }

  /// Returns null if the cache is older than 2 days or if the cache is older than the server data.
  /// Otherwise returns the cached playlists.
  ///
  /// Requires a userId to ensure uniqueness of the cache.
  Future<List<Playlist>?> getPlaylists(
      DateTime serverTimestamp, String userId) async {
    logger.i('getPlaylists from cache');
    final key = keyForPlaylists(userId);
    final box = await Hive.openBox(key);
    final keyPlaylistsLastFetch = keyForPlaylistsLastFetch(userId);

    final String? jsonString = box.get(key);
    final String? lastUpdatedCacheString = box.get(keyPlaylistsLastFetch);

    // If the local cache is older than 2 days, return null so we can fetch from server
    final serverUpdatedTime =
        DateTime.tryParse(box.get(keyPlaylistsLastFetch) as String? ?? '');
    if (serverUpdatedTime != null) {
      final expirationTime = serverUpdatedTime.add(Duration(days: 2));
      if (DateTime.now().isAfter(expirationTime)) {
        return null;
      }
    }

    /// If the local cache is older than the server data, return null so we can fetch from server
    if (jsonString != null && lastUpdatedCacheString != null) {
      final DateTime lastLocalCacheUpdated =
          DateTime.parse(lastUpdatedCacheString);
      if (lastLocalCacheUpdated.isBefore(serverTimestamp)) {
        logger.i(
            'cached playlists are older than server data so please re-fetch cache');
        return null;
      }
    }
    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      logger.i('returning ${jsonList.length} playlists from cache');
      return jsonList
          .map((p) => Playlist.fromJson(p as Map<String, dynamic>, userId))
          .toList();
    }
    logger.i('no playlists in cache so returning null');
    return null;
  }

  /// Returns null if the cache is older than the server data.
  /// Otherwise returns the cached ratings.
  ///
  /// Requires a userId to ensure uniqueness of the cache.
  // Get ratings data from cache
  Future<List<Rating>?> getRatings(String userId) async {
    logger.i('getRatings from cache');
    final key = keyForRatings(userId);
    final box = await Hive.openBox(key);
    final jsonString = box.get(key) as String?;

    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((r) => Rating.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    return null;
  }

  // Future<List<Rating>?> getRatings(
  //     DateTime serverTimestamp, String userId) async {
  //   logger.i('getRatings from cache');
  //   final key = keyForRatings(userId);
  //   final box = await Hive.openBox(key);

  //   final String? jsonString = box.get(key);
  //   final String? lastUpdatedString = box.get('last_updated_ratings');

  //   if (jsonString != null && lastUpdatedString != null) {
  //     final DateTime lastUpdated = DateTime.parse(lastUpdatedString);
  //     if (lastUpdated.isBefore(serverTimestamp)) {
  //       logger.i(
  //           'cache for ratings is older than server data so please re-fetch');
  //       return null;
  //     }

  //     logger.i(
  //         'cache for ratings is newer than server data so don\'t fetch-just use cache');

  //     final jsonList = json.decode(jsonString) as List<dynamic>;
  //     return jsonList
  //         .map((r) => Rating.fromJson(r as Map<String, dynamic>))
  //         .toList();
  //   }

  //   logger.i('no ratings in cache so returning null');
  //   return null;
  // }

  // // Returns null if the cache is older than the server data.
  // /// Otherwise returns the cached tracks.
  // Future<List<Track>?> getTracks(
  //     DateTime serverTimestamp, String userId) async {
  //   logger.i('getTracks cache');
  //   final key = keyForTracks(userId);
  //   final box = await Hive.openBox(key);
  //   final jsonString = box.get(key) as String?;
  //   final String? lastUpdatedString = box.get('last_updated_tracks');
  //   if (jsonString != null && lastUpdatedString != null) {
  //     final DateTime lastUpdated = DateTime.parse(lastUpdatedString);
  //     if (lastUpdated.isBefore(serverTimestamp)) {
  //       logger.i(
  //           'cached tracks are older than server data so please re-fetch cache');
  //       return null;
  //     }
  //     logger.i(
  //         'cache tracks are newer than server data so don\'t fetch-just use cache');
  //     final jsonArray = json.decode(jsonString) as List<dynamic>;
  //     return jsonArray
  //         .map((json) => Track.fromJson(json as Map<String, dynamic>))
  //         .toList();
  //   }
  //   logger.i('no tracks in cache so returning null');
  //   return null;
  // }

  //   // Save tracks data to cache
  // Future<void> saveTracks(List<Track> tracks, String userId) async {
  //   logger.i('saveTracks cache');
  //   final key = keyForTracks(userId);
  //   final box = await Hive.openBox(key);
  //   final jsonString =
  //       json.encode(tracks.map((track) => track.toJson()).toList());
  //   await box.put(key, jsonString);
  //   // Save the timestamp as an ISO string
  //   box.put('last_updated_tracks', DateTime.now().toIso8601String());
  // }
// Returns null if the cache is older than the server data.
// Otherwise returns the cached tracks.
  Future<List<Track>?> getTracks(
      DateTime serverTimestamp, String userId) async {
    logger.i('getTracks cache');
    final key = keyForTracks(userId);

    try {
      final box = await Hive.openBox<dynamic>(key);

      final String? lastUpdatedString =
          box.get('last_updated_tracks') as String?;

      if (lastUpdatedString != null) {
        final DateTime lastUpdated = DateTime.parse(lastUpdatedString);
        if (lastUpdated.isBefore(serverTimestamp)) {
          logger.i(
              'Cached tracks are older than server data; re-fetch required.');
          return null;
        }

        logger.i('Using cached tracks.');

        final entries = box.toMap().entries.where(
              (entry) =>
                  entry.key != 'last_updated_tracks' &&
                  entry.key != 'cache_version',
            );

        if (kIsWeb) {
          // On Web, properly convert LinkedMap to Map<String, dynamic>
          final List<Track> cachedTracks = entries.map((entry) {
            final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(entry.value as Map);
            return Track.fromJson(jsonMap);
          }).toList();
          return cachedTracks;
        } else {
          // On Mobile/Desktop, retrieve stored Track objects
          final List<Track> cachedTracks =
              entries.map((entry) => entry.value as Track).toList();
          return cachedTracks;
        }
      }

      logger.i('No tracks in cache.');
      return null;
    } catch (e) {
      logger.e('Error retrieving tracks from cache: $e');
      return null;
    }
  }

// Save tracks data to cache
  Future<void> saveTracks(List<Track> tracks, String userId) async {
    logger.i('saveTracks cache');
    final key = keyForTracks(userId);
    final box = await Hive.openBox<dynamic>(key); // Open as dynamic to store different types

    await box.clear(); // Clear existing data

    // Save the timestamp as an ISO string
    await box.put('last_updated_tracks', DateTime.now().toIso8601String());

    if (kIsWeb) {
      // On Web, store tracks as Map<String, dynamic>
      for (Track track in tracks) {
        final trackKey = 'track_${track.uuid ?? track.databaseId}';
        await box.put(trackKey, track.toJson());
      }
    } else {
      // On Mobile/Desktop, store tracks directly
      for (Track track in tracks) {
        final trackKey = 'track_${track.uuid ?? track.databaseId}';
        await box.put(trackKey, track);
      }
    }
  }

  /// Save playlists data to cache
  Future<void> savePlaylists(List<Playlist> playlists, String userId) async {
    logger.i('savePlaylists to cache');
    final key = keyForPlaylists(userId);
    final box = await Hive.openBox(key);
    final jsonString = json.encode(playlists.map((p) => p.toJson()).toList());
    box.put(key, jsonString);
    final keyPlaylistsLastFetch = keyForPlaylistsLastFetch(userId);
    box.put(keyPlaylistsLastFetch, DateTime.now().toIso8601String());
  }

  // Save ratings data and timestamp to cache
  // Save ratings data to cache
  Future<void> saveRatings(List<Rating> ratings, String userId) async {
    logger.i('saveRatings to cache');
    final key = keyForRatings(userId);
    final box = await Hive.openBox(key);
    final jsonString = json.encode(ratings.map((r) => r.toJson()).toList());
    // Save the ratings data
    await box.put(key, jsonString);
  }

  /// CACHES COMMON TO ALL USERS ON A DEVICE
// Save bundles data to cache
  Future<void> saveBundles(List<Bundle> bundles) async {
    logger.i('saveBundles to cache');
    final box = await Hive.openBox(KEY_BUNDLES);
    final jsonString =
        json.encode(bundles.map((bundle) => bundle.toJson()).toList());
    box.put(KEY_BUNDLES, jsonString);
  }

// Get bundles data from cache
  Future<List<Bundle>?> getBundles(DateTime serverTimestamp) async {
    logger.i('getBundles from cache');
    final box = await Hive.openBox(KEY_BUNDLES);
    final jsonString = box.get(KEY_BUNDLES) as String?;
    if (jsonString != null) {
      final jsonArray = json.decode(jsonString) as List<dynamic>;
      return jsonArray
          .map((json) => Bundle.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  // Save artists data to cache
  Future<void> saveArtists(List<User> artists) async {
    logger.i('saveArtists to cache');
    final box = await Hive.openBox(KEY_ARTISTS);
    final jsonString = json.encode(artists.map((a) => a.toJson()).toList());
    box.put(KEY_ARTISTS, jsonString);
  }

  // Get artists data from cache
  // Get artists data from cache
  Future<List<User>?> getArtists() async {
    logger.i('getArtists from cache');
    final box = await Hive.openBox(KEY_ARTISTS);
    final jsonString = box.get(KEY_ARTISTS) as String?;

    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((a) => User.fromJson(a as Map<String, dynamic>))
          .toList();
    }

    return null;
  }

  // Future<List<User>?> getArtists(DateTime serverTimestamp) async {
  //   logger.i('getArtists to cache');
  //   final box = await Hive.openBox(KEY_ARTISTS);
  //   final jsonString = box.get(KEY_ARTISTS) as String?;

  //   if (jsonString != null) {
  //     final jsonList = json.decode(jsonString) as List<dynamic>;
  //     return jsonList
  //         .map((a) => User.fromJson(a as Map<String, dynamic>))
  //         .toList();
  //   }
  //   return null;
  // }

  // Save server timestamps to cache
  Future<void> saveServerTimestamps(
      Map<String, DateTime> serverTimestamps) async {
    logger.i('saveServerTimestamps to cache');
    final box = await Hive.openBox(KEY_SERVER_TIMESTAMPS);
    final jsonMap = serverTimestamps
        .map((key, value) => MapEntry(key, value.toIso8601String()));
    final jsonString = json.encode(jsonMap);
    await box.put(KEY_SERVER_TIMESTAMPS, jsonString);
  }

  // Get server timestamps from cache
  Future<Map<String, DateTime>?> getServerTimestamps() async {
    logger.i('getServerTimestamps from cache');
    final box = await Hive.openBox(KEY_SERVER_TIMESTAMPS);
    final jsonString = box.get(KEY_SERVER_TIMESTAMPS) as String?;
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final serverTimestamps = jsonMap
          .map((key, value) => MapEntry(key, DateTime.parse(value as String)));
      return serverTimestamps;
    }
    return null;
  }

// Clear specific box Cache
  Future<void> clearSpecific(String key) async {
    logger.i('ClearSpecific from cache: $key');
    await Hive.deleteBoxFromDisk(key);
  }
}
