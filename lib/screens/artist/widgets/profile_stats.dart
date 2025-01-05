import 'package:flutter/material.dart';
import 'package:boxify/models/user_model.dart';
import 'package:boxify/screens/artist/buttons/profile_button.dart';

class ArtistStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final User user;
  final User viewer;

  const ArtistStats({
    super.key,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.user,
    required this.viewer,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          // if (user.username != 'Lurker')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ArtistButton(
              user: user,
              isCurrentUser: isCurrentUser,
              isFollowing: isFollowing,
            ),
          ),
          // else
          //   Container(),

          // Show to admin or current user
          if (isCurrentUser || viewer.admin)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stats(stat: user.email, label: 'email'),
              ],
            )
          else
            Container(),
          // Show to everyone
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final String stat;
  final String label;

  const _Stats({
    required this.stat,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: SelectableText(
              stat,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
