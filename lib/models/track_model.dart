import 'package:boxify/app_core.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'track_model.g.dart'; // Generated file for the adapter

@HiveType(typeId: 0)
class Track extends Equatable {
  @HiveField(0)
  final String? databaseId;

  @HiveField(1)
  final String? uuid;

  @HiveField(2)
  String? link;

  @HiveField(3)
  String? downloadedUrl;

  @HiveField(4)
  String? bundleName;

  @HiveField(5)
  final String? artist;

  @HiveField(6)
  final String? imageUrl; // a remote url?

  @HiveField(7)
  final String? imageFilename;

  @HiveField(8)
  final String? userId;

  @HiveField(9)
  final String? username;

  @HiveField(10)
  final String? primarySortValue;

  @HiveField(11)
  final String? title;

  @HiveField(12)
  final String displayTitle;

  @HiveField(13)
  final int? sequence;

  @HiveField(14)
  final int? length;

  @HiveField(15)
  String? lyrics;

  @HiveField(16)
  final String? localpath;

  @HiveField(17)
  final int? year;

  @HiveField(18)
  final double? bpm;

  @HiveField(19)
  bool? newRelease;

  @HiveField(20)
  bool? available;

  @HiveField(21)
  final bool? explicit;

  @HiveField(22)
  final String? album;

  @HiveField(23)
  final String? folder;

  // @HiveField(24)
  // final String? releaseDate;

  @HiveField(25)
  final bool isRateable;

  @HiveField(26)
  final String? bundleId;

  @HiveField(27)
  final String? finalSongTitle;

  @HiveField(28)
  final double? fanRating;

  @HiveField(29)
  final int? fanRatingCount;

  @HiveField(30)
  double? userRating;

  @HiveField(31)
  Color backgroundColor;

  Track({
    this.databaseId,
    this.uuid,
    this.bundleName,
    this.link,
    this.downloadedUrl,
    this.title,
    required this.displayTitle,
    this.artist,
    this.userId,
    this.username,
    this.primarySortValue,
    this.imageUrl,
    this.imageFilename,
    this.lyrics,
    this.sequence,
    this.length,
    this.localpath,
    this.year,
    this.bpm,
    this.newRelease,
    this.available,
    this.explicit,
    this.album,
    this.folder,
    // this.releaseDate,
    this.isRateable = true,
    this.bundleId,
    this.finalSongTitle,
    this.fanRating,
    this.fanRatingCount,
    this.userRating,
    this.backgroundColor = Colors.grey,
  });

  @override
  List<Object?> get props => [
        databaseId,
        uuid,
        link,
        downloadedUrl,
        bundleName,
        artist,
        userId,
        username,
        primarySortValue,
        title,
        displayTitle,
        imageUrl,
        imageFilename,
        sequence,
        length,
        lyrics,
        localpath,
        year,
        bpm,
        newRelease,
        available,
        explicit,
        album,
        // RivifyTrack unique properties
        folder,
        // releaseDate,
        isRateable,
        // audioAssetPath,

        // Weezify Track unique properties
        bundleId,

        finalSongTitle,

        fanRating,
        fanRatingCount,
        userRating,
        backgroundColor,
      ];

  static Track empty = Track(
      databaseId: '',
      uuid: '',
      link: '',
      bundleName: '',
      downloadedUrl: '',
      title: '',
      displayTitle: '',
      artist: '',
      explicit: false,
      album: '',
      userId: '',
      username: '',
      primarySortValue: '',
      imageUrl: '',
      imageFilename: '',
      lyrics: '',
      sequence: 0,
      length: 0,
      localpath: '',
      year: 0,
      bpm: 0,
      newRelease: false,
      available: false,
      // RivifyTrack unique properties
      folder: '',
      // releaseDate: '',
      isRateable: true,
      // audioAssetPath: '',
      // Track Weezify unique properties
      bundleId: '',
      finalSongTitle: '',
      fanRating: 0,
      fanRatingCount: 0,
      userRating: 0,
      backgroundColor: Colors.grey);

