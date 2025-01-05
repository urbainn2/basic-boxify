import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void showMySnack(
  BuildContext context, {
  Color? color,
  String message = 'no message provided.',
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: color ?? Core.appColor.primary,
      content: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
  );
}

SnackBar buildSnackbar(String message) {
  var height = 50.0;
  if (message.length > 100) {
    height = 150.0;
  } else if (message.length > 50) {
    height = 100.0;
  }
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    width: 250,
    backgroundColor: Colors.blueAccent,
    content: SizedBox(
      height: height,
      child: Center(
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    ),
  );
}

/// This function shows a snack bar to the user stating that they can purchase
/// the corresponding bundle in the Market. It handles both web and mobile.
void showTrackSnack(
  BuildContext context,
  String bundleName,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Core.appColor.primary,
      content: Text(
        'You can purchase the $bundleName bundle in the Market.',
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
        label: 'Go to Market',
        onPressed: () {
          if (kIsWeb) {
            myLaunch(
              Core.app.marketUrl,
              context.read<AuthBloc>().state.user!.uid,
            );
          } else {
            GoRouter.of(context).push(
              '/market',
            );
          }
        },
      ),
    ),
  );
}
