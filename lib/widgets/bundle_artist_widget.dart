import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

typedef OnTapCallback = void Function();

GestureDetector bundleArtistWidget(
  BuildContext context,
  Track track, {
  double fontSize = 14,
  bool bold = false,
  bool underline = false,
  required OnTapCallback onTap,
}) {
  final color = Theme.of(context).textTheme.bodyLarge?.color;

  final style = TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: bold ? FontWeight.bold : null,
    decoration: underline ? TextDecoration.underline : null,
  );
  var text = '';
  if (track.artist != null) text += track.artist!;

  return GestureDetector(
    onTap: onTap,
    child: Text(text, style: style),
  );
}

// import 'package:flutter/material.dart';

// /// ACTUALLY JUST FOR LARGE SCREEN?
// /// SEE ALSO SMALL CONTROL BUTTONS.DART
// dynamic bundleArtistWidget(BuildContext context, Track track, double fontSize,
//     Color? color, bool bold, bool underline,) {
//   final style = TextStyle(
//     fontSize: fontSize,
//     color: color,
//     fontWeight: bold ? FontWeight.bold : null,
//     decoration: underline ? TextDecoration.underline : null,
//   );
//   var text = '';
//   if (track.artist != null) text += track.artist!;

//   return Text(text, style: style);
// }
