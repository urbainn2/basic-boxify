import 'package:boxify/app_core.dart';
import 'package:boxify/helpers/color_helper.dart';
import 'package:boxify/ui/image_with_color_extraction.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SmallPlayer extends StatefulWidget {
  const SmallPlayer({
    Key? key,
    this.imageUrl,
    this.imageFilename,
    required this.track,
  }) : super(key: key);

  final String? imageUrl;
  final String? imageFilename;
  final Track track;

  @override
  State<SmallPlayer> createState() => _SmallPlayerState();
}

class _SmallPlayerState extends State<SmallPlayer> {
  // Background color, extracted from the track's cover image
  // use theme default color if not available
  Color trackBackgroundColor =
      ColorHelper.dimColor(Core.appColor.primary, dimFactor: 0.25);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: trackBackgroundColor,
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
            onTap: () => GoRouter.of(context).push('/playerDetail'),
            child: Row(children: [
              /// IMAGE
              Padding(
                padding: const EdgeInsets.all(5),
                child: ImageWithColorExtraction(
                  imageUrl: widget.imageUrl,
                  filename: widget.imageFilename,
                  height: Core.app.smallRowImageSize,
                  width: Core.app.smallRowImageSize,
                  roundedCorners: 8,
                  onColorExtracted: (color) {
                    setState(() {
                      // Dim the color a bit to make the text more readable
                      trackBackgroundColor = ColorHelper.dimColor(
                          // Ensure the color isn't too dark to avoid interfering with the UI
                          ColorHelper.ensureWithinRange(color,
                              minLightness: 0.6, maxLightness: 1),
                          dimFactor: 0.25);
                    });
                  },
                ),
              ),

              /// TITLE AND ARTIST
              SmallPlayerTitleAndArtistWidget(
                  track: widget.track, isWide: !widget.track.isRateable),
            ]),
          ),
          StarRating(track: widget.track),
          PlayButton(
              // track: track,
              ),
        ],
      ),
    );
  }
}
