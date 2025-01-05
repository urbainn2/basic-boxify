import 'package:boxify/core.dart';
import 'package:flutter/material.dart';

final beveledRectangleBorder = BeveledRectangleBorder(
  side: BorderSide(
    color: Core.appColor.primary,
    width: .3,
  ),
);

class FixedWidthIconWrapper extends StatelessWidget {
  const FixedWidthIconWrapper(
      {super.key, required this.child, this.width = 30.0});

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: width,
        child: Align(alignment: Alignment.centerRight, child: child),
      ),
    );
  }
}

const musicNoteIcon = Icon(
  Icons.music_note,
  color: Colors.grey,
  size: 120,
);

const sizedBox8 = SizedBox(height: 8);
const sizedBox12 = SizedBox(height: 12);
const sizedBox16 = SizedBox(height: 16);
const sizedBox20 = SizedBox(height: 20);
const sizedBox28 = SizedBox(height: 28);
const sizedBox36 = SizedBox(height: 36);
const sizedBox40 = SizedBox(height: 40);
const sizedBox50 = SizedBox(height: 50);

// Padding
const edgeInsets8 = EdgeInsets.all(8);
const edgeInsets24 = EdgeInsets.all(24);

// Dividers
final divider5 = Divider(
  thickness: 5,
  color: Core.appColor.primary,
);

const divider2 = Divider(
  height: 20,
  thickness: 2,
  indent: 20,
  endIndent: 20,
);

const divider1 = Divider(
  height: 20,
  thickness: 1,
  indent: 20,
  endIndent: 20,
);

BoxDecoration boxDecorationBlack = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  color: Colors.black12,
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(1, 1), //(x,y)
      blurRadius: 6,
    )
  ],
);

// Center circularProgressIndicator = const Center(
//   child: SizedBox(
//     height: Core.app.smallRowImageSize,
//     child: CircularProgressIndicator(),
//   ),
// );
LinearProgressIndicator linearProgress = const LinearProgressIndicator();
SizedBox sizedBox = const SizedBox.shrink();

// Styles
const TextStyle black10 = TextStyle(fontSize: 10, color: Colors.black);
const TextStyle grey10 = TextStyle(fontSize: 10, color: Colors.grey);
const TextStyle grey14 = TextStyle(fontSize: 14, color: Colors.grey);
const TextStyle boldWhite12 =
    TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
const TextStyle boldWhite14 =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
const TextStyle boldWhite18 =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle boldWhite22 =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

const TextStyle white10 = TextStyle(fontSize: 10, color: Colors.white);
ButtonStyle roundedButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(),
    ),
  ),
);
ButtonStyle roundedButtonStyleBlack = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Colors.grey),
    ),
  ),
);

ButtonStyle roundedButtonStyleRed = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Colors.grey),
    ),
  ),
);

MaterialStateProperty<OutlinedBorder?>? buttonShapeCircleWhite =
    MaterialStateProperty.all<RoundedRectangleBorder>(
  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
    side: const BorderSide(color: Colors.white),
  ),
);
