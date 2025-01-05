import 'dart:convert';

import 'package:boxify/app_core.dart';
import 'package:flutter/services.dart' show rootBundle;

Map<String, String> userIds = {};

Future<void> initializeUserIds() async {
  logger.i('iinitializeUserIds');
  String jsonString =
      await rootBundle.loadString('assets/data/weezify_user_ids.json');
  Map<String, dynamic> jsonData =
      jsonDecode(jsonString) as Map<String, dynamic>;
  jsonData.forEach((key, value) {
    userIds[key] = value as String;
  });
}
