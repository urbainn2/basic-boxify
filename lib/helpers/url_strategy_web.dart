import 'package:boxify/app_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void setPathUrlStrategy() {
  logger.d('in web file so something happens');
  setUrlStrategy(PathUrlStrategy());
}
