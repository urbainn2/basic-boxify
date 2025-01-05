part of 'download_bloc.dart';

enum DownloadStatus {
  initial, // The initial state before any download actions have commenced.
  preparing, // Preparing to start the download (ensuring network availability, etc.).
  downloading, // Download is in progress.
  pausing, // The download is in the process of pausing.
  paused, // The download has been paused.
  resuming, // The download is in the process of resuming.
  downloaded,
  undownloaded,
  removing, // New status to represent download removal.
  cancelled, // Download was cancelled by the user.
  error, // An error occurred during the download process.
  completed, // All downloads have been completed successfully (useful for batch downloads).
  syncingDownloads,
  syncingDownloadsCompleted,
}

class DownloadState extends Equatable {
  final DownloadStatus status;
  final Map<String, DownloadStatus> playlistDownloadStatus;
  final List<Track> tracksToDownload;
  final List<Track> tracksToUnDownload;
  final int downloadedCount; // Number of tracks successfully downloaded.
  final Map<String, Track>
      downloadedTracks; // Tracks that have been downloaded, keyed by their ID.
  final Map<String, double>
      downloadProgress; // Progress for individual tracks, keyed by their ID.
  final bool
      isDownloadCancelled; // Indicates if the download process was cancelled.
  final String?
      errorMessage; // Error message, if there was an error while downloading.
  // Add a new field to map track or playlist IDs to download task IDs.
  final Map<String, String> downloadTaskIds;

  DownloadState({
    required this.status,
    this.playlistDownloadStatus = const {},
    this.tracksToDownload = const [],
    this.tracksToUnDownload = const [],
    this.downloadedCount = 0,
    this.downloadedTracks = const {},
    this.downloadProgress = const {},
    this.isDownloadCancelled = false,
    this.errorMessage,
    this.downloadTaskIds = const {},
  });

  @override
  List<Object?> get props => [
        status,
        playlistDownloadStatus,
        tracksToDownload,
        tracksToUnDownload,
        downloadedCount,
        downloadedTracks,
        downloadProgress,
        isDownloadCancelled,
        errorMessage,
        downloadTaskIds,
      ];

  DownloadState copyWith({
    DownloadStatus? status,
    Map<String, DownloadStatus>? playlistDownloadStatus,
    List<Track>? tracksToDownload,
    List<Track>? tracksToUnDownload,
    int? downloadedCount,
    Map<String, Track>? downloadedTracks,
    Map<String, double>? downloadProgress,
    bool? isDownloadCancelled,
    String? errorMessage,
    Map<String, String>? downloadTaskIds,
  }) {
    return DownloadState(
      status: status ?? this.status,
      playlistDownloadStatus:
          playlistDownloadStatus ?? this.playlistDownloadStatus,
      tracksToDownload: tracksToDownload ?? this.tracksToDownload,
      tracksToUnDownload: tracksToUnDownload ?? this.tracksToUnDownload,
      downloadedCount: downloadedCount ?? this.downloadedCount,
      downloadedTracks: downloadedTracks ?? this.downloadedTracks,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      isDownloadCancelled: isDownloadCancelled ?? this.isDownloadCancelled,
      errorMessage: errorMessage ?? this.errorMessage,
      downloadTaskIds: downloadTaskIds ?? this.downloadTaskIds,
    );
  }

  DownloadState copyWithPlaylistStatus(
      {required String playlistId, required DownloadStatus status}) {
    final newPlaylistDownloadStatus =
        Map<String, DownloadStatus>.from(playlistDownloadStatus)
          ..[playlistId] = status;

    return copyWith(
      playlistDownloadStatus: newPlaylistDownloadStatus,
      // ... copy other fields if necessary ...
    );
  }

  factory DownloadState.initial() {
    return DownloadState(
      status: DownloadStatus.initial,
      playlistDownloadStatus: {},
    );
  }
}

extension DownloadStateExtensions on DownloadState {
  bool isTrackDownloading(String trackUuid) {
    final currentProgress = downloadProgress[trackUuid];
    return currentProgress != null && currentProgress < 1.0;
  }

  bool isTrackDownloaded(String trackUuid) {
    return downloadedTracks.containsKey(trackUuid) ||
        (downloadedTracks[trackUuid]?.downloadedUrl?.isNotEmpty ?? false);
  }

  double trackDownloadProgress(String trackUuid) {
    return downloadProgress[trackUuid] ?? 0.0;
  }
}
