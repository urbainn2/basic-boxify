import 'dart:math';
import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// [BaseApp] serves as an abstract foundation class that outlines shared
/// functionalities necessary for various app implementations. It includes
/// features like shared preferences management, supported languages, theme
/// styles, UI configurations, lifecycle event handling, and logging utilities.
///
/// Subclasses should override and provide specific implementations for
/// those functionalities that vary between different app versions.
///
/// Example usage of subclasses inheriting BaseApp:
/// class App extends BaseApp {
///   // Specialized implementation for a specific app version goes here...
/// }
class BaseApp {
  String serverToken = '';
  String androidApiKey = '';
  String iosApiKey = '';

  // Sizes
  double appBarHeight = 75;
  double largeScreenRowHeight = 60;
  double playerHeight = 95;
  double smallPlayerHeight = 60;
  double libraryPanelWidth = 350;
  double navPanelWidth = 350;
  double smallRowImageSize = 50;
  double titleFontSize = 15;
  double subtitleFontSize = 13;
  double signInBoxWidth = 500;
  double largeSmallBreakpoint = 660;

  BasePrefs get prefs => BasePrefs();

  String _version = '';
  String _buildNumber = '';
  String name = '';
  AppType type = AppType.basic;
  String get appVersion =>
      _version.isNotEmpty ? '$_version ($_buildNumber)' : '';
  String get displayAppVersion => appVersion;
  var restartKey = ValueNotifier<Key>(UniqueKey());
  var restarting = false;
  final DateTime _appStarted = DateTime.now();
  Duration get startupElapsed => DateTime.now().difference(_appStarted);

  // User Ids
  String rivers = '';

  String collaboratorsPath = '';
  String weezerPath = '';
  String pinkAlbumPath = ''; // Deprecated (renamed to weezer)
  String adminPath = '';
  String vetroPath = '';
  String christmasPath = '';

  // BUNDLE IDS
  String bestOfTheDemosBundleId = '43';
  // String blackRoomBundleId = '37';
  String bluePinkertonBundleId = '36';
  String byThePeopleBundleId = '1Vxg8FUzbxR4hFItNB6x';
  String greenBundleId = '38';
  String ewbaiteBundleId = '34';
  String makeBelieveBundleId = '42';
  // String maladroitBundleId = '39';
  String pacificDaydreamBundleId = 'bu0QgWG8ILJw7afdqkvp';
  String patrickAndRiversBundleId = '45';
  String pianoBundleId = 'Ar83xHQd7YDRFL6EXIw2';
  String preWeezerBundleId = '35';
  String redRadHurleyBundleId = '40';
  String weezmaBundleId = '48';
  String whiteBundleId = '30';
  String blackAlbumBundleId = 'Xuq6DptPbiXebElzip99';
  String sznzBundleId = 'K8B5vBaQJnck9aoSAZ1b';
  String vanWeezerBundleId = 'qki8QLSg7m8W6yVyD1OO';
  String okHumanBundleId = 'CZnb2XGfNUSPYA5izsg1';

  List<String> get marketBundleIds => [
        whiteBundleId,
        ewbaiteBundleId,
        preWeezerBundleId,
        bluePinkertonBundleId,
        // blackRoomBundleId,
        greenBundleId,
        // maladroitBundleId,
        redRadHurleyBundleId,
        makeBelieveBundleId,
        // bestOfTheDemosBundleId,
        // '44',
        patrickAndRiversBundleId,
        // '47',
        weezmaBundleId,
        pacificDaydreamBundleId,

        blackAlbumBundleId,
        sznzBundleId,
        okHumanBundleId,
        vanWeezerBundleId,
      ];

  /// meaning not for the market????
  List<String> get badBundleIds => [
        '51',
        '53',
        '50',
        byThePeopleBundleId,
        pianoBundleId,
      ];

// PLAYLIST IDs
// If you add any new default playlist ids, make sure to add them to bestOfPlaylistIds
// so that new users will automatically get them.
// see also one time function add_default_playlists_to_users in playlists_routine.py
// to add a new playlist to all users

