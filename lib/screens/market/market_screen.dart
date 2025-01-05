import 'dart:io';

import 'package:boxify/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:boxify/screens/market/widgets/bundle_card_for_market.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  Future<void> _restore(BuildContext context) async {
    try {
      final result =
          await Purchases.logIn(context.read<AuthBloc>().state.user!.uid);
      final restored = await Purchases.restorePurchases();
      // (restored);
      // ("through");
      // for (var element in restored.allPurchasedProductIdentifiers) {
      //   (element);
      // }
      // ... check restored purchaser to see if entitlement is now active
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackbar(
          'Your purchases have been restored.${restored.allPurchasedProductIdentifiers}',
        ),
      ); //  '${restored.toString()}'
    } on PlatformException catch (e) {
      // // Error restoring purchases
      // ScaffoldMessenger.of(context).showSnackBar(buildSnackbar(
      //     "Your purchases have been restored. '${e.toString()}'"));
      e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    return BlocBuilder<MarketBloc, MarketState>(
      builder: (context, state) {
        if (kIsWeb) {
          myLaunch(Core.app.marketUrl, userBloc.state.user.id);
        }
        if (state.status == MarketStatus.loading ||
            state.status == MarketStatus.initial) {
          if (context.read<AuthBloc>().state.status !=
              AuthStatus.authenticated) {
            return CenteredText(state.failure.message!);
          } else {
            return circularProgressIndicator;
          }
        } else if (state.status == MarketStatus.error) {
          // return CenteredText(state.failure.message!);
          return ErrorDialog(
            content: state.failure.message!,
          );
        }
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      'You own ${state.userBundleCount} of ${state.bundleCount} bundles',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'You own ${state.userTrackCount} of ${state.trackCount} demos',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    direction: Axis
                        .horizontal, // Use horizontal to create a row-like flow
                    spacing: 10.0, // Horizontal spacing between chips
                    runSpacing: 10.0, // Vertical spacing between lines
                    children:
                        List.generate(state.unpurchasedBundles.length, (i) {
                      return Container(
                        width: 190,
                        height: 300,
                        child: BundleCardForMarketScreen(
                          bundle: state.unpurchasedBundles[i],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              if (!kIsWeb && Platform.isIOS && userBloc.state.user.id != '')
                ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      buildSnackbar('Restoring purchases...'),
                    );
                    await _restore(context);
                  },
                  child: Text('Restore Purchases'.translate()),
                )
              else
                Container(),
            ],
          ),
        );
      },
    );
  }
}
