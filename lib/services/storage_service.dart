import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

// import 'package:app_core/app_core.dart';  //
import 'package:boxify/app_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  Future<XFile?> _compressImage(String? imageId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$imageId.jpg',
      quality: 70,
    );
    return compressedImageFile;
  }

//   Future<String> getImageUrl(String imagePath) async {
//     FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://riverscuomo-8cc6d');
//     final ref = storage.ref().child(imagePath);
//     final imageUrl = await ref.getDownloadURL();
//     return imageUrl;
//   }

//   Future<Map<String, String>> loadAllImageUrls(List<String> imagePaths) async {
//     Map<String, String> imageUrls = {};

//     for (String imagePath in imagePaths) {
//       String imageUrl = await getImageUrl(imagePath);
//       imageUrls[imagePath] = imageUrl;
//     }

//   return imageUrls;
// }

  // Future<String> _uploadImage(String path, String imageId, File image) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;

  //   await storage.ref(path).putFile(image);
  // }

  Future<String> _uploadImage(String path, String? imageId, File image) async {
    // StorageUploadTask uploadTask = storageRef.child(path).putFile(image);
    // StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    // String downloadUrl = await storageSnap.ref.getDownloadURL();
    // return downloadUrl;
    logger.i('..._uploadImage');

    final storage = FirebaseStorage.instance;
    String url;
    final ref = storage.ref().child(path);
    final uploadTask = ref.putFile(image);

    final imageUrl = await (await uploadTask)
        .ref
        .getDownloadURL(); // https://stackoverflow.com/questions/64880675/flutter-uploadtask-method-oncomplete-does-not-exists
    url = imageUrl.toString();

    return url;
  }

  Future<String> _uploadImageOnWeb(
    String path,
    String imageId,
    Uint8List image,
  ) async {
    // image was dynamic
    // StorageUploadTask uploadTask = storageRef.child(path).putFile(image);
    // StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    // String downloadUrl = await storageSnap.ref.getDownloadURL();
    // return downloadUrl;
    logger.i('..._uploadImageOnWeb');

    final storage = FirebaseStorage.instance;
    String url;
    final ref = storage.ref().child(path);
    final uploadTask = ref.putData(image);

    final imageUrl = await (await uploadTask)
        .ref
        .getDownloadURL(); // https://stackoverflow.com/questions/64880675/flutter-uploadtask-method-oncomplete-does-not-exists
    url = imageUrl.toString();

    return url;
  }

  Future<String> uploadChatImage(String url, File imageFile) async {
    logger.i('....uploadChatImage');
    // logger.i(url);
    // url = 'chat_d5dd1ebb-09ec-4d67-9260-553384f771e3.jpg';

    // logger.i('making an id for the image');
    String? imageId = const Uuid().v4();
    // logger.i(imageId);

    // logger.i('compressing the image');
    final image = await (_compressImage(imageId, imageFile) as FutureOr<File>);
    // logger.i(image);

    final exp = RegExp('chat_(.*).jpg');
    // logger.i(exp);
    imageId = exp.firstMatch(url)![1];

    // logger.i('_uploadImage the image and image id and get back the downloadurl');
    final downloadUrl = await _uploadImage(
      'images/chats/chat_$imageId.jpg',
      imageId,
      image,
    );
    // logger.i(downloadUrl);
    return downloadUrl;
  }

  Future<String> uploadMessageImage(File imageFile) async {
    logger.i('.......uploadMessageImage');
    final imageId = const Uuid().v4();
    final image = await (_compressImage(imageId, imageFile) as FutureOr<File>);
    // logger.i(image);
    final downloadUrl = await _uploadImage(
      'images/messages/message_$imageId.jpg',
      imageId,
      image,
    );
    // logger.i('message uploaded, here is the url:');
    // logger.i(downloadUrl);
    return downloadUrl;
  }

  Future<String> uploadMessageImageOnWeb(Uint8List fileBytes) async {
    // was dynamic
    logger.i('.......uploadMessageImageOnWeb');
    final imageId = const Uuid().v4();

    final downloadUrl = await _uploadImageOnWeb(
      'images/messages/message_$imageId.jpg',
      imageId,
      fileBytes,
    );
    // logger.i(downloadUrl);

    return downloadUrl;
  }
}
