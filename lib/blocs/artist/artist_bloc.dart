import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:boxify/app_core.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';


part 'artist_event.dart';
part 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final UserRepository _userRepository;
  final PlaylistRepository _playlistRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;
  late final StreamSubscription marketBlocBlocSubscription;

  @override
  Future<void> close() {
    // marketBlocBlocSubscription.cancel();
    return super.close();
  }

  ArtistBloc({
    required UserRepository userRepository,
    required StorageRepository storageRepository,
    required PlaylistRepository playlistRepository,
    required AuthBloc authBloc,
    required MarketBloc marketBloc,
  })  : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _playlistRepository = playlistRepository,
        _authBloc = authBloc,
        super(ArtistState.initial()) {
    // marketBlocBlocSubscription = marketBloc.stream.listen((state) {
    //   // React to state changes here.
    //   // Add events here to trigger changes in MyBloc.
    //   if (state.purchasedBundle != Bundle.empty) {
    //     logger.i('ArtistBloc.purchasedBundle');
    //     add(AddPurchasedBundle(purchasedBundle: state.purchasedBundle));
    //   }
    // });
    on<ArtistReset>(_profileReset);
    // on<AddPurchasedBundle>(_addPurchasedBundle);
    on<LoadArtist>(_onloadArtist);
    on<ArtistAddRemoveUserBundles>(_profileAddRemoveUserBundles);
    on<ArtistAddRemoveUserBadges>(_mapArtistAddRemoveUserBadges);
    on<ArtistChangeUsername>(_mapArtistChangeUsername);
    on<ArtistToggleUserSettings>(_mapArtistToggleUserSettings);
    on<ArtistImageChanged>(profileImageChanged);
    on<ArtistImageChangedOnWeb>(profileImageChangedOnWeb);
    on<BioChanged>(bioChanged);
    on<SubmitArtist>(submitArtist);
    on<SubmitArtistOnWeb>(submitArtistOnWeb);
  }

  Future<void> _profileReset(
      ArtistReset event, Emitter<ArtistState> emit) async {
    emit(ArtistState.initial());
  }

  Future<void> _onloadArtist(
    LoadArtist event,
    Emitter<ArtistState> emit,
  ) async {
    logger.i('ArtistBloc received _onloadArtist');
    emit(state.copyWith(status: ArtistStatus.loading));

    final userId = event.userId ?? _authBloc.state.user!.uid;
    if (_authBloc.state.user == null) {
      logger.i(
        'artistBloc.loadUser: still no authenticated authbloc user so emiting status: ArtistStatus.loading',
      );
      emit(state.copyWith(status: ArtistStatus.loading));
    } else {
      logger.i(
        'authenticated authbloc user so emiting loading user to profile state',
      );

      final viewer = event.viewer;
      final isCurrentUser = viewer.id == userId;

      final user = isCurrentUser
          ? viewer
          : await _userRepository.getUserWithId(
              userId: userId,
            );

      var allBundles = <Bundle>[];
      var userBundles = <Bundle>[];
      List<MyBadge>? userBadges;

      if (Core.app.type == AppType.advanced) {
        try {
          allBundles = await _userRepository.getBundlesApi();
        } catch (err) {
          logger.i('artist_bloc _onloadArtist $err');
          emit(
            state.copyWith(
              status: ArtistStatus.error,
              failure: Failure(
                message:
                    '$err. _userRepository.getBundlesApi. So I was unable to load your bundles in pbloc. The flask server might have crashed. view heroku logs.',
              ),
            ),
          );
        }

        try {
          allBundles = await _userRepository.getBundlesApi();
        } catch (err) {
          logger.i('artist_bloc _onloadArtist $err');
          emit(
            state.copyWith(
              status: ArtistStatus.error,
              failure: Failure(
                message:
                    '$err. _userRepository.getBundlesApi. So I was unable to load your bundles in pbloc. The flask server might have crashed. view heroku logs.',
              ),
            ),
          );
        }
        // MARK bundle.ISOWNED
        for (final bundleId in Core.app.marketBundleIds) {
          if (state.user.bundleIds.contains(bundleId)) {
            final myListFiltered = allBundles.where((e) => e.id == bundleId);
            if (myListFiltered.isNotEmpty) {
              allBundles.firstWhere((bundle) => bundle.id == bundleId).isOwned =
                  true;
            }
          }
        }

        userBundles = allBundles
            .where((i) => user.bundleIds.contains(i.id.toString()))
            .toList();
        userBundles.isNotEmpty
            ? userBundles
                .sort((a, b) => Utils.compareString(true, a.years, b.years))
            : null;

        try {
          user.badges.isNotEmpty
              ? userBadges = badges
                  .where((element) => user.badges.contains(element.title))
                  .toList()
              : userBadges = [];
        } catch (err) {
          logger.i('artist_bloc _onloadArtist2 $err');
          emit(
            state.copyWith(
              status: ArtistStatus.error,
              failure: const Failure(
                message:
                    'Drat. I couldnt get your badges in pbloc. The flask server might have crashed. view heroku logs.',
              ),
            ),
          );
        }
      }

      // userPlaylists
      final userPlaylists =
          await _playlistRepository.fetchUserPlaylists(user.id);

      logger.i('done with loadArtist, emitting state with loaded');
      emit(
        state.copyWith(
          user: user,
          allBundles: allBundles,
          bundles: userBundles,
          userPlaylists: userPlaylists,
          badges: userBadges,
          viewer: viewer,
          isCurrentUser: isCurrentUser,
          status: ArtistStatus.loaded,
        ),
      );
    }
  }

  Future<void> _mapArtistToggleUserSettings(
    ArtistToggleUserSettings event,
    Emitter<ArtistState> emit,
  ) async {
    emit(state.copyWith(status: ArtistStatus.loading));
    final userId = event.user.id;
    logger.i('_mapArtistToggleUserSettings $userId');
    logger.i(state.user.id == userId);
    await _userRepository.toggleUserSetting(
      field: event.field,
      user: event.user,
      value: event.value,
    );

    final user = await _userRepository.getUserWithId(userId: userId);
    CacheHelper().saveUser(user);

    emit(
      state.copyWith(
        user: user,
        status: ArtistStatus.loaded,
      ),
    );
  }

  Future<void> _profileAddRemoveUserBundles(
    ArtistAddRemoveUserBundles event,
    Emitter<ArtistState> emit,
  ) async {
    // Add logger.i statements to debug
    logger
      ..i('Before updating state:')
      ..i(state.user);
    emit(state.copyWith(status: ArtistStatus.loading));
    final userId = event.user.id;
    logger.i('_profileAddRemoveUserBundles $userId');
    logger.i(state.user.id == userId);
    await _userRepository.addRemoveUserBundles(
      user: event.user,
      bundleId: event.bundleId,
      switchOff: event.value,
    );

    final user = await _userRepository.getUserWithId(userId: userId);

    for (final bundleId in Core.app.marketBundleIds) {
      if (state.user.bundleIds.contains(bundleId)) {
        final myListFiltered = state.allBundles.where((e) => e.id == bundleId);
        if (myListFiltered.isNotEmpty) {
          state.allBundles
              .firstWhere((bundle) => bundle.id == bundleId)
              .isOwned = true;
        }
      }
    }
    var userBundles = <Bundle>[];
    userBundles = state.allBundles
        .where((i) => user.bundleIds.contains(i.id.toString()))
        .toList();
    userBundles.isNotEmpty
        ? userBundles
            .sort((a, b) => Utils.compareString(true, a.years, b.years))
        : null;
    CacheHelper().saveUser(user);
    emit(
      state.copyWith(
        user: user,
        allBundles: state.allBundles,
        bundles: userBundles,
        status: ArtistStatus.loaded,
      ),
    );
  }

  Future<void> _mapArtistAddRemoveUserBadges(
    ArtistAddRemoveUserBadges event,
    Emitter<ArtistState> emit,
  ) async {
    emit(state.copyWith(status: ArtistStatus.loading));
    await _userRepository.addRemoveUserBadges(
      user: event.user,
      badge: event.field,
      switchOff: event.value,
    );
    final user = await _userRepository.getUserWithId(userId: event.user.id);
    var userBadges = <MyBadge>[];
    userBadges = badges.where((i) => user.badges.contains(i.title)).toList();
    CacheHelper().saveUser(user);
    emit(
      state.copyWith(
        user: user,
        badges: userBadges,
        status: ArtistStatus.loaded,
      ),
    );
  }

  Future<void> _mapArtistChangeUsername(
    ArtistChangeUsername event,
    Emitter<ArtistState> emit,
  ) async {
    emit(state.copyWith(status: ArtistStatus.loading));
    await _userRepository.changeUsername(
      user: event.user,
      newUsername: event.newUsername,
    );

    final user = await _userRepository.getUserWithId(userId: event.user.id);
    CacheHelper().saveUser(user);

    emit(
      state.copyWith(
        user: user,
        status: ArtistStatus.loaded,
      ),
    );
  }

  void profileImageChanged(
    ArtistImageChanged event,
    Emitter<ArtistState> emit,
  ) {
    final image = event.image;
    final imageFile = File(image.path); // convert CroppedFile to File
    emit(
      state.copyWith(profileImage: imageFile, status: ArtistStatus.initial),
    );
  }

  void profileImageChangedOnWeb(
    ArtistImageChangedOnWeb event,
    Emitter<ArtistState> emit,
  ) {
    // emit(
    //   state.copyWith(status: ArtistStatus.loading),
    // );
    final file = event.file;
    final pngByteData = event.pngByteData;
    logger.i('profileImageChangedOnWeb for ${state.user.username}');
    logger.i('emitting file ${file.name}');
    logger.i('emitting pngbytedata ${pngByteData.sublist(0, 10).toString()}');
    emit(
      state.copyWith(
        profileImageOnWeb: file,
        pngByteData: pngByteData,
        // status: ArtistStatus.loaded,
      ),
    );
  }

  void bioChanged(BioChanged event, Emitter<ArtistState> emit) {
    final bio = event.bio;
    emit(
      state.copyWith(bio: bio),
    );
  }

  Future<void> submitArtist(
    SubmitArtist event,
    Emitter<ArtistState> emit,
  ) async {
    logger.i('pbloc submitArtist');
    logger.i(state.bio.toString());
    emit(state.copyWith(status: ArtistStatus.submitting));
    try {
      final user = state.user;
      var profileImageUrl = user.profileImageUrl;
      // logger.i(user);
      // logger.i(profileImageUrl);

      if (state.profileImage != null) {
        profileImageUrl = await _storageRepository.uploadArtistImage(
          url: profileImageUrl,
          image: state.profileImage!,
        );
      }
      // logger.i(profileImageUrl);

      final updatedUser = user.copyWith(
        username: user.username,
        bio: state.bio,
        profileImageUrl: profileImageUrl,
      );
      logger
        ..i(updatedUser)
        ..i(updatedUser.bio);

      await _userRepository.updateUser(user: updatedUser);
      CacheHelper().saveUser(updatedUser);

      logger.i('emitting success');
      emit(state.copyWith(status: ArtistStatus.success, user: updatedUser));
      logger.i(state.user.bio);
    } catch (err) {
      logger.i('profilebloc.submitArtist: $err');
      emit(
        state.copyWith(
          status: ArtistStatus.error,
          failure: const Failure(
            message: 'I was unable to update your profile.',
          ),
        ),
      );
    }
  }

  Future<void> submitArtistOnWeb(
    SubmitArtistOnWeb event,
    Emitter<ArtistState> emit,
  ) async {
    logger.i('submitArtistOnWeb');
    emit(state.copyWith(status: ArtistStatus.submitting));
    final user = state.user;
    logger.i(state.pngByteData!.sublist(0, 10));
    try {
      final profileImageUrl = await _storageRepository.uploadArtistImageOnWeb(
        pngByteData: state.pngByteData!,
      );
      final updatedUser = user.copyWith(
        username: user.username,
        bio: user.bio,
        profileImageUrl: profileImageUrl,
      );
      logger.i(updatedUser);
      await _userRepository.updateUser(user: updatedUser);
      CacheHelper().saveUser(updatedUser);
      emit(state.copyWith(status: ArtistStatus.success, user: updatedUser));
    } catch (err) {
      emit(
        state.copyWith(
          status: ArtistStatus.error,
          failure: const Failure(
            message:
                'billions of blistering blue barnacles. I was unable to update your thingie.',
          ),
        ),
      );
    }
  }
}
