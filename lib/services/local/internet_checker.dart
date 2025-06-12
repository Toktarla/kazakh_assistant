import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class InternetChecker {
  // Singleton pattern
  static final InternetChecker _instance = InternetChecker._internal();
  factory InternetChecker() => _instance;
  InternetChecker._internal();

  // StreamController to emit connectivity status
  // Using a regular StreamController; new listeners won't get the last value automatically.
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  Stream<bool> get internetStream => _controller.stream;

  // Track the current connectivity status
  // Initialize as true, assuming connectivity until proven otherwise
  bool _hasInternet = true;
  bool get hasInternet => _hasInternet;

  // Subscription for connectivity_plus changes
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Debouncer for frequent network changes (optional, but good practice)
  Timer? _debounceTimer;

  // Initialize the checker
  void initialize() {
    // Initial check
    _checkInternetConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Debounce to avoid excessive checks on rapid network changes
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _checkInternetConnectivity();
      });
    });
  }

  // Dispose of resources when the app is no longer using the checker
  void dispose() {
    _connectivitySubscription.cancel();
    _controller.close();
    _debounceTimer?.cancel();
  }

  // Internal method to perform the actual internet check
  Future<void> _checkInternetConnectivity() async {
    bool previousStatus = _hasInternet;
    try {
      // Attempt to look up a reliable host.
      // This is more robust than just checking ConnectivityResult.
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _hasInternet = true;
      } else {
        // If lookup returns empty or rawAddress is empty, it might still be a no-internet scenario.
        _hasInternet = false;
      }
    } on SocketException catch (_) {
      // Catch specific socket exceptions (e.g., host unreachable)
      _hasInternet = false;
    } on Exception catch (e) {
      // Catch any other general exceptions during lookup
      print("Error during internet lookup: $e");
      _hasInternet = false;
    }

    // Only update stream if status has changed
    if (_hasInternet != previousStatus) {
      _controller.add(_hasInternet);
    }
  }

  // Manual check for internet connectivity (useful on demand)
  Future<bool> checkInternet() async {
    await _checkInternetConnectivity(); // Perform an immediate check
    return _hasInternet; // Return the result of that check
  }
}