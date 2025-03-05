import 'dart:math';
import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// LargePlayerSkeleton
/// This is a placeholder for the LargePlayer, displayed while waiting for tracks to be loaded
class LargePlayerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Assume the minimum screen size is 500 pixels
    final minScreenSize = min(MediaQuery.of(context).size.width, 500);
    return Container(
      color: Core.appColor.scaffoldBackgroundColor,
      height: Core.app.playerHeight,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Shimmer.fromColors(
            // Track image skeleton
            baseColor: Core.appColor.shimmerBaseColor,
            highlightColor: Core.appColor.shimmerHighlightColor,
            child: Container(
              height: Core.app.smallRowImageSize,
              width: Core.app.smallRowImageSize,
              decoration: BoxDecoration(color: Colors.grey[300]),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Core.appColor.shimmerBaseColor,
                  highlightColor: Core.appColor.shimmerHighlightColor,
                  child: Container(
                    height: 14,
                    width: minScreenSize * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: Core.appColor.shimmerBaseColor,
                  highlightColor: Core.appColor.shimmerHighlightColor,
                  child: Container(
                    height: 12,
                    width: minScreenSize * 0.18,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