  // String blackRoomPlaylistId = 'MQBGdQNW21xjvazu26Oy';
  String bluePinkertonPlaylistId = 'ImAlVo9CSrGXgaBPpXo3';
  String byThePeoplePlaylistId = 'BOvQOnRqJmgLJJjWYWbg';
  String greenPlaylistId = 'gBSq42uaUs64vPfYc7DQ';
  String highestRatedPlaylistId = '6C7GjLWSQKvvTco33Sfz'; // Should be added by userrepo when a user signs up as part of Core.app.defaultPlaylistIds
  String ewbaitePlaylistId = 'llpm2LkFjw8Prhjcu19V';
  String makeBelievePlaylistId = 'wpWrAtYYIffNzmOzKmo6';
  // String maladroitPlaylistId = 'fyab5urz2Vk1cltqi56z';
  String newReleasesPlaylistId = 'RAUZopvzD6WjWa2PuVin'; // Note, this playlist is added as an individual property to the state, not to the user's playlists.
  String pacificDaydreamPlaylistId = 'nvD0gesKQHaap5k2gbiW';//
  String patrickAndRiversPlaylistId = 'ucpOckpbIfnkNvIwnhFg';
  String pianoPlaylistId = '5zztuyJ7Vjd4GFnJCoPj';
  String preWeezerPlaylistId = "SGqAcY3htl6Vc3QlZm1h";
  String redRadHurleyPlaylistId = 'FPmNMeGMNduvZq1YLWpF';
  String weezmaPlaylistId = "CPAfuZxpQQsgJcLRD4Xe";
  String whitePlaylistId = 'sPDeejLKjMO4SKvCMPnQ';
  String blackAlbumPlaylistId = 'abXrLOK2ybsYnvboT0bV';
  String sZNZPlaylistId = 'X2fz9YYcl6XlASHuU0V1';
  String oKHumanPlaylistId = 'jAWdM78MsKMr0TSeCKLi';
  String vanWeezerPlaylistId = 'RHCEXTTiCLutTcpG8qVi';

// The track lists for these are updated in firestore automatically when I run playlists_routine.py
// Playlist IDs must be stored in each user record so they can reorder them.
  List<String> get bestOfPlaylistIds => [
        highestRatedPlaylistId, // The highest rated rivers demos
        ewbaitePlaylistId,
        byThePeoplePlaylistId,
        pacificDaydreamPlaylistId,
        weezmaPlaylistId,
        redRadHurleyPlaylistId,
        bluePinkertonPlaylistId,
        whitePlaylistId, // the best of white
        makeBelievePlaylistId, // the best of make believe
        patrickAndRiversPlaylistId, // Patrick & Rivers
        preWeezerPlaylistId, // Pre-Weezer
        greenPlaylistId, // Best of Green
        pianoPlaylistId, // technically not a best of

        // maladroitPlaylistId,
        // blackRoomPlaylistId, // the best of black room

        // blackAlbumPlaylistId,
        // sZNZPlaylistId,
        // oKHumanPlaylistId,
        // vanWeezerPlaylistId,
      ];
  List<String> get defaultPlaylistIds => bestOfPlaylistIds;

  // List<String> get pinnedPlaylistIds => [
  //       newReleasesPlaylistId
  //     ]; // The other pinned playlist is 'Liked Songs' which is generated in loadUser

