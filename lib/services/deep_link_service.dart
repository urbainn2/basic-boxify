import 'package:app_links/app_links.dart';
import 'package:boxify/app_core.dart';

import 'dart:async';

/// A singleton service responsible for handling iOS deep links throughout the application.
/// Android will directly go to the route you want, so there's no need to push manually.
class IOSDeepLinkService {
  static final IOSDeepLinkService _instance = IOSDeepLinkService._internal();
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  IOSDeepLinkService._internal() {
    if (Core.isIOS) {
      _initDeepLinkListener();
    }
  }

  static IOSDeepLinkService get instance => _instance;

  void _initDeepLinkListener() async {
    _appLinks = AppLinks();

    // Retrieve the initial link when the app starts.
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      print('Initial uri: $initialUri');
      if (initialUri != null) {
        router.go(initialUri.path);
      }
    } catch (err) {
      print('Error retrieving initial app link: $err');
    }

    // Listen to incoming URI links.
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        print('Received uri: $uri');
        router.go(uri.path);
      },
      onError: (err) {
        print('Error receiving app link: $err');
      },
    );
  }

  /// Call this method when the service is no longer needed to cancel the subscription.
  void dispose() {
    _linkSubscription?.cancel();
  }
}



// /// A singleton service responsible for handling iOS deep links throughout the application.
// /// Android will directly go to the route you want, so don't neet to push manually.
// ///
// /// It subscribes to deep link URIs being opened in the app and dispatches them to the [NavController]
// /// to navigate to corresponding screens or perform associated actions based on the URI's path and parameters.
// class IOSDeepLinkService {
//   static final IOSDeepLinkService _instance = IOSDeepLinkService._internal();

//   IOSDeepLinkService._internal() {
//     if (Core.isIOS) {
//       _initDeepLinkListener();
//     }
//   }

//   static IOSDeepLinkService get instance => _instance;

//   void _initDeepLinkListener() {
//     // You have to set your gorouter first.

//     // This will get full Uri when opening the app by deep link
//     getInitialUri().then((Uri? uri) {
//       print('Initial uri: $uri');
//       if (uri != null) {
//         router.go(uri.path);
//       }
//     }, onError: (err) {
//       print('Error retrieving initial link: $err');
//     });

//     // This is for app staying in the background.
//     uriLinkStream.listen((Uri? uri) {
//       print('Received uri: $uri');
//       if (uri != null) {
//         router.go(uri.path);
//       }
//     }, onError: (err) {
//       print('Error receiving URI: $err');
//     });
//   }
// }


