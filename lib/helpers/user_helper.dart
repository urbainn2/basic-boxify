import 'package:boxify/app_core.dart';

class UserHelper {
  UserHelper();

  /// Returns [bundleCount, trackCount, userBundleCount, userTrackCount]
  /// to display the counts at the top of the Market screen.
  List<int> calculateCounts(User user, List<Bundle> allBundles) {
    final bundleCount = allBundles.length;
    var trackCount = 0;
    var userTrackCount = 0;
    for (final bundle in allBundles) {
      trackCount += bundle.count!;
      if (user.bundleIds.contains(bundle.id)) {
        userTrackCount += bundle.count!;
      }
    }
    final userBundleCount = user.bundleIds
        .where((element) => !Core.app.badBundleIds.contains(element))
        .toList()
        .length;
    return [bundleCount, trackCount, userBundleCount, userTrackCount];
  }

  /// Returns true if the user is authenticated and email is verified and
  /// the user's username is not set, it still has the default value of 'Lurker'.
  bool settingUsername(AuthState state, User user) {
    final settingUsername = state.user?.email != null &&
        state.user?.emailVerified == true &&
        user.username == 'Lurker';
    return settingUsername;
  }

  /// Returns true if the user is authenticated and email is not verified.
  bool verifyingEmail(AuthState state) =>
      state.user?.email != null && state.user?.emailVerified == false;
}
