import 'package:boxify/app_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SeekBarWidget extends StatelessWidget {
  final SeekBarType? type;

  const SeekBarWidget({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    final state = context.read<PlayerBloc>().state;
    return
        // THE SEEK BAR UNDER THE PLAYER CONTROLS
        StreamBuilder<Duration?>(
      stream: state.player.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return StreamBuilder<PositionData>(
          stream: Rx.combineLatest2<Duration, Duration, PositionData>(
            state.player.positionStream,
            state.player.bufferedPositionStream,
            (position, bufferedPosition) =>
                PositionData(position, bufferedPosition),
          ),
          builder: (context, snapshot) {
            final positionData =
                snapshot.data ?? PositionData(Duration.zero, Duration.zero);
            var position = positionData.position;
            if (position > duration) {
              position = duration;
            }
            var bufferedPosition = positionData.bufferedPosition;
            if (bufferedPosition > duration) {
              bufferedPosition = duration;
            }
            return SeekBar(
              type: type ?? SeekBarType.small,
              duration: state.player.duration ?? Duration.zero,
              position: state.player.position,
              bufferedPosition: state.player.bufferedPosition,
              onChangeEnd: (newPosition) {
                state.player.seek(newPosition);
              },
            );
          },
        );
      },
    );
  }
}
