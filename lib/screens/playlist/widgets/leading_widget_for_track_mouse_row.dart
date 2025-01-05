import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class LeadingWidgetForTrackMouseRow extends StatelessWidget {
  LeadingWidgetForTrackMouseRow({
    super.key,
    required this.showLeadingWidget,
    required this.index,
    required this.isHovering,
    required this.isMouseClicked,
    this.size = 20,
    this.isPlaying = false,
  });

  final bool showLeadingWidget;
  final int index;
  final bool isHovering;
  final bool isMouseClicked;
  final double size;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    if (showLeadingWidget) {
      return PlayButtonUnpadded(
        size: size,
        isPlaying: isPlaying,
        isHovering: isHovering,
        isMouseClicked: isMouseClicked,
        index: index,
      );
    } else {
      return SizedBox();
    }
  }
}
