import 'dart:math';

// import 'package:app_core/app_core.dart';  //

/// returns whichever is greater: 1 or the number of items divided by 4
double getSmallSectionHeight(int items) {
  const rowHeight = 103.0;
  // basically, 4 badges per row
  return max(rowHeight, rowHeight * (items / 4).floor().toDouble());
}

double getVerySmallSectionHeight(int items) {
  const rowHeight = 75.0;
  // basically, 6 playlists per row
  return max(rowHeight, rowHeight * (items / 6).ceil().toDouble());
}

/// returns whichever is greater: 1 or the number of items divided by 4
double getLargeSectionHeight(int items, int crossAxisCount) {
  const rowHeight = 350.0;

  // dynamically calculates how many items fit in a row based on screen size
  int rows = (items / crossAxisCount).ceil();
  
  return max(rowHeight, rowHeight * rows.toDouble());
}
