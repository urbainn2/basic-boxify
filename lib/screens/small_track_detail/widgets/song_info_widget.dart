import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SongInfoWidget extends StatelessWidget {
  final Track track;

  const SongInfoWidget({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    final ratingWidgetWidth = 50;

    final width = MediaQuery.of(context).size.width - (ratingWidgetWidth);
    // final dividend = isWide ? 1.2 : 3;
    // final adjustedWidth = width / dividend;

    // /// the Image and Title will be max of 400 px and will shrink if the screen is smaller
    // final maxWidth = min(adjustedWidth, 400.0);
    // SONG TITLE, ARTIST
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                width: width,
                child: TextOrMarquee(
                  text: track.displayTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(
                    '/user/${track.userId}',
                  );
                },
                child: Text(
                  track.artist ?? 'Rivers',
                ),
              )
            ],
          ),
        ),
        StarRating(track: track),
      ],
    );
  }
}

// class BaseTrackInfo extends StatelessWidget {
//   const BaseTrackInfo({
//     super.key,
//     required this.track,
//   });

//   final Track track;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start, // or whatever fits your UI
//       children: [
//         Text(
//           track.privateReleaseDate.toString(),
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(
//             color: Colors.grey,
//             fontSize: 10,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           track.artist ?? 'Rivers',
//         ),
//       ],
//     );
//   }
// }
