class AppConstant {
  static String appName = 'OutC';

  /// Single host for every module, search through book — confirmed with the
  /// backend team that splitting a module across two hosts breaks anything
  /// that depends on server-side session/log state (bus's block step used to
  /// 404 with "log not found" when search ran on a different host than
  /// block/book). Test points at `b2c.outc.in`; prod will switch this one
  /// value to `outc.in` once that host is fully live.
  static String baseUrl = 'https://b2c.outc.in/';

  /// Shared with web (`VITE_LOGIN_SECRETKEY`) — used client-side to
  /// AES-encrypt the password sent to `admin/login`'s password branch (see
  /// `LoginCryptoService`). Intentionally client-visible, not a server-only
  /// secret — confirmed by it being a `VITE_`-prefixed, web-bundle-exposed
  /// value.
  static String loginSecretKey = 'sytVR>Q~){6[d<@`7>46EetxV]3)69s&';
}
