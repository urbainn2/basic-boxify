import 'package:boxify/app_core.dart';
import 'package:boxify/repositories/playlist/base_playlist_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Remember to abstract the repository with an interface to make it easy to swap for different implementations.
// For instance, you can create a `MusicRepository` interface and then create a `FirebaseMusicRepository` that implements that interface. This way,
// when you decide to change your backend or write tests, you simply need to provide a different implementation.
class PlaylistRepository extends BasePlaylistRepository {
  final FirebaseFirestore _firebaseFirestore;

  PlaylistRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  /// Returns a [Playlist] converted from firestore doc given a string playlistId
  @override
  Future<Playlist> fetchPlaylist(String playlistId, String userId) async {
    final doc = await _firebaseFirestore
        .collection(Paths.playlists)
        .doc(playlistId)
        .get();

    return doc.exists ? Playlist.fromDocument(doc, userId) : Playlist.empty;
  }

  /// Returns a list of [Playlist]s after converting them
  /// for a [User]. Used in [AppType.basic]
  @override
  Future<List<Playlist>> fetchPlaylistsBasic(String userId) async {
    logger.i('fetchPlaylistsBasic');
    final QuerySnapshot playlistsSnap = await _firebaseFirestore
        .collection(Paths.playlists)
        .where('total', isGreaterThan: 0)
        .get();
    final playlists = playlistsSnap.docs
        .map((doc) => Playlist.fromDocument(doc, userId))
        .toList();
    // final playlists = playlistsSnap.docs
    //     .map((doc) => Playlist.fromDocument(doc, userId))
    //     .where((playlist) =>
    //         userId == Core.app.rivers ||
    //         !playlist.displayTitle!
    //             .toLowerCase()
    //             .contains(Core.app.collaboratorsPath)) // Exclude Core.app.collaboratorsPath for other users
    //     .toList();
    // playlists.sort((a, b) =>
    //     a.displayTitle!.toLowerCase().compareTo(b.displayTitle!.toLowerCase()));

    return playlists;
  }

  /// Returns a list of [Playlist]s the user follows (or owns) (including [Core].app.defaultPlaylistIds)
  /// such as Piano and BTP (these are not dynamically created) from Firestore, not from the RC Server.
  ///
  /// Used in [AppType.advanced]
  /// Requires a string userId to get the playlists created by the user, regardless of score.
  @override
  Future<List<Playlist>> fetchPlaylistsAdvanced(String userId) async {
    logger.i('fetchPlaylistsAdvanced');

    final CollectionReference playlistsRef =
        _firebaseFirestore.collection(Paths.playlists);

    var playlistScoreCutoff = -1;

    if (kReleaseMode) {
      logger.i(
          'Running in release mode so fetching all playlist with score > $playlistScoreCutoff');
    } else {
      playlistScoreCutoff = Core.app.playlistScoreCutoff;
      logger.i(
          'Running in either Debug or Artist mode so limiting allPlaylists to score > $playlistScoreCutoff');
    }

    final QuerySnapshot scoredPlaylistsSnap = await playlistsRef
        .where('score', isGreaterThan: playlistScoreCutoff)
        .get();

    final QuerySnapshot userPlaylistsSnap =
        await playlistsRef.where('owner.id', isEqualTo: userId).get();

    // Combine two result sets
    final allPlaylistsDocs = [
      ...scoredPlaylistsSnap.docs,
      ...userPlaylistsSnap.docs,
    ];

    final playlists = await Future.wait(
      allPlaylistsDocs.map((doc) => Playlist.fromDoc(doc, userId)).toList(),
    );
    // logger.i(playlists);
    // logger.i('${s.elapsedMilliseconds}ms to Playlist.fromDoc).toList');
    final uniquePlaylists =
        {for (var playlist in playlists) playlist.id: playlist}.values.toList();

    return uniquePlaylists;
  }

  /// Returns a list of playlist objects from firestore given a string user Id.
  /// Used in both psb.loadUser and artistBloc.loadArtist
  @override
  Future<List<Playlist>> fetchUserPlaylists(String userId) async {
    var userPlaylists = <Playlist>[];
    logger.i('playlistRepo: fetchUserPlaylists for user: $userId');

    try {
      await _firebaseFirestore
          .collection(Paths.playlists)
          .where('owner.id', isEqualTo: userId)
          // .where('total', isGreaterThan: 0)
          .get()
          .then((docs) async {
        try {
          userPlaylists = await Future.wait(
            docs.docs.map((doc) => Playlist.fromDoc(doc, userId)).toList(),
          );
        } catch (e) {
          logger.e('fetchUserPlaylistserror1: $e');
        }
      });
    } catch (e) {
      logger.e('fetchUserPlaylistserror2: $e');
    }
    return userPlaylists;
  }

