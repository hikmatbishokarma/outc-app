import 'package:google_sign_in/google_sign_in.dart';

/// Wraps `google_sign_in` for the app's "Sign in with Google" button.
///
/// No Firebase involved: the backend's `login` endpoint doesn't verify a
/// Google/Firebase token at all (see `mobileLogin.txt`) — it just trusts
/// whatever email comes with `isloginType: IsLoginType.google`. So this only
/// needs the Google account's email client-side, not a full Firebase Auth
/// integration. (That backend gap is a real security issue, flagged
/// separately to the backend team — not something to work around here.)
class GoogleAuthService {
  GoogleAuthService._();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  /// Returns the signed-in Google account, or null if the user cancelled.
  static Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();

  static Future<void> signOut() => _googleSignIn.signOut();
}
