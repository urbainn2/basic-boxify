import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class MyLinkify extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;

  const MyLinkify({
    super.key,
    required this.text,
    this.textStyle,
    this.linkStyle,
  });

  TextStyle _getDefaultTextStyle(BuildContext context) {
    // You can define the default text style here, or get it from the context/theme
    return textStyle ??
        Core.appStyle.title.copyWith(
            color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal);
  }

  TextStyle _getDefaultLinkStyle(BuildContext context) {
    // You can define the default link style here, or get it from the context/theme
    return linkStyle ??
        TextStyle(color: Colors.blue, decoration: TextDecoration.underline);
  }

  @override
  Widget build(BuildContext context) {
    return Linkify(
      text: text,
      style: _getDefaultTextStyle(context),
      linkStyle: _getDefaultLinkStyle(context),
      onOpen: (link) async {
        print(link.url);
        try {
          final Uri url = Uri.parse(link.url);
          await launchUrl(url);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Exception when opening the link: $e')),
          );
        }
      },
    );
  }
}
