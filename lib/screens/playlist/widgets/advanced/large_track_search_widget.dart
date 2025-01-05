import 'package:boxify/app_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

/// This is the widget returned at the bottom of [PlaylistMouseScreen]. It has a Search bar and the search results.
/// Not to be confused with the actual [LargeTrackSearchResults]
class LargeTrackSearchWidget extends StatefulWidget {
  const LargeTrackSearchWidget({super.key});

  @override
  _LargeTrackSearchWidgetState createState() => _LargeTrackSearchWidgetState();
}

class _LargeTrackSearchWidgetState extends State<LargeTrackSearchWidget> {
  final TextEditingController _textController = TextEditingController();
  final playlistRepository = PlaylistRepository();
  final userRepository = UserRepository(
    firebaseFirestore: FirebaseFirestore.instance,
    cacheHelper: CacheHelper(),
  );
  List<bool> isHovereds = [];
  List<bool> isClicked = [];
  List<bool> isDragTargets = [];
  int indexForItemBeingDragged = 0;
  int? sortColumnIndex;
  bool isAscending = false;
  late List<IndexedAudioSource> sequence;
  List<Track>? tracks;

  int current = 0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('LargeTrackSearchWidget');
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // THE SEARCH BAR
          SearchBarForAddToPlaylist(),
          // THE QUEUE OF SEARCH RESULTS
          Center(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                logger.i(
                    'state.searchResultsTracks.length: ${state.searchResultsTracks.length}');
                return state.searchResultsTracks.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        height: Core.app.largeScreenRowHeight *
                            state.searchResultsTracks.length,
                        width: size.width - 100,
                        child: TrackMouseRowHelper().getTrackMouseRows(
                          context,
                          innerItemsAreScrollable: true,
                          showArtist: true,
                          showYear: false,
                          compact: false,
                          canDrag: true,
                          canBeADragTarget: false,
                          replaceSelectedTracksWithSearchResultsOnTap: true,
                          trackRowType:
                              TrackRowType.searchResultsForAddToPlaylist,
                        ),
                      )
                    : CenteredText('noSongsFound'.translate());
              },
            ),
          ),
        ],
      ),
    );
  }
}
