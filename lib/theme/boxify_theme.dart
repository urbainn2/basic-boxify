import 'package:flutter/material.dart';
import 'package:boxify/app_core.dart';

class BoxifyTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      dialogTheme: DialogTheme(
        elevation: 10,
        shape: Core.appUI.shapeBorder,
        backgroundColor: Core.appColor.background,
        surfaceTintColor: Core.appColor.background,
        contentTextStyle: Core.appStyle.small,
      ),
    );
  }
}