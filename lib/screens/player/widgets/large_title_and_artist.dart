import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class LargeTitleAndArtist extends StatelessWidget {
  const LargeTitleAndArtist({
    super.key,
    required this.track,
  });
  final Track track;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20,
            child: TextOrMarquee(
              text: track.displayTitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (Core.app.type == AppType.advanced) {
                pushToUserArtist(context, track.userId ?? '');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: HoverText(
                text: track.artist!,
                fontSize: 10,
                underlineOnHover: true,
                changeColorOnHover: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// void pushToUserArtist(BuildContext context, String userId) {
//   logger.i('Core.app.name == Weezify so LoadArtist with widget.userId');
//   logger.i('pushing to /user/$userId');
//   if (userId != context.read<ArtistBloc>().state.user.id) {
//     logger.i(
//         'widget.userId != state.user.id so LoadArtist with widget.userId');
//     context.read<ArtistBloc>().add(
//           LoadArtist(viewer: userBloc.state.user,userId: userId),
//         );
//     context.push('/user/$userId');
//     context.read<UserBloc>().add(
//           SetScreen('user'),
//         );
//   }
// }
