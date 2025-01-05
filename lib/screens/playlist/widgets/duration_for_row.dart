// ignore_for_file: prefer_int_literals

import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class DurationWidgetForRow<T extends Track> extends StatelessWidget {
  const DurationWidgetForRow({
    super.key,
    required this.track,
    this.ratingWidget,
  });

  final T track;
  final Widget? ratingWidget; // an optional parameter for the rating widget

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // if (ratingWidget != null) // if widget is provided
        //   Padding(
        //     padding: const EdgeInsets.all(7),
        //     child: ratingWidget,
        //   ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Text(
            track.length != null ? printCustomDuration(track.length!) : '    ',
            style: TextStyle(color: Colors.grey[300], fontSize: 12.0),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
