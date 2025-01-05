import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Used in [SearchMusicScreen]
class SearchPlayerBar extends StatelessWidget implements PreferredSizeWidget {
  final UserBloc userBloc;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  SearchPlayerBar({super.key, required this.userBloc});

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    final trackBloc = context.read<TrackBloc>();
    final playlistBloc = context.read<PlaylistBloc>();
    final userBloc = context.read<UserBloc>();

    final songsSelected = searchBloc.state.searchTypeIndex == 0;
    final playlistsSelected = searchBloc.state.searchTypeIndex == 1;
    final artistsSelected = searchBloc.state.searchTypeIndex == 2;
    return AppBar(
        backgroundColor: Core.appColor.panelColor,
        title: MySearchTextField(
          textController: _textController,
          hintText: 'whatDoYouWantToListenTo'.translate(),
          onTextChanged: (value) {
            if (value.trim().isNotEmpty) {
              searchBloc.add(ChangeQuery(query: value.trim()));
              if (songsSelected) {
                searchBloc.add(SearchTracks(trackBloc.state.allTracks));
              } else if (playlistsSelected) {
                searchBloc
                    .add(SearchPlaylists(playlistBloc.state.allPlaylists));
              } else if (artistsSelected) {
                searchBloc.add(SearchArtists(userBloc.state.allArtists));
              }
            } else {
              searchBloc.add(const ClearSearch());
              _textController.clear();
            }
          },
          onClear: () {
            searchBloc.add(const ClearSearch());
            _textController.clear();
          },
        ));
  }
}
