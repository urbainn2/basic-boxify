import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:boxify/app_core.dart';

class ShareHelper {
  static Future<void> shareContent({
    required BuildContext context,
    required String url,
    required String title,
  }) async {
    if (kIsWeb) {
      // Logic for web
      FlutterClipboard.copy(url);
      showMySnack(
        context,
        message: 'Link copied to clipboard.',
      );
    } else {
      final RenderBox? box = context.findRenderObject() as RenderBox?;

      if (box != null) {
        await Share.share(
          url,
          subject: 'Link to $title',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        );
      } else {
        // Handle the case when box is null, e.g., log an error
        logger.e('RenderBox was null when trying to share content.');
      }
    }
  }

  // You can add other utility functions here...
}
