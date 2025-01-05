import 'package:boxify/app_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

mixin EditPlaylistMixin<T extends StatefulWidget> on State<T> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> selectPlaylistImage(BuildContext context) async {
    logger.i('selectPlaylistImage');
    if (kIsWeb) {
      logger.i('on web');
      final result = await FilePicker.platform.pickFiles(withData: true);
      logger.i('FilePickerResult:$result');
      if (result != null) {
        final file = result.files.first;
        final pngByteData = result.files.first.bytes;
        if (pngByteData != null) {
          context.read<PlaylistInfoBloc>().add(
                PlaylistImageChangedOnWeb(
                  playlistImageOnWeb: file,
                  pngByteData: pngByteData,
                ),
              );
        }
      } else {
        // User canceled the picker
      }
    } else {
      logger.i('not on web');
      final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Create Playlist',
      );

// NON WEB APP??
      if (pickedFile != null) {
        // logger.i(pickedFile);
        context
            .read<PlaylistInfoBloc>()
            .add(PlaylistImageChanged(playlistImage: pickedFile));
      }
    }
  }

  /// Returns either an image url
  /// or an Icon widget
  /// based on whether or not the playlist has an image
  Widget imageForEditDetails(Playlist playlist) {
    logger.i('imageForEditDetails!!!!!!!!!!!');

    /// This was for android
    // if (state.playlistImage != null) {
    //   logger.i("well state.playlistImage is not null so I'm still returning it.");
    //   return Image.file(state.playlistImage!, fit: BoxFit.cover);
    // } else

    // If the playlist has an image
    // and you haven't recently picked an image,
    // return it.

    //  && state.playlistImageOnWeb.size == 0

    final state = context.read<PlaylistInfoBloc>().state;

    // Else if the state has a recently picked image on web, return that.
    if (kIsWeb && (state.playlistImageOnWeb.size > 0)) {
      logger.i('image or icon is returning state.playlistImageOnWeb');
      return Image.memory(state.pngByteData as Uint8List);
    } else if (!kIsWeb && (state.playlistImage != null)) {
      logger.i('image or icon is returning state.playlistImage');
      return Image.file(state.playlistImage!);
    } else {
      return imageOrIcon(
        imageUrl: playlist.imageUrl,
        filename: playlist.imageFilename,
        height: 120,
        width: 120,
      );
    }
  }

  // Any other shared methods can be added here
}
