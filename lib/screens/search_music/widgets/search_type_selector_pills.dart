import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTypeSelectorPills extends StatelessWidget {
  const SearchTypeSelectorPills({
    super.key,
    required this.screenType,
    required this.searchBloc,
    required bool songsSelected,
    required bool playlistsSelected,
    required bool artistsSelected,
  })  : _songsSelected = songsSelected,
        _playlistsSelected = playlistsSelected,
        _artistsSelected = artistsSelected;

  final double screenType;
  final SearchBloc searchBloc;
  final bool _songsSelected;
  final bool _playlistsSelected;
  final bool _artistsSelected;

  @override
  Widget build(BuildContext context) {
    final trackBloc = context.read<TrackBloc>();
    final playlistBloc = context.read<PlaylistBloc>();
    final userBloc = context.read<UserBloc>();
    return Container(
      height: 65,
      color: Core.appColor.widgetBackgroundColor,
      child: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SearchSongsPill(
                      searchBloc: searchBloc,
                      trackBloc: trackBloc,
                      songsSelected: _songsSelected),
                  SearchPlaylsitsPill(
                      searchBloc: searchBloc,
                      playlistBloc: playlistBloc,
                      playlistsSelected: _playlistsSelected),
                  SearchArtistsPill(
                      searchBloc: searchBloc,
                      userBloc: userBloc,
                      artistsSelected: _artistsSelected),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchSongsPill extends StatelessWidget {
  const SearchSongsPill({
    super.key,
    required this.searchBloc,
    required this.trackBloc,
    required bool songsSelected,
  }) : _songsSelected = songsSelected;

  final SearchBloc searchBloc;
  final TrackBloc trackBloc;
  final bool _songsSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          searchBloc.add(
            SearchTracks(trackBloc.state.allTracks),
          );
          searchBloc.add(
            SetSearchType(0),
          );
        },
        style: ButtonStyle(
          shape: buttonShapeCircleWhite,
          backgroundColor: MaterialStateProperty.all(
            _songsSelected ? Core.appColor.primary : Colors.black,
          ),
        ),
        child: Text('songs'.translate()),
      ),
    );
  }
}

class SearchPlaylsitsPill extends StatelessWidget {
  const SearchPlaylsitsPill({
    super.key,
    required this.searchBloc,
    required this.playlistBloc,
    required bool playlistsSelected,
  }) : _playlistsSelected = playlistsSelected;

  final SearchBloc searchBloc;
  final PlaylistBloc playlistBloc;
  final bool _playlistsSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          searchBloc.add(
            SearchPlaylists(playlistBloc.state.allPlaylists),
          );
          searchBloc.add(
            SetSearchType(1),
          );
        },
        style: ButtonStyle(
          shape: buttonShapeCircleWhite,
          backgroundColor: MaterialStateProperty.all(
            _playlistsSelected ? Core.appColor.primary : Colors.black,
          ),
        ),
        child: Text('playlists'.translate()),
      ),
    );
  }
}

class SearchArtistsPill extends StatelessWidget {
  const SearchArtistsPill({
    super.key,
    required this.searchBloc,
    required this.userBloc,
    required bool artistsSelected,
  }) : _artistsSelected = artistsSelected;

  final SearchBloc searchBloc;
  final UserBloc userBloc;
  final bool _artistsSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          searchBloc.add(
            SearchArtists(userBloc.state.allArtists),
          );
          searchBloc.add(
            SetSearchType(2),
          );
        },
        style: ButtonStyle(
          shape: buttonShapeCircleWhite,
          backgroundColor: MaterialStateProperty.all(
            _artistsSelected ? Core.appColor.primary : Colors.black,
          ),
        ),
        child: Text('artists'.translate()),
      ),
    );
  }
}
