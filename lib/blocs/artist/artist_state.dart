part of 'artist_bloc.dart';

enum ArtistStatus {
  initial,
  loading,
  loaded,
  error,
  submitting,
  submitted,
  success
}

class ArtistState extends Equatable {
  final User user;
  final User viewer;
  final List<Bundle> bundles;
  final List<MyBadge> allBadges;
  final List<Playlist> userPlaylists;
  final List<MyBadge> badges;
  final bool isCurrentUser;
  final bool isGridView;
  final bool isFollowing;
  final ArtistStatus status;
  final Failure failure;
  final int index;
  final bool value;
  final bool chatPhoto;
  final File? profileImage;
  final PlatformFile? profileImageOnWeb;
  final Uint8List? pngByteData;
  final String? bio;

  const ArtistState({
    required this.user,
    required this.viewer,
    required this.bundles,
    required this.allBadges,
    required this.userPlaylists,
    required this.badges,
    required this.isCurrentUser,
    required this.isGridView,
    required this.isFollowing,
    required this.status,
    required this.failure,
    required this.index,
    required this.value,
    required this.chatPhoto,
    required this.profileImage,
    required this.profileImageOnWeb,
    required this.pngByteData,
    required this.bio,
  });

  factory ArtistState.initial() {
    return ArtistState(
      user: User.empty,
      viewer: User.empty,
      bundles: [],
      allBadges: [],
      userPlaylists: [],
      badges: [],
      isCurrentUser: false,
      isGridView: false,
      isFollowing: true,
      status: ArtistStatus.initial,
      failure: Failure(),
      index: 0,
      value: true,
      chatPhoto: true,
      profileImage: null,
      profileImageOnWeb: null,
      pngByteData: null,
      bio: null,
    );
  }

  @override
  List<dynamic> get props => [
        user,
        viewer,
        bundles,
        allBadges,
        userPlaylists,
        badges,
        isCurrentUser,
        isGridView,
        isFollowing,
        status,
        failure,
        index,
        value,
        chatPhoto,
        profileImage,
        profileImageOnWeb,
        pngByteData,
        bio,
      ];

  ArtistState copyWith({
    User? user,
    User? viewer,
    List<Bundle>? bundles,
    List<MyBadge>? badges,
    List<MyBadge>? allBadges,
    List<Playlist>? userPlaylists,
    bool? isCurrentUser,
    bool? isGridView,
    bool? isFollowing,
    ArtistStatus? status,
    Failure? failure,
    int? index,
    bool? value,
    bool? chatPhoto,
    File? profileImage,
    PlatformFile? profileImageOnWeb,
    Uint8List? pngByteData,
    String? bio,
  }) {
    return ArtistState(
      user: user ?? this.user,
      viewer: viewer ?? this.viewer,
      bundles: bundles ?? this.bundles,
      allBadges: allBadges ?? this.allBadges,
      userPlaylists: userPlaylists ?? this.userPlaylists,
      badges: badges ?? this.badges,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isGridView: isGridView ?? this.isGridView,
      isFollowing: isFollowing ?? this.isFollowing,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      index: index ?? this.index,
      value: value ?? this.value,
      chatPhoto: chatPhoto ?? this.chatPhoto,
      profileImage: profileImage ?? this.profileImage,
      profileImageOnWeb: profileImageOnWeb ?? this.profileImageOnWeb,
      pngByteData: pngByteData ?? this.pngByteData,
      bio: bio ?? this.bio,
    );
  }
}
