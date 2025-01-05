import 'dart:ui';
import 'package:flutter/material.dart';

class BlurryDialog extends StatefulWidget {
  // final String title;
  final String content;
  final VoidCallback continueCallBack;

  BlurryDialog(this.content, this.continueCallBack, {super.key});

  @override
  _BlurryDialogState createState() => _BlurryDialogState();
}

class _BlurryDialogState extends State<BlurryDialog> {
  // TextStyle textStyle = TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        // title: Text(widget.title,style: textStyle,),
        content: Text(widget.content),
        // actions: <Widget>[
        //   FlatButton(
        //     child: Text("Continue"),
        //     onPressed: () {
        //       widget.continueCallBack();
        //     },
        //   ),
        //   FlatButton(
        //     child: Text("Cancel"),
        //     onPressed: () {
        //       context.pop();
        //     },
        //   ),
        // ],
      ),
    );
  }
}
