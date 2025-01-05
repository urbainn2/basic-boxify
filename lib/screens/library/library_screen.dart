// import 'package:app_core/app_core.dart';  //

import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen() : super();

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final playlistBloc = context.watch<PlaylistBloc>();
    final trackBloc = context.read<TrackBloc>();
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < Core.app.largeSmallBreakpoint;
    return MultiBlocListener(
      listeners: [
        BlocListener<PlaylistTracksBloc, PlaylistTracksState>(
          listener: (context, state) {
            logger.i('PlaylistTracksBloc listener');
            if (state.status == PlaylistTracksStatus.updated &&
                state.updatedPlaylist != null) {
              logger.e(
                  'PlaylistTracksStatus.updated so calling  playlistBloc.add(PlaylistUpdated!');
              playlistBloc
                  .add(PlaylistUpdated(playlist: state.updatedPlaylist!));
            }
          },
        ),
      ],
      child:
          BlocBuilder<PlaylistBloc, PlaylistState>(builder: (context, state) {
        if (state.status == PlaylistStatus.error) {
          logger.e('LibraryScreen.build() - PlaylistStatus == error');
          return ErrorDialog(content: state.status.toString());
        } else if (state.status == PlaylistStatus.playlistsLoading ||
            state.status == PlaylistStatus.initial) {
          logger.i(
              'LibraryScreen.build() - PlaylistStatus == ${state.status} so returning circularProgressIndicator');
          return circularProgressIndicator;
        }

        return isSmall
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Scaffold(
                  appBar: SmallAppBarForHomeAndLibrary(),
                  body: Container(
                      color: Core.appColor.scaffoldBackgroundColor,
                      child: SmallLibraryScreen(
                        smallLibraryBodyBuilder: () {
                          return SmallLibraryBody();
                        },
                      )),
                ),
              )
            : Scaffold(
                body: HomeScreen(
                    // playlistsFunction: playlistsFunction,
                    ),
              );

        // return BlocBuilder<LibraryBloc, LibraryState>(
        //   builder: (context, state) {
        //     logger.i(
        //       'LIBRARY SCREEN bloc.builder ',
        //     );
        //     if (state.status != LibraryStatus.submitting) {
        //       logger.i(
        //           '${state.status} so LIBRARY SCREEN returning circularProgressIndicator');
        //       return circularProgressIndicator;
        //     } else if (state.status == LibraryStatus.error) {
        //       logger.i('LIBRARY SCREEN builder error=${state.failure.message}');
        //       return ErrorDialog(
        //         content: state.failure.message!,
        //       );
        //     }
      }),
    );
  }
}
