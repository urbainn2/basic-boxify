//
import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackArrow extends StatelessWidget {
  const BackArrow({
    required this.userBloc,
    required this.previousScreen,
  });
  final UserBloc userBloc;
  final String previousScreen;

  @override
  Widget build(BuildContext context) {
    // logger.i('back arrow build ');
    var gorouter = GoRouter.of(context);
    // logger.i(gorouter);

    bool canPop = false;
    try {
      canPop = gorouter.canPop();
    } catch (e) {
      logger.e(e);
    }

    return GestureDetector(
      child: Icon(
        Icons.arrow_back,
        color: canPop
            ? Colors.black
            : Colors.grey, // Change color based on whether you can pop
      ),
      onTap: canPop
          ? () {
              GoRouter.of(context).pop();
            }
          : null, // Make non-interactive when you can't pop
    );
  }
}
// class BackArrow extends StatelessWidget {
//   const BackArrow({
//     required this.userBloc,1
//     required this.previousScreen,
//
//   });
//   final UserBloc userBloc;
//   final String previousScreen;
//

//   @override
//   Widget build(BuildContext context) {
//     if (GoRouter.of(context).canPop()) {
//       return GestureDetector(
//         child: const Icon(Icons.arrow_back),
//         onTap: () {
//           GoRouter.of(context).pop();
//           navBloc.add(BackwardEvent());
//         },
//       );
//     } else {
//       return Container();
//     }
//   }
// }
