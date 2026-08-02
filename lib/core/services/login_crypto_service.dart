import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt_pkg;

/// Matches Node's `CryptoJS.AES.encrypt(plaintext, passphrase)` output so the
/// backend's `CryptoJS.AES.decrypt(...)` on the `login` endpoint can read it
/// (see `mobileLogin.txt`'s `login` method — unlike `mobileLogin`, it only
/// decrypts, it never re-encrypts, so the client must send a real
/// CryptoJS-shaped ciphertext).
///
/// CryptoJS's string-passphrase mode is OpenSSL's legacy format: an 8-byte
/// random salt, an MD5-based `EVP_BytesToKey` key/IV derivation from
/// (passphrase + salt), AES-256-CBC/PKCS7, and an output of
/// base64("Salted__" + salt + ciphertext). There's no standard Dart package
/// for this — `package:encrypt` does the AES step but not CryptoJS's KDF —
/// so the derivation is reimplemented here to match byte-for-byte.
class LoginCryptoService {
  LoginCryptoService._();

  static const _saltLength = 8;
  static const _keyLength = 32;
  static const _ivLength = 16;

  static String encryptPassword(String plaintext, String passphrase) {
    final salt = _randomBytes(_saltLength);
    final derived = _evpBytesToKey(utf8.encode(passphrase), salt, _keyLength, _ivLength);

    final encrypter = encrypt_pkg.Encrypter(
      encrypt_pkg.AES(encrypt_pkg.Key(derived.key), mode: encrypt_pkg.AESMode.cbc),
    );
    final ciphertext = encrypter.encryptBytes(
      utf8.encode(plaintext),
      iv: encrypt_pkg.IV(derived.iv),
    );

    final output = BytesBuilder()
      ..add(utf8.encode('Salted__'))
      ..add(salt)
      ..add(ciphertext.bytes);
    return base64.encode(output.toBytes());
  }

  static Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(List<int>.generate(length, (_) => random.nextInt(256)));
  }

  /// OpenSSL's legacy `EVP_BytesToKey` with MD5 — repeatedly hashes
  /// (previous block + password + salt) until enough bytes are produced for
  /// the key and IV combined.
  static ({Uint8List key, Uint8List iv}) _evpBytesToKey(
    List<int> password,
    Uint8List salt,
    int keyLength,
    int ivLength,
  ) {
    final target = keyLength + ivLength;
    final derived = BytesBuilder();
    Uint8List block = Uint8List(0);

    while (derived.length < target) {
      final input = BytesBuilder()
        ..add(block)
        ..add(password)
        ..add(salt);
      block = Uint8List.fromList(md5.convert(input.toBytes()).bytes);
      derived.add(block);
    }

    final bytes = derived.toBytes();
    return (key: bytes.sublist(0, keyLength), iv: bytes.sublist(keyLength, target));
  }
}
