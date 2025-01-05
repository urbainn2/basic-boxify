import 'package:boxify/app_core.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class SmallLibraryScreen extends StatelessWidget {
  final Function smallLibraryBodyBuilder;

  const SmallLibraryScreen({
    required this.smallLibraryBodyBuilder,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Core.appColor.widgetBackgroundColor,
      child: smallLibraryBodyBuilder(),
    );
  }
}
