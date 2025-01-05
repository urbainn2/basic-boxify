import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class DraggedFeedback extends StatelessWidget {
  const DraggedFeedback({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .65,
      child: Container(
        color: Colors.grey[900],
        height: Core.app.smallRowImageSize,
        width: track.title!.length * 11,
        child: Row(
          children: [
            const Icon(Icons.add),
            Text(
              track.title!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
