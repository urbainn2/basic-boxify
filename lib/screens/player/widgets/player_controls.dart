import 'package:boxify/app_core.dart';

import 'package:flutter/material.dart';

/// Player Controls
/// on the [SmallTrackDetailScreen], Row.mainAxisSize: MainAxisSize.min,
/// on [LargeControls], that property was not set.
class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  Widget build(BuildContext context) {
    // logger.d('track in player_controls.dart: ${track.title}');
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShuffleButton(),
        SeekToPreviousButton(),
        PlayButton(),
        SeekToNextButton(),
        LoopButton(),
      ],
    );
  }
}
