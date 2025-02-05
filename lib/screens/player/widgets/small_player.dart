import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SmallPlayer extends StatelessWidget {
  const SmallPlayer({
    super.key,
    this.imageUrl,
    this.imageFilename,
    required this.track,
  });

  final String? imageUrl;
  final String? imageFilename;
  final Track track;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: track.backgroundColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 5,
            offset: Offset(2, 2), // shadow direction: bottom right
          )
        ],
      ),
      height: Core.app.smallPlayerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            // Define what happens when the widget is tapped
            // Push the playerDetail screen to the navigation stack
            onTap: () => GoRouter.of(context).push('/playerDetail'),
            child: Row(children: [
              /// IMAGE
              Padding(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageOrIcon(
                    imageUrl: imageUrl,
                    filename: imageFilename,
                    height: Core.app.smallRowImageSize,
                    width: Core.app.smallRowImageSize,
                  ),
                ),
              ),

              /// TITLE AND ARTIST
              SmallPlayerTitleAndArtistWidget(
                  track: track, isWide: !track.isRateable),
            ]),
          ),
          StarRating(track: track),
          PlayButton(
              // track: track,
              ),
        ],
      ),
    );
  }
}
