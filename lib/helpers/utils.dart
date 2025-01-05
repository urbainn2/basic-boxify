import 'dart:io';
import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:boxify/data/background_colors.dart';
// import 'package:permission_handler/permission_handler.dart';

void info(Object o) {
  if (kDebugMode) logger.i(o);
}

/// Logs the runtime of a function.
void logRunTime(DateTime start, String functionName) {
  final end = DateTime.now();
  final difference = end.difference(start).inMilliseconds;
  final message = 'Time to $functionName: ${end.difference(start)}';
  if (difference > 1000) {
    logger.w(message);
  } else if (difference > 200) {
    logger.f(message);
  } else {
    logger.i(message);
  }
}

Logger logger = Logger(
  printer: PrettyPrinter(methodCount: 0, errorMethodCount: 3, excludeBox: {
    Level.info: true,
    // Level.debug: true,
    // Level.trace: true,
    // Level.warning: true,
    // Level.error: true,
    Level.fatal: true
  }),
);

class Utils {
  /// Returns the background color based on the given [id].
  ///
  /// The [id] is used to calculate the index of the background color
  /// from the [backgroundColors] list. If the index is negative, it is converted
  /// to a positive value. The calculated background color is then returned.
  static Color getColorFromId(String id) {
    int index = id.hashCode % backgroundColors.length;
    if (index < 0) index = -index;
    return backgroundColors[index];
  }

  static String getRandomFactFromId(String id) {
    int index = id.hashCode % RandomFacts.randomFacts.length;
    if (index < 0) index = -index;
    return RandomFacts.randomFacts[index];
  }

