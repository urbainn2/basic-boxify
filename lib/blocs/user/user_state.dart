part of 'user_bloc.dart';

enum UserStatus {
  initial,
  loading,
  loaded,
  submitting,
  error,
  success,
  updated,
  updatedRating,
  updatingRating,
}

class UserState extends Equatable {
  final UserStatus status;
  final Failure failure;
  User user;
  bool forceFetch;
  List<User> allArtists;
  List<Rating> ratings;
  Bundle purchasedBundle;
  String? trackIdOfTrackBeingRated;

  UserState({
    required this.status,
    required this.failure,
    required this.user,
    required this.forceFetch,
    required this.allArtists,
    required this.purchasedBundle,
    required this.ratings,
    required this.trackIdOfTrackBeingRated,
  });

  factory UserState.initial() {
    return UserState(
      status: UserStatus.initial,
      failure: const Failure(),
      user: User.empty,
      forceFetch: false,
      allArtists: [User.empty],
      purchasedBundle: Bundle.empty,
      ratings: [],
      trackIdOfTrackBeingRated: '',
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        user,
        forceFetch,
        status,
        failure,
        user,
        allArtists,
        purchasedBundle,
        ratings,
        trackIdOfTrackBeingRated,
      ];

  UserState copyWith({
    UserStatus? status,
    Failure? failure,
    User? user,
    bool? forceFetch,
    List<User>? allArtists,
    int? userTrackCount,
    int? userBundleCount,
    int? bundleCount,
    Bundle? purchasedBundle,
    List<Rating>? ratings,
    String? trackIdOfTrackBeingRated,
  }) {
    return UserState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      user: user ?? this.user,
      forceFetch: forceFetch ?? this.forceFetch,
      allArtists: allArtists ?? this.allArtists,
      purchasedBundle: purchasedBundle ?? this.purchasedBundle,
      ratings: ratings ?? this.ratings,
      trackIdOfTrackBeingRated:
          trackIdOfTrackBeingRated ?? this.trackIdOfTrackBeingRated,
    );
  }

  // /// Define getter for Playlist.empty
  // static UserState get empty => UserState.initial();
}
