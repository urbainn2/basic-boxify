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

  @override
  List<String> get defaultPlaylistIds => [];


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

  // SERVER URLS
  // String baseUrlLocal = 'localhost:8686/';

  @override
  String get serverUrl => 'https://rivers-staging-a57034f97ea2.herokuapp.com/';

  // String get bundlesAPIUrl => '${serverUrl}bundles/api';
  // String get tracksAPIUrl => '${serverUrl}tracks/api';
  // String get usersAPIUrl => '${serverUrl}weezify_users/api';
  // String get lastUpdatedTracksUrl => '$tracksAPIUrl/last_updated';
  // String get lastUpdatedBundlesUrl => '$bundlesAPIUrl/last_updated';
  // String get lastUpdatedUsersUrl => '$usersAPIUrl/last_updated';
  // String get emailBundleUrl => '${serverUrl}email_bundle/api';
  // String get libraryUrl => '${serverUrl}wiki';
  // String get marketUrlTest => 'http://127.0.0.1:5000//demos';
  // String get marketUrl => '${serverUrl}demos';
  // String get weezifyPrivacyPolicyUrl =>
  //     '$libraryUrl/Weezify%20Privacy%20Policy';

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
