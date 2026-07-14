// ignore_for_file: unnecessary_statements

import 'package:flutter/foundation.dart';

printL(String text) {
  // ignore: avoid_print
  kReleaseMode != true ? print(text) : null;
}
