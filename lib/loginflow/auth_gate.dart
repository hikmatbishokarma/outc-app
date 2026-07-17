import 'package:flutter/material.dart';
import 'package:outc/loginflow/multiloginpage.dart';
import 'package:outc/widgets/sharedprefservices.dart';

/// Returns true immediately if already logged in. Otherwise pushes the login screen in "gate mode"
/// and awaits the result — true only if the user logged in successfully. Callers must check the
/// return value and abort their own navigation (return early) if it's false, so a cancelled/failed
/// login never proceeds into a booking form.
Future<bool> ensureLoggedIn(BuildContext context) async {
  if (SharedPrefServices.getislogged().toString() == "true") return true;
  final loggedIn = await Navigator.of(context).push<bool>(
    MaterialPageRoute(builder: (_) => const MultiLoginScreen(isGateMode: true)),
  );
  return loggedIn == true;
}
