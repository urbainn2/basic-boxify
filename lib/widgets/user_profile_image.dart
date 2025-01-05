import 'dart:io';
import 'dart:typed_data';

import 'package:boxify/app_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserArtistImage extends StatelessWidget {
  final double radius;
  final String? profileImageUrl;
  final File? profileImage;
  final Uint8List? pngByteData;

  const UserArtistImage({
    super.key,
    required this.radius,
    this.profileImageUrl,
    this.profileImage,
    this.pngByteData,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('UserArtistImage build profileImageUrl: $profileImageUrl');

    return Padding(
      padding: const EdgeInsets.all(14),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        backgroundImage: _getBgImage(),
        // child: _noArtistIcon(),
      ),
    );
  }

  ImageProvider<Object> _getBgImage() {
    if (profileImage != null) {
      return FileImage(profileImage!);
    } else {
      if (pngByteData != null) {
        return MemoryImage(pngByteData!);
      } else if (profileImageUrl != null) {
        // logger.d('_getBgImage profileImageUrl: $profileImageUrl');
        return CachedNetworkImageProvider(profileImageUrl!);
      } else {
        return AssetImage('assets/icon/rc.png');
      }
    }
  }

  Icon? _noArtistIcon() {
    if (profileImage == null && profileImageUrl == null) {
      return Icon(
        Icons.account_circle,
        color: Colors.grey[400],
        size: radius * 2,
      );
    }
    return null;
  }
}
