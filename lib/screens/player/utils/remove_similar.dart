import 'package:boxify/app_core.dart';

List<Track> removeSimilar(List<Track> tracks) {
  // logger.i("removeSimilar()");
  // logger.i(tracks.length);
  final noFinalTitles = <Track>[];
  final uniques = <Track>[];

  for (final track in tracks) {
    // logger.i(track.title.toString() + track.finalSongTitle.toString());
    // If the track has no final song title
    // or if you haven't collected any uniques to compare it with yet
    // go ahead and add it to uniques
    if (track.finalSongTitle == '') {
      noFinalTitles.add(track);
    } else if (uniques.isEmpty) {
      uniques.add(track);
    } else if (isUnique(track, uniques)) {
      // logger.i("is unique");
      uniques.add(track);
    }
  }
  // logger.i(uniques.length);
  return uniques + noFinalTitles;
}

bool isUnique(Track track, List<Track> uniques) {
  for (final u in uniques) {
    // logger.i(u.finalSongTitle.toLowerCase());
    if (u.finalSongTitle!.toLowerCase() ==
        track.finalSongTitle?.toLowerCase()) {
      // logger.i('match!' +
      //     u.finalSongTitle!.toLowerCase() +
      //     track.finalSongTitle.toLowerCase());
      return false;
    }
  }
  return true;
}
