part of 'artist_bloc.dart';

abstract class ArtistEvent extends Equatable {
  const ArtistEvent();

  @override
  List<Object?> get props => [];
}

class ArtistReset extends ArtistEvent {
  const ArtistReset();
}

class ArtistImageChanged extends ArtistEvent {
  const ArtistImageChanged({required this.image});
  final CroppedFile image;
}

class ArtistImageChangedOnWeb extends ArtistEvent {
  ArtistImageChangedOnWeb({required this.file, required this.pngByteData});
  PlatformFile file;
  Uint8List pngByteData;
}

class UsernameChanged extends ArtistEvent {
  UsernameChanged({required this.username});
  String username;
}

class BioChanged extends ArtistEvent {
  const BioChanged({required this.bio});
  final String bio;
}

class SubmitArtist extends ArtistEvent {
  const SubmitArtist();
}

class SubmitArtistOnWeb extends ArtistEvent {
  const SubmitArtistOnWeb();
}

class AddPurchasedBundle extends ArtistEvent {
  final Bundle purchasedBundle;

  const AddPurchasedBundle({required this.purchasedBundle});

  @override
  List<Object> get props => [purchasedBundle];
}

class LoadArtist extends ArtistEvent {
  final User viewer;
  final String? userId;

  const LoadArtist({required this.viewer, this.userId});

  @override
  List<Object?> get props => [viewer, userId];
}

class ArtistToggleUserSettings extends ArtistEvent {
  final User user;
  final String field;
  final bool value;

  const ArtistToggleUserSettings(
      {required this.user, required this.field, required this.value});

  @override
  List<Object> get props => [user, field, value];
}

class ArtistAddRemoveUserBundles extends ArtistEvent {
  final User user;
  final String bundleId;
  final bool value;

  const ArtistAddRemoveUserBundles({
    required this.user,
    required this.bundleId,
    required this.value,
  });

  @override
  List<Object> get props => [user, bundleId, value];
}

class ArtistAddRemoveUserBadges extends ArtistEvent {
  final User user;
  final String field;
  final bool value;

  const ArtistAddRemoveUserBadges(
      {required this.user, required this.field, required this.value});

  @override
  List<Object> get props => [user, field, value];
}

class ArtistUserPlusMinus extends ArtistEvent {
  final User user;
  final bool value;

  const ArtistUserPlusMinus({required this.user, required this.value});

  @override
  List<Object> get props => [user, value];
}

class ArtistChangeUsername extends ArtistEvent {
  final User user;
  final String newUsername;

  const ArtistChangeUsername({required this.user, required this.newUsername});

  @override
  List<Object> get props => [user, newUsername];
}
