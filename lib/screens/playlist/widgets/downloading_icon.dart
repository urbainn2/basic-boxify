import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class DownloadingIcon extends StatelessWidget {
  const DownloadingIcon({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: SizedBox(
        width: 12.0,
        height: 12.0,
        child: CircularProgressIndicator(
          value: progress, // Bind the download progress value
          strokeWidth: 2.0,
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Core.appColor.primary),
        ),
      ),
    );
  }
}
