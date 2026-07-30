import 'package:connectivity_plus/connectivity_plus.dart';

/// The single way to check "online vs offline" (spec 0012) — providers call
/// [isOnline] before firing a request instead of each screen/provider
/// inventing its own platform check.
class ConnectivityService {
  ConnectivityService._();

  static final Connectivity _connectivity = Connectivity();

  static Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
