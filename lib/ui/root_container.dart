import 'dart:async';

import 'package:boxify/app_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart' show Platform;

class AppBase extends StatefulWidget {
  final List<NavigatorObserver>? observers;
  final Function(BuildContext, Function) builder;
  final ThemeData? themeData;

  const AppBase(
      {Key? key, this.observers, this.themeData, required this.builder})
      : super(key: key);

  @override
  State<AppBase> createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> with WidgetsBindingObserver {
  AppLifecycleState? _state;
  var _started = false;

  @override
  void initState() {
    _state = WidgetsBinding.instance.lifecycleState;
    info('lifecycleState: $_state');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!Core.isTablet) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_state != state && !_started) {
      logger.i('AppBase - didChangeAppLifecycleState $state');
      setState(() {
        _state = state;
      });
    }
    // // "Input dispatching timed out" ANR prevention for Android 11+
    // if (Core.isNewAndroid && _started && _state == AppLifecycleState.detached) {
    //   5.secDelay(() => app.checkDetachedState(startUp: false));
    // }
  }

  /// This method builds the widget tree for the current context.
  /// It is an overridden method from the parent class.
  ///
  /// Returns [Widget] - the widget tree that renders the UI based on the
  /// application state and app configuration object
  ///
  /// It checks the `_state` variable which represents the current state of the
  /// application in its life cycle. The possible values of this variable are
  /// defined in AppLifecycleState enum (inactive, paused, resumed, detached).
  ///
  /// When the `_state` is `AppLifecycleState.detached`, it means the application
  /// is no longer connected to its Flutter engine, which can happen when the
  /// app is in the background, being dismissed by the user, or having its
  /// resources reclaimed by the system. In this case, the method builds
  /// a MaterialApp with a white background to reduce resource consumption and
  /// handle the transition gracefully.
  ///
  /// Otherwise, the method builds the UI using the provided app configuration
  /// object and the EasyLocalization package to handle localization in the app.
  @override
  Widget build(BuildContext context) {
    // If the app state is not detached, perform the following steps
    if (_state != AppLifecycleState.detached) {
      // If the app hasn't started, set _started to true
      if (!_started) _started = true;

      return EasyLocalization(
        supportedLocales: Core.app.supportedLocales,
        path: 'assets/translations', // Path to weezify translations
        fallbackLocale: Locale('en'),
        useFallbackTranslations: true,
        // useOnlyLangCode: true,
        assetLoader: PackageAssetLoader(
          packageName: 'boxify',
        ), // Use your custom asset loader
        // startLocale: Locale('ja'), // Force start locale for testing purposes
        child: MyApp(),
      );
    } else {
      // If the app state is detached, display a MaterialApp with a plain white background
      return MaterialApp(home: Scaffold(body: Container(color: Colors.white)));
    }
  }
}

class AppRoot extends StatelessWidget {
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    info(
        'locale: ${context.locale} | device: ${Core.deviceLocale} | ${Platform.localeName}');
    return MaterialApp(
      navigatorKey: navKey,
      // onGenerateTitle: (context) => 'app_name'.localized().capitalized(),
      debugShowCheckedModeBanner: false,
      // theme: themeData,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: app.supportedLocales,
      // locale: app.language.locale,
      // navigatorObservers: observers ?? [],
      // home: root,
    );
  }
}
