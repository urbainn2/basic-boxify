import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

SizedBox noResultsFound(String query) {
  return SizedBox(
    height: 200,
    child: Column(
      children: [
        CenteredText('No results found for "$query"'),
        CenteredText(
          'pleaseMake'.translate(),
        ),
      ],
    ),
  );
}
