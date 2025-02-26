import 'package:boxify/app_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Enum for th type of playlist (playlist, album, single, etc.)
enum PlaylistType {
  playlist,
  single,
}

class Playlist extends Equatable {
  List<String> trackIds;
  final String? id;
  final PlaylistType? type;
  String? description;
  final String? imageUrl; // for remote images
  final String? imageFilename; // for local images
  final String? name;
  final String? displayTitle;
  int total;
  int followerCount;
  final Timestamp? updated;
  final Timestamp? created;
  final Map<String, dynamic>? owner;
  bool isOwnPlaylist;
  bool isEditable;
  bool isFollowable;
  bool isRemoveable;
  bool isDeleteable;
  // bool isRiversOnly;
  int? score;
  int? sortScore; // will be lowered if you own it
  Color backgroundColor;
  String? year;
  List<String> roles;

  Playlist({
    this.trackIds = const [],
    this.id,
    this.name,
    this.type,
    this.displayTitle,
    this.imageUrl,
    this.imageFilename,
    this.total = 0,
    this.followerCount = 0,
    this.description,
    this.updated,
    this.created,
    this.owner,
    this.isOwnPlaylist = false,
    this.isEditable = false,
    this.isFollowable = false,
    this.isRemoveable = false,
    this.isDeleteable = false,
    // this.isRiversOnly = false,
    this.score,
    this.sortScore,
    this.backgroundColor = Colors.blue,
    this.year,
    this.roles = const [],
  });

  copyWith({
    String? id,
    String? name,
    String? displayTitle,
    PlaylistType? type,
    String? imageUrl,
    String? imageFilename,
    int? total,
    int? followerCount,
    String? description,
    Timestamp? updated,
    Timestamp? created,
    List<String>? trackIds,
    Map<String, dynamic>? owner,
    int? score,
    int? sortScore,
    bool? isOwnPlaylist,
    bool? isEditable,
    bool? isFollowable,
    bool? isDeleteable,
    // bool? isRiversOnly,
    // bool? isDownloadable,
    bool? isRemoveable,
    Color? backgroundColor,
    String? year,
    List<String>? roles,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      displayTitle: displayTitle ?? this.displayTitle,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFilename: imageFilename ?? this.imageFilename,
      total: total ?? this.total,
      description: description ?? this.description,
      updated: updated ?? this.updated,
      created: created ?? this.created,
      trackIds: trackIds ?? this.trackIds,
      owner: owner ?? this.owner,
      score: score ?? this.score,
      sortScore: sortScore ?? this.sortScore,
      followerCount: followerCount ?? this.followerCount,
      isOwnPlaylist: isOwnPlaylist ?? this.isOwnPlaylist,
      isEditable: isEditable ?? this.isEditable,
      isFollowable: isFollowable ?? this.isFollowable,
      isDeleteable: isDeleteable ?? this.isDeleteable,
      isRemoveable: isRemoveable ?? this.isRemoveable,
      // isRiversOnly: isRiversOnly ?? this.isRiversOnly,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      year: year ?? this.year,
      roles: roles ?? this.roles,
    );
  }

  @override
  List<Object?> get props => [
        trackIds,
        name,
        displayTitle,
        type,
        imageUrl,
        imageFilename,
        total,
        followerCount,
        description,
        updated,
        created,
        owner,
        isOwnPlaylist,
        isEditable,
        isFollowable,
        isRemoveable,
        isDeleteable,
        // isRiversOnly,
        score,
        sortScore,
        backgroundColor,
        year,
        roles,
      ];

  // THIS WAS WEEZIFY
  /// This is to parse the playlists data from firestore?
  /// Used on the profile screen?
  /// We need the userId to set `isEditable` etc.
  factory Playlist.fromDocument(DocumentSnapshot doc, String userId) {
    final data = doc.data()! as Map<String, dynamic>;
    data["id"] = doc.id; // add the id to the data
    final imageUrl = Utils.getUrlFromData(
        data, 'image'); // in firestore, playlists have an image field
    final owner = getOwner(data);
    final imageFilename =
        Utils.getImageFilenameFromData(data, field: 'imageFilename');

    return Playlist(
      id: doc.id,
      description: parsePlaylistDescription(data),
      type: PlaylistType.playlist,
      name: data['name'] ?? 'Gerb-Dance',
      displayTitle: parseName(data['name']),
      owner: owner,
      isOwnPlaylist: owner['id'] == userId,
      isEditable: getIsEditable(owner, userId),
      isFollowable: getIsFollowable(owner, userId),
      isDeleteable: data['isDeleteable'] ?? false,
      // isDownloadable: true,
      isRemoveable: data['isRemoveable'] ?? false,
      // isRiversOnly: data['name']?.contains('Rivers Only'),
      imageUrl: imageUrl,
      imageFilename: imageFilename,
      total: data['total'] ?? 0,
      trackIds: _getTracks(data),
      updated: data['updated'],
      followerCount: data['followerCount'] ?? 0,
      score: data['score'] ?? 0,
      sortScore: data['score'] ?? 0,
      created: data['created'],
      backgroundColor: getBackgroundColor(data),
      roles: getRoles(
        data,
      ),
    );
  }

