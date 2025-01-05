import 'dart:io';
import 'package:boxify/app_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BundleImage extends StatelessWidget {
  const BundleImage({
    super.key,
    required this.bundle,
  });

  final Bundle bundle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageOrIcon(imageUrl: bundle.image, width: 132, height: 132),
        ),
      ],
    );
  }
}

/// CircularImage
///
/// A widget to display an image in circular form.
/// Fetches images either from the network or file system.
/// Shows a dummy profile icon if no image is available.
///
/// It takes in the following parameters -
/// [radius] - doubles as the size of the icon
/// [imageString] - a URL string of the image from network
/// [imageFile] - A File object of the image from filesystem
/// [imageFilename]
class CircularImage extends StatelessWidget {
  final double radius;
  final String imageString;
  final String? imageFilename;
  final File? imageFile;

  /// Constructor takes in the [radius] and [imageString] as required.
  /// [imageFile] is optional.
  const CircularImage({
    super.key,
    required this.radius,
    required this.imageString,
    this.imageFilename,
    this.imageFile,
  });

  ImageProvider<Object>? getImageProvider() {
    if (imageFilename != null) {
      logger.d('image_widgets.getImageProvider: imageFilename: $imageFilename');
      return AssetImage(imageFilename!);
    } else if (imageFile != null) {
      return FileImage(imageFile!);
    } else if (imageString.isNotEmpty) {
      logger.d('image_widgets.getImageProvider: imageString: $imageString');
      return CachedNetworkImageProvider(imageString);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Returns a circle avatar with radius defined
    // Loads an image from a file if provided,
    // Else, tries to fetch from the network using the URL string.
    // If neither available, doesn't set a background image
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: getImageProvider(),
      child: _noArtistIcon(),
    );
  }

  /// Display a standard "no profile" icon if no image is available.
  Icon? _noArtistIcon() {
    if (imageFile == null && imageString.isEmpty) {
      return Icon(
        Icons.account_circle,
        color: Colors.grey[400],
        size: radius * 2,
      );
    }
    return null;
  }
}

class ImageForRow extends StatelessWidget {
  ImageForRow({
    super.key,
    required this.track,
    this.playlist,
    this.height,
    this.width,
  });

  final Track track;
  final Playlist? playlist;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: imageOrIcon(
        imageUrl: assignPlaylistImageUrlToTrack(track, playlist),
        filename: assignPlaylistImageFilenameToTrack(track, playlist),
        height: height ?? Core.app.smallRowImageSize,
        width: width ?? Core.app.smallRowImageSize,
      ),
    );
  }
}

/// All this does is wrap an imageOrIcon in a Padding widget
/// and an AspectRatio widget.
class SquareImage extends StatelessWidget {
  final String? imageUrl;
  final String? imageFilename;
  final double padding;
  final Color? color;

  const SquareImage({
    super.key,
    this.imageUrl,
    this.imageFilename,
    this.padding = 14,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final image = imageOrIcon(
      imageUrl: imageUrl,
      filename: imageFilename,
      color: color,
    );

    return Padding(
      padding: EdgeInsets.all(padding),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: image,
      ),
    );
  }
}

//// Seems to be for Weezify profile screen only?
class RoundedCornersImage extends StatelessWidget {
  final String? imageUrl;
  final String? imageFilename;
  final Color? color;
  final double? height;
  final double? width;

  const RoundedCornersImage({
    super.key,
    this.imageUrl,
    this.imageFilename,
    this.color,
    this.height = 132,
    this.width = 132,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: imageOrIcon(
            imageUrl: imageUrl,
            filename: imageFilename,
            width: width,
            height: height,
          ),
        ),
      ],
    );
  }
}