  Track copyWith({
    String? databaseId,
    String? uuid,
    String? link,
    String? downloadedUrl,
    String? bundleName,
    bool? explicit,
    String? album,
    String? artist,
    String? userId,
    String? username,
    String? primarySortValue,
    String? title,
    required String displayTitle,
    String? imageUrl,
    String? imageFilename,
    int? sequence,
    int? length,
    String? lyrics,
    String? localpath,
    int? year,
    double? bpm,
    bool? newRelease,
    bool? available,
    // RivifyTrack unique properties
    String? folder,
    // String? releaseDate,
    bool? isRateable,
    // String? audioAssetPath,
    // Weezify Track unique properties
    String? bundleId,
    String? finalSongTitle,
    double? fanRating,
    int? fanRatingCount,
    double? userRating,
    Color? backgroundColor,
  }) {
    return Track(
      databaseId: databaseId ?? this.databaseId,
      uuid: uuid ?? this.uuid,
      link: link ?? this.link,
      bundleName: bundleName ?? this.bundleName,
      downloadedUrl: downloadedUrl ?? this.downloadedUrl,
      title: title ?? this.title,
      displayTitle: displayTitle,
      artist: artist ?? this.artist,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      primarySortValue: primarySortValue ?? this.primarySortValue,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFilename: imageFilename ?? this.imageFilename,
      lyrics: lyrics ?? this.lyrics,
      sequence: sequence ?? this.sequence,
      length: length ?? this.length,
      localpath: localpath ?? this.localpath,
      year: year ?? this.year,
      bpm: bpm ?? this.bpm,
      newRelease: newRelease ?? this.newRelease,
      available: available ?? this.available,
      explicit: explicit ?? this.explicit,
      album: album ?? this.album,
      // RivifyTrack unique properties
      folder: folder ?? this.folder,
      // releaseDate: releaseDate ?? this.releaseDate,
      isRateable: isRateable ?? this.isRateable,
      // audioAssetPath: audioAssetPath ?? this.audioAssetPath,
      // Weezify Track unique properties
      bundleId: bundleId ?? this.bundleId,
      finalSongTitle: finalSongTitle ?? this.finalSongTitle,
      fanRating: fanRating ?? this.fanRating,
      fanRatingCount: fanRatingCount ?? this.fanRatingCount,
      userRating: userRating ?? this.userRating,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  static double? _getFanRating(Map<String, dynamic> data) {
    if (data["fanRating"] != null) {
      return (data['fanRating'] is int)
          ? (data['fanRating'] as int).toDouble()
          : (data['fanRating'] as double);
    }
    return null;
  }

  /// Returns a [Track] from a Firestore [DocumentSnapshot].
  /// Def used in Rivify. Is it used in Weezify?
  factory Track.fromDocumentNoFuture(
    DocumentSnapshot doc, {
    String? Function(Map<String, dynamic>?)? artworkFactory,
  }) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return Track.empty;
    }
    final imageUrl = Utils.getUrlFromData(data, "imageUrl");
    final imageFilename = Utils.getImageFilenameFromData(data);
    final artistName = Utils.getArtistNameFromData(data);
    final bundleName = getBundleName(data);

    return Track(
        databaseId: doc.id,
        uuid: data["uuid"] ?? '',
        bundleName: bundleName,
        link: data['link'] ?? '',
        downloadedUrl: data['downloadedUrl'] ?? '',
        title: data['title'] ?? '',
        displayTitle: data['title'] ?? 'untitled',
        userId: data['userId'] ??
            Core.app
                .rivers, // If the track doesn't have a userId, give it Rivers' userId
        username: data['username'],
        primarySortValue: data['primarySortValue'] ?? '',
        artist: artistName,
        explicit: data['explicit'] ?? false,
        album: data['album'] ?? '',
        imageUrl: imageUrl,
        imageFilename: imageFilename,
        sequence: data['sequence'] ?? 0,
        length: data['length'] ?? 0,
        localpath: data['localpath'] ?? '',
        year: data['year'],
        bpm: data['bpm']?.toDouble(),
        newRelease: data['newRelease'] ?? false,
        available: _getAvailable(data),
        lyrics: data['lyrics'] ?? '',
        folder: data['folder'] ?? '',
        // releaseDate: getReleaseDate(data),
        isRateable: _getIsRateable(data),
        bundleId: data['bundleId'] ?? '',
        finalSongTitle: data['finalSongTitle'] ?? '',
        fanRating: data['fanRating']?.toDouble() ?? 0,
        fanRatingCount: data['fanRatingCount'] ?? 0,
        userRating: data['userRating']?.toDouble() ?? 0,
        backgroundColor: getBackgroundColor(data, bundleName));
  }

  /// ahh, this is for getting it from:
  /// 1. the flask server
  /// 2. the local cache
  ///
  /// Is used to create a `Track` instance from JSON data.
  ///
  /// Problematically, the JSON data may come from either the RC server or the local cache which may
  /// have slightly different parameter names, for example, the RC server uses 'bundle'
  /// whereas the local cache uses 'bundleName'.
  static Track fromJson(Map<String, dynamic> data) {
    final imageUrl = getImageUrlForTrack(data);
    final imageFilename =
        Utils.getImageFilenameFromData(data, field: 'imageFilename');
    final artistName = Utils.getArtistNameFromData(data);
    final bundleName = getBundleName(data);
    // logger.i("downloadedUrl: ${data['downloadedUrl']}");
    return Track(
        databaseId: data["id"] ?? '',
        uuid: data["uuid"] ?? '',
        link: data['link'] ?? '',
        downloadedUrl: data['downloadedUrl'] ?? '',
        album: data['album'] ?? '-',
        bundleId: data['bundleId'] ?? '',
        title: data['title'] ?? '',
        displayTitle: data['title'] ?? 'untitled',
        primarySortValue: data['primarySortValue'] ?? '',
        userId: data['userId'] ?? 'asEZOrKHjwZAGv69tUb1blQpwgo2',
        username: data['username'],
        artist: artistName,
        imageUrl: imageUrl,
        imageFilename: imageFilename,
        lyrics: data['lyrics'] ?? '',
        sequence: data['sequence'] ?? 0,
        length: data['length'] ?? 0,
        bundleName: bundleName,
        explicit: data['explicit'] ?? false,
        isRateable: _getIsRateable(data),
        available: _getAvailable(data),
        localpath: data['localpath'] ?? '',
        finalSongTitle: data['finalSongTitle'] ?? '',
        fanRating: _getFanRating(data),
        fanRatingCount: data["fanRatingsCount"],
        year: data['year'],
        bpm: data['bpm']?.toDouble(),
        newRelease: false,
        backgroundColor: getBackgroundColor(data, bundleName));
  }