  /// Returns a playlist parsed from a JSON object.
  /// Used ONLY by cache_helper.getPlaylists?
  /// The data is coming from the client's cache or from a freshly fetched firestore request.
  /// (note: playlists are not yet stored in and served from the rc server API)
  factory Playlist.fromJson(Map<String, dynamic> json, String userId) {
    /// is it here it's always coming back as boxify?
    /// even when it has a url in firebasestorage?
    final imageUrl = Utils.getUrlFromData(json, 'imageUrl');
    final imageFilename =
        Utils.getImageFilenameFromData(json, field: 'imageFilename');
    final owner = json['owner'] as Map<String, dynamic>;
    return Playlist(
      id: json['id'],
      description: parsePlaylistDescription(json),
      name: json['name'] ?? 'Gerb-Dance',
      displayTitle: parseName(json['name']),
      type: PlaylistType.playlist,
      owner: owner,
      imageUrl: imageUrl,
      imageFilename: imageFilename,
      total: json['total'] ?? 0,
      trackIds: _getTracks(json),
      updated: json['updated'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['updated'])
          : null,
      followerCount: json['followerCount'] ?? 0,
      score: json['score'] ?? 0,
      sortScore: json['score'] ?? 0,
      isOwnPlaylist: owner["id"] == userId,
      isEditable: getIsEditable(owner, userId),
      isDeleteable: json['isDeleteable'] ?? false,
      // isDownloadable: true,
      isFollowable: getIsFollowable(owner, userId),
      isRemoveable: json['isRemoveable'] ?? false,
      // isRiversOnly: json['name']?.contains('Rivers Only'),
      created: json['created'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['created'])
          : null,
      backgroundColor: getBackgroundColor(json),
      roles: getRoles(
        json,
      ),
    );
  }

  /// This is to parse the playlists data from firestore.
  /// Used by PlaylistRepository.fetchPlaylistsAdvanced()
  static Future<Playlist> fromDoc(DocumentSnapshot doc, String userId) async {
    final data = doc.data()! as Map<String, dynamic>;
    data["id"] = doc.id; // add the id to the data
    final imageUrl = Utils.getUrlFromData(data, 'image');
    final imageFilename =
        Utils.getImageFilenameFromData(data, field: 'imageFilename');
    final owner = data['owner'] ?? defaultPlaylistOwner;
    return Playlist(
      description: parsePlaylistDescription(data),
      id: doc.id,
      name: data['name'].toString(),
      displayTitle: parseName(data['name']),
      type: PlaylistType.playlist,
      owner: owner,
      isOwnPlaylist:
          data['owner'] != null ? data['owner']["id"] == userId : false,
      isEditable: getIsEditable(owner, userId),
      isFollowable: getIsFollowable(owner, userId),
      isDeleteable: data['isDeleteable'] ?? false,
      // isDownloadable: true,
      isRemoveable: data['isRemoveable'] ?? false,
      // isRiversOnly: data['name']?.contains('Rivers Only'),
      imageUrl: imageUrl,
      imageFilename: imageFilename,
      total: data['total'] ?? 0,
      trackIds: _getTracks(data),
      updated: data['updated'],
      created: data['created'],
      followerCount: data['followerCount'] ?? 0,
      score: data['score'] ?? 0,
      sortScore: data['score'] ?? 0,
      backgroundColor: getBackgroundColor(data),
      roles: getRoles(
        data,
      ),
    );
  }

  static List<String> getRoles(Map<String, dynamic> data) {
    // First check if roles are already stored in Firestore
    if (data.containsKey('roles') &&
        data['roles'] is List &&
        data['roles'].isNotEmpty) {
      return List<String>.from(data['roles']);
    } else if (data.containsKey('name')) {
      String name = data['name'].toString();
      
      // Split the path into components and normalize slashes
      List<String> pathComponents = name
          .replaceAll('\\', '/')  // Convert Windows backslashes to forward slashes
          .split('/')
          .where((s) => s.isNotEmpty)  // Remove empty strings
          .map((s) => s.toLowerCase())  // Normalize case
          .toList();
      
      // Remove 'demos' from the start if present
      if (pathComponents.isNotEmpty && pathComponents[0] == 'demos') {
        pathComponents.removeAt(0);
      }
      
      // Only generate the full path role if we have components
      if (pathComponents.isNotEmpty) {
        return [pathComponents.join('/')];
      }
    }
    
    return [];
  }

  static parsePlaylistDescription(Map<String, dynamic> data) {
    return data.containsKey('id') &&
            data['id'] != null &&
            data['id'] == Core.app.byThePeoplePlaylistId
        ? 'submitToWeezifyInstructions'.translate()
        : data.containsKey('description') && data['description'] != ''
            ? data['description']
            : Utils.getRandomFactFromId(data['id']);
  }

