import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SurveyButtonWidget extends StatelessWidget {
  final String _url = 'https://rate-my-weez.web.app/#/';

  // This method is used to launch the URL.
  // If the URL can't be launched, it will throw an error.
  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'setlistSurvey'.translate(),
        style: Core.appStyle.bold,
      ),
      subtitle: Text(
        'helpMeCraft'.translate(),
      ),
      trailing: IconButton(
        icon: Icon(Icons.rate_review_outlined),
        onPressed: _launchURL,
      ),
    );
  }
}
