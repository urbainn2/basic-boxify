// ignore_for_file: prefer_int_literals

import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

import 'package:boxify/models/user_model.dart';

class ArtistButton extends StatelessWidget {
  const ArtistButton({
    // @PathParam('user')
    super.key,
    required this.user,
    required this.isCurrentUser,
    required this.isFollowing,
  });

  final User user;

  final bool isCurrentUser;
  final bool isFollowing;

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? ElevatedButton(
            onPressed: () => {null},
            // GoRouter.of(context).push(
            //   EditArtistRoute(
            //     user: user,
            //   ),
            // ),
            child: Text(
              'editArtist'.translate(),
              style: TextStyle(fontSize: 16.0),
            ),
          )
        : Container();
  }
}