  /// For playlist images
  Map<String, String> get playlistIdToImageMap => {
        bluePinkertonPlaylistId: "assets/images/blue.jpg",
        byThePeoplePlaylistId: "assets/images/bythepeople.jpg",
        ewbaitePlaylistId: "assets/images/ewbaite.jpg",
        newReleasesPlaylistId: "assets/images/sniffingglue.jpg",
        greenPlaylistId: "assets/images/green.jpg",
        highestRatedPlaylistId: "assets/images/placeholder.png",

        // newReleasesPlaylistId: "assets/images/newreleases.jpg",// Better to use the image from one of the tracks if possible?
        // oKHumanPlaylistId: "assets/images/ok_human.jpg",
        pacificDaydreamPlaylistId: "assets/images/pacific_daydream.jpg",
        patrickAndRiversPlaylistId: "assets/images/pat_and_rivers.jpg",
        pianoPlaylistId: "assets/images/piano.jpg",
        preWeezerPlaylistId: "assets/images/pre_weezer.jpg",
        makeBelievePlaylistId: "assets/images/make_believe.jpg",
        redRadHurleyPlaylistId: "assets/images/red_rad_hurley.jpg",
        // sZNZPlaylistId: "assets/images/sznz.jpg",
        // vanWeezerPlaylistId: "assets/images/van_weezer.jpg",
        whitePlaylistId: "assets/images/white.jpg",
        weezmaPlaylistId: "assets/images/weezma.jpg",

        // blackRoomPlaylistId: "assets/images/blackroom.jpg",
        // maladroitPlaylistId: "assets/images/maladroit.jpg",
      };

  /// For track images
  Map<String, String> get bundleIdToImageMap => {
        // blackAlbumBundleId: "assets/images/black_album.jpg",
        // okHumanBundleId: "assets/images/ok_human.jpg",
        // sznzBundleId: "assets/images/sznz.jpg",
        // vanWeezerBundleId: "assets/images/van_weezer.jpg",
        pacificDaydreamBundleId: "assets/images/pacific_daydream.jpg",
        pianoBundleId: "assets/images/piano.jpg",
        preWeezerBundleId: "assets/images/pre_weezer.jpg",
        bluePinkertonBundleId: "assets/images/blue.jpg",

        greenBundleId: "assets/images/green.jpg",

        makeBelieveBundleId: "assets/images/make_believe.jpg",
        redRadHurleyBundleId: "assets/images/red_rad_hurley.jpg",
        ewbaiteBundleId: "assets/images/ewbaite.jpg",
        whiteBundleId: "assets/images/white.jpg",
        weezmaBundleId: "assets/images/weezma.jpg",
        patrickAndRiversBundleId: "assets/images/pat_and_rivers.jpg",
        byThePeopleBundleId: "assets/images/bythepeople.jpg",
      };

  // For profile images (unused??)
  Map<String, String> get profilePicIdToImageMap => {};

  // IMAGE FILENAMES
  String riversPicFilename = 'assets/images/rc.png';
  String placeHolderImageFilename = 'assets/images/placeholder.png';

// IMAGE URLS
  String boxifyDefaultImageUrl = '';
  String boxifyPicUrl = '';
  String rcHeadPicUrl =
      'https://www.dl.dropboxusercontent.com/s/c7waq75z8khnjdu/rc.png?raw=1';

  String riversPicUrl =
      'https://www.dl.dropboxusercontent.com/s/soonlxryu4gxhvu/rc.png?raw=1';
  String pianoPicUrl = '';
  String byThePeopleImageUrl =
      'https://www.dl.dropboxusercontent.com/s/dj8xhhu7u7amzbk/Immagine.png?raw=1';

  /// This is for the image that appears on the home page. It's not for use in Weezify
  String weezifyImageUrl =
      'https://www.dl.dropboxusercontent.com/s/h5x5ep6bwr1jxi3/weezifyImage.png?raw=1';

  String get defaultImageUrl => riversPicUrl;
  String get gerbil => riversPicUrl;
  String get mike => riversPicUrl;
  String get funko => riversPicUrl;
  String get placeHolderImageUrl => rcHeadPicUrl;
  String get rcpng => riversPicUrl;

// SHARE Urls
  String get baseUrl => 'https://weezify.web.app/';
  String get trackUrl => '${baseUrl}track/';
  String get playlistUrl => '${baseUrl}playlist/';

