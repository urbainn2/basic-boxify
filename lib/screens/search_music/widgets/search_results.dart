import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Sadly, the headers scroll
class LargeTrackSearchResults extends StatelessWidget {
  const LargeTrackSearchResults({
    super.key,
    required this.screenType,
    required bool isLargeScreen,
    required this.itemCount,
  }) : _isLargeScreen = isLargeScreen;

  final double screenType;
  final bool _isLargeScreen;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: Core.app.appBarHeight * screenType),
        _isLargeScreen
            ? LargePlaylistQueueHeaders(showYear: false)
            : Container(),

        /// Expanded is causing a space???
        SizedBox(
          height: Core.app.largeScreenRowHeight * itemCount,
          child: TrackMouseRowHelper().getTrackMouseRows(
            context,
            innerItemsAreScrollable: false,
            canDrag:
                kIsWeb, // You actually can't drag search results on a longPress, just on a click
            canBeADragTarget: false,
            replaceSelectedTracksWithSearchResultsOnTap: true,
            trackRowType: TrackRowType.searchResultsForSearchScreen,
          ),
        ),
      ],
    );
  }
}
