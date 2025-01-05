import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:boxify/app_core.dart';

/// A mixin designed for State objects that need to listen for purchase
/// updates. Specifically, it handles the case of identifying and loading
/// purchases made on the Flask web app into the Flutter mobile apps.
///
/// It relies on a flag (`loadedToFlutterApps`) in the Firestore purchase
/// documents to determine whether a purchase has already been loaded.
/// If a purchase marked as not loaded is found, it triggers relevant
/// actions to process this purchase in the mobile app.
mixin PurchaseListenerMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<QuerySnapshot>? _purchaseListenerSubscription;

  Future<void> initializePurchaseListener(String userId) async {
    listenToPurchaseUpdates(userId);
  }

  @override
  void dispose() {
    _purchaseListenerSubscription?.cancel(); // Cancel Firestore listener
    super.dispose();
  }

  /// Listens to Firestore for updates to purchases for the given user.
  /// Specifically, it looks for the most recent purchase that has not been
  /// marked as loaded to the Flutter apps (`loadedToFlutterApps` == false).
  /// When such a purchase is found, it executes actions to process the
  /// purchase within the app.
  void listenToPurchaseUpdates(String userId) {
    _purchaseListenerSubscription = FirebaseFirestore.instance
        .collection(Paths.purchases)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
      bool? loadedToFlutterApps = snapshot.docs.isNotEmpty
          ? (snapshot.docs.first.data()['loadedToFlutterApps'])
          : null;

      logger.f('loadedToFlutterApps: $loadedToFlutterApps');

      if (loadedToFlutterApps != null && loadedToFlutterApps == false) {
        // Trigger actions to process the purchase in the app, e.g., loading tracks.
        final trackBloc = context.read<TrackBloc>();
        final userBloc = context.read<UserBloc>();
        trackBloc.add(
          LoadAllTracks(
            serverUpdated: DateTime.now(),
            user: userBloc.state.user,
          ),
        );

        // Reset the flag to true, indicating the purchase has been loaded.
        // This prevents reprocessing the same purchase in future checks.
        await FirebaseFirestore.instance
            .collection(Paths.purchases)
            .doc(snapshot.docs.first.id)
            .update({'loadedToFlutterApps': true});
      } else {
        logger.f('No new purchases detected.');
      }
    });
  }
}
