import 'package:boxify/app_core.dart';
import 'package:boxify/helpers/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// SmallPlayerSkeleton
/// This is a placeholder for the SmallPlayer, displayed while waiting for playlists and tracks to be loaded
class SmallPlayerSkeleton extends StatelessWidget {
  static final Color shimmerBaseColor = Colors.grey[300]!.withOpacity(0.5);
  static final Color shimmerHighlightColor =
      SmallPlayerSkeleton.shimmerBaseColor.withOpacity(0.35);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorHelper.dimColor(Core.appColor.primary, dimFactor: 0.25),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 5,
            offset: Offset(2, 2),
          )
        ],
      ),
      height: Core.app.smallPlayerHeight,
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Shimmer.fromColors(
            baseColor: SmallPlayerSkeleton.shimmerBaseColor,
            highlightColor: SmallPlayerSkeleton.shimmerHighlightColor,
            child: Container(
              height: Core.app.smallRowImageSize,
              width: Core.app.smallRowImageSize,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
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
                  baseColor: SmallPlayerSkeleton.shimmerBaseColor,
                  highlightColor: SmallPlayerSkeleton.shimmerHighlightColor,
                  child: Container(
                    height: 14,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: SmallPlayerSkeleton.shimmerBaseColor,
                  highlightColor: SmallPlayerSkeleton.shimmerHighlightColor,
                  child: Container(
                    height: 12,
                    width: MediaQuery.of(context).size.width * 0.3,
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
