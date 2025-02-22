import 'package:boxify/app_core.dart';
import 'package:boxify/screens/playlist/widgets/track_mouse_row_skeleton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Sadly, the headers scroll
class LargeTrackSearchResults extends StatelessWidget {
  const LargeTrackSearchResults({
    super.key,
    required this.screenType,
    required bool isLargeScreen,
    required this.itemCount,
    required this.showLoadingState,
  }) : _isLargeScreen = isLargeScreen;

  final double screenType;
  final bool _isLargeScreen;
  final int itemCount;
  final bool showLoadingState;

  @override
  Widget build(BuildContext context) {
    // If tracks are loading, show a loading state (skeleton)

    return ListView(
      children: [
        SizedBox(height: Core.app.appBarHeight * screenType),
        _isLargeScreen
            ? LargePlaylistQueueHeaders(showYear: false)
            : Container(),
        showLoadingState
            ? SizedBox(
                // Loading state with 3 skeleton rows
                height: Core.app.largeScreenRowHeight * 3,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, i) {
                    return TrackMouseRowSkeleton();
                  },
                ))
            : SizedBox(
                // Actual search results
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
