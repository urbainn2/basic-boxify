// import 'package:app_core/app_core.dart';  //
import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class UrlLaunchTile extends StatelessWidget {
  const UrlLaunchTile({
    super.key,
    required this.size,
    required this.url,
    required this.userId,
    required this.text,
  });
  final double size;
  final String url;
  final String userId;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(fontSize: size),
      ),
      onTap: () {
        myLaunch(Core.app.weezifyPrivacyPolicyUrl, userId);
      },
    );
  }
}
