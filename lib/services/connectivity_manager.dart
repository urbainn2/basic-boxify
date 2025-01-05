import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityManager {
  // Private constructor
  ConnectivityManager._internal();

  // Singleton instance
  static final ConnectivityManager _instance = ConnectivityManager._internal();

  // Factory constructor
  factory ConnectivityManager() => _instance;

  // Alternatively, static getter for instance
  static ConnectivityManager get instance => _instance;

  // Implementation
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _currentStatus = ConnectivityResult.none;

  final StreamController<ConnectivityResult> _connectivityStreamController =
      StreamController<ConnectivityResult>.broadcast();

  // Public init method
  Future<void> init() async {
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _currentStatus = result;
      _connectivityStreamController.add(result);
    });

    // Get initial status asynchronously
    final result = await _connectivity.checkConnectivity();
    _currentStatus = result;
    _connectivityStreamController.add(result);
  }

  // Getter for currentStatus
  ConnectivityResult get currentStatus => _currentStatus;

  // Getter for connectivityStream
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityStreamController.stream;

  void dispose() {
    _connectivityStreamController.close();
  }
}
