import 'dart:io';

import 'package:boxify/app_core.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _androidApiKey = 'goog_SibIlGiVRXgqPgqroKiJQzkqjHB';
  static const _iosApiKey = 'appl_hVYwWigZLWWndBKVzzTECSoVQYe';

  /// Initializes the Purchases SDK.
  static Future<void> init() async {
    logger.i('PurchaseApi INIT');

    // Set log level (optional).
    await Purchases.setLogLevel(LogLevel.verbose);

    // Determine the platform and set the API key accordingly.
    String apiKey;
    PurchasesConfiguration configuration;

    if (Platform.isAndroid) {
      apiKey = _androidApiKey;
      logger.i('Initializing for Android');

      configuration = PurchasesConfiguration(apiKey);
      // Android-specific configurations can go here if needed.
    } else if (Platform.isIOS) {
      apiKey = _iosApiKey;
      logger.i('Initializing for iOS');

      configuration = PurchasesConfiguration(apiKey);

      // iOS-specific configurations.
      // For example, if you need to set the StoreKit version:
      // configuration.storeKitVersion = StoreKitVersion.storeKit2;
    } else {
      // Handle other platforms or throw an error.
      throw UnsupportedError('Unsupported platform');
    }

    // Optionally, set the appUserID if you have one.
    // configuration.appUserID = 'your_app_user_id';

    // Configure Purchases SDK.
    await Purchases.configure(configuration);
  }

  /// Fetches products by their IDs.
  static Future<List<StoreProduct>> fetchProductsByIds(List<String> ids) async {
    logger.i('Fetching products with IDs: $ids');

    List<StoreProduct> products;

    if (Platform.isAndroid) {
      // For Android, specify the product category.
      products = await Purchases.getProducts(
        ids,
        productCategory:
            ProductCategory.nonSubscription, // or ProductCategory.subscription
      );
    } else if (Platform.isIOS) {
      // For iOS, call getProducts without productCategory
      products = await Purchases.getProducts(ids);
    } else {
      // Handle other platforms or throw an error.
      throw UnsupportedError('Unsupported platform');
    }

    logger.i('Fetched products: $products');
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
