import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final String? s;

  const CenteredText(this.s, {super.key, this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          s ?? text ?? 'CenteredText',
          textAlign: TextAlign.center,
          maxLines: 7,
          style: style,
        ),
      ),
    );
  }
}
