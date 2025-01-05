import 'package:boxify/app_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// A utility function that returns a widget which displays either
/// a local image asset or a remote image (with caching), depending
/// on the provided [imageUrl] and [filename]. If neither is provided,
/// it will display a default icon.
///
/// The function also supports providing custom [height] and [width]
/// for displaying the image.
///
/// The [imageUrl] parameter represents a remote image URL, while the
/// [filename] parameter represents the file name of a local image
/// asset inside the `assets/images/` directory.
///
/// When compiled to web, it uses [FadeInImage] for remote images,
/// while on mobile platforms it uses [CachedNetworkImage].
///
/// Example usage:
///
/// - Local asset: `imageOrIcon(filename: 'my-image.png')`
/// - Remote image: `imageOrIcon(imageUrl: 'https://example.com/image.png')`
/// - With custom height and width: `imageOrIcon(imageUrl: 'https://example.com/image.png', height: 100, width: 100)`
Widget imageOrIcon({
  String? imageUrl,
  String? filename,
  double? height,
  double? width,
  String? placeholder,
  Color? color,
  bool isCircular = false,
  double? roundedCorners, // Added roundedCorners param
}) {
  // If neither imageUrl nor filename is provided, return the default icon
  if (imageUrl == null && filename == null) {
    return const Icon(Icons.music_note);
  }

  // Use the provided placeholder or fallback to the default placeholder
  final finalPlaceholder = placeholder ?? 'assets/images/placeholder.png';

  // Initial widget is rectangular Image.asset or Icon
  Widget initialWidget;
  if (filename != null) {
    initialWidget = Image.asset(
      filename,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Log the error if needed
        logger.e('Error loading image from asset $filename: $exception');
        // Return the placeholder image
        return Image.asset(
          finalPlaceholder,
          height: height,
          width: width,
          fit: BoxFit.cover,
        );
      },
    );
  } else {
    // final finalColor = color ?? Core.appColor.primary;
    if (kIsWeb) {
      initialWidget = FadeInImage.assetNetwork(
        image: imageUrl!,
        placeholder: finalPlaceholder,
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    } else {
      initialWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        // placeholder: (context, url) => CircularProgressIndicator(
        //   color: finalColor,
        // ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    }
  }

  // Handling circular shape
  if (isCircular) {
    return ClipOval(child: initialWidget);
  }

  // Handling rounded corners
  if (roundedCorners != null) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(roundedCorners),
      child: initialWidget,
    );
  }

  // Return rectangular widget if not circular or rounded
  return initialWidget;
}