  static int? compareNumber(bool ascending, dynamic value1, dynamic value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  static int compareString(bool ascending, String? value1, String? value2) =>
      ascending ? value1!.compareTo(value2!) : value2!.compareTo(value1!);

  static List<String> convertDynamicsToStrings(List<dynamic>? listOfDynamics) {
    // logger.i('_getBundleIds');
    // logger.i(listOfDynamics);
    var listOfStrings = <String>[];

    if (listOfDynamics != null) {
      listOfStrings = listOfDynamics.map((b) => b.toString()).toList();
    }
    // logger.i(listOfStrings);

    return listOfStrings;
  }

  static double getScreenType(
    BuildContext context, {
    double? breakpoint,
  }) {
    breakpoint ??= Core.app.largeSmallBreakpoint;
    // MediaQueryData device;
    // device = MediaQuery.of(context);
    // final double screenType;
    // device.size.width < breakpoint ? screenType = .75 : screenType = 1;
    // return screenType;
    return 1;
  }

  /// Returns the image URL from the given [data] map.
  ///
  /// This method checks if the `image` key in the [data] map is not null and not
  /// an empty string. If the `image` key contains a valid URL, it replaces
  /// 'dropbox.com' with 'dl.dropboxusercontent.com' in the URL.
  ///
  /// If the `image` key is null or an empty string, it returns a default image URL.
  static String getUrlFromData(
    Map<String, dynamic> data,
    String field, {
    String? defaultUrl,
  }) {
    /// If you've passed in a defaultUrl, let's start with that.
    /// Otherwise, start with the defaultUrl from the constants file (rc head)
    String imageUrl = defaultUrl ?? Core.app.placeHolderImageUrl;

    /// If you've passed in a defaultUrl, let's start with that.
    if (defaultUrl != null) {
      imageUrl = defaultUrl;
    } else {
      /// Otherwise, start with the defaultUrl from the constants file
      imageUrl = Core.app.riversPicUrl;
    }

    /// Check the incoming data to see if a custom image is set.  If so, return that.
    if (data[field] != null && data[field].toString().isNotEmpty) {
      imageUrl = data[field];
    }

    /// Otherwise, check to see if the data has an 'owner'['profileImageUrl'] key.
    /// If so, use that.
    else if (data['owner'] != null &&
        data['owner']['profileImageUrl'] != null &&
        data['owner']['profileImageUrl'].toString().isNotEmpty) {
      imageUrl = data['owner']['profileImageUrl'];
    }

    imageUrl = sanitizeUrl(imageUrl);

    return imageUrl;
  }

  /// Sanitizes a Dropbox URL for direct file access.
  ///
  /// This method modifies the provided Dropbox URL to point directly to the file,
  /// bypassing the Dropbox preview page. It ensures compatibility with URLs containing 'www'
  /// and those without it by targeting the generic 'dropbox.com' domain for replacement.
  /// This approach is particularly useful for accessing media files (like images, audio,
  /// and video) or documents directly in applications that require the actual file content
  /// rather than a web page.
  ///
  /// The method replaces the domain 'www.dropbox.com' or 'dropbox.com' with
  /// 'dl.dropboxusercontent.com' and changes the query parameter 'dl=0'
  /// (which signifies a web page preview) to 'raw=1', indicating direct file access.
  ///
  /// Example:
  ///
  /// ```dart
  /// var originalUrl = "https://www.dropbox.com/s/examplefile?dl=0";
  /// var sanitizedUrl = sanitizeUrl(originalUrl);
  /// print(sanitizedUrl);  // Outputs: https://dl.dropboxusercontent.com/s/examplefile?raw=1
  /// ```
  ///
  /// @param url The original Dropbox URL to be sanitized for direct access.
  /// @returns A sanitized URL that points directly to the Dropbox file, suitable for direct download or media streaming.
  static String sanitizeUrl(String url) {
    return url
        .replaceAll(
            'https://www.dropbox.com', 'https://dl.dropboxusercontent.com')
        .replaceAll('https://dropbox.com',
            'https://dl.dropboxusercontent.com') // Handle URLs without 'www'
        .replaceAll('?dl=0', '?raw=1');
  }

  /// Returns the image filename from the given [data] map.
  /// For [Track]s, see also [assignPlaylistImageFilenameToTrack]
  /// which dynamically assigns the playlist image to the track when the track
  /// is being viewed from a [Playlist].
  static String? getImageFilenameFromData(Map<String, dynamic> data,
      {String field = "imageFilename", defaultFilename}) {
    /// If you've passed in a defaultUrl, let's start with that.
    /// Otherwise, start with the defaultUrl from the constants file (rc head)
    String imageFilename = defaultFilename ?? Core.app.placeHolderImageFilename;

    if (data.containsKey('bundleId') &&
        data['bundleId'] == Core.app.byThePeopleBundleId) {
      return null;
    }

    /// Check the incoming data to see if a custom imageFilename is set.
    /// If so, return that.
    else if (data.containsKey(field) &&
            data[field] != null &&
            data[field] != Core.app.placeHolderImageFilename

        /// Turned this back on trying to get user playlist images to show
        ) {
      imageFilename = data[field];
    }

    /// For advanced apps, try to map the playlist's associated bundleIds to
    /// local asset images for default playlists.
    else if (Core.app.type == AppType.advanced) {
      if (data.containsKey('id')) {
        imageFilename = _getImageFilenameForPlaylist(data, imageFilename);
      } else {
        imageFilename = _getImageFilenameForTrack(data, imageFilename);
      }
      if (imageFilename != Core.app.placeHolderImageFilename) {
        return imageFilename;
      }
    }

    /// Looks like in Firestore, [Track]s and [Playlist]s have an 'image' field.
    ///
    /// Just pulled this above the weezify block below for rivify.schneider.
    /// but i probably messed it up.
    ///
    /// Maybe there's a better way to do this.
    /// Schneider has the right value set for both of these. hmm.
    /// I want to prefer filename over imageFilename if they're the same.
    /// but image if imagefilename is default.
    else if (data.containsKey("image") &&
        data["image"] != null &&
        data["image"].toString().isNotEmpty) {
      return null;
    }

    /// But in the local cache, [Track]s and [Playlist]s have an 'imageUrl' field.
    /// So check for that too.
    else if (data.containsKey("imageUrl") &&
        data["imageUrl"] != null &&
        data["imageUrl"].toString().isNotEmpty) {
      return null;
    }

    /// If the filename does not start with 'assets/images/', add it.
    if (!imageFilename.startsWith('assets/images/')) {
      imageFilename = 'assets/images/$imageFilename';
    }

    /// Out of desperation, killing placeholder so I can see user playlist images
    if (imageFilename == Core.app.placeHolderImageFilename) {
      return null;
    }
    return imageFilename;
  }

  /// For Advanced [Playlist]s you can map playlistIds to local asset images
  static String _getImageFilenameForPlaylist(
      Map<String, dynamic> data, String imageFilename) {
    String playlistId = data["id"];

    if (Core.app.playlistIdToImageMap.containsKey(playlistId)) {
      imageFilename = Core.app.playlistIdToImageMap[playlistId]!;
    }

    return imageFilename;
  }

  /// For Advanced [Track]s you can map the playlist's associated bundleIds to
  /// local asset images.
  static String _getImageFilenameForTrack(
      Map<String, dynamic> data, String imageFilename) {
    String? bundleId = data["bundleId"];
    if (bundleId.toString().isNotEmpty) {
      if (Core.app.bundleIdToImageMap.containsKey(bundleId)) {
        imageFilename = Core.app.bundleIdToImageMap[bundleId]!;
      }
    }
    return imageFilename;
  }

  static String getArtistNameFromData(Map<String, dynamic> data,
      {defaultFilename = 'Rivers Cuomo'}) {
    /// If this is a btp track, use 'Unknown Artist' as the artist name if it's not set
    if (data['bundleId'] != null &&
        Core.app.byThePeopleBundleId == data['bundleId']) {
      defaultFilename = 'Unknown Artist';
    }

    String artistName;
    if (data.containsKey('artist') &&
        data['artist'] != null &&
        data['artist'].isNotEmpty) {
      artistName = data['artist'];
    } else if (data.containsKey('composer') &&
        data['composer'] != null &&
        data['composer'].isNotEmpty) {
      artistName = data['composer'];
    } else if (defaultFilename != null && defaultFilename.isNotEmpty) {
      artistName = defaultFilename;
    } else {
      artistName = 'Unknown Artist';
    }

    return artistName;
  }

  static Future showSheet(BuildContext context, WidgetBuilder builder) =>
      showModalBottomSheet(
        useRootNavigator: true,
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        context: context,
        builder: builder,
      );
}

Future<String> getAudioAssetPath(
  String userId,
  String uuid,
  String dropboxLink,
) async {
  if (kIsWeb) {
    return dropboxLink;
  } else if (Platform.isAndroid || Platform.isIOS) {
    final String dir = await findLocalPath(
        userId); // Ensure this function returns app-specific directory path for the logged-in user.
    final String filePath = '$dir/$uuid.mp3';

    if (await File(filePath).exists()) {
      return 'file:///$filePath';
    }
  }

  // If the file does not exist on device, return the Dropbox link for streaming
  return dropboxLink;
}

Future<String> findLocalPath(String userId) async {
  Directory directory;

  if (Platform.isAndroid || Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    throw UnsupportedError("Unsupported platform");
  }

  final String path =
      '${directory.path}${Platform.pathSeparator}Download${Platform.pathSeparator}$userId';
  final userDirectory = Directory(path);

  if (!await userDirectory.exists()) {
    try {
      await userDirectory.create(recursive: true);
    } catch (e) {
      print('Error creating user directory: $e');
    }
  }

  return userDirectory.path;
}

// /// Returns local storage path for downloaded files on mobile, a dropbox link for streaming, or (deprecated) a location within the app bundle
// Future<String> getAudioAssetPath(
//   // String localPath, String uuid, String dropboxLink) async {
//   String uuid,
//   String dropboxLink,
// ) async {
//   // logger.i('"$uuid", "$link"');
//   // final path = 'audio/$uuid.mp3';
//   // final syncPath = Uri.parse(path).toString();
//   if (kIsWeb) {
//     return dropboxLink;
//   }

//   /// If you're on android and the file has already been downloaded to the sd card
//   else if (Platform.isAndroid) {
//     const localPath = '/sdcard/download/';
//     final androidStorageLink = '$localPath/$uuid.mp3';
//     // logger.i('androidStorageLink: $androidStorageLink');
//     if (File(androidStorageLink).existsSync()) {
//       // logger.d('androidStorageLink exists');
//       return androidStorageLink;
//     } else {
//       // logger.i('file does not exist on device so returning dropboxLink: $dropboxLink');
//       return dropboxLink;
//     }
//   }

//   /// If you're on iOS and the file has already been downloaded to the sd card
//   else if (Platform.isIOS) {
//     var directory = await getApplicationDocumentsDirectory();
//     logger.i('directory=${directory.path}');
//     final iosStorageLink =
//         '${directory.path}${Platform.pathSeparator}Download/$uuid.mp3';
//     logger.i('iosstoragelink=$iosStorageLink');
//     if (File(iosStorageLink).existsSync()) {
//       logger.i('iosStorageLink exists');
//       return 'file:///$iosStorageLink';
//     } else {
//       logger.i('iosStoragelink DOESNT EXIST!!!!!!!!!!!!!!');
//       return dropboxLink;
//     }
//   }
//   // // Deprecated if you built the app with local asset audio files
//   // if (!kIsWeb && localAudioAssets.contains(syncPath) && !title.contains('cuomo')) {
//   // const base = 'asset:///';
//   //   logger.i('returning local asset: $base$syncPath');
//   //   return '$base$syncPath';
//   // }
//   else {
//     // Return the dropbox link for streaming
//     // logger.i('returning dropbox link: $link');
//     return dropboxLink;
//   }
// }

double logDuration(
  Stopwatch s,
  double timeLastFunctionFinished,
  String function,
) {
  final currentTotalTime = s.elapsedMilliseconds / 1000;
  final timeForThisFunction = currentTotalTime - timeLastFunctionFinished;
  if (timeForThisFunction > 1.0) {
    logger.w(
      'SLOW FUNCTION WARNING: $function took ${timeForThisFunction.toStringAsFixed(1)} (${currentTotalTime.toStringAsFixed(1)})',
    );
  }

  return currentTotalTime;
}

String printCustomDuration(int length) {
  final duration = Duration(seconds: length);
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitMinutes:$twoDigitSeconds';
}

bool isDownloaded(String? downloadedUrl) {
  return downloadedUrl != null && downloadedUrl.isNotEmpty;
  // return !link.startsWith('https') &&
  //     !link.startsWith('downloading') &&
  //     (link.isNotEmpty && link.length > 1);
}

/// Determines whether to skip a track based on the player state and track availability.
///
/// This function checks if the player is loaded, if the track isn't available,
/// if there are any selected tracks, and if a [Playlist] with tracks is present.
/// This is typically used when traversing through a playlist to skip over tracks
/// that are not available.
///
/// * `state`: The current player state from a [MyPlayerState] instance.
/// * `track`: The current track from a [Track] instance.
///
/// Returns [true] if the track should be skipped, otherwise [false].
bool skipUnavailableTrack(MyPlayerState state, Track track) {
  // final playlist = state.viewedPlaylist;
  return state.status == PlayerStatus.loaded &&
      track.available == false &&
      state.queue.isNotEmpty;
  //  &&
  // playlist.total! > 0;
}

int getCrossAxisCount(double screenWidth, {double breakpoint = 700.0}) {
  const base = 4;

  if (screenWidth < 400.0) {
    return base;
  }
  if (screenWidth < 550.0) {
    return base + 2;
  }
  if (screenWidth < breakpoint) {
    return base + 3;
  }
  if (screenWidth < 850.0) {
    return base + 4;
  } else {
    return base + 5;
  }
}

/// Returns the number of cross axis items for the given [screenWidth].
/// This is used for the [GridView] in the [MarketScreen].
int getCrossAxisCount2(double screenWidth, {double breakpoint = 700.0}) {
  const base = 1;

  if (screenWidth < 500.0) {
    return base;
  } else if (screenWidth < breakpoint) {
    return 2;
  } else if (screenWidth < 900.0) {
    return 3;
  } else if (screenWidth < 1100.0) {
    return base + 3;
  } else {
    return 5;
  }
}

/// This will divide the screenWidth by 200 and
/// return an integer value. Change this value
/// to increase or decrease the count.
/// [LibraryBody]
int getCrossAxisCount3(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width; // Get screen width

  // If you're in large screen format, with the left side nav panel open,
  // subtract the nav panel width, because that shouldn't count towards the
  // available width for the grid.
  if (screenWidth > Core.app.largeSmallBreakpoint) {
    screenWidth -= Core.app.navPanelWidth;
  }
  // // logger.d('screenWidth: $screenWidth');

  /// Currently necessary for market screen
  // if (screenWidth < 700.0) {
  //   return 1;
  // }

  int crossAxisCount = screenWidth ~/
      250; // This will divide the screenWidth by 200 and return an integer value. Change this value to increase or decrease the count.

  if (crossAxisCount < 2) {
    crossAxisCount = 2;
  }
  return crossAxisCount;
}

double getAspectRatio(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  // If you're in large screen format, with the left side nav panel open,
  // subtract the nav panel width, because that shouldn't count towards the
  // available width for the grid.
  if (screenWidth > Core.app.largeSmallBreakpoint) {
    screenWidth -= Core.app.navPanelWidth;
  }
  final double screenHeight = MediaQuery.of(context).size.height + 150;
  final double aspectRatio = screenWidth / screenHeight;
  logger.d('aspectRatio: $aspectRatio');
  return aspectRatio;
}

String parseName(String? name) {
  if (Core.app.type == AppType.advanced) {
    return name ?? '';
  }
  if (name == null) return '';

  final stringsToRemove = [
    // Core.app.collaboratorsPath,
    // Core.app.adminPath,
    // Core.app.weezerPath,
    r'\Rivers Only',
    r'\Tracks',
    r'\Demos',
    r'\Boxify',
  ];

  try {
    for (final string in stringsToRemove) {
      name = name!.replaceAll(string, '');
    }

    // replace a first leading slash with an empty string
    name = name!.replaceFirst(r'\', '');

    // replace all remaining slashes with a dash
    name = name.replaceAll(r'\', ': ').replaceAll('_', ' ');

    name = name.trim();
  } catch (e) {
    logger.e(e);
  }

  if (name == null || name.isEmpty) {
    return 'Unnamed';
  }

  return name;
}

Future<void> testUrls(List<String> urls) async {
  for (final url in urls) {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        logger.i('URL [$url] is valid.');
      } else {
        logger.i('URL [$url] is invalid. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error testing URL [$url]: $e');
    }
  }
}
