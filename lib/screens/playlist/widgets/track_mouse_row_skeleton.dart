import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// TrackMouseRowSkeleton
/// This is a [TrackMouseRow] placeholder, displayed while waiting for tracks to be loaded
class TrackMouseRowSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
      color: Core.appColor.widgetBackgroundColor,
      child: Row(
        children: [
          Shimmer.fromColors(
            // Skeleton for track index text
            baseColor: Core.appColor.shimmerBaseColor,
            highlightColor: Core.appColor.shimmerHighlightColor,
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
            child: Shimmer.fromColors(
              baseColor: Core.appColor.shimmerBaseColor,
              highlightColor: Core.appColor.shimmerHighlightColor,
              child: Container(
                height: 42.0,
                width: 42.0,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8)),
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
                      width: 200,
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
                      height: 10,
                      width: 100,
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
        ],
      ),
    );
  }
}
