import 'dart:async';
import 'dart:io';

import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart'; // needed in playlist_event

part 'playlist_info_event.dart';
part 'playlist_info_state.dart';

class PlaylistInfoBloc extends Bloc<PlaylistInfoEvent, PlaylistInfoState> {
  final PlaylistRepository _playlistRepository;
  final StorageRepository _storageRepository;
  PlaylistInfoBloc({
    required PlaylistRepository playlistRepository,
    required StorageRepository storageRepository,
  })  : _playlistRepository = playlistRepository,
        _storageRepository = storageRepository,
        super(PlaylistInfoState.initial()) {
    // on<ChangeDescription>(_onChangeDescription);
    on<SubmitOnWeb>(_onSubmitPlaylistInfoOnWeb);
    on<Submit>(_onSubmitPlaylistInfo);
    on<PlaylistImageChangedOnWeb>(_onPlaylistImageChangedOnWeb);
    on<PlaylistImageChanged>(_onPlaylistImageChanged);
  }

  Future<void> _onInitialState(
    InitialPlaylistInfoState event,
    Emitter<PlaylistInfoState> emit,
  ) async {
    emit(state.copyWith(status: PlaylistInfoStatus.initial));
  }

  Future<void> _onPlaylistImageChanged(
    PlaylistImageChanged event,
    Emitter<PlaylistInfoState> emit,
  ) async {
    logger.f(
      'playlistImageChanged: the playlistImage is in your state now and accessible to save.',
    );
    final imageFile =
        File(event.playlistImage!.path); // convert CroppedFile to File
    emit(
      state.copyWith(
        playlistImage: imageFile,
      ),
    );
  }

  Future<void> _onPlaylistImageChangedOnWeb(
    PlaylistImageChangedOnWeb event,
    Emitter<PlaylistInfoState> emit,
  ) async {
    logger.f('ps bloc _playlistImageChangedOnWeb');
    emit(
      state.copyWith(
        playlistImageOnWeb: event.playlistImageOnWeb,
        pngByteData: event.pngByteData,
      ),
    );
  }

  Future<void> _onSubmitPlaylistInfo(
      Submit event, Emitter<PlaylistInfoState> emit) async {
    logger.f('submit');
    emit(state.copyWith(status: PlaylistInfoStatus.updating));
    try {
      final data = {
        'id': event.playlist.id,
        'description': event.description,
        'name': event.name,
        'updated': Timestamp.now(),
      };
      if (state.playlistImage != null) {
        final playlistImageUrl = await _storageRepository.uploadPlaylistImage(
            image: state.playlistImage!);
        data['image'] = playlistImageUrl;
      }

      await _playlistRepository.updatePlaylist(data: data);
      final playlist = await _playlistRepository.fetchPlaylist(
          event.playlist.id!, event.userId);
      // And you also need to empty out playlistIMage
      emit(
        state.copyWith(
          status: PlaylistInfoStatus.updated,
          updatedPlaylist: playlist,
          playlistImage: null,
        ),
      );
    } catch (err) {
      logger.e('psb _submitPlaylistInfo error: $err');
      emit(
        state.copyWith(
          status: PlaylistInfoStatus.error,
          failure: const Failure(
            message: 'I was unable to update your playlist in submit.',
          ),
        ),
      );
    }
  }

  /// Oh this is playlist details??
  Future<void> _onSubmitPlaylistInfoOnWeb(
    SubmitOnWeb event,
    Emitter<PlaylistInfoState> emit,
  ) async {
    logger.f('psb_submitOnWeb');
    emit(state.copyWith(status: PlaylistInfoStatus.updating));
    try {
      final data = {
        'id': event.playlist.id,
        'description': event.description,
        'name': event.name,
        'updated': Timestamp.now(),
      };
      // If they submitted an image,
      // add it to firestore and the new url.
      if (state.playlistImageOnWeb.size > 0) {
        final playlistImageUrl =
            await _storageRepository.uploadPlaylistImageOnWeb(
                pngByteData: state.pngByteData as Uint8List);
        data['image'] = playlistImageUrl;
      }
      await _playlistRepository.updatePlaylist(data: data);
      final updatedPlaylist = await _playlistRepository.fetchPlaylist(
          event.playlist.id!, event.userId);
      // And you also need to empty out playlistIMageOnWeb
      emit(
        state.copyWith(
          status: PlaylistInfoStatus.updated,
          updatedPlaylist: updatedPlaylist,
          playlistImageOnWeb: PlatformFile(size: 0, name: '', bytes: null),
        ),
      );
    } catch (err) {
      logger.e('psb _submitPlaylistInfoOnWeb error: $err');
      emit(
        state.copyWith(
          status: PlaylistInfoStatus.error,
          failure:
              const Failure(message: 'I was unable to update your playlist.'),
        ),
      );
    }
  }

  // Future<void> _onChangeDescription(
  //   ChangeDescription event,
  //   Emitter<PlaylistInfoState> emit,
  // ) async {
  //   logger.f('changeDescription');
  //   try {
  //     event.playlist.description = event.description;

  //     emit(state.copyWith(updatedPlaylist: state.updatedPlaylist));
  //   } catch (err) {
  //     logger.f('psb _changeDescription error: $err');
  //     emit(
  //       state.copyWith(
  //         status: PlaylistInfoStatus.error,
  //         failure:
  //             const Failure(message: 'I was unable to create your playlist.'),
  //       ),
  //     );
  //   }
  // }
}
