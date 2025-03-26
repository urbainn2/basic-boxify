import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'player_event.dart';
part 'my_player_state.dart';

/// `PlayerBloc` is a Business Logic Component (BLOC) responsible for managing
/// the audio playback state of the application. It receives `PlayerEvent`s,
/// which it translates into changes in the `MyPlayerState`. This bloc is an
/// essential part of the application's state management architecture and is
/// designed to be the single source of truth for all audio playback operations.
///
/// The `PlayerBloc` reacts to a variety of events such as play, pause, stop,
/// seek, and load new tracks. It manages the `AudioPlayer` instance and
/// a `ConcatenatingAudioSource` that holds the playlist's audio sources.
///
/// The bloc ensures a decoupled and testable approach to handling playback
/// logic, keeping playback concerns separate from UI and data layers.
///
/// Usage Example:
/// ```dart
/// final playerBloc = PlayerBloc(audioPlayer: myAudioPlayer, audioSource: myAudioSource);
/// playerBloc.add(PlayEvent(track: myTrack));
/// ```
///
/// Handling transitions between player states (e.g., loading, playing, paused) should reflect
/// changes in the UI accordingly, providing a reactive and smooth user experience.
class PlayerBloc extends Bloc<PlayerEvent, MyPlayerState> {
  final AudioPlayer _audioPlayer;
  StreamSubscription<PositionDiscontinuity>? _discontinuitySubscription;
  static const String _basePlayerStateKey = 'player_state';

  String get _playerStateKey {
    final user = FirebaseAuth.instance.currentUser;
    return user != null
        ? '${_basePlayerStateKey}_${user.uid}'
        : _basePlayerStateKey;
  }

