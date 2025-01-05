import 'package:boxify/app_core.dart';
import 'package:charcode/charcode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Used in [TrackMouseRow], [TrackTouchRow]
class BundleArtistTextWidget extends StatelessWidget {
  final Track track;
  final double? fontSize;
  final bool isInteractive;
  final bool parentIsMouseClicked;

  const BundleArtistTextWidget({
    Key? key,
    required this.track,
    this.fontSize,
    this.isInteractive = true,
    this.parentIsMouseClicked = false,
  }) : super(key: key);

  String _getArtistAlbumBundle() {
    var text = '';
    if (track.artist != null) {
      text += track.artist!;
    } else if (track.album != null) {
      text += track.album!;
    }

    if (track.bundleName != null && track.bundleName!.isNotEmpty) {
      if (text.isNotEmpty) {
        text += ' ${String.fromCharCode(0x2022)} '; // corrected bull symbol
      }
      text += track.bundleName!;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    String artistAlbumBundle = _getArtistAlbumBundle();
    return GestureDetector(
      onLongPress: () {
        if (!isInteractive) return;
        if (Core.app.type == AppType.advanced) {
          pushToUserArtist(context, track.userId ?? '');
        }
      },
      onTap: () {
        if (!isInteractive) return;
        if (Core.app.type == AppType.advanced) {
          pushToUserArtist(context, track.userId ?? '');
        }
      },
      child: Row(
        children: [
          if (track.explicit != null && track.explicit!)
            Icon(
              Icons.explicit,
              size: 13,
              color: Colors.grey[600],
            ),
          if (track.explicit != null && track.explicit!)
            const SizedBox(
              width: 3,
            ),
          Expanded(
            // Added Expanded here
            child: kIsWeb
                ? HoverText(
                    text: artistAlbumBundle,
                    fontSize: fontSize!,
                    underlineOnHover: true,
                    changeColorOnHover: true, // true for web and desktop
                    parentIsMouseClicked: parentIsMouseClicked,
                  )
                : Text(
                    artistAlbumBundle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
          ),
        ],
      ),
    );
  }
}
