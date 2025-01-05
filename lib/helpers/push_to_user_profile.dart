import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Pushes to the user profile page
/// and loads the user profile
/// and sets the player screen to user
///
void pushToUserArtist(BuildContext context, String userId) {
  logger.i('Core.app.name == Weezify so LoadArtist with widget.userId');
  logger.i('pushing to /user/$userId');
  final userBloc = context.read<UserBloc>();
  if (userId != context.read<ArtistBloc>().state.user.id) {
    logger.f('widget.userId != state.user.id so LoadArtist with widget.userId');
    context.read<ArtistBloc>().add(
          LoadArtist(viewer: userBloc.state.user, userId: userId),
        );
    context.push('/user/$userId');
  }
}
