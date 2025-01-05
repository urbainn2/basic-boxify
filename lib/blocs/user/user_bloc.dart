import 'dart:async';
import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthBloc _authBloc;
  final UserRepository _userRepository;
  final TrackRepository _trackRepository;
  final CacheHelper _cacheHelper;
  final FirebaseFirestore _firebaseFirestore;

  UserBloc({
    required AuthBloc authBloc,
    required UserRepository userRepository,
    required TrackRepository trackRepository,
  })  : _authBloc = authBloc,
        _userRepository = userRepository,
        _trackRepository = trackRepository,
        _cacheHelper = CacheHelper(),
        _firebaseFirestore = FirebaseFirestore.instance,
        super(UserState.initial()) {
    // logger.f('UserBloc constructor ${state.hashCode}');

    on<LoadUser>((event, emit) async {
      // logger.f('UserBloc loaduser called on ${state.hashCode}');
      if (Core.app.type == AppType.advanced) {
        await _loadAdvancedUser(event, emit);
      } else {
        await _loadBasicUser(event, emit);
      }
    });
    on<InitialState>(_onInitialState);
    on<NewPlaylistCreated>(_onNewPlaylistCreated);
    on<UpdateRating>(_onUpdateRating);
    on<UserBundlePurchaseSuccess>(_onBundlePurchaseSuccess);
    on<BadUserPlaylistIdsFound>(_onBadUserPlaylistIdsFound);
  }

  Future<void> _onBadUserPlaylistIdsFound(
    BadUserPlaylistIdsFound event,
    Emitter<UserState> emit,
  ) async {
    logger.f('UserBloc: BadUserPlaylistIdsFound: ${event.badPlaylistIds}');

    if (state.user.isAnonymous) {
      logger.i('User is anonymous, so not updating playlistIds');
      return;
    }

    // Update the user's playlistIds with the newly purchased bundle.
    final updatedPlaylistIds = List<String>.from(state.user.playlistIds)
      ..removeWhere((element) => event.badPlaylistIds.contains(element));

    final updatedUser = state.user.copyWith(playlistIds: updatedPlaylistIds);

    _userRepository.updateUser(user: updatedUser);

    // Assuming this is synchronous, you can use a Future.value() to create a completed Future.
    return Future<void>.value(_cacheHelper.saveUser(updatedUser)).then((_) {
      // Emit the new state with the updated user
      emit(state.copyWith(user: updatedUser));
    }).catchError((e) {
      // You may want to handle any potential errors here
      logger.e('Error when processing BadUserPlaylistIdsFound event: $e');
    });
  }

  Future<void> _onInitialState(
    InitialState event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.initial());
  }

  Future<void> _loadBasicUser(
    LoadUser event,
    Emitter<UserState> emit,
  ) async {
    logger.i('_loadBasicUser');
    emit(state.copyWith(status: UserStatus.loading));

    final userId = _authBloc.state.user!.uid;

    if (event.clearCache == true) {
      await _userRepository.clearUserCache(userId);
      await _trackRepository.clearRatingsCache(userId);
    }

    try {
      final user = await _userRepository.getUserWithId(userId: userId);
      final ratings =
          await _trackRepository.getUserRatings(userId, _firebaseFirestore);

      emit(state.copyWith(
        user: user,
        ratings: ratings,
        status: UserStatus.loaded,
      ));
    } on NoConnectionException catch (e) {
      logger.e('NoConnectionException: $e');
      emit(state.copyWith(
        status: UserStatus.error,
        failure: Failure(
          message: e.message,
        ),
      ));
    } on DataFetchException catch (e) {
      logger.e('DataFetchException: $e');
      emit(state.copyWith(
        status: UserStatus.error,
        failure: Failure(
          message: e.message,
        ),
      ));
    } catch (e) {
      logger.e('An unexpected error occurred: $e');
      emit(state.copyWith(
        status: UserStatus.error,
        failure: Failure(
          message: 'An unexpected error occurred.',
        ),
      ));
    }
  }

  Future<void> _loadAdvancedUser(
    LoadUser event,
    Emitter<UserState> emit,
  ) async {
    logger.i('_loadAdvancedUser');
    emit(state.copyWith(status: UserStatus.loading));

    final userId = _authBloc.state.user!.uid;

    if (event.clearCache == true) {
      await _userRepository.clearUserCache(userId);
      await _trackRepository.clearRatingsCache(userId);
      await _userRepository.clearArtistsCache();
    }

    try {
      final user = await _userRepository.getUserWithId(userId: userId);
      final ratings =
          await _trackRepository.getUserRatings(userId, _firebaseFirestore);
      final allArtists = await _userRepository.getAllArtists();

      // Optionally sort the artists if needed
      allArtists.sort(
        (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()),
      );

      emit(state.copyWith(
        user: user,
        ratings: ratings,
        allArtists: allArtists,
        status: UserStatus.loaded,
      ));
    } on NoConnectionException catch (e) {
      logger.e('NoConnectionException: $e');
      emit(state.copyWith(
        status: UserStatus.error,
        failure: Failure(
          message: e.message,
        ),
      ));
    } on DataFetchException catch (e) {
      logger.e('DataFetchException: $e');
      emit(state.copyWith(
        status: UserStatus.error,
        failure: Failure(
          message: e.message,
        ),
      ));
    } catch (e) {
      logger.e('An unexpected error occurred: $e');
      emit(state.copyWith(
        status: UserStatus.error,
        failure: Failure(
          message: 'An unexpected error occurred.',
        ),
      ));
    }
  }

