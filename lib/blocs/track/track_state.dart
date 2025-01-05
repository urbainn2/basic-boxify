part of 'track_bloc.dart';

enum TrackStatus {
  initial,
  ratingsMapping,
  ratingsMapped,
  allTracksLoading,
  allTracksLoaded,
  displayedTracksLoading,
  displayedTracksLoaded,
  error,
}

class TrackState extends Equatable {
  final TrackStatus status;
  final Failure failure;
  final List<Track> allTracks; // All tracks in the app, provided by the server
  // Tracks selected by the user for viewing in a [BasePlaylistScreen] or in the [Player]
  final List<Track> displayedTracks;
  final List<Track> displayedTracksPlayable;
  bool clearCache;
  // final String? trackIdPassedToUrl;
  final String? mouseClickedTrackId;

  TrackState({
    required this.displayedTracks,
    required this.displayedTracksPlayable,
    required this.status,
    required this.failure,
    required this.allTracks,
    required this.clearCache,
    // this.trackIdPassedToUrl,
    this.mouseClickedTrackId,
  });

  factory TrackState.initial() {
    return TrackState(
      displayedTracks: [],
      displayedTracksPlayable: [],
      status: TrackStatus.initial,
      failure: const Failure(),
      allTracks: [],
      clearCache: false,
      // trackIdPassedToUrl: null,
      mouseClickedTrackId: null,
    );
  }

  @override
  List<Object?> get props => [
        displayedTracks,
        displayedTracksPlayable,
        status,
        failure,
        allTracks,
        clearCache,
        displayedTracks,
        status,
        failure,
        // trackIdPassedToUrl,
        mouseClickedTrackId,
      ];

  TrackState copyWith({
    List<Track>? displayedTracks,
    List<Track>? displayedTracksPlayable,
    TrackStatus? status,
    Failure? failure,
    List<Track>? allTracks,
    bool? clearCache,
    Track? currentTrack,
    // String? trackIdPassedToUrl,
    String? mouseClickedTrackId,
  }) {
    return TrackState(
      displayedTracks: displayedTracks ?? this.displayedTracks,
      displayedTracksPlayable:
          displayedTracksPlayable ?? this.displayedTracksPlayable,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      allTracks: allTracks ?? this.allTracks,
      clearCache: clearCache ?? this.clearCache,
      // trackIdPassedToUrl: trackIdPassedToUrl ?? this.trackIdPassedToUrl,
      mouseClickedTrackId: mouseClickedTrackId ?? this.mouseClickedTrackId,
    );
  }
}
