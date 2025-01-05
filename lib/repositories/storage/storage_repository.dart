import 'dart:io';
import 'dart:typed_data';

import 'package:boxify/app_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

// import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'base_storage_repository.dart';

class StorageRepository extends BaseStorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

// // STarts here, pick one of 4: Either Post or Artist, and either web or mobile
//   @override
//   Future<String> uploadPostImage({required File image}) async {
//     final imageId = Uuid().v4();
//     final downloadUrl = await _uploadImage(
//       image: image,
//       ref: 'images/posts/post_$imageId.jpg',
//     );
//     logger.i(downloadUrl);
//     return downloadUrl;
//   }

  @override
  Future<String> uploadArtistImage({
    required String url,
    required File image,
  }) async {
    var imageId = const Uuid().v4();
    final String downloadUrl;
    try {
      // ignore: join_return_with_assignment
      downloadUrl = await _uploadImage(
        image: image,
        ref: 'images/users/userArtist_$imageId.jpg',
      );
      return downloadUrl;
    } catch (e) {
      logger.i('storage_repo_uploadArtistImage: $e');
    }
    return '';
  }

  @override
  Future<String> uploadArtistImageOnWeb({
    required Uint8List pngByteData,
  }) async {
    logger.i('uploadArtistImageOnWeb');
    final imageId = const Uuid().v4();
    final downloadUrl = await _uploadImageOnWeb(
      pngByteData: pngByteData,
      ref: 'images/users/userArtist_$imageId.jpg',
    );
    // logger.i(downloadUrl);
    return downloadUrl;
  }

  @override
  Future<String> uploadPlaylistImage({
    // required String url,
    required File image,
  }) async {
    final imageId = const Uuid().v4();
    final downloadUrl = await _uploadImage(
      image: image,
      ref: 'images/posts/post_$imageId.jpg',
    );
    // logger.i(downloadUrl);
    return downloadUrl;
  }

  @override
  Future<String> uploadPlaylistImageOnWeb({
    required Uint8List pngByteData,
  }) async {
    logger.i('uploadPlaylistImageOnWeb');
    final imageId = const Uuid().v4();
    final downloadUrl = await _uploadImageOnWeb(
      pngByteData: pngByteData,
      ref: 'images/posts/post_$imageId.jpg',
    );
    // logger.i(downloadUrl);
    return downloadUrl;
  }

// Then one of these 2 functions actually does the uploading,
// either to web or mobile
  Future<String> _uploadImage({
    required File image,
    required String ref,
  }) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  Future<String> _uploadImageOnWeb({
    required Uint8List pngByteData,
    required String ref,
  }) async {
    // logger.i(ref);
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putData(pngByteData)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    // logger.i(downloadUrl);
    return downloadUrl;
  }
}
