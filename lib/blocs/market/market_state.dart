part of 'market_bloc.dart';

enum MarketStatus {
  initial,
  loading,
  loaded,
  submitting,
  error,
  bundlePurchased,
  bundlePurchasing,
  updated,
}

class MarketState extends Equatable {
  final MarketStatus status;
  final Failure failure;

  List<Bundle> allBundles;
  List<Bundle> unpurchasedBundles;
  final int trackCount;
  final int userTrackCount;
  final int userBundleCount;
  final int bundleCount;
  Bundle purchasedBundle;

  MarketState({
    required this.status,
    required this.failure,
    required this.allBundles,
    required this.unpurchasedBundles,
    required this.trackCount,
    required this.userTrackCount,
    required this.userBundleCount,
    required this.bundleCount,
    required this.purchasedBundle,
  });

  factory MarketState.initial() {
    return MarketState(
      status: MarketStatus.initial,
      failure: const Failure(),
      allBundles: const [],
      unpurchasedBundles: const [],
      trackCount: 0,
      userTrackCount: 0,
      userBundleCount: 0,
      bundleCount: 0,
      purchasedBundle: Bundle.empty,
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        status,
        failure,
        allBundles,
        unpurchasedBundles,
        trackCount,
        userTrackCount,
        userBundleCount,
        bundleCount,
        purchasedBundle,
      ];

  MarketState copyWith({
    MarketStatus? status,
    Failure? failure,
    List<Bundle>? allBundles,
    List<Bundle>? unpurchasedBundles,
    int? trackCount,
    int? userTrackCount,
    int? userBundleCount,
    int? bundleCount,
    Bundle? purchasedBundle,
  }) {
    return MarketState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      allBundles: allBundles ?? this.allBundles,
      unpurchasedBundles: unpurchasedBundles ?? this.unpurchasedBundles,
      trackCount: trackCount ?? this.trackCount,
      userTrackCount: userTrackCount ?? this.userTrackCount,
      userBundleCount: userBundleCount ?? this.userBundleCount,
      bundleCount: bundleCount ?? this.bundleCount,
      purchasedBundle: purchasedBundle ?? this.purchasedBundle,
    );
  }

  // /// Define getter for Playlist.empty
  // static MarketState get empty => MarketState.initial();
}
