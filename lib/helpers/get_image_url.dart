import 'package:boxify/app_core.dart';

/// Returns the appropriate image URL for an artwork based on the provided [data].
///
/// While most use cases use [Utils.getUrlFromData], this function is used before calling that
/// one in the case of Weezify tracks, as they have a somewhat buried image URL.
///
/// If the input [data] contains 'By The People', it will attempt to get the image URL
/// from one of the following keys, in this order: 'profileImageUrl', 'artistImage',
/// 'image', 'bundleImage'. If none of these keys provide a valid URL, it will fall back
/// to the [Core.app.byThePeopleImageUrl] constant.
///
/// If the input [data] does not contain 'By The People', it will try to get the image URL
/// from the 'bundleImage' key, using the [funko] constant as the default fallback.
///
/// The function also replaces 'rc\\static\\funko.jpg' with [Core.app.byThePeopleImageUrl],
/// and 'dl=0' with 'raw=1' in the image URL.
///
/// Example usage:
///
/// - Get artwork image URL: `getArtwork(data)`
///
String getImageUrlForTrack(Map<String, dynamic> data) {
  String? imageUrl;

  final bundleName = data['bundle'];

  /// First, handle the case of tracks submitted by users,
  /// so-called 'By The People' tracks. Here you prefer profileImageUrl.
  if (isByThePeopleTrack(bundleName)) {
    /// First try
    imageUrl = Utils.getUrlFromData(
      data,
      'profileImageUrl',
      defaultUrl: Core.app.byThePeopleImageUrl,
    );
  } else {
    imageUrl = Utils.getUrlFromData(data, 'imageUrl',
        defaultUrl: Core.app.riversPicUrl);
  }

  return imageUrl;
}

bool isByThePeopleTrack(String? bundleName) {
  return bundleName != null &&
      bundleName.isNotEmpty &&
      bundleName == 'By The People';
}