//   Future<void> _loadBasicUser(
//     LoadUser event,
//     Emitter<UserState> emit,
//   ) async {
//     logger.i('_loadBasicUser');
//     emit(state.copyWith(status: UserStatus.loading));

//     if (event.clearCache == true) {
//       _cacheHelper
//           .clearSpecific(CacheHelper.keyForUser(_authBloc.state.user!.uid));
//     }

//     final userId = _authBloc.state.user!.uid;

//     final user = await _userRepository.getUserWithId(userId: userId);

// // check for cached tracks first
//     final cachedRatings =
//         await _cacheHelper.getRatings(event.serverRatingsUpdated, userId);

//     // If there are cached ratings, use them
//     if (cachedRatings != null) {
//       logger.i('userBloc: there are cachedRatings, emitting loaded!');
//       emit(state.copyWith(
//         user: user,
//         ratings: cachedRatings,
//         status: UserStatus.loaded,
//         forceFetch: false,
//       ));
//       return;
//     }
//     logger.i('there are no cachedRatings !');

//     final ratings =
//         await _trackRepository.getUserRatings(user.id, _firebaseFirestore);
//     // Save the fetched tracks to cache
//     await _cacheHelper.saveRatings(ratings, _authBloc.state.user!.uid);

//     logger.i('_loadUser: Emitting UserStatus.loaded');
//     emit(
//       state.copyWith(
//         user: user,
//         ratings: ratings,
//         status: UserStatus.loaded,
//         forceFetch: false,
//       ),
//     );
//   }

  // Future<void> _loadAdvancedUser(
  //   LoadUser event,
  //   Emitter<UserState> emit,
  // ) async {
  //   logger.i(' _loadAdvancedUser');
  //   emit(state.copyWith(status: UserStatus.loading));

  //   logger.f('_loadAdvancedUser for uid ${_authBloc.state.user!.uid}');
  //   final s = Stopwatch()..start();

  //   User user;

  //   var timeLastFunctionFinished = 0.0;

  //   // // Compare the user IDs
  //   // final cachedUserId = await _cacheHelper.getUserIdOfCurrentCache();
  //   // final currentUserId = _authBloc.state.user!.uid;
  //   // final currentUserId = userIds['evangeline']!;

  //   if (event.clearCache == true) {
  //     _cacheHelper
  //         .clearSpecific(CacheHelper.keyForUser(_authBloc.state.user!.uid));
  //   }

  //   bool testForceFetch;
  //   kReleaseMode ? testForceFetch = false : testForceFetch = true;
  //   testForceFetch = false;

  //   // // When a user changes their account, clearing the cache ensures
  //   // // your app does not display old data from the previous account,
  //   // // or mix up data between accounts. This is especially important for preventing potential
  //   // // data leaks from one account to another, and ensuring a consistent user experience.
  //   // // As Weezify is predominately single-user, clearing the cache when switching accounts is a good practice.
  //   // final forceFetch = cachedUserId == null ||
  //   //     cachedUserId != currentUserId ||
  //   //     state.forceFetch == true ||
  //   //     testForceFetch == true;

  //   logger.i('forceFetch: ${event.clearCache}');

  //   final data = await loadData(
  //     _firebaseFirestore,
  //     _authBloc.state.user!.uid,
  //     forceFetch: event.clearCache,
  //     serverRatingsUpdated: event.serverRatingsUpdated,
  //   );

  //   user = data[0] as User;
  //   // // Save the current user ID in Hive
  //   // if (forceFetch) {
  //   //   await _cacheHelper.saveUser(user);
  //   // }
  //   // var tracks = data[1] ;
  //   // final allBundles = data[2] as List<Bundle>;
  //   // final allPlaylists = data[3] as List<Playlist>;
  //   final ratings = data[1] as List<Rating>;
  //   final allArtists = data[2] as List<User>;
  //   timeLastFunctionFinished =
  //       logDuration(s, timeLastFunctionFinished, 'loadData');

  //   allArtists.sort(
  //     (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()),
  //   );
  //   timeLastFunctionFinished =
  //       logDuration(s, timeLastFunctionFinished, 'allArtists.sort');

  //   // List<Playlist> followedPlaylists;

  //   // followedPlaylists =
  //   //     _playlistHelper.getFollowedPlaylists(user, allPlaylists);

  //   // // MARK bundles ISOWNED=true if user.bundleIds contains bundleId
  //   // for (final bundleId in Core.app.marketBundleIds) {
  //   //   if (user.bundleIds.contains(bundleId)) {
  //   //     Bundle? targetBundle =
  //   //         allBundles.firstWhereOrNull((e) => e.id == bundleId);
  //   //     if (targetBundle != null) {
  //   //       targetBundle.isOwned = true;
  //   //     }
  //   //   }
  //   // }
  //   // timeLastFunctionFinished =
  //   //     logDuration(s, timeLastFunctionFinished, 'MARK bundles ISOWNED=true');

  //   logger.i('_loadAdvancedUser: Emitting state with UserStatus.loaded');
  //   emit(
  //     state.copyWith(
  //       user: user,
  //       forceFetch: false,
  //       ratings: ratings,
  //       allArtists: allArtists,
  //       status: UserStatus.loaded,
  //     ),
  //   );
  // }

  Future<void> _onBundlePurchaseSuccess(
      UserBundlePurchaseSuccess event, Emitter<UserState> emit) {
    logger.i('UserBloc: BundlePurchaseSuccess: ${event.bundleId}');

    // Update the user's bundle IDs with the newly purchased bundle.
    final updatedBundleIds = List<String>.from(state.user.bundleIds)
      ..add(event.bundleId);

    final updatedUser = state.user.copyWith(bundleIds: updatedBundleIds);

    // Assuming this is synchronous, you can use a Future.value() to create a completed Future.
    return Future<void>.value(_cacheHelper.saveUser(updatedUser)).then((_) {
      // Emit the new state with the updated user
      emit(state.copyWith(user: updatedUser));
    }).catchError((e) {
      // You may want to handle any potential errors here
      logger.e('Error when processing BundlePurchaseSuccess event: $e');
    });
  }

  Future<void> _onNewPlaylistCreated(
    NewPlaylistCreated event,
    Emitter<UserState> emit,
  ) async {
    _userRepository.addUserPlaylist(state.user.id, event.playlist.id!,
        newLastPlaylistNumber: event.lastPlaylistNumber);

    final updateUserPlaylistIds = state.user.playlistIds
      ..insert(0, event.playlist.id!);

    final updateUser = state.user.copyWith(playlistIds: updateUserPlaylistIds);

    if (event.lastPlaylistNumber != null) {
      updateUser.lastPlaylistNumber = event.lastPlaylistNumber!;
    }

    CacheHelper().saveUser(updateUser);

    emit(state.copyWith(user: updateUser));
  }

  /// Handles the event of updating a track's rating, adding a new rating if the track is being rated for the first time.
  ///
  /// Parameters:
  /// - [event] UpdateRating event containing the track ID and the new rating value.
  /// - [emit] Function to emit new states.
  ///
  /// Emits a state indicating the updating process, followed by an updated state with the new rating or indicates an error.
  Future<void> _onUpdateRating(
    UpdateRating event,
    Emitter<UserState> emit,
  ) async {
    // Log the rating update attempt
    logger.i('saveRating${event.trackId}: ${event.value}');

    // Emit a state indicating that rating update is in process
    emit(state.copyWith(status: UserStatus.updatingRating));
    final trackId = event.trackId;

    // Emit a state to keep track of which track is being rated
    emit(state.copyWith(trackIdOfTrackBeingRated: trackId));

    // Update the rating in Firestore and handle possible errors
    bool firestoreUpdateSucceeded = await _updateFirestoreRating(
      trackId: trackId,
      rating: event.value,
    );
    if (!firestoreUpdateSucceeded) {
      // Stop execution if Firestore update failed
      return;
    }

    // Update the rating in the local state
    final ratings = state.ratings;
    final existingRatingIndex =
        ratings.indexWhere((rating) => rating.trackUuid == trackId);

    List<Rating> updatedRatings;
    if (existingRatingIndex != -1) {
      // Track already has a rating, so we update it
      updatedRatings = ratings.map((rating) {
        if (rating.trackUuid == trackId) {
          return rating.copyWith(value: event.value);
        }
        return rating;
      }).toList();
    } else {
      // Track is being rated for the first time, add a new rating entry
      final newRating = Rating(
          userId: _authBloc.state.user!.uid,
          trackUuid: trackId,
          value: event.value);
      updatedRatings = List.from(ratings)..add(newRating);
    }

    // Cache the updated ratings
    _cacheHelper.saveRatings(updatedRatings, _authBloc.state.user!.uid);

    // Emit the updated state with new ratings
    emit(state.copyWith(
        ratings: updatedRatings,
        trackIdOfTrackBeingRated: null,
        status: UserStatus.updatedRating));
  }

  Future<bool> _updateFirestoreRating(
      {required String trackId, required double rating}) async {
    try {
      await _trackRepository.updateRating(
        trackUuid: trackId,
        userId: _authBloc.state.user!.uid,
        value: rating,
      );
      return true;
    } catch (err) {
      logger.i('psb _updateRating error: $err');
      // ... Update state with error information as needed
      return false;
    }
  }

  /// Loads from cache or if cache is null, fetches data from the rc.com server
  /// or directly from Firestore.
  /// And saves it to the cache.
  /// User, tracks, bundles, playlists, ratings, and artists.
  Future<List<dynamic>> loadData(
    FirebaseFirestore firebaseFirestore,
    String userId, {
    bool forceFetch = false,
    DateTime? serverRatingsUpdated,
  }) async {
    logger.i('loadData for $userId with forceFetch = $forceFetch');
    User? cachedUser;
    // List<Track>? cachedTracks;
    // List<Bundle>? bundles;
    // List<Playlist>? playlists;
    List<Rating>? ratings;
    List<User>? artists;

    // forceFetch = true;
    // _cacheHelper.clearAll();
    // _cacheHelper.clearSpecific(CacheHelper.KEY_USER);

    // final serverTimestamps =
    //     await _metaDataRepository.getServerTimestamps(userId);

    // TODO
    // Fetch data from cache only if forceFetch is false
    if (!forceFetch) {
      // cachedUser = await _cacheHelper.getUser(serverUserUpdated!);
      // cachedTracks = await _cacheHelper.getTracks(serverTimestamps['tracks']!);
      // bundles = await _cacheHelper.getBundles();
      // // playlists = await _cacheHelper.fetchPlaylists(user!.id);
      ratings = await _cacheHelper.getRatings(userId);
      // artists = await _cacheHelper.getArtists(serverUsersUpdated!);

      // logger.i('loadData: got cache');
    }

    // For each data object (user, tracks, bundles, etc.), fetch it if it's null
    // (not in the cache or the cache is expired), otherwise, use the existing cached
    // value, and add it to the 'responses' list
    final responses = await Future.wait([
      // User
      _userRepository.getUserWithId(userId: userId),

      if (ratings == null)
        _trackRepository.getUserRatings(userId, firebaseFirestore)
      else
        Future.value(ratings),
      _userRepository.getAllArtists(),
    ]);
    logger.i('loadData: got responses');

    final User user;
    // final List<Track> tracks;

    user = responses[0] as User;
    // tracks = responses[1] ;

    if (cachedUser == null) {
      logger.i('no cachedUser!');

      // Save the fetched data to cache if it was not available
      await _cacheHelper.saveUser(user);
    } else {
      logger.i('there is a cachedUser!');
    }
    logger.i('user.username: ${user.username}');

    if (ratings == null) {
      ratings = responses[1] as List<Rating>;
      await _cacheHelper.saveRatings(ratings, _authBloc.state.user!.uid);
    }
    artists = responses[2] as List<User>;
    await _cacheHelper.saveArtists(artists);
    logger.i('_cacheHelper.saveArtists(artists)');

    return [user, ratings, artists];
  }
}
