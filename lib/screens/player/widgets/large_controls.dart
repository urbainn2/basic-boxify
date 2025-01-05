//
import 'dart:math';

import 'package:boxify/app_core.dart';
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LargeControls extends StatelessWidget {
  // final bool Function(MyPlayerState state, Track track)? skipUnavailableTrack;
  final Track track;
  const LargeControls({
    // this.skipUnavailableTrack,
    required this.track,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, MyPlayerState>(
      builder: (context, state) {
        // if (state.status == PlayerStatus.loading) {
        //   return circularProgressIndicator;
        // }
        // final Track track;

        // if (state.player.currentIndex != null && state.queue.isNotEmpty) {
        //   track = state.queue[state.player.currentIndex!];
        //   if (skipUnavailableTrack(state, track)) {
        //     context.read<PlayerBloc>().add(const SeekToNext());
        //   }
        // } else {
        //   logger.d('state.player.currentIndex == null or state.queue.isEmpty');
        //   logger.d('state.player.currentIndex: ${state.player.currentIndex}');
        //   logger.d('state.queue.length: ${state.queue.length}');
        //   return circularProgressIndicator;
        // }

        final width = MediaQuery.of(context).size.width;

        /// the Player controls will be max of 700 px and will shrink if the screen is smaller
        final maxWidth = min((width / 3), 700) as double;

        return Expanded(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LargeControlButtonsOnTop(
                //   track: track,
                // ),
                PlayerControls(track: track),
                SeekBarWidget(type: SeekBarType.large),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class LargeControlButtonsOnTop extends StatelessWidget {
//   const LargeControlButtonsOnTop({
//     super.key,
//     required this.track,
//   });

//   final Track track;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ShuffleButton(),
//         SeekToPreviousButton(),
//         PlayButton(
//             // track: track,
//             ),
//         SeekToNextButton(),
//         LoopButton(),
//       ],
//     );
//   }
// }
