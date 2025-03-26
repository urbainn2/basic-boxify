import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:basic_examplify/config/firebase_options.dart';
import 'package:basic_examplify/core/app.dart';

void main() async {
  info('Examplify main');

  ///  The Flutter framework uses bindings to get instances of different services such
  /// as the `WidgetsBinding`, `ServicesBinding`, or `SchedulerBinding`.
  /// You should add the `WidgetsFlutterBinding.ensureInitialized();`
  /// line of code before calling any method which has potential platform interaction i.e.,
  /// in this case, it is `DeviceInfoPlugin.androidInfo()`. You generally call it before `runApp()`.
  WidgetsFlutterBinding.ensureInitialized();

  await Core.init(
      appName: 'Basic Examplify',
      firebaseOptions: firebaseOptions,
      baseApp: App(),
      baseColor: AppColor());

  runApp(
    createExamplifyApp(),
  );
}

AppBase createExamplifyApp({bool showLoaders = true}) {
  return AppBase(
    builder: (context, setState) {
      return AppRoot();
    },
    // themeData: BoxifyTheme.buildTheme(),
  );
}
