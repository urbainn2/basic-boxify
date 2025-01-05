import 'package:boxify/app_core.dart';

import 'package:flutter/material.dart';

class LeftSideWidgets extends StatelessWidget {
  const LeftSideWidgets({
    super.key,
    required this.userLibraryWidget,
  });

  final Widget userLibraryWidget;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Core.app.libraryPanelWidth,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: <Widget>[
            // Home, Search, Market
            HomeSearchMarketWidget(),
            YourLibraryTitle(),

            // Your library playlists
            userLibraryWidget,
          ],
        ),
      ),
    );
  }
}
