import 'package:auto_size_text/auto_size_text.dart';
import 'package:boxify/marquee.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Note: does not work in debug mode
///
/// This widget will display a text or a marquee if the text is too long.
/// The marquee will scroll the text horizontally.
/// Used in [LargeImageTitleRating] and [SmallPlayerTitleAndArtistWidget]
/// [BundleCardForMarketScreen]
class TextOrMarquee extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const TextOrMarquee({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: AutoSizeText(
        text,
        maxLines: 1,
        style: style,
        overflowReplacement: kReleaseMode
            ? Marquee(
                text: text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                blankSpace: 40,
              )
            : Text(
                text,
                style: style,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}
