import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Used in [PlaylistTouchScreen] at the bottom and in [LargeTrackSearchWidget]
class SearchBarForAddToPlaylist extends StatefulWidget {
  SearchBarForAddToPlaylist({
    super.key,
    // required TextEditingController textController,
  });

  @override
  State<SearchBarForAddToPlaylist> createState() =>
      _SearchBarForAddToPlaylistState();
}

class _SearchBarForAddToPlaylistState extends State<SearchBarForAddToPlaylist> {
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// get the device size with MediaQuery
    final device = MediaQuery.of(context);
    final searchBloc = context.watch<SearchBloc>();
    final trackBloc = context.watch<TrackBloc>();
    return TextField(
      controller: _textController,
      autofocus: false,
      decoration: InputDecoration(
        fillColor: Colors.grey[900],
        filled: false,
        hintText: 'Search for songs',
        hintStyle: TextStyle(
          fontSize: device.size.width > Core.app.largeSmallBreakpoint ? 16 : 13,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            logger.i('clear');
            searchBloc.add(const ClearSearch());
            _textController.clear();
          },
        ),
      ),
      textInputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          searchBloc.add(ChangeQuery(query: value.trim()));
          searchBloc.add(SearchTracks(trackBloc.state.allTracks));
        } else {
          searchBloc.add(const ClearSearch());
          _textController.clear();
        }
      },
    );
  }
}
