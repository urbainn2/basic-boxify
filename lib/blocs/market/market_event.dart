part of 'market_bloc.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarket extends MarketEvent {
  final User user;
  final DateTime serverTimestamp;
  const LoadMarket({required this.user, required this.serverTimestamp});

  @override
  List<Object?> get props => [user];
}

class PurchaseBundle extends MarketEvent {
  final String? id;
  final User user;
  const PurchaseBundle({required this.id, required this.user});

  @override
  List<Object?> get props => [id, user];
}

class ActivateBundle extends MarketEvent {
  final Bundle purchasedBundle;

  const ActivateBundle({required this.purchasedBundle});

  @override
  List<Object> get props => [purchasedBundle];
}

class InitialMarketState extends MarketEvent {
  @override
  List<Object?> get props => [];
}
