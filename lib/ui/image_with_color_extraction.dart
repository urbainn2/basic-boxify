import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:boxify/app_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageWithColorExtraction extends StatefulWidget {
  final String? imageUrl;
  final String? filename;
  final String? placeholder;
  final ValueChanged<Color> onColorExtracted;
  final double height;
  final double width;
  final double? roundedCorners;

  const ImageWithColorExtraction({
    super.key,
    this.imageUrl,
    this.filename,
    this.placeholder,
    required this.onColorExtracted,
    required this.height,
    required this.width,
    this.roundedCorners,
  });

  @override
  State<ImageWithColorExtraction> createState() =>
      _ImageWithColorExtractionState();
}

class _ImageWithColorExtractionState extends State<ImageWithColorExtraction> {
  late ImageProvider? _imageProvider;

  @override
  void initState() {
    super.initState();
    _initImageProvider();

    // If a valid provider is set, extract the average color.
    if (_imageProvider != null) _extractAverageColor();
  }

  void _initImageProvider() {
    // Set the image provider: network, cached, or asset image.
    // If no image is provided, set it to null.
    _imageProvider = widget.imageUrl != null
        ? kIsWeb
            ? NetworkImage(widget.imageUrl!) as ImageProvider
            : CachedNetworkImageProvider(widget.imageUrl!)
        : widget.filename != null
            ? AssetImage(widget.filename!)
            : null;
  }

  void _extractAverageColor() async {
    if (_imageProvider == null) return;
    try {
      final ImageStream imageStream =
          _imageProvider!.resolve(ImageConfiguration.empty);

      // Wait for the image to load and extract the average color.
      imageStream.addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) async {
          // Image is loaded; convert it to a Uint8List (so we can read its data).
          final ui.Image uiImage = info.image;
          final ByteData? byteData =
              await uiImage.toByteData(format: ui.ImageByteFormat.png);
          if (byteData == null) return;

          // Use the correct offset and length when converting ByteData to Uint8List.
          // This is needed because the ByteData may contain extra data at the beginning.
          final Uint8List imageBytes = byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          );

          // Decode the image so we can use it to extract the average color.
          final img.Image? decodedImage = img.decodeImage(imageBytes);
          if (decodedImage == null) return;

          final Color averageColor = _calculateAverageColor(decodedImage);
          widget.onColorExtracted(averageColor);
        }),
      );
    } catch (e) {
      logger.e('Error extracting average color: $e');
    }
  }

  Color _calculateAverageColor(img.Image image) {
    final width = image.width;
    final height = image.height;
    final totalPixels = width * height;
    const sampleSize = 100;

    // Determine the step size for sampling the image.
    // the step value = nbr of pixels to skip between samples
    int step = sqrt(totalPixels / sampleSize).floor();
    step = step.clamp(1, 100); // must be between 1 and 100

    double r = 0, g = 0, b = 0;
    int samples = 0;

    for (int y = 0; y < height; y += step) {
      for (int x = 0; x < width; x += step) {
        // Sample pixel: get the color values and add them to the running totals.
        final pixel = image.getPixel(x, y);
        r += pixel.r; // ref
        g += pixel.g; // green
        b += pixel.b; // blue
        samples++;
      }
    }

    // Return the average of the sampled colors.
    return Color.fromARGB(
      255, // alpha channel (transparency). set it to 255 (opaque)
      (r / samples).round(),
      (g / samples).round(),
      (b / samples).round(),
    );
  }

  @override
  void didUpdateWidget(covariant ImageWithColorExtraction oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Onlt re-extract the color if the image URL has changed.
    if (widget.imageUrl != oldWidget.imageUrl) {
      // Update the image provider and extract color for the new URL.
      _initImageProvider();
      _extractAverageColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filename == null && widget.imageUrl == null) {
      // Create a 'placeholder' box with a music note icon in its center
      return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: Core.appColor.widgetBackgroundColor,
            borderRadius: BorderRadius.circular(widget.roundedCorners ?? 0),
          ),
          child: const Icon(Icons.music_note));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.roundedCorners ?? 0),
      child: _imageProvider != null
          ? Image(
              image: _imageProvider!,
              height: widget.height,
              width: widget.width,
              fit: BoxFit.cover,
            )
          : Image.asset(
              widget.placeholder ?? 'assets/images/placeholder.png',
              height: widget.height,
              width: widget.width,
              fit: BoxFit.cover,
            ),
    );
  }
}
