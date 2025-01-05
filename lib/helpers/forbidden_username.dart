// import 'package:flutter/material.dart';
import 'package:boxify/app_core.dart';
import 'package:profanity_filter/profanity_filter.dart';

import 'package:validators/validators.dart';

final profanity = ProfanityFilter();

String forbiddenUsername(String username) {
  // logger.i(username + 'in username');

  if ((profanity.hasProfanity(cleaned(username))) || (username.contains('!'))) {
    return 'has Profanity';
  } else if (username.length < 2) {
    // logger.i("{username} too short ");
    return 'username.length < 2';
  } else {
    final blockedString = containsBlockedString(username.toLowerCase());
    return blockedString;
  }
}

String containsBlockedString(String username) {
  // var blockedInUserNames;
  for (String x in blockedInUsernames) {
    // logger.i(x);
    if (username.contains(x)) {
      logger.i('blocked for $x');
      return x;
    }
  }
  return 'NOT_FORBIDDEN';
}

String cleaned(String message) {
  message = message.replaceAll('.', '');
  message = message.replaceAll("'s", '');
  message = message.replaceAll('"', '');
  message = message.replaceAll('"', '');

  return message.toLowerCase();
}

int getCapCount(String message) {
  var capCount = 0;
  final chars = message.split('');
  for (final c in chars) {
    if (isUppercase(c)) {
      capCount += 1;
    }
  }
  return capCount;
}