  /// This is to add to Firestore
  Map<String, dynamic> toDocument() {
    return {
      'tracks': trackIds,
      'id': id,
      'name': name,
      'displayTitle': displayTitle,
      'imageUrl': imageUrl,
      'imageFilename': imageFilename,
      'total': total,
      'followerCount': followerCount,
      'description': description,
      'updated': updated,
      'created': created,
      'owner': owner,
      'isOwnPlaylist': isOwnPlaylist,
      'isEditable': isEditable,
      'isFollowable': isFollowable,
      'isRemoveable': isRemoveable,
      'isDeleteable': isDeleteable,
      'backgroundColor': backgroundColor
          .value, // Convert Color to its integer (ARGB) representation
    };
  }

  // // For saving to firestore?
  // Map<String, dynamic> toDocument() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'displayTitle': displayTitle,
  //     'owner': owner,
  //     'imageUrl':
  //         imageUrl != Core.app.boxifyDefaultImageUrl ? imageUrl : null,
  //     'imageFilename': imageFilename,
  //     'total': total,
  //     'tracks': trackIds,
  //     'description': description,
  //     'updated': updated,
  //     'created': created,
  //   };
  // }

  static List<String> _getTracks(Map<String, dynamic> json) {
    List<String> trackIds = <String>[];

    if (json['tracks'] is Map) {
      if (json['tracks']['items3'] != null) {
        trackIds = (json['tracks']['items3'] as List)
            .where((item) => item != null)
            .map((item) => item.toString())
            .toList();
      }
    } else if (json['tracks'] is List) {
      trackIds = (json['tracks'] as List)
          .where((item) => item != null)
          .map((item) => item.toString())
          .toList();
    } else if (json['tracks'] == null) {
      trackIds = [];
    } else {
      logger.e('tracks is not a list or a map or null');
    }

    return trackIds;
  }

  String? _getImageUrl(imageUrl) {
    // no idea why this is happening
    if (imageUrl == 'assets/images/rc.png') {
      return Core.app.boxifyDefaultImageUrl;
    }
    if (imageUrl != Core.app.boxifyDefaultImageUrl) {
      return imageUrl!;
    }
    return null;
  }

  // Convert the Playlist instance to a JSON object
  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'description': description,
      'name': name,
      'displayTitle': displayTitle,
      'owner': owner,
      'imageUrl': _getImageUrl(imageUrl),
      'imageFilename': imageFilename,
      'total': total,
      'tracks': trackIds,
      'updated': updated?.millisecondsSinceEpoch,
      'followerCount': followerCount,
      'score': score,
      'isDeleteable': isDeleteable,
      'isRemoveable': isRemoveable,
      'roles': roles,  // Add roles to the JSON output
      'created': created?.millisecondsSinceEpoch,
    };
    return json;
  }

  static Map<String, dynamic> defaultPlaylistOwner = {
    'username': 'Rivers',
    'id': Core.app.rivers,
    'type': 'user',
    'profileImageUrl': Core.app.riversPicUrl,
  };

  static Playlist get empty => Playlist(
        id: '1',
        name: 'Empty Folder',
        displayTitle: 'Empty Folder',
        imageUrl: Core.app.boxifyPicUrl,
        imageFilename: Core.app.riversPicFilename,
        owner: defaultPlaylistOwner,
        isOwnPlaylist: false,
        isEditable: false,
        isFollowable: false,
        isDeleteable: false,
        // isDownloadable: false,
        isRemoveable: false,
        trackIds: [],
        total: 0,
        followerCount: 0,
        description:
            'Tell Rivers: Is it possible the user has a playlist ID with no corresponding playlist in the playlist table?',
        score: 0,
        sortScore: 0,
        updated: Timestamp.now(),
        created: Timestamp.now(),
      );
}

getOwner(Map<String, dynamic> data) {
  if (data.containsKey('owner')) {
    return data['owner'];
  } else {
    return Playlist.defaultPlaylistOwner;
  }
}

Color getBackgroundColor(data) {
  if (data.containsKey('backgroundColorValue') &&
      data['backgroundColorValue'] is int) {
    final storedColorValue =
        data['backgroundColorValue'] /* fetch from cache */;
    Color color = Color(storedColorValue); // Convert int back to Color
    return color;
  } else {
    return Utils.getColorFromId(data['id']);
  }
}
// /// This will have to be modified later in the load to check if all of the tracks are already downloaded
// bool getIsDownloadable(Map<String, dynamic> owner, String userId) => true;

bool getIsEditable(Map<String, dynamic> owner, String userId) =>
    Core.app.type != AppType.basic && owner['id'] == userId;

/// If it can be ever be followed. Does not account for already following the playlist
bool getIsFollowable(Map<String, dynamic> owner, String userId) =>
    Core.app.type != AppType.basic && owner['id'] != userId;
