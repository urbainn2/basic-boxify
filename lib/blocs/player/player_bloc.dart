import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:boxify/app_core.dart';
import 'package:boxify/services/playback_debug_logger.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final _firestore = FirebaseFirestore.instance;

  PlayerBloc({
    required AudioPlayer audioPlayer,
  })  : _audioPlayer = audioPlayer,
        super(MyPlayerState.initial(
          player: audioPlayer,
        )) {
    // Initialize debug logger
    PlaybackDebugLogger.init();
    PlaybackDebugLogger.debug('PlayerBloc initialized');

    on<PlayerReset>(_onPlayerReset);
    on<StartPlayback>(_onStartPlayback);
    on<LoadPlayer>(_onLoadPlayer);
    on<Play>(_onPlay);
    on<SeekToNext>(_onSeekToNext);
    on<SeekToPrevious>(_onSeekToPrevious);
    on<SeekToIndex>(_onSeekToIndex);
    on<NotifyAutoAdvance>(_onNotifyAutoAdvance);

    _discontinuitySubscription =
        _audioPlayer.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        add(NotifyAutoAdvance());
      }
    });

    // Listen for playback interruptions
    _audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed ||
          !_audioPlayer.playing) {
        PlaybackDebugLogger.debug(
            'Playback interrupted: completed=${event.processingState == ProcessingState.completed}, playing=${_audioPlayer.playing}');
        _savePlaybackState(_audioPlayer.position);
      }
    });

    // Restore saved state on init
    PlaybackDebugLogger.debug('Attempting to restore playback state on init');
    _restorePlaybackState();
  }

  @override
  Future<void> close() {
    _discontinuitySubscription?.cancel();
    // Check if a track is already playing
    if (state.player.playing) {
      _savePlaybackState(state.player.position);
      state.player.stop();
    }
    _audioPlayer.dispose();
    return super.close();
  }

  /// was causing a memory leak https://github.com/riverscuomo/flutter-apps/issues/104
  Future<void> _onPlayerReset(
    PlayerReset event,
    Emitter<MyPlayerState> emit,
  ) async {
    // Assuming you want to completely reset the player
    await _audioPlayer.stop(); // Stop any current playback
    await _audioPlayer.seek(Duration
        .zero); // Seek to the beginning of the audio source if necessary
    await _audioPlayer
        .dispose(); // If you need to dispose of the current instance

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

    // logger.i('done play ${state.player.currentIndex}');
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
    emit(state.copyWith(status: PlayerStatus.playPressed));

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

  // Future<void> _onStartPlayback(
  //   StartPlayback event,
  //   Emitter<MyPlayerState> emit,
  // ) async {
  //   logger.i('_onStartPlayback PlayerStatus.playPressed');
  //   // logger.i(state.player.currentIndex);
  //   emit(state.copyWith(status: PlayerStatus.playPressed));
  //   // logger.i(state.player.currentIndex);

  //   final trackIndexMapping = createTrackIndexMapping(event.tracks);
  //   final audioSourceIndex = trackIndexMapping[event.index];

  //   final availableTracksInEvent = event.tracks
  //       .where((track) => track.available == true)
  //       .toList(); // filtering out unavailable tracks

  //   final queue = state.queue
  //       .where((track) => track.available == true)
  //       .toList(); // filtering out unavailable tracks

  //   /// If the user has requested a new queue by either:
  //   /// - clicking the [PlayButtonInCircle] for the first time to play a unqueued playlist
  //   /// - tapping on an unqueued playlist track
  //   if (!areTrackListsEqual(availableTracksInEvent, queue)) {
  //     logger.i(
  //         'user has requested a new queue (tracks != state.queue) so setting audiosource');

  //     await _setAudioSource(availableTracksInEvent);
  //   }

  //   /// If you've clicked in a list at an index that is not the current index
  //   if (audioSourceIndex != null &&
  //       audioSourceIndex != state.player.currentIndex) {
  //     logger.d(
  //         'audioSourceIndex $audioSourceIndex != state.player.currentIndex ${state.player.currentIndex} so seeking to $audioSourceIndex');
  //     add(SeekToIndex(index: audioSourceIndex));

  //     emit(
  //       state.copyWith(
  //         status: PlayerStatus.playing,
  //         player: state.player,
  //         queue: availableTracksInEvent,
  //       ),
  //     );
  //   }

  //   state.player
  //       .play(); // don't add the event Play() because that fire before Seek is done
  //   logger.i('emitting PlayerStatus.playing');
  //   emit(
  //     state.copyWith(
  //       status: PlayerStatus.playing,
  //       queue: availableTracksInEvent,
  //     ),
  //   );
  // }

  Future<void> _onLoadPlayer(
    LoadPlayer event,
    Emitter<MyPlayerState> emit,
  ) async {
    logger.i('_onLoadPlayer Player with new tracks.');

    emit(state.copyWith(status: PlayerStatus.loading));

    try {
      await _setAudioSource(event.tracks);
      logger.i('done setting audio source so emitting PlayerStatus.loaded');

      // Try to restore any saved state after loading tracks
      await _restorePlaybackState();

      emit(
        state.copyWith(
          status: PlayerStatus.loaded,
          player: state.player,
          queue: event.tracks,
        ),
      );
    } catch (err) {
      logger.e('Error setting audio source: $err');
      emit(
        state.copyWith(
          status: PlayerStatus.error,
          failure:
              Failure(code: err.hashCode.toString(), message: err.toString()),
        ),
      );
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
            // logger.i(url);
            // String cleanedUrl = cleanUrlKeepRaw();
            // logger.d(cleanedUrl);

            if (kIsWeb) {
              // If problems on web, maybe it has something to do with renaming the files with
              // and index number? Consider handling?
            }
            // print(url);
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

  Future<void> _savePlaybackState(Duration position) async {
    if (!state.player.playing || state.queue.isEmpty || state.player.currentIndex == null) {
      PlaybackDebugLogger.debug('Cannot save state: playing=${state.player.playing}, queueEmpty=${state.queue.isEmpty}, currentIndex=${state.player.currentIndex}');
      return;
    }

    final currentTrack = state.queue[state.player.currentIndex!];
    if (currentTrack.uuid == null) {
      PlaybackDebugLogger.debug('Cannot save state: track has no UUID');
      return;
    }

    PlaybackDebugLogger.debug('Saving state for track: ${currentTrack.displayTitle} at position ${position.inSeconds}s');

    // Save locally in bloc state
    emit(state.copyWith(
      savedPosition: position,
      savedTrack: currentTrack,
    ));
    PlaybackDebugLogger.debug('Saved to local state');

    // Save to Firestore for cross-device sync
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        PlaybackDebugLogger.debug('Saving to Firestore for user ${user.uid}');
        await _firestore.collection('playback_states').doc(user.uid).set({
          'trackId': currentTrack.uuid,
          'position': position.inMilliseconds,
          'timestamp': FieldValue.serverTimestamp(),
          'trackTitle': currentTrack.displayTitle, // Add title for debugging
        });
        PlaybackDebugLogger.debug('Successfully saved to Firestore');
      } else {
        PlaybackDebugLogger.debug('No user logged in, skipping Firestore save');
      }
    } catch (e) {
      PlaybackDebugLogger.error('Error saving to Firestore', e);
    }
  }

  Future<void> _restorePlaybackState() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        PlaybackDebugLogger.debug('No user logged in, cannot restore state');
        return;
      }

      PlaybackDebugLogger.debug('Attempting to restore state for user ${user.uid}');
      
      // Check if we have tracks in our state
      if (state.queue.isEmpty) {
        PlaybackDebugLogger.debug('Queue is empty, cannot restore state');
        return;
      }

      final doc = await _firestore.collection('playback_states').doc(user.uid).get();
      if (!doc.exists) {
        PlaybackDebugLogger.debug('No saved state found in Firestore');
        return;
      }

      final data = doc.data()!;
      final trackId = data['trackId'] as String;
      final position = Duration(milliseconds: data['position'] as int);
      final savedTitle = data['trackTitle'] as String?;
      PlaybackDebugLogger.debug('Found saved state: trackId=$trackId, position=${position.inSeconds}s, title=$savedTitle');

      // Find track in state or return early if not found
      final tracks = state.queue.where((t) => t.uuid == trackId).toList();
      PlaybackDebugLogger.debug('Found ${tracks.length} matching tracks in queue');
      
      if (tracks.isNotEmpty) {
        final track = tracks.first;
        PlaybackDebugLogger.debug('Found matching track: ${track.displayTitle}');
        await _setAudioSource([track]);
        PlaybackDebugLogger.debug('Set audio source');
        await state.player.seek(position);
        PlaybackDebugLogger.debug('Seeked to position ${position.inSeconds}s');
        if (!state.player.playing) {
          PlaybackDebugLogger.debug('Starting playback');
          await state.player.play();
        }
        emit(state.copyWith(
          savedPosition: position,
          savedTrack: track,
          queue: [track],
        ));
        PlaybackDebugLogger.debug('State restored successfully');
      } else {
        PlaybackDebugLogger.debug('Track not found in current queue');
      }
    } catch (e) {
      PlaybackDebugLogger.error('Error restoring playback state', e);
    }
  }
}
