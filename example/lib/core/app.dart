import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:boxify/screens/market/api/purchase_api.dart';
// import 'dart:io'
//     show Platform; // For Platform.isAndroid and Platform.isIOS for Purchase

/// App is the concrete implementation of a specific application. It inherits
/// from BaseApp, augmenting the foundational functionalities with application-
/// specific behaviors and configurations. App considers the post-initialization
/// stage, and it customizes app events, version information, and service
/// integration such as Firebase Analytics and Crashlytics to fulfill the
/// requirements for this specific app instance.
///
/// Example usage of App:
/// void main() {
///   runApp(App()); // Launches the app with its configured behaviors
/// }
class App extends BaseApp {
  @override
  String get name => "Examplify";

  @override
  AppType get type => AppType.advanced;

  @override
  String get serverToken =>
      '';

  @override
  String get androidApiKey => '';

  @override
  String get iosApiKey => '';


// PLAYLIST
  String defaultPlaylistId = '40briftVDwVQmA0NAayo';
  String ethan = 'g39cCaKrmQaeIUGWFsY5dJ1jXp33';
  String jake = '4293';
  String jaketest = 'edhkKs3fM5PEftB4ZJQmj8Ore0w1';
  String charliebrand = '3XwuPaGEpVhYI9PWvaBsMIK1fFu1';
  String kingTomId = '1922';

  //LARGE NAV PANEL
  // double playerHeight = 110;
  double staticPanelHeight = 266; // This is just the unchanging part at the top

  @override
  postInit() async {
    await super.postInit();
    logger.i('weezify postInit');
    await initializeUserIds();

    if (kIsWeb) {
    } else {
      await PurchaseApi.init();
    }
  }
}

class AppColor extends BaseColor {
  @override
  get primary => Colors.blue;

  @override
  get link => primary;
}
