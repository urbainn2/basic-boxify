import 'dart:io';
import 'package:path_provider/path_provider.dart';

File? _logFile;

Future<void> initLogger() async {
  final directory = await getApplicationDocumentsDirectory();
  _logFile = File('${directory.path}/playback_debug.log');
  if (!await _logFile!.exists()) {
    await _logFile!.create(recursive: true);
  }
}

void writeToLog(String message) async {
  if (_logFile != null) {
    try {
      await _logFile!.writeAsString('${DateTime.now()} - $message\n', 
        mode: FileMode.append);
    } catch (e) {
      print('Failed to write to log file: $e');
    }
  }
}