// Tracks the status of an asynchronous/lazy load operation.
// Used to signal whether a ressource (tracks, ratings, etc.) is available or not.
enum LoadStatus {
  /// The ressource is not available.
  notLoaded,

  /// The ressource is currently being loaded.
  loading,

  /// The ressource is available.
  loaded,

  /// Unable to load the ressource.
  error
}
