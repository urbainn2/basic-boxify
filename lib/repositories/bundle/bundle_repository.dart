import 'dart:convert';

import 'package:boxify/app_core.dart';
import 'package:http/http.dart' as http;

import 'base_bundle_repository.dart';

class BundleRepository extends BaseBundleRepository {
  BundleRepository();

  void emailBundleAndSavePurchaseToFirestore(
      User user, Bundle purchasedBundle) {
    final data = <String, dynamic>{
      'user': {
        'username': user.username,
        'email': user.email,
        'id': user.id,
      },
      'bundle': {
        'description': purchasedBundle.description,
        'id': purchasedBundle.id,
        // 'link': purchasedBundle.downloadLink, // get it server side for security
        'song_list': purchasedBundle.songList,
        'title': purchasedBundle.title,
        'price_string': purchasedBundle.priceString,
      },
      'purchaseId':
          '${DateTime.now().toIso8601String()}-${user.id}-${purchasedBundle.revenueCatId!}',
      'isTestPurchase': user.email.toLowerCase().contains('.test'),
    };
    logger.i(data);
    final headers = {
      'Content-Type': 'application/json',
      'TOKEN': Core.app.serverToken,
      'userId': '8',
    };
    http.post(
      Uri.parse(Core.app.emailBundleUrl),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  Future<List<Bundle>> loadBundles(String userId) {
    return fetchBundles(userId)
        .then((value) => parseBundlesFromResponse(value));
  }

  @override

  /// Fetches all bundles from the server bundlesAPIUrl
  Future<http.Response> fetchBundles(String userId) {
    return http.get(
      Uri.parse(Core.app.bundlesAPIUrl),
      headers: {
        'TOKEN': Core.app.serverToken,
        'userId': userId,
      },
    );
  }

  /// For display in the market??
  List<Bundle> parseBundlesFromResponse(http.Response response) {
    final s = Stopwatch()..start();
    logger.i('_parseBundlesFromResponse');

    if (response.body == null) {
      logger.i(
        'response.body from bundles/api is null. so returning empty list to market/loaduser.',
      );
      return [];
    }
    // Notice how you have to call body from the response
    // if you are using http to retrieve json
    final body = json.decode(response.body) as Map<String, dynamic>;

    if (body.containsKey('error')) {
      logger.i(
        'error getting tracks from 1.0, so returning empty list to playerscreen.',
      );
      logger.i(body);
      return [];
    }

    final data = body['bundles'] as List<dynamic>;

    // // INITIAL RUN FOR IOS APP.
    // // ONCE APPROVED YOU CAN ADD THE OTHER BUNDLES BACK IN
    // data = data.where((i) => i["id"] == "35").toList();

    final bundles = data.map(Bundle.fromJson).toList();
    // Chronological order
    bundles.sort((a, b) => b.years!.compareTo(a.years!));
    // My tracks before collabs
    bundles.sort((a, b) => a.category!.compareTo(b.category!));
    // Put new ones on top
    bundles.sort((a, b) {
      if (a.isNew!) {
        return 1;
      }
      return -1;
    });

    return bundles;
  }
}
