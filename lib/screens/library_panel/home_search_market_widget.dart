import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

/// This is the top left of the large screen. It contains the home and search
/// tiles.
class HomeSearchMarketWidget extends StatelessWidget {
  const HomeSearchMarketWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        HomeTile(),
        SearchTile(),
        Core.app.type == AppType.advanced ? MarketTile() : Container(),
        SizedBox(height: 8),
      ],
    );
  }
}
