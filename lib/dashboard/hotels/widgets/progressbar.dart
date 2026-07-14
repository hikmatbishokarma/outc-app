import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';
import 'package:outc/widgets/colors/colors.dart';

class Hotels_ProgressBar extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  // final Animation<Color> valueColor;

  const Hotels_ProgressBar({
    super.key,
    // required Key key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    //  this.valueColor,
  });
  //  : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(
              dismissible: false,
              color: color,
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
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