  /// The tracks API has a "bundle" field, whereas the cache will be saving
  /// the bundle name as "bundleName".
  static getBundleName(Map<String, dynamic> data) {
    if (data.containsKey('bundleName') &&
        data['bundleName'].toString().isNotEmpty) {
      return data['bundleName'];
    } else if (data.containsKey('bundle')) {
      return data['bundle'];
    } else {
      return '';
    }
  }

  static Color getBackgroundColor(data, bundleName) {
    if (data.containsKey('backgroundColorValue') &&
        data['backgroundColorValue'] is int) {
      final storedColorValue =
          data['backgroundColorValue'] /* fetch from cache */;
      Color color = Color(storedColorValue); // Convert int back to Color
      return color;
    } else if (bundleName != null && bundleName.isNotEmpty) {
      return Utils.getColorFromId(bundleName);
    } else if (data['album'] != null && data['album'].isNotEmpty) {
      /// Rivify tracks have no bundleName, so we use the album name
      return Utils.getColorFromId(data['album']);
    }
    return Colors.grey;
  }

  static bool _getIsRateable(Map<String, dynamic> data) {
    if (Core.app.type == AppType.advanced) {
      return true;
    }
    try {
      // final album = data['album'] ?? '';
      // final folder = data['folder'] ?? '';
      final localpath = data['localpath'] ?? '';

      if (localpath.contains(Core.app.vetroPath)) {
        return false;
      }
      if (localpath.contains(Core.app.christmasPath)) {
        return false;
      }
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  // Convert Track object to JSON format. Used for saving to local cache
  // and thus its structure differs from what the rc.server sends.
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'link': link,
      'downloadedUrl': downloadedUrl,
      'album': album,
      'bundleId': bundleId,
      'imageFilename': imageFilename,
      'imageUrl': imageUrl,
      'title': title,
      'primarySortValue': primarySortValue,
      'userId': userId,
      'username': username,
      'artist': artist,
      'lyrics': lyrics,
      'sequence': sequence,
      'length': length,
      'bundleName': bundleName,
      'explicit': explicit,
      'available': available,
      'localpath': localpath,
      'finalSongTitle': finalSongTitle,
      'fanRating': fanRating,
      'fanRatingsCount': fanRatingCount,
      'year': year,
      'bpm': bpm,
      'newRelease': newRelease,
      'backgroundColor': backgroundColor
          .value, // Convert Color to its integer (ARGB) representation
    };
  }

  static String cleanUrl(String url) {
    if (url.contains('dl=0')) {
      url = url.replaceAll('dl=0', 'raw=1');
    }
    return url;
  }


/// Ensure releaseDate is in the format 'yyyy-MM-dd'
static String getReleaseDate(Map<String, dynamic> data) {
  String dateField = Core.app.type == AppType.advanced ? 
    'publicReleaseDate' : 'privateReleaseDate';

  // First try app-specific field
  if (data.containsKey(dateField) && data[dateField] != null) {
    var releaseDate = data[dateField];
    
    if (releaseDate is Timestamp) {
      return releaseDate.toDate().toIso8601String().substring(0, 10);
    }

    if (releaseDate is String && releaseDate.length == 10) {
      return releaseDate;
    }
  }
  
  // Fallback for cached data
  if (data.containsKey('privateReleaseDate') && data['privateReleaseDate'] != null) {
    var releaseDate = data['privateReleaseDate'];
    
    if (releaseDate is Timestamp) {
      return releaseDate.toDate().toIso8601String().substring(0, 10);
    }

    if (releaseDate is String && releaseDate.length == 10) {
      return releaseDate;
    }
  }

  return DateTime.now().toIso8601String().substring(0, 10);
}


  static bool _getAvailable(Map<String, dynamic> data) {
    if (Core.app.type == AppType.advanced) {
      // if (data['link'] is String && data['link'].contains('https://')) {
      if (data['link'] is String && data['link'].isNotEmpty) {
        return true;
      } else {
        // if (data['bundleId'] == "bu0QgWG8ILJw7afdqkvp") {
        //   logger.w('pd: ${data['link']}');
        // }
        return false;
      }
    } else {
      return true;
    }
  }
}
