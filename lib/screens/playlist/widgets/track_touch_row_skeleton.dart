import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// TrackTouchRowSkeleton
/// This is a [TrackTouchRow] placeholder, displayed while waiting for tracks to be loaded
class TrackTouchRowSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
      color: Core.appColor.widgetBackgroundColor,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Shimmer.fromColors(
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
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Shimmer.fromColors(
                    baseColor: Core.appColor.shimmerBaseColor,
                    highlightColor: Core.appColor.shimmerHighlightColor,
                    child: Container(
                      height: 10,
                      width: MediaQuery.of(context).size.width * 0.18,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
