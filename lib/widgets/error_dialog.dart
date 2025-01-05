import 'package:boxify/app_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String? content;
  final void Function()? onPressed;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    this.onPressed,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return AlertDialog(
        title: Text(title),
        content: Text(content!),
        actions: [
          TextButton(
            onPressed: onPressed ?? () => _onPressed(context),
            child: Text('oK'.translate()),
          ),
        ],
      );
    } else {
      return defaultTargetPlatform == TargetPlatform.iOS
          ? _showIOSDialog(context, onPressed)
          : _showAndroidDialog(context, onPressed);
    }
  }

  void _onPressed(BuildContext context) {
    logger.e('pressed ok on error dialog');

    // close the dialog. The first pop does not close the dialog for some reason
    Navigator.of(context).pop();
    
    try {
      Navigator.of(context).pop();
    } catch (e) {
      logger.e('error on pop: $e');
    }

    GoRouter.of(context).go('/');
  }

  CupertinoAlertDialog _showIOSDialog(
      BuildContext context, Function()? onPressed) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content!),
      actions: [
        CupertinoDialogAction(
          onPressed: onPressed ?? () => _onPressed(context),
          child: Text('ok'.translate()),
        ),
      ],
    );
  }

  AlertDialog _showAndroidDialog(BuildContext context, Function()? onPressed) {
    return AlertDialog(
      title: Text(title),
      content: Text(content!),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => _onPressed(context),
          child: Text('ok'.translate()),
        ),
      ],
    );
  }
}
