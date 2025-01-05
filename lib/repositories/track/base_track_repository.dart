import 'package:boxify/app_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

abstract class BaseTrackRepository {
  Future<List<Track>> fetchTracksFromRCServerAPI(String userId);

  Future<List<Track>> fetchPrivateTracksFromFirestore(User user);

  Future<List<Track>> getUserTracksApi(String userId);

  Future<List<Rating>> getUserRatings(
    String userId,
    FirebaseFirestore firebaseFirestore,
  );

  // Returns a list of playlists after converting them
  /// from a list of playlist Ids (strings)
  /// passed to the function.
  /// So you can search all playlists?
  Future<List<Listen>> fetchUserListens(String userId);

  List<Track> parseTracksFromResponse(http.Response response);

  Future<List<Track>> searchTracks({required String? query});

  Future<void> logListen({
    required String trackId,
    required String userId,
  });

  Future<void> updateRating({
    required String trackUuid,
    required String userId,
    required double value,
  });
}
