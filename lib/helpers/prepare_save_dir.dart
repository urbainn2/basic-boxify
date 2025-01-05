// prepare for finding localpath :
import 'dart:io';

// import 'package:app_core/common.dart';

Future<Directory> prepareSaveDir(String localPath) async {
  final savedDir = Directory(localPath);

  final hasExisted = await savedDir.exists();
  if (!hasExisted) {
    // logger.i('savedDir does not exist so creating it');
    await savedDir.create();
  }
  // logger.i('savedDir: $savedDir');

  return savedDir;
}
