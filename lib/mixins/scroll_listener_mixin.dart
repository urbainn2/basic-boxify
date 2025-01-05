import 'package:flutter/material.dart';

mixin ScrollListenerMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();
  final double expandedHeight = 250.0;
  double titleOpacity = 0.0;
  double appBarBackgroundOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final double titleFadeStart = expandedHeight - kToolbarHeight;

    if (scrollController.hasClients) {
      // logger.d('scrollController.offset: ${scrollController.offset}');
      if (scrollController.offset == 0) {
        setState(() {
          titleOpacity = 0.0;
          appBarBackgroundOpacity = 0.0;
        });
      } else {
        double offsetFactor =
            (scrollController.offset - titleFadeStart) / kToolbarHeight;
        double newTitleOpacity = offsetFactor.clamp(0.0, 1.0);
        double newAppBarBackgroundOpacity =
            (scrollController.offset / (expandedHeight - kToolbarHeight))
                .clamp(0.0, 1.0);

        // Only call setState if the values are different
        if (titleOpacity != newTitleOpacity ||
            appBarBackgroundOpacity != newAppBarBackgroundOpacity) {
          setState(() {
            titleOpacity = newTitleOpacity;
            appBarBackgroundOpacity = newAppBarBackgroundOpacity;
            // logger.d(
            //     'titleOpacity: $titleOpacity | appBarBackgroundOpacity: $appBarBackgroundOpacity');
          });
        }
      }
    }
  }
}
