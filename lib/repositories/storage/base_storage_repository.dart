import 'dart:io';

import 'dart:typed_data';

abstract class BaseStorageRepository {
  Future<String> uploadArtistImage({required String url, required File image});
  Future<String> uploadPlaylistImage({required File image});
  Future<String> uploadPlaylistImageOnWeb({required Uint8List pngByteData});
  Future<String> uploadArtistImageOnWeb({required Uint8List pngByteData});
}
