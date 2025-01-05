import 'package:boxify/app_core.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:app_core/app_core.dart';  //

class PurchaseApiApple {
  static const _apiKey = 'appl_hVYwWigZLWWndBKVzzTECSoVQYe';
  static Future init() async {
    logger.i(
      'APPLE INIT========================================================================================================',
    );
    await Purchases.setLogLevel(LogLevel.verbose);
    // Create configuration with your API key.
    PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);

    // Optionally, set the appUserID if you have one.
    // configuration.appUserID = 'your_app_user_id';

    // Optionally, configure additional settings.
    // For example, if you handle purchases manually (observer mode):
    // configuration.purchasesCompletedBy = PurchasesAreCompletedByMyApp(
    //   storeKitVersion: StoreKitVersion.storeKit2, // iOS only
    // );

    // Configure Purchases SDK.
    await Purchases.configure(configuration);
  }

  static Future<List<StoreProduct>> fetchStoreProductsByIds(
    List<String> ids,
  ) async {
    logger.i('.......................fetchStoreProductsById in Apple');
    final products = await Purchases.getProducts(ids);
    return products;
  }

  /// Initiates the purchase flow for a given product.
  static Future<bool> purchaseProduct(StoreProduct product) async {
    try {
      logger.i('Initiating purchase for product: ${product.identifier}');

      // Start the purchase process.
      CustomerInfo customerInfo = await Purchases.purchaseStoreProduct(product);

      logger.i('Purchase successful: $customerInfo');
      // Handle customerInfo if needed.

      return true;
    } on PlatformException catch (e) {
      // Get error code to handle specific errors.
      var errorCode = PurchasesErrorHelper.getErrorCode(e);

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        logger.i('User cancelled the purchase.');
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        logger.e('Purchase not allowed on this device.');
      } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
        logger.i('Payment is pending.');
      } else {
        logger.e('Purchase failed with error: $e');
      }

      return false;
    } catch (e) {
      // Catch any other errors.
      logger.e('An unexpected error occurred: $e');
      return false;
    }
  }
}


  // static Future<bool> purchaseStoreProduct(StoreProduct product) async {
  //   logger.i('.......................purchaseStoreProduct in Apple');
  //   try {
  //     logger.i('here we go');
  //     logger.i(product.identifier);
  //     await Purchases.purchaseProduct(product.identifier);
  //     logger.i('success is true!');
  //     return true;
  //   } catch (e) {
  //     logger.i("oops suceess is false here's your error");
  //     logger.e(e);
  //     return false;
  //   }
  // }