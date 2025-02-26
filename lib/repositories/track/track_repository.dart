import 'dart:convert';

import 'package:boxify/app_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'base_track_repository.dart';

class TrackRepository extends BaseTrackRepository {
  TrackRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firebaseFirestore;
  final CacheHelper _cacheHelper = CacheHelper();

  Future<void> clearRatingsCache(String userId) async {
    await _cacheHelper.clearSpecific(CacheHelper.keyForRatings(userId));
  }

  @override
  Future<List<Track>> fetchTracksFromRCServerAPI(String userId) async {
    // final start = DateTime.now();
    logger.i('fetchTracksFromRCServerAPI');
    if (Core.app.type == AppType.basic) {
      throw Exception(
          'AppType.Basic does not have access to riverscuomo.flask.server tracks. Use fetchPrivateTracksFromFirestore instead');
    }
    final start2 = DateTime.now();
    try {
      final response = await http.get(
        Uri.parse(Core.app.tracksAPIUrl),
        headers: {
          'TOKEN': Core.app.serverToken,
          'userId': userId,
        },
      );

      logRunTime(start2, "fetchTracksFromRCServerAPI: http.get");
      if (response.statusCode == 200) {
        final tracks = parseTracksFromResponse(response);
        return tracks;
      } else if (response.statusCode == 401) {
        logger.e(
            'fetchTracksFromRCServerAPI: 401! Unauthorized! Did you pass the correct Core.app.serverToken?');
        return [];
      }
      
      else if (response.statusCode == 503) {
        logger.e(
            'fetchTracksFromRCServerAPI: 503! Server is down! Check books-r-fun server on Heroku. They may have updated your postgresql database credentials. Run the server locally to test.');
        return [];
      } else {
        throw Exception(
            'TRACK REPO:Failed to load tracks because of status code ${response.statusCode}}');
      }
    } catch (e) {
      logger.e('fetchTracksFromRCServerAPI: $e');
      return [];
    }
  }

  @override
  Future<List<Track>> fetchPrivateTracksFromFirestore(User user) async {
    logger.e('fetchPrivateTracksFromFirestore');
    if (Core.app.type == AppType.advanced) {
      throw Exception(
          'AppType.Advanced does not have access to private tracks. Use fetchTracksFromRCServerAPI instead');
    }
    final firebaseFirestore = FirebaseFirestore.instance;
    final roles = user.roles;

    // Get tracks whose role property is in the list of user roles
    if (roles != null && roles.isNotEmpty) {
      final tracksSnap = await firebaseFirestore
          .collection(Paths.tracks)
          .where('role', whereIn: roles)
          .get();
      final tracks = tracksSnap.docs.map(Track.fromDocumentNoFuture).toList();
      return tracks;
    } else {
      // If user has no roles, return empty list for security
      return [];
    }
  }

  @override
  Future<List<Track>> getUserTracksApi(String userId) async {
    logger.e('getUserTracksApi');

    final response = await http.get(
      Uri.parse(Core.app.tracksAPIUrl),
      headers: {
        'TOKEN': Core.app.serverToken,
        'userId': userId,
      },
    );
    // logger.e(response);
    if (response.body.isEmpty) {
      logger.e(
        'pbloc_error_getusertracksapi getting tracks from 1.0, returned null, so returning empty list to playerscreen.',
      );
      return [];
    }
    // Notice how you have to call body from the response
    // if you are using http to retrieve json
    final body = json.decode(response.body) as Map<String, dynamic>;

    if (body.containsKey('error') == true) {
      logger.e(
        'error getting tracks from 1.0, so returning empty list to playerscreen.',
      );
      logger.e(body.toString());
      return [];
    }
    final data = body['tracks'] as List<Map<String, dynamic>>;
    final tracks = data.map(Track.fromJson).toList();
    logger.i('returning ${tracks.length} tracks from server');
    return tracks;
  }

  Future<List<Rating>> getUserRatings(
    String userId,
    FirebaseFirestore firebaseFirestore,
  ) async {
    logger.i('Fetching user ratings for userId: $userId');

    if (userId.isEmpty) {
      logger.i('User is anonymous or invalid userId, returning empty list');
      return [];
    }

    if (ConnectivityManager.instance.currentStatus == ConnectivityResult.none) {
      // Offline, get ratings from cache
      final cachedRatings = await _cacheHelper.getRatings(userId);
      if (cachedRatings != null) {
        logger.i('Returning cached ratings');
        return cachedRatings;
      } else {
        logger.e('No internet connection and no cached ratings available.');
        return [];
      }
    } else {
      // Online, fetch from Firestore
      try {
        final ratingsSnapshot = await _firebaseFirestore
            .collection(Paths.ratings)
            .where('userId', isEqualTo: userId)
            .get();

        // Map documents to futures of Rating objects
        final futureRatings =
            ratingsSnapshot.docs.map((doc) => Rating.fromDoc(doc)).toList();

        // Await all futures
        final ratingsList = await Future.wait(futureRatings);

        // Filter out nulls and cast to List<Rating>
        final ratings = ratingsList.whereType<Rating>().toList();

        // Save ratings to cache
        await _cacheHelper.saveRatings(ratings, userId);

        return ratings;
      } catch (e) {
        logger.e('Error fetching ratings: $e');
        // Return cached ratings if available
        final cachedRatings = await _cacheHelper.getRatings(userId);
        if (cachedRatings != null) {
          logger.i('Returning cached ratings after exception');
          return cachedRatings;
        } else {
          return [];
        }
      }
    }
  }

//   Future<List<Rating>> getUserRatings(
//     String userId,
//     FirebaseFirestore firebaseFirestore,
//   ) async {
//     logger.i('trackRepo: getUserRatings');
//     final s = Stopwatch()..start();

//     if (userId.isEmpty) {
//       logger.i('user is anonymous or invalid userId so returning empty list');
//       return [];
//     }

//     QuerySnapshot ratingsSnap;
//     ratingsSnap = await firebaseFirestore
//         .collection(Paths.ratings)
//         .where('userId', isEqualTo: userId)
//         .get();
//     logger.e('${s.elapsedMilliseconds}ms to get ratingsSnap');

// // Use Future.wait to asynchronously convert each document to a Rating object.
// // This assumes Rating.fromDoc returns a Future<Rating?>.
//     final futureRatings =
//         ratingsSnap.docs.map((doc) => Rating.fromDoc(doc)).toList();

// // Await all futures and then filter out any null values.
// // The cast is safe because we're explicitly removing nulls.
//     final ratings = (await Future.wait(futureRatings))
//         .whereType<Rating>() // This removes any null values from the list.
//         .toList();

//     return ratings;
//   }

  // Returns a list of playlists after converting them
  /// from a list of playlist Ids (strings)
  /// passed to the function.
  /// So you can search all playlists?
  @override
  Future<List<Listen>> fetchUserListens(String userId) async {
    final firebaseFirestore = FirebaseFirestore.instance;
    logger.e('_fetchUserListens');

    var userListens = <Listen>[];

    try {
      await firebaseFirestore
          .collection(Paths.listens)
          .where('userId', isEqualTo: userId)
          .where('trackId', isNotEqualTo: null)
          .limit(1)
          .get()
          .then((docs) {
        try {
          userListens = docs.docs.map(Listen.fromDoc).toList();
          // logger.e(userPlaylists);
        } catch (e) {
          logger.e('_fetchUserListens2: $e');
        }
      });
    } catch (e) {
      logger.e('_fetchUserListens1: $e');
    }
    logger.e('listens: ${userListens.length}');
    return userListens;
  }

  @override
  List<Track> parseTracksFromResponse(http.Response response) {
    // final s = Stopwatch();
    final start = DateTime.now();
    logger.i('parseTracksFromResponse');

    // logger.e(response);
    if (response.body.isEmpty) {
      logger.e(
        'pbloc_error_getusertracksapi getting tracks from 1.0, returned null, so returning empty list to playerscreen.',
      );
      return [];
    }
    // Notice how you have to call body from the response
    // if you are using http to retrieve json
    final body = json.decode(response.body) as Map<String, dynamic>;

    if (body.containsKey('error') == true) {
      logger.e(
        'error getting tracks from 1.0, so returning empty list to playerscreen.',
      );
      logger.e(body.toString());
      return [];
    }
    final dynamicList = body['tracks'] as List<dynamic>;
    final tracks = <Track>[];

    for (final item in dynamicList) {
      tracks.add(Track.fromJson(item as Map<String, dynamic>));
    }
    // logger.e('returning ${tracks.length} tracks from server');
    logRunTime(start, "parseTracksFromResponse");
    return tracks;
  }

  @override
  Future<List<Track>> searchTracks({required String? query}) async {
    final tracksSnap = await _firebaseFirestore
        .collection(Paths.tracks)
        .where('title', isGreaterThanOrEqualTo: query)
        .limit(10) // I added
        .get();

    final tracks = tracksSnap.docs.map(Track.fromDocumentNoFuture).toList();

    return tracks;
  }

  @override
  Future<void> logListen({
    required String trackId,
    required String userId,
  }) async {
    await _firebaseFirestore.collection(Paths.listens).add({
      'trackId': trackId,
      'userId': userId,
    });
  }

  @override
  Future<void> updateRating({
    required String trackUuid,
    required String userId,
    required double value,
  }) async {
    logger.i('trackRepo:updateRating: $trackUuid, $userId, $value');
    await _firebaseFirestore
        .collection(Paths.ratings)
        .where('userId', isEqualTo: userId)
        .where('trackUuid', isEqualTo: trackUuid)
        .limit(1)
        .get()
        .then(
          (querySnapshot) => {
            if (querySnapshot.docs.isEmpty)
              {
                logger.e(
                  'no docs in the this ratings snapshot so adding to firstore',
                ),
                _firebaseFirestore.collection(Paths.ratings).add({
                  'trackUuid': trackUuid,
                  'userId': userId,
                  'value': value,
                  'updated': FieldValue.serverTimestamp()
                }),
              }
            else
              {
                logger
                    .e('doc in this ratings snapshot so updating in firestore'),
                for (final doc in querySnapshot.docs)
                  {
                    doc.reference.update({
                      'value': value,
                      'updated': FieldValue.serverTimestamp()
                    }),
                  }
              }
          },
        );
  }
}
