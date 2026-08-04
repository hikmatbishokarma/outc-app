import 'package:flutter/material.dart';
import 'package:outc/core/widgets/travel_loading_indicator.dart';

class Flight_ProgressBar extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  // final Animation<Color> valueColor;

  const Flight_ProgressBar({
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
          const Center(
            child: TravelLoadingIndicator(size: 220, showCaption: false),
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