  // SERVER URLS
  String baseUrlLocal = 'localhost:8686/';
  String serverUrl = 'https://books-r-fun.herokuapp.com/';
  String discordUrl =
      'https://discord.com/channels/890210072381247548/890210073308172343';
  String get bundlesAPIUrl => '${serverUrl}bundles/api';
  String get tracksAPIUrl => '${serverUrl}tracks/api';
  String get usersAPIUrl => '${serverUrl}weezify_users/api';
  String get lastUpdatedTracksUrl => '$tracksAPIUrl/last_updated';
  String get lastUpdatedBundlesUrl => '$bundlesAPIUrl/last_updated';
  String get lastUpdatedUsersUrl => '$usersAPIUrl/last_updated';
  String get emailBundleUrl => '${serverUrl}email_bundle/api';
  String get libraryUrl => '${serverUrl}wiki';
  String get marketUrlTest => 'http://127.0.0.1:5000//demos';
  String get marketUrl => '${serverUrl}demos';
  String get weezifyPrivacyPolicyUrl =>
      '$libraryUrl/Weezify%20Privacy%20Policy';

  String get homeHeader {
    final hour = DateFormat('H').format(DateTime.now());
    if (int.parse(hour) < 12) {
      return 'Good Morning';
    } else if (int.parse(hour) < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String get libraryHeader => 'yourLibrary'.translate();

// IMAGES
  String placeholderImage = 'assets/images/rc.png';

  List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('ar'),
    const Locale('cs'),
    const Locale('de'),
    const Locale('es'),
    const Locale('fr'),
    const Locale('id'),
    const Locale('it'),
    const Locale('ja'),
    const Locale('ko'),
    const Locale('nl'),
    const Locale('nn'),
    const Locale('pl'),
    const Locale('plsv'),
    const Locale('pt'),
    const Locale('sv'),
    const Locale('tl'),
    const Locale('zh'),
  ];

  /// Carries out post-initialization tasks common to both apps in the base app.
  ///
  /// The `BaseApp.postInit` method executes additional setup and configurations that are shared between both apps after the initial primary initialization. This includes obtaining app versions using native services like `PackageInfo`, adjusting UI scaling based on screen size, and setting certain configuration properties based on device type (like if it's a tablet).
  ///
  /// This method is intended to be called by the `Core.postInit` method during the post-initialization phase, ensuring that these shared tasks are performed for both apps.
  init() async {
    logger.i("base app init");
  }

  postInit() async {
    logger.i("base app postInit");
    await RandomFacts.loadRandomFacts();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
    logger.i("appVersion: $appVersion");
  }
}

class BasePrefs {
  init() async {}
}

class BaseStyle {
  double fontScale = 1;
  String? get font1 => null;
  String? get fontBold => null;

  size(double val) {
    return val * fontScale;
  }

  get textColor => Colors.white;

  TextStyle get header {
    return TextStyle(
        color: textColor,
        fontFamily: fontBold,
        fontWeight: FontWeight.bold,
        fontSize: size(23));
  }

  TextStyle get regular {
    return TextStyle(color: textColor, fontFamily: font1, fontSize: size(16));
  }

  TextStyle get bold {
    return TextStyle(
        color: textColor,
        fontFamily: fontBold,
        fontWeight: FontWeight.bold,
        fontSize: size(16));
  }

  TextStyle get small {
    return TextStyle(
        color: textColor,
        fontFamily: font1,
        fontWeight: FontWeight.normal,
        fontSize: size(15));
  }

  TextStyle get xsmall {
    return TextStyle(
        color: textColor,
        fontFamily: font1,
        fontWeight: FontWeight.normal,
        fontSize: size(14));
  }

  TextStyle get tiny {
    return TextStyle(color: textColor, fontFamily: font1, fontSize: size(13));
  }

  TextStyle get title {
    return TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontFamily: fontBold,
        fontSize: size(28));
  }

  TextStyle get medium {
    return TextStyle(
        color: textColor, fontWeight: FontWeight.normal, fontSize: size(20));
  }
}

