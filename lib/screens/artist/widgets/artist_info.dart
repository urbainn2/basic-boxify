import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Using this for large and small. Don't get confused because User Artist
/// and some small artists use circle avatar for [LargeArtist].
class ArtistInfo extends StatefulWidget {
  const ArtistInfo({
    super.key,
    // this.screenSize,
  });

  // final Size? screenSize;

  @override
  State<ArtistInfo> createState() => _ArtistInfoState();
}

class _ArtistInfoState extends State<ArtistInfo> {
  // TextEditingController usernameController = TextEditingController();
  // FocusNode myFocusNode = FocusNode();

  // @override
  // void dispose() {
  //   usernameController.dispose();
  //   myFocusNode.dispose();
  //   super.dispose();
  // }

  // Future<void> _displayTextInputDialog(BuildContext context) async {
  //   final state = context.read<ArtistBloc>().state;
  //   final user = state.user;
  //   final username = user.username;
  //   usernameController.text = username;
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       myFocusNode.requestFocus();
  //       return SizedBox(
  //         width: 300,
  //         child: AlertDialog(
  //           title: Text("changeUsername".translate()),
  //           elevation: 24,
  //           content: TextField(
  //             controller: usernameController,
  //             focusNode: myFocusNode,
  //           ),
  //           actions: <Widget>[
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //               onPressed: () {
  //                 setState(() {
  //                   Navigator.pop(context);
  //                 });
  //               },
  //               child: Text('cancel'.translate()),
  //             ),
  //             ElevatedButton(
  //               child: Text('saveCap'.translate()),
  //               onPressed: () {
  //                 context.read<ArtistBloc>().add(
  //                       ArtistChangeUsername(
  //                         user: user,
  //                         newUsername: usernameController.text,
  //                       ),
  //                     );
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final state = context.read<ArtistBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.status == ArtistStatus.loading) circularProgressIndicator,
        // else
        //   Stack(
        //     children: [
        //       GestureDetector(
        //         onLongPress: () {
        //           if (state.viewer.admin) {
        //             _displayTextInputDialog(context);
        //           }
        //         },
        //         child: Padding(
        //           padding: EdgeInsets.only(left: 16),
        //           child: Text(
        //             state.user.username,
        //             maxLines: 1,
        //             overflow: TextOverflow.ellipsis,
        //             style: TextStyle(
        //               fontSize: fontSize,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(height: 8),
        //     ],
        //   ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyLinkify(
            text: state.user.bio,
            textStyle: const TextStyle(fontSize: 14),
            linkStyle:
                TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ],
    );
  }
}
