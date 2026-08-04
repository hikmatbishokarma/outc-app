import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper over `connectivity_plus` so a provider can check "online vs
/// offline" imperatively before starting a network call, without needing to
/// be a widget — most providers here are plain `ChangeNotifier`s created
/// per-screen, not registered in `main.dart`'s `MultiProvider`, so they have
/// no `context` to `watch`. Reports interface-level connectivity (Wi-Fi/
/// mobile/ethernet present), not a live "can actually reach the internet"
/// probe — sufficient for detecting airplane mode before a request is made.
class ConnectivityService {
  ConnectivityService._();

  static Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