extension StyleExtension on TextStyle {
  TextStyle get bold =>
      copyWith(fontWeight: FontWeight.bold, fontFamily: Core.appStyle.fontBold);
  TextStyle get normal => copyWith(fontWeight: FontWeight.normal);
  TextStyle get thin => copyWith(fontWeight: FontWeight.w300);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle c(Color value) => copyWith(color: value);
  TextStyle get white => copyWith(color: Colors.white);
  TextStyle get grey => copyWith(color: Colors.grey);
  TextStyle get darkGrey => copyWith(color: const Color(0XFF666666));
  TextStyle get lightGrey => copyWith(color: const Color(0XFFCCCCCC));
  TextStyle get green => copyWith(color: Colors.green);
  TextStyle get red => copyWith(color: const Color(0XFFFF0000));
  TextStyle get orange => copyWith(color: const Color(0XFFFF9900));
  TextStyle get primaryColor => copyWith(color: Core.appColor.primary);
  TextStyle get primary => copyWith(color: Core.appColor.primary);
  TextStyle s(double value) => copyWith(fontSize: Core.appStyle.size(value));
  TextStyle w(FontWeight value) => copyWith(fontWeight: value);
  TextStyle h(double value) => copyWith(height: value);
  TextStyle d(TextDecoration value) => copyWith(decoration: value);
  TextStyle bl(TextBaseline value) => copyWith(textBaseline: value);
  TextStyle get tall => copyWith(height: 1.35);
  TextStyle get defaultFont => copyWith(
      fontFamily: Core.isIOS
          ? Typography.blackCupertino.bodySmall?.fontFamily
          : Typography.blackMountainView.bodySmall?.fontFamily);
}

class BaseColor {
  // Colors
  Color scaffoldBackgroundColor = Colors.black;
  Color widgetBackgroundColor = const Color.fromRGBO(18, 18, 18, 1);
  Color cardColor = const Color.fromRGBO(31, 31, 31, 1);
  Color cardHoverColor = const Color.fromRGBO(97, 97, 97, 1);
  // Color scaffoldBackgroundColor = const Color.fromRGBO(27, 27, 27, 1);
  Color primaryColor = const Color.fromRGBO(30, 30, 30, 1);

  Color get primary => Colors.green;

  get background => Colors.black;

  get header => Colors.black;
  Color get navBar => Colors.white;
  Color get iconButton => const Color(0xFF999999);
  Color get barrier => Colors.black38;
  Color get separator => const Color(0xFFeeeeee);
  Color get link => Colors.brown;
  Color get darkGrey => const Color(0XFF666666);
  Color get lightGrey => const Color(0XFFCCCCCC);
  Color get grey => Colors.grey;
  Color get red => const Color(0XFFFF0000);

  Color? playerColor = Colors.grey[700];
  //  Color? LargePlaylistTileColor = Colors.black87;
  Color largePlayerColor = Colors.black;
  Color panelColor = const Color.fromARGB(255, 16, 16, 16);
  Color hoverColor = const Color.fromARGB(255, 26, 26, 26);
  Color selectedColor = const Color.fromARGB(255, 36, 36, 36);
  Color hoverSelectedColor = const Color.fromARGB(255, 57, 57, 57);
  Color subtitleColor = const Color.fromARGB(255, 158, 158, 158);
  Color titleColor = Color.fromARGB(255, 255, 255, 255);
  Color discordColor = Color.fromARGB(255, 114, 137, 218);
}

class BaseUI {
  double scale = 1;
  double get iconSmall => 24 * scale;
  double get iconRegular => 30 * scale;
  double get iconBig => 35 * scale;
  double border = 15.0;
  // double contentBorder = 15.0;
  Radius roundedRadius = const Radius.circular(12);

  EdgeInsets get borderPadding => EdgeInsets.all(border);
  BorderRadius get borderRadius =>
      BorderRadius.circular(roundedRadius.x); // all(Radius.circular(border));
  BorderRadius get smallBorderRadius => BorderRadius.circular(8);
  OutlinedBorder get shapeBorder =>
      RoundedRectangleBorder(borderRadius: borderRadius);
  OutlinedBorder get smallRoundedBorder =>
      RoundedRectangleBorder(borderRadius: smallBorderRadius);

  double thumbImageSize(double maxWidth) => min(maxWidth * 0.16, 70);
}
