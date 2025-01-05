import 'dart:async';
import 'dart:io';

import 'package:boxify/app_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart'; // needed in playlist_event

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final UserRepository _userRepository;
  final PlaylistRepository _playlistRepository;

  LibraryBloc({
    required AuthBloc authBloc,
    required UserRepository userRepository,
    required TrackRepository trackRepository,
    required PlaylistRepository playlistRepository,
    required MetaDataRepository metaDataRepository,
    required StorageRepository storageRepository,
    required BundleRepository bundleRepository,
  })  : _userRepository = userRepository,
        _playlistRepository = playlistRepository,
        super(LibraryState.initial()) {
    on<InitialLibraryState>(_onInitialState);
    on<RemovePlaylist>(_onRemovePlaylist);
    on<DeletePlaylist>(_onDeletePlaylist);
    on<CreatePlaylist>(_onCreatePlaylist);
    on<AddPlaylistToLibrary>(_onAddPlaylistToLibrary);
    on<ResequencePlaylists>(_onResequencePlaylists);
  }

  Future<void> _onInitialState(
    InitialLibraryState event,
    Emitter<LibraryState> emit,
  ) async {
    emit(state.copyWith(status: LibraryStatus.initial));
  }

  Future<void> _onResequencePlaylists(
    ResequencePlaylists event,
    Emitter<LibraryState> emit,
  ) async {
    logger.i('resequencePlaylists bloc ');

    final updatedPlaylists = [...event.followedPlaylists];

    var playlist = updatedPlaylists[event.oldIndex];
    updatedPlaylists.removeAt(event.oldIndex);
    updatedPlaylists.insert(event.newIndex, playlist);

    final updatedPlaylistIds =
        updatedPlaylists.map((playlist) => playlist.id!).toList();

    // Add the song to firestore playlist
    await _playlistRepository.resequencePlaylists(
      userId: event.user.id,
      playlistIds: updatedPlaylistIds,
    );

    // Update the cached user, otherwise the old playlistIds will be reupdated
    // from cache when the user is reupdated.
    CacheHelper()
        .saveUser(event.user.copyWith(playlistIds: updatedPlaylistIds));

    emit(
      state.copyWith(
        status: LibraryStatus.playlistsResequenced,
        // user: event.user.copyWith(playlistIds: updatedPlaylistIds),
        // followedPlaylists: updatedPlaylists,
      ),
    );
  }

  /// Adds a playlist to the user's playlistIds,
  /// and adds the playlist to the state.followedPlaylists
  /// Event added in various menus, [PlaylistOwnerRow]
  Future<void> _onAddPlaylistToLibrary(
    AddPlaylistToLibrary event,
    Emitter<LibraryState> emit,
  ) async {
    logger.i('addPlaylistToLibrary${event.playlistId}');
    emit(state.copyWith(status: LibraryStatus.addingPlaylistToLibrary));

    try {
      await _userRepository.addUserPlaylist(event.user.id, event.playlistId);

      await _playlistRepository.incrementFollowerCount(
        playlistId: event.playlistId,
        quantity: 1,
      );

      final firestorePlaylist = await _playlistRepository.fetchPlaylist(
          event.playlistId, event.user.id);

      //         final updatedPlaylist = firestorePlaylist.copyWith(

      // isFollowable: false,
      // );
      emit(
        state.copyWith(
          status: LibraryStatus.playlistAddedToLibrary,
          playlistJustCreated: firestorePlaylist,
        ),
      );
    } catch (err) {
      logger.i('psb _addPlaylistToLibrary error: $err');
      emit(
        state.copyWith(
          status: LibraryStatus.error,
          failure:
              const Failure(message: 'I was unable to addPlaylistToLibrary.'),
        ),
      );
    }
  }

  Future<void> _onCreatePlaylist(
    CreatePlaylist event,
    Emitter<LibraryState> emit,
  ) async {
    logger.i('createPlaylist');
    emit(state.copyWith(status: LibraryStatus.creatingPlaylist));
    final user = event.user;
    final newLastPlaylistNumber = user.lastPlaylistNumber + 1;

    List<String> trackIds = [];
    if (event.trackToAdd != null) {
      trackIds.add(event.trackToAdd!.uuid!);
    }
    final displayTitle = '${'myPlaylist'.translate()} #$newLastPlaylistNumber';
    try {
      final playlist = Playlist(
        isOwnPlaylist: true,
        owner: {
          'username': user.username,
          'id': user.id,
          'type': 'user',
          'profileImageUrl': user.profileImageUrl
        },
        description: '',
        name: displayTitle, // ?
        displayTitle: displayTitle,
        total: trackIds.length,
        trackIds: trackIds,
        updated: Timestamp.now(),
        created: Timestamp.now(),
        followerCount: 1,
      );

      final playlistId =
          await _playlistRepository.createPlaylist(playlist: playlist);

      logger.i(
          '_createPlaylist: new playlist id: $playlistId lastPlaylistNumber: $newLastPlaylistNumber');
      final firestorePlaylist =
          await _playlistRepository.fetchPlaylist(playlistId, user.id);
      logger.i(
        '_createPlaylist: returning with playlist ${firestorePlaylist.id}',
      );
      emit(
        state.copyWith(
          status: LibraryStatus.playlistCreated,
          playlistJustCreated: firestorePlaylist,
          lastPlaylistNumber: newLastPlaylistNumber,
        ),
      );
    } catch (err) {
      logger.e('psb _createPlaylist error: $err');
      emit(
        state.copyWith(
          status: LibraryStatus.error,
          failure:
              const Failure(message: 'I was unable to create your playlist.'),
        ),
      );
    }
  }

  /// Removes a playlist from the user's playlistIds
  /// and decrements the playlist's followerCount.
  ///
  /// For playlists that are not owned by the user.
  /// Compare with [DeletePlaylist]
  Future<void> _onRemovePlaylist(
    RemovePlaylist event,
    Emitter<LibraryState> emit,
  ) async {
    logger.i('removePlaylist${event.playlist.id}');

    emit(state.copyWith(status: LibraryStatus.removingPlaylist));
    try {
      await _playlistRepository.incrementFollowerCount(
        playlistId: event.playlist.id!,
        quantity: -1,
      );
    } catch (err) {
      logger.e('psb _removePlaylist error: $err');
      emit(
        state.copyWith(
          status: LibraryStatus.error,
          failure: const Failure(
            message: 'I was unable to decrement followers on your playlist.',
          ),
        ),
      );
    }
    try {
      // remove the id from the user.playlists in firestore
      await _playlistRepository.removePlaylist(
        playlistId: event.playlist.id!,
        userId: event.user.id,
      );
    } catch (err) {
      logger.e('psb _removePlaylist error: $err');
      emit(
        state.copyWith(
          status: LibraryStatus.error,
          failure: const Failure(
            message:
                'I was unable to remove the id from the user.playlists in firestore.',
          ),
        ),
      );
    }

    try {
      // remove the playlist from state.followedPlaylists
      // (probably going to need to modify the props isFollowable)
      event.user.playlistIds.removeWhere((x) => x == event.playlist.id);
    } catch (err) {
      logger.e('psb _removePlaylist error: $err');
      emit(
        state.copyWith(
          status: LibraryStatus.error,
          failure: const Failure(
            message:
                'I was unable to remove your playlist from state.FollowedPlaylists',
          ),
        ),
      );
    }

    emit(
      state.copyWith(
        status: LibraryStatus.playlistRemoved,
        playlistToRemove: event.playlist,
      ),
    );
  }

  /// Deletes a playlist from firestore.
  /// If a user is deleting there own playlist, then [RemovePlaylist] is
  /// must also be called.
  Future<void> _onDeletePlaylist(
    DeletePlaylist event,
    Emitter<LibraryState> emit,
  ) async {
    logger.i('deletePlaylist${event.playlistId}');

    try {
      // remove the id from the user.playlists
      await _playlistRepository.deletePlaylist(
        playlistId: event.playlistId,
      );
    } catch (err) {
      logger.i('psb _deletePlaylist error: $err');
      emit(
        state.copyWith(
          status: LibraryStatus.error,
          failure: const Failure(
            message: 'I was unable to update your delete the playlist.',
          ),
        ),
      );
    }
  }
}
