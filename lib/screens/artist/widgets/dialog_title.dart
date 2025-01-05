import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  const DialogTitle({
    super.key,
    required this.itemName,
    required this.username,
  });

  final String itemName;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Add/Remove $itemName for  ($username)'),
        ),
      ],
    );
  }
}
