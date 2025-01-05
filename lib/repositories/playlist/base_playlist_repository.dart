import 'package:boxify/app_core.dart';

abstract class BasePlaylistRepository {
  Future<List<Playlist>> fetchPlaylistsAdvanced(String userId);
  Future<List<Playlist>> fetchPlaylistsBasic(String userId);
  Future<List<Playlist>> fetchUserPlaylists(String userId);
  Future<void> resequencePlaylists({
    required List<String> playlistIds,
    required String userId,
  });

  Future<void> removeTrackFromPlaylist({
    required String playlistId,
    required int index,
  });
  Future<void> addTrackToPlaylist({
    required String playlistId,
    required Track track,
  });
  Future<void> createPlaylist({required Playlist playlist});
  Future<void> deletePlaylist({
    required String playlistId,
  });
  Future<void> removePlaylist({
    required String playlistId,
    required String userId,
  });
  Future<void> updatePlaylist({required Map data});
  Future<Playlist> fetchPlaylist(String playlistId, String userId);
  // Stream<List<Playlist>> fetchPlaylist({String userId});
  Future<void> selectSource({required String source, required String userId});

  Future<void> incrementFollowerCount({
    required int quantity,
    required String playlistId,
  });
}
