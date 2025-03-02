import 'package:boxify/app_core.dart';
import 'package:boxify/helpers/color_helper.dart';
import 'package:boxify/ui/image_with_color_extraction.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallPlayer extends StatefulWidget {
  const SmallPlayer(
      {Key? key,
      this.imageUrl,
      this.imageFilename,
      required this.track,
      required this.backgroundColor})
      : super(key: key);

  final String? imageUrl;
  final String? imageFilename;
  final Track track;
  final HSLColor backgroundColor;

  @override
  State<SmallPlayer> createState() => _SmallPlayerState();
}

class _SmallPlayerState extends State<SmallPlayer> {
  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // Dim the color a bit to make the text more readable
        color: ColorHelper.dimColorHsl(
                // Ensure color isn't too dark to avoid interfering with the UI
                ColorHelper.ensureWithinRangeHsl(
                  widget.backgroundColor,
                  minLightness: 0.5,
                  maxLightness: 0.7,
                ),
                dimFactor: 0.25)
            .toColor(),
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
                      playerBloc.add(UpdateTrackBackgroundColor(
                          backgroundColor: HSLColor.fromColor(color)));
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
