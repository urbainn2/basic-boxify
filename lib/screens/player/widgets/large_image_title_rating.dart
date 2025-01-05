import 'dart:math';

import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

import 'large_title_and_artist.dart';

/// Used in [LargePlayer]
class LargeImageTitleRating extends StatelessWidget {
  const LargeImageTitleRating({
    super.key,
    required this.track,
    this.imageFilename,
    this.imageUrl,
  });
  final Track track;
  final String? imageFilename;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imageOrIcon(
              imageUrl: imageUrl,
              filename: imageFilename,
              height: Core.app.smallRowImageSize,
              width: Core.app.smallRowImageSize, // 50
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: LargeTitleAndArtist(track: track),
                    fit: FlexFit.tight,
                  ),
                  // No need for Expanded around StarRating, as we want it to stay next to the title
                  StarRating(track: track),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
