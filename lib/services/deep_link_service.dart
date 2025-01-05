import 'package:uni_links/uni_links.dart';
import 'package:boxify/app_core.dart';

/// A singleton service responsible for handling iOS deep links throughout the application.
/// Android will directly go to the route you want, so don't neet to push manually.
///
/// It subscribes to deep link URIs being opened in the app and dispatches them to the [NavController]
/// to navigate to corresponding screens or perform associated actions based on the URI's path and parameters.
class iOSDeepLinkService {
  static final iOSDeepLinkService _instance = iOSDeepLinkService._internal();

  iOSDeepLinkService._internal() {
    if (Core.isIOS) {
      _initDeepLinkListener();
    }
  }

  static iOSDeepLinkService get instance => _instance;

  void _initDeepLinkListener() {
    // You have to set your gorouter first.

    // This will get full Uri when opening the app by deep link
    getInitialUri().then((Uri? uri) {
      print('Initial uri: $uri');
      if (uri != null) {
        router.go(uri.path);
      }
    }, onError: (err) {
      print('Error retrieving initial link: $err');
    });

    // This is for app staying in the background.
    uriLinkStream.listen((Uri? uri) {
      print('Received uri: $uri');
      if (uri != null) {
        router.go(uri.path);
      }
    }, onError: (err) {
      print('Error receiving URI: $err');
    });
  }
}
