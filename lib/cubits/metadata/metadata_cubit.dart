import 'dart:async'; // Import for StreamSubscription
import 'package:boxify/app_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity package

// Define states
abstract class MetaDataState {}

class MetaDataInitial extends MetaDataState {}

class MetaDataLoading extends MetaDataState {}

class MetaDataLoaded extends MetaDataState {
  final Map<String, DateTime> serverTimestamps;
  MetaDataLoaded(this.serverTimestamps);
}

class MetaDataError extends MetaDataState {
  final String message;
  MetaDataError(this.message);
}

class MetaDataCubit extends Cubit<MetaDataState> {
  final MetaDataRepository metaDataRepository;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  MetaDataCubit(this.metaDataRepository) : super(MetaDataInitial()) {
    // Initialize connectivity listener
    _connectivitySubscription = ConnectivityManager.instance.connectivityStream
        .listen((connectivityResult) {
      _handleConnectivityChange(connectivityResult);
    });
  }

  // Method to load metadata
  Future<void> getMetaData() async {
    try {
      emit(MetaDataLoading());
      final timestamps = await metaDataRepository.getLastUpdatedTimestamps();
      emit(MetaDataLoaded(timestamps));
    } on NoConnectionException catch (e) {
      logger.e(e.toString());
      emit(MetaDataError(e.message));
    } catch (e) {
      logger.e(e.toString());
      emit(MetaDataError('An unexpected error occurred.'));
    }
  }

  // Handle connectivity changes
  void _handleConnectivityChange(ConnectivityResult connectivityResult) {
    if (connectivityResult != ConnectivityResult.none) {
      // If we are now connected and previously had a connectivity error, retry fetching metadata
      if (state is MetaDataError) {
        final errorState = state as MetaDataError;
        if (errorState.message.contains('No internet connection')) {
          // Retry fetching metadata
          getMetaData();
        }
      }
    }
  }

  // Reset
  void reset() {
    emit(MetaDataInitial());
  }

  @override
  Future<void> close() {
    // Cancel the connectivity subscription
    _connectivitySubscription.cancel();
    return super.close();
  }
}
