import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/src/provider.dart';

/// This is the screen that shows up when the user taps on
/// 'Add to other playlist' in the overflow menu of a track.
class SmallAddToPlaylistScreen extends StatefulWidget {
  SmallAddToPlaylistScreen({super.key});
  final List<Track>? tracks = [];

  @override
  _SmallAddToPlaylistScreenState createState() =>
      _SmallAddToPlaylistScreenState();
}

class _SmallAddToPlaylistScreenState extends State<SmallAddToPlaylistScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAnonymous = context.read<UserBloc>().state.user.id == '';
    MediaQueryData device;
    device = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.black87,
          backgroundColor: Core.appColor.widgetBackgroundColor,
          centerTitle: true,
          title: Text(
            'addToPlaylist'.translate(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Container(
          color: Core.appColor.widgetBackgroundColor,
          child: Column(
            children: [
              AddToNewPlaylistButton(isAnonymous: isAnonymous),
              SizedBox(height: 16),
              Expanded(
                child: SmallLibraryScreenForAddingPlaylists(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddToNewPlaylistButton extends StatelessWidget {
  const AddToNewPlaylistButton({
    super.key,
    required this.isAnonymous,
  });

  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black),
      onPressed: () {
        if (isAnonymous) {
          showMySnack(context, message: 'pleaseLoginToSave'.translate());
        } else {
          final track = context.read<PlaylistTracksBloc>().state.trackToAdd!;
          context.read<LibraryBloc>().add(
                CreatePlaylist(
                  user: context.read<UserBloc>().state.user,
                  trackToAdd: track,
                ),
              );

          ScaffoldMessenger.of(context).showSnackBar(
            buildSnackbar('addToANewPlaylist'.translate()),
          );
          context.pop();
        }
      },
      child: Text('newPlaylist'.translate()),
    );
  }
}
