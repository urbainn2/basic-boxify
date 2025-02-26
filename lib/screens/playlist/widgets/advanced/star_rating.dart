import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.track,
    this.showRating = true,
  });

  final Track track;
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    if (!track.isRateable) {
      return const SizedBox.shrink();
    } else if (!showRating) {
      return const SizedBox(
        width: 120,
      ); // so the row contents won't move when rating is not shown
    }
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final isAnonymous = context.read<UserBloc>().state.user.id == '';

    // Get the rating from the user's ratings map/list
    final ratingFromUserBloc = state.ratings
        .firstWhere(
          (r) => r.trackUuid == track.uuid,
          orElse: () => Rating(trackUuid: track.uuid!, value: 0),
        )
        .value;
        return RatingBar.builder(
          // initialRating: track.userRating ?? 0.0, // https://github.com/riverscuomo/boxify/issues/108
          initialRating: ratingFromUserBloc ?? 0.0,
          minRating: 0,
          itemCount: 5,
          itemSize: 20,
          itemPadding: const EdgeInsets.symmetric(horizontal: 2),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Core.appColor.primary,
          ),
          onRatingUpdate: (v) {
            if (isAnonymous) {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              GoRouter.of(context).push('/login');
            } else if (v > 0) {
              context
                  .read<UserBloc>()
                  .add(UpdateRating(trackId: track.uuid!, value: v));
            }
          },
        );
      },
    );
  }
}
