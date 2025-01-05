/// shows a list of your own playlists you can add the track to.
/// fOR THE SEARCH SCREEN and the playlist screen (but just for a playlist that you don't own, because there's no delete function)
// AddToPlaylist,

/// for the playlist screen (for a playlist that youown, because there's a delete function)
/// shows a list of your own playlists you can add the track to and a delete button.
// AddToOrRemoveFromPlaylist,

/// In the left side large Nav panel. This deletes a playlist from library.
// OwnPlaylist,

/// In the large Nav panel. Add or Remove a playlist to or from library..
library;
// OthersPlaylist,

// SearchOthersPlaylist,

enum ContextMenuType {
  /// shows a list of your own playlists you can add the track to.
  /// fOR THE SEARCH SCREEN and the playlist screen (but just for a playlist that you don't own, because there's no delete function)
  AddToPlaylist,

  /// for the playlist screen (for a playlist that youown, because there's a delete function)
  /// shows a list of your own playlists you can add the track to and a delete button.
  AddToOrRemoveFromPlaylist,

  /// In the left side large Nav panel. This deletes a playlist from library.
  OwnPlaylist,

  /// In the large Nav panel. Add or Remove a playlist to or from library..
  OthersPlaylist,

  SearchOthersPlaylist,
}