  @override
  Future<void> resequencePlaylists({
    required List<String> playlistIds,
    required String userId,
  }) async {
    final docRef = _firebaseFirestore.collection(Paths.users).doc(userId);

    await docRef.update({
      'playlistIds': playlistIds,
      'updated': FieldValue.serverTimestamp(),
    }).catchError((error) => logger.i('Failed to resequencePlaylists: $error'));
  }

  Future<void> setPlaylistSequence({
    required String playlistId,
    required List<String> trackIds,
  }) async {
    logger.i('repo setPlaylistSequence $playlistId');
    logger.e(trackIds);
    return _firebaseFirestore
        .collection(Paths.playlists)
        .doc(playlistId)
        .update({
      'tracks': trackIds,
      'total': trackIds.length,
      'updated': FieldValue.serverTimestamp(),
    }).catchError((error) {
      logger.i('Failed to setPlaylistSequence: $error');
      return Future.error(error);
    });
  }

  @override
  Future<void> removeTrackFromPlaylist({
    required String playlistId,
    required int index,
  }) async {
    logger.i('repo removeTrackFromPlaylist');

    final docRef =
        _firebaseFirestore.collection(Paths.playlists).doc(playlistId);

    await docRef.get().then((playlist) {
      final trackIds = playlist['tracks'];
      trackIds.removeAt(index);

      _firebaseFirestore.collection(Paths.playlists).doc(playlistId).update({
        'tracks': trackIds,
        'total': trackIds.length,
        'updated': FieldValue.serverTimestamp(),
      }).catchError(
        (error) => logger.i('Failed to addTrackToPlaylist: $error'),
      );
    });
  }

  /// Adds a trackId to the end of a playlist.tracks in firestore
  @override
  Future<void> addTrackToPlaylist({
    required String playlistId,
    required Track track,
  }) async {
    logger.i('repoaddTrackToPlaylist $playlistId');
    final trackId = track.uuid!;
    logger.i('trackId: $trackId');
    final docRef =
        _firebaseFirestore.collection(Paths.playlists).doc(playlistId);
    // logger.i(docRef);

    await docRef.get().then((playlist) {
      final trackIds = playlist['tracks'];
      trackIds.add(trackId);

      _firebaseFirestore.collection(Paths.playlists).doc(playlistId).update({
        'tracks': trackIds,
        'total': FieldValue.increment(1),
        'updated': FieldValue.serverTimestamp(),
      }).catchError(
        (error) => logger.i('Failed to addTrackToPlaylist: $error'),
      );
    });
  }

  @override

  /// simply creates the Playlist doc in firestore and returns the playlistId
  Future<String> createPlaylist({required Playlist playlist}) async {
    try {
      final doc = playlist.toDocument();
      final docRef =
          await _firebaseFirestore.collection(Paths.playlists).add(doc);
      return docRef.id; // Directly return the generated ID on success.
    } catch (error) {
      logger.i('Failed to createPlaylist: $error');
      rethrow; // Re-throw the error to handle it externally if needed.
    }
  }

  /// Actually I'm leaving the playlist in firestore.
  /// This just removes the playlist id from the user's playlist array.
  @override
  Future<void> removePlaylist({
    required String playlistId,
    required String userId,
  }) async {
    await _firebaseFirestore.collection(Paths.users).doc(userId).update({
      'playlistIds': FieldValue.arrayRemove([playlistId])
    });
  }

  @override
  Future<void> deletePlaylist({
    required String playlistId,
  }) async {
    /// also delete the playlist from firestore
    await _firebaseFirestore
        .collection(Paths.playlists)
        .doc(playlistId)
        .delete();
  }

  @override
  Future<void> updatePlaylist({required Map data}) async {
    logger.i('repo: updatePlaylist');
    final id = data['id'] as String;

    if (data.containsKey('image')) {
      await _firebaseFirestore.collection(Paths.playlists).doc(id).update({
        'image': data['image'],
        'name': data['name'],
        'description': data['description'],
        'updated': FieldValue.serverTimestamp(),
      });
    } else {
      await _firebaseFirestore.collection(Paths.playlists).doc(id).update({
        'name': data['name'],
        'description': data['description'],
        'updated': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<void> incrementFollowerCount(
      {required int quantity, required String playlistId}) async {
    logger.e('playlistRepo: incrementFollowerCount');
    await _firebaseFirestore
        .collection(Paths.playlists)
        .doc(playlistId)
        .update({
      'followerCount': FieldValue.increment(quantity),
      'updated': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> selectSource({
    required String source,
    required String userId,
  }) async {
    await _firebaseFirestore
        .collection(Paths.playlists)
        .doc(userId)
        .update({'selectedSource': source});
  }
}
