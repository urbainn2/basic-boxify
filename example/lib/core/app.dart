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
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnYiOiJzdGFnaW5nIn0.sanDGWAQy-VEWGuJ0B_pFFL3E-pkMteJK7PwE3w3S2g';

  @override
  String get androidApiKey => '';

  @override
  String get iosApiKey => '';

// PLAYLIST
  String defaultPlaylistId = '40briftVDwVQmA0NAayo';

  @override
  String get preWeezerPlaylistId => 'Xih5mmsI9PVYttdiCvbE';
  @override
  String get bluePinkertonPlaylistId => 'tjGtXvfS2mnf1KCCARMy';
  @override
  String get greenPlaylistId => '1cHanICoiKFZ5kJgrkj0';
  @override
  String get makeBelievePlaylistId => '7PBHKKun1I8miewHqfuU';
  @override
  String get byThePeoplePlaylistId => 'n7Dgp6oJVc6iDvkpPZQB';
  @override
  String get redRadHurleyPlaylistId => 'YS4qmRtQzjVaQJPz85WJ';
  @override
  String get ewbaitePlaylistId => 'oDIz7u5HqWvFnOvD6P2p';
  @override
  String get whitePlaylistId => 'ifxcDmApNKjjEaj2sstu';
  @override
  String get patrickAndRiversPlaylistId => 'EHrCdpuWBfMQnCV63Jx9';
  @override
  String get weezmaPlaylistId => '8OwoXYmtyXBmiifq1Y5R';
  String get pacificDaydreamBlackPlaylistId => 'yFE6XUB8hZFk4MNvd9wE';
  @override
  String get pianoPlaylistId => 'btQRMVXFDwWxjrU6bhfA';

  // //LARGE NAV PANEL
  // double staticPanelHeight = 266; // This is just the unchanging part at the top


  @override
  String get serverUrl => 'https://rivers-staging-a57034f97ea2.herokuapp.com/';

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
  get primary => const Color(0xFF00C0C0);

  @override
  get link => primary;
}