  PlayerBloc({
    required AudioPlayer audioPlayer,
  })  : _audioPlayer = audioPlayer,
        super(MyPlayerState.initial(
          player: audioPlayer,
        )) {
    on<PlayerReset>(_onPlayerReset);
    on<StartPlayback>(_onStartPlayback);
    on<LoadPlayer>(_onLoadPlayer);
    on<Play>(_onPlay);
    on<SeekToNext>(_onSeekToNext);
    on<SeekToPrevious>(_onSeekToPrevious);
    on<SeekToIndex>(_onSeekToIndex);
    on<NotifyAutoAdvance>(_onNotifyAutoAdvance);
    on<UpdateTrackBackgroundColor>(_onUpdateTrackBackgroundColor);

    _discontinuitySubscription =
        _audioPlayer.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        add(NotifyAutoAdvance());
      }
    });

    // Listen for both state changes and play/pause events
    _audioPlayer.playbackEventStream.listen((event) {
      if (state.status == PlayerStatus.loaded) {
        final needsSave = event.processingState == ProcessingState.completed ||
            event.processingState == ProcessingState.ready ||
            (_lastPlayingState != null &&
                _lastPlayingState != _audioPlayer.playing);

        if (needsSave) {
          _savePlaybackState();
        }

        _lastPlayingState = _audioPlayer.playing;
      }
    });

    // Add a separate listener for player state changes to ensure pauses are captured properly
    _audioPlayer.playerStateStream.listen((playerState) {
      // Save when transitioning from playing to paused
      if (playerState.playing == false && _lastPlayingState == true) {
        _savePlaybackState();
      }
      _lastPlayingState = playerState.playing;
    });
  }

  bool? _lastPlayingState;

  @override
  Future<void> close() {
    _discontinuitySubscription?.cancel();
    // Check if a track is already playing
    if (state.player.playing) {
      _savePlaybackState();
      state.player.stop();
    }
    _audioPlayer.dispose();
    return super.close();
  }

  Future<void> _onPlayerReset(
    PlayerReset event,
    Emitter<MyPlayerState> emit,
  ) async {
    if (state.queue.isNotEmpty && state.player.currentIndex != null) {
      await _savePlaybackState();
    }
    await _audioPlayer.stop();
    await _audioPlayer.setAudioSource(ConcatenatingAudioSource(children: []),
        preload: false);
    logger.i('Player reset completed for account change');
    emit(MyPlayerState.initial(player: _audioPlayer));
  }

  Future<void> _onPlay(Play event, Emitter<MyPlayerState> emit) async {
    logger.i('bloc _play at index ${state.player.currentIndex}');
    emit(state.copyWith(status: PlayerStatus.loading));
    // Check if a track is already playing
    if (state.player.playing) {
      await state.player.stop(); // Stop the current track
    }
    state.player.play();
    emit(state.copyWith(player: state.player, status: PlayerStatus.loaded));
  }

  Future<void> _onNotifyAutoAdvance(
    NotifyAutoAdvance event,
    Emitter<MyPlayerState> emit,
  ) async {
    if (state.status != PlayerStatus.playPressed) {
      logger.i('bloc _onNotifyAutoAdvance');
      emit(state.copyWith(
        status: PlayerStatus.loading,
      ));
      emit(state.copyWith(
        status: PlayerStatus.loaded,
        player: state.player,
      ));
    }
  }

  Future<void> _onStartPlayback(
    StartPlayback event,
    Emitter<MyPlayerState> emit,
  ) async {
    logger.i('_onStartPlayback PlayerStatus.playPressed');
    emit(
        state.copyWith(status: PlayerStatus.playPressed, source: event.source));

    final trackIndexMapping = createTrackIndexMapping(event.tracks);
    final audioSourceIndex = trackIndexMapping[event.index];

    final availableTracksInEvent =
        event.tracks.where((track) => track.available == true).toList();

    final queue =
        state.queue.where((track) => track.available == true).toList();

    if (!areTrackListsEqual(availableTracksInEvent, queue)) {
      emit(state.copyWith(queue: availableTracksInEvent));
      logger.i(
          'User has requested a new queue (tracks != state.queue) so setting audio source');
      await _setAudioSource(availableTracksInEvent);
    }

    if (audioSourceIndex != null &&
        audioSourceIndex != state.player.currentIndex) {
      logger.i(
          'audioSourceIndex $audioSourceIndex != state.player.currentIndex ${state.player.currentIndex} so seeking to $audioSourceIndex');

      // // Update currentIndex in PlayerState
      // emit(
      //   state.copyWith(
      //     status: PlayerStatus.playing,
      //     queue: availableTracksInEvent,
      //   ),
      // );

      // Seek to the desired index in AudioPlayer
      await state.player.seek(Duration.zero, index: audioSourceIndex);
    }
    // Emit the updated state with status playing
    emit(
      state.copyWith(
        status: PlayerStatus.playing,
        // queue: availableTracksInEvent,
      ),
    );

    await state.player.play(); // Start playback
  }

  Future<void> _onLoadPlayer(
    LoadPlayer event,
    Emitter<MyPlayerState> emit,
  ) async {
    logger.i('_onLoadPlayer Player with new tracks.');
    emit(state.copyWith(status: PlayerStatus.loading));

    try {
      // Try to restore state first
      await _restorePlaybackState();

      // If restoration didn't work (no state or empty queue), use provided tracks
      if (state.queue.isEmpty) {
        await _setAudioSource(event.tracks);
        emit(state.copyWith(
          queue: event.tracks,
          status: PlayerStatus.loaded,
          player: state.player,
        ));
      }
    } catch (err) {
      logger.e('Error in _onLoadPlayer: $err');
      emit(state.copyWith(
        status: PlayerStatus.error,
        failure:
            Failure(code: err.hashCode.toString(), message: err.toString()),
      ));
    }
  }

  Future<void> _onSeekToIndex(
    SeekToIndex event,
    Emitter<MyPlayerState> emit,
  ) async {
    logger.i('_onSeekToIndex #${event.index}');
    emit(state.copyWith(status: PlayerStatus.loading));
    // Check if a track is already playing
    // if (state.player.playing) {
    //   await state.player.stop(); // Stop the current track
    // }
    await state.player.seek(Duration.zero, index: event.index);

    // logger.i('done emmitting _onSeekToIndex #${event.index}');
    emit(state.copyWith(player: state.player, status: PlayerStatus.loaded));
  }

  Future<void> _onSeekToNext(
    SeekToNext event,
    Emitter<MyPlayerState> emit,
  ) async {
    emit(state.copyWith(status: PlayerStatus.loading));
    // logger.i('bloc seekToNext');
    await state.player.seekToNext();
    emit(state.copyWith(status: PlayerStatus.loaded));
    // emit(
    //   state.copyWith(
    //     selectedIndex: state.player.currentIndex!,
    //   ),
    // );
  }

  Future<void> _onSeekToPrevious(
    SeekToPrevious event,
    Emitter<MyPlayerState> emit,
  ) async {
    logger.i('bloc seek to previous');
    emit(state.copyWith(status: PlayerStatus.loading));
    await state.player.seekToPrevious();
    // while (state.queue[state.player.currentIndex!].available == false) {
    //   logger.i('skipping ${state.queue[state.player.currentIndex!].title}');
    //   await state.player.seekToPrevious();
    // }
    // emit(
    //   state.copyWith(
    //     selectedIndex: state.player.currentIndex,
    //   ),
    // );
    emit(state.copyWith(status: PlayerStatus.loaded));
  }

  String cleanUrlKeepRaw(String url) {
    // url = url.split('?')[0]; // remove query params from url
    // url += '?raw=1'; // add raw=1 to url
    // url = url.replaceAll('scl/fi', 's'); // replace spaces with %20
    url = url.replaceAll('www.dropbox.com',
        'dl.dropboxusercontent.com'); // replace spaces with %20
    return url;
  }

  /// Returns a [Future] that completes after adding state.displayedTracks to [audioSource].
  ///
  /// This asynchronous function converts each selected track to an [AudioSource]
  /// with a URI and [MediaItem] (containing track metadata) as parameters and then adds them to
  /// the [ConcatenatingAudioSource] instance referred to by [audioSource].
  ///
  /// The [MediaItem] is used to display metadata in the notification. Unique ID is given
  /// for each track and Dropbox file links are parsed to fetch raw artwork file and track file.
  Future<void> _setAudioSource(List<Track> tracks) async {
    logger.i('_setAudioSource');
    final audioSource = ConcatenatingAudioSource(children: []);

    try {
      await audioSource.addAll(
        tracks
            .where(
                (track) => track.available!) // filtering out unavailable tracks
            .map(
          (track) {
            var url =
                (track.downloadedUrl == null || track.downloadedUrl!.isEmpty)
                    ? track.link!
                    : track.downloadedUrl;

            // url = url!.split('?')[0]; // remove query params from url
            logger.i(url);
            // String cleanedUrl = cleanUrlKeepRaw();
            // logger.d(cleanedUrl);

            if (kIsWeb) {
              // If problems on web, maybe it has something to do with renaming the files with
              // and index number? Consider handling?
            }
            url = Utils.sanitizeUrl(url!);

            return AudioSource.uri(
              Uri.parse(
                url,
              ),
              tag: MediaItem(
                // Specify a unique ID for each media item:
                id: track.uuid!,
                // Metadata to display in the notification:
                album: track.album,
                title: track.displayTitle,
                artUri: Uri.parse(track.imageUrl!),
              ),
            );
          },
        ).toList(),
      );
      logger.i('done adding tracks to audio source');
      await state.player.setAudioSource(audioSource);
      logger.f('done setting audio source');
    } catch (e) {
      logger.e('Error setting audio source: $e');
    }
  }

  /// Updates the background color of the player based on the track's cover image.
  Future<void> _onUpdateTrackBackgroundColor(
    UpdateTrackBackgroundColor event,
    Emitter<MyPlayerState> emit,
  ) async {
    logger.i('_onUpdateTrackBackgroundColor');
    emit(state.copyWith(backgroundColor: event.backgroundColor));
  }

  Future<void> _savePlaybackState() async {
    // Get the current ACTUAL position from the player directly
    final currentPosition = await state.player.position;

    // Only save state if we have a valid queue and track - don't check playing state
    if (state.queue.isEmpty || state.player.currentIndex == null) {
      logger.d(
          'Cannot save state: queueEmpty=${state.queue.isEmpty}, currentIndex=${state.player.currentIndex}');
      return;
    }

    if (state.player.currentIndex! >= state.queue.length) {
      logger.d(
          'Cannot save state: invalid current index ${state.player.currentIndex}');
      return;
    }

    final currentTrack = state.queue[state.player.currentIndex!];
    if (currentTrack.uuid == null) {
      logger.d('Cannot save state: track has no UUID');
      return;
    }

    logger.d(
        'Saving state for track: ${currentTrack.displayTitle} at position ${currentPosition.inSeconds}s');

    // Save locally in bloc state
    emit(state.copyWith(
      savedPosition: currentPosition,
      savedTrack: currentTrack,
    ));

    // Save to SharedPreferences for device-local persistence
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        logger.d('Saving to SharedPreferences for user ${user.uid}');

        // Save full queue data for proper restoration
        final queueData = state.queue
            .map((track) => {
                  'uuid': track.uuid,
                  'title': track.displayTitle,
                  'link': track.link,
                  'downloadedUrl': track.downloadedUrl,
                  'imageUrl': track.imageUrl,
                  'album': track.album,
                  'available': track.available,
                })
            .toList();

        // Create a map with all player state data
        final playerStateData = {
          'trackId': currentTrack.uuid,
          'position': currentPosition.inMilliseconds,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'trackTitle': currentTrack.displayTitle,
          'playing': state.player.playing,
          'currentIndex': state.player.currentIndex,
          'queue': queueData,
          'userId': user.uid, // Keep track of which user this belongs to
        };

        // Convert to JSON string and save
        await prefs.setString(_playerStateKey, jsonEncode(playerStateData));
        logger.d('Successfully saved state to SharedPreferences');
      }
    } catch (e) {
      logger.e('Error saving to SharedPreferences: $e');
    }
  }

  Future<void> _restorePlaybackState() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        logger.d('No user logged in, cannot restore state');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final savedStateStr = prefs.getString(_playerStateKey);

      if (savedStateStr == null) {
        logger.d('No saved state found in SharedPreferences');
        return;
      }

      final data = jsonDecode(savedStateStr) as Map<String, dynamic>;

      // Verify this state belongs to the current user
      if (data['userId'] != user.uid) {
        logger.d('Saved state belongs to a different user');
        return;
      }

      // Restore queue first
      if (data['queue'] != null) {
        final queueData =
            List<Map<String, dynamic>>.from(data['queue'] as List);
        final restoredTracks = queueData
            .map((trackData) => Track(
                  uuid: trackData['uuid'] as String,
                  displayTitle: trackData['title'] as String,
                  link: trackData['link'] as String?,
                  downloadedUrl: trackData['downloadedUrl'] as String?,
                  imageUrl: trackData['imageUrl'] as String?,
                  album: trackData['album'] as String?,
                  available: trackData['available'] as bool?,
                ))
            .toList();

        if (restoredTracks.isEmpty) {
          logger.d('Restored queue is empty');
          return;
        }

        // Find the previously playing track
        final trackId = data['trackId'] as String;
        final position = Duration(milliseconds: data['position'] as int);
        final trackIndex = restoredTracks.indexWhere((t) => t.uuid == trackId);

        if (trackIndex >= 0) {
          logger.d(
              'Restoring queue and seeking to saved track at position ${position.inSeconds}s');
          await _setAudioSource(restoredTracks);
          await state.player.seek(position, index: trackIndex);

          emit(state.copyWith(
            queue: restoredTracks,
            savedPosition: position,
            savedTrack: restoredTracks[trackIndex],
          ));

          logger.d('State restored successfully');
        }
      }
    } catch (e) {
      logger.e('Error restoring playback state: $e');
    }
  }
}
