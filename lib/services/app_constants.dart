class AppConstant {
  static String appName = 'OutC';
  static String baseUrl = 'https://b2c.outc.in/';
  static String busBaseUrl = 'https://outc.in/';

  /// Shared with web (`VITE_LOGIN_SECRETKEY`) — used client-side to
  /// AES-encrypt the password sent to `admin/login`'s password branch (see
  /// `LoginCryptoService`). Intentionally client-visible, not a server-only
  /// secret — confirmed by it being a `VITE_`-prefixed, web-bundle-exposed
  /// value.
  static String loginSecretKey = 'sytVR>Q~){6[d<@`7>46EetxV]3)69s&';
}
