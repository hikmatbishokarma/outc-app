import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/widgets/sharedprefservices.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      SharedPrefServices.setguestCount(1);
      SharedPrefServices.setroomCount(1);
      SharedPrefServices.setcurrencycode("INR");
      SharedPrefServices.setcurrencyAmount("1");
      // SharedPrefServices.setcityId(22059);
      // SharedPrefServices.setcityName("Hyderabad,India");
      // SharedPrefServices.setcountryCode("IN");
      // SharedPrefServices.setcurrencycode("INR");
      // SharedPrefServices.setcurrencyAmount("1.00");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Dashboard();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                "images/OutcLogoNew.svg",
                height: 250,
                width: 350,
              ),
            ),
            const Text("Book all travel tickets from one Plotform")
          ],
        ),
      ),
    );
  }
}
