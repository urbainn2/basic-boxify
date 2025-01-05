import 'package:boxify/helpers/utils.dart';
import 'package:url_launcher/url_launcher.dart';

myLaunch(String url, String userId) async {
  logger.i('myLaunch $userId');

  // THE HEADERS WORK ON ANDROID BUT WHEN this request
  // is sent from web OR IOS, there is no userId attached.
  launch(
    url,
    webOnlyWindowName: '_self',
    forceWebView: true,
    enableJavaScript: true,
    headers: <String, String>{'userId': userId},
  );
}

void launchURL(String url) {
  try {
    launch(
      url,
      webOnlyWindowName: '_self',
      forceWebView: true,
      enableJavaScript: true,
    );
  } catch (e) {
    throw 'Could not launch $url $e';
  }
}
