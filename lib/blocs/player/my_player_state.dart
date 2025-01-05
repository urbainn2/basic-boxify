part of 'player_bloc.dart';

enum PlayerStatus {
  initial, // When PlayerBloc is first created or after the player has been reset.
  loading, // When a new track or playlist is loaded into the player.
  loaded, // When the player successfully finishes loading a track or playlist.
  playPressed, // When the user presses the play button but the audio playback has not started yet.
  playing, // When the audio playback is in progress.
  // paused, // When the audio playback is paused.
  // stopped, // When the audio playback is stopped.
  // completed, // When the audio playback completes all tracks in the queue.
  error, // When an error occurs within the player (e.g., loading or playback fails).
}

class MyPlayerState extends Equatable {
  final PlayerStatus status;
  final Failure failure;
  final AudioPlayer player;
  List<Track> queue;

  MyPlayerState({
    required this.status,
    required this.failure,
    required this.player,
    required this.queue,
  });

  factory MyPlayerState.initial(
      {required AudioPlayer player, ConcatenatingAudioSource? audioSource}) {
    // logger.f('MyPlayerState.initial: player.hashCode = ${player.hashCode}');
    return MyPlayerState(
      status: PlayerStatus.initial,
      failure: const Failure(),
      player: player,
      queue: [],
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        player,
        queue,
      ];

  MyPlayerState copyWith({
    PlayerStatus? status,
    Failure? failure,
    AudioPlayer? player,
    ConcatenatingAudioSource? audioSource,
    List<Track>? queue,
  }) {
    return MyPlayerState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      player: player ?? this.player,
      queue: queue ?? this.queue,
    );
  }
}
