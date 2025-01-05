import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class LargePlaylistQueueHeaders extends StatefulWidget {
  final bool showYear;

  const LargePlaylistQueueHeaders({super.key, this.showYear = true});

  @override
  State<LargePlaylistQueueHeaders> createState() =>
      _LargePlaylistQueueHeadersState();
}

class _LargePlaylistQueueHeadersState extends State<LargePlaylistQueueHeaders> {
  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: Colors.grey,
    );

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    '#',
                    style: style,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Expanded(
                flex: FlexValues.titleColumnFlex,
                child: Text('title'.translate(), style: style)),
            Expanded(
                flex: FlexValues.artistColumnFlex,
                child: Text('artist'.translate(), style: style)),
            const Expanded(
              flex: FlexValues.durationAndRatingColumnFlex,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Icon(
                        Icons.timer_outlined,
                        color: Colors.grey,
                      ),
                    ],
                  )),
            ),
          ],
        ),
        Divider(
          thickness: .2,
          color: Colors.grey.shade600,
        ),
      ],
    );
  }
}

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minExtentValue;
  final double maxExtentValue;
  final Color startColor;
  final Color endColor;

  StickyHeaderDelegate({
    required this.child,
    required this.minExtentValue,
    required this.maxExtentValue,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // logger.d('shrinkOffset: $shrinkOffset');
    // Calculate the opacity for the end color based on the shrinkOffset
    double t =
        (shrinkOffset / (maxExtentValue - minExtentValue)).clamp(0.0, 1.0);

    // logger.d('t: $t');
    // t = 0;

    // Interpolate between the startColor and endColor
    Color backgroundColor = Color.lerp(startColor, endColor, t)!;

    return Container(
      color: backgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent => math.max(maxExtentValue, minExtentValue);

  @override
  double get minExtent => minExtentValue;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

class FlexValues {
  static const int numberColumnFlex = 1;
  static const int titleColumnFlex = 4;
  static const int artistColumnFlex = 2;
  static const int durationAndRatingColumnFlex = 2;
}
