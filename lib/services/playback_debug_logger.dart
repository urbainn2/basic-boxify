import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// Import IO-specific code only for non-web platforms
import 'playback_debug_logger_io.dart' if (dart.library.html) 'playback_debug_logger_web.dart' as platform;

class PlaybackDebugLogger {
  static final Logger _logger = Logger(
    printer: PrefixPrinter(
      PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 100,
        colors: false,
        printEmojis: false,
        printTime: true,
      ),
    ),
    output: ConsoleOutput(),
  );

  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      await platform.initLogger();
      _initialized = true;
    }
  }

  static void debug(String message) {
    _logger.d('[Playback Debug] $message');
    platform.writeToLog('[DEBUG] [Playback Debug] $message');
  }

  static void error(String message, [dynamic error]) {
    final errorMsg = error != null ? '$message: $error' : message;
    _logger.e('[Playback Error] $errorMsg');
    platform.writeToLog('[ERROR] [Playback Error] $errorMsg');
  }
}