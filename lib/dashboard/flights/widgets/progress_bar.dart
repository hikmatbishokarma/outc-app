import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';
import 'package:outc/widgets/colors/colors.dart';

class Flights_ProgressBarHUD extends StatelessWidget {
  final Color? backGroundColor;

  const Flights_ProgressBarHUD({super.key, this.backGroundColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(
              dismissible: false,
              color: backGroundColor ?? Colors.grey,
            ),
          ),
          Center(
            child: SpinKitSpinningLines(
              itemCount: 5,
              color: Flights_Colours.strongRed,
              lineWidth: 5,
              size: 100,
            ),
          ),
        ],
      ),
    );
  }
}
