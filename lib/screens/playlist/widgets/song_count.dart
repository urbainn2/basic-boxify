import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SongCount extends StatelessWidget {
  const SongCount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final trackBloc = context.read<TrackBloc>();
    return Row(
      children: [
        // Text(' ${String.fromCharCode($bull)} '),
        Text(
          '${trackBloc.state.displayedTracks.length} songs',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
