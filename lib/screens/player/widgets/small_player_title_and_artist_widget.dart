import 'dart:math';
import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Used in [SmallPlayer]
class SmallPlayerTitleAndArtistWidget extends StatelessWidget {
  const SmallPlayerTitleAndArtistWidget({
    super.key,
    required this.track,
    required this.isWide,
  });

  final Track track;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);
    final state = playerBloc.state;
    final status = state.status;

    final imageSize = 50;
    final buttonSize = 44;
    final width = MediaQuery.of(context).size.width - (imageSize + buttonSize);
    final dividend = isWide ? 1.2 : 3;
    final adjustedWidth = width / dividend;

    /// the Image and Title will be max of 400 px and will shrink if the screen is smaller
    final maxWidth = min(adjustedWidth, 400.0);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: maxWidth,
            height: 18,
            child: TextOrMarquee(
              text: track.displayTitle,
              // text: status.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            width: maxWidth,
            height: 20,
            child: TextOrMarquee(
              text: track.artist ?? '',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
