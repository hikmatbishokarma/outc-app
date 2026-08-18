import 'package:flutter/material.dart';
import 'package:outc/core/widgets/travel_loading_indicator.dart';

/// Full-screen "please wait" takeover for flight search/booking calls that
/// don't have a step-by-step breakdown to show (unlike
/// `BookingStepOverlay`) — an opaque white page carrying the shared
/// `TravelLoadingIndicator` animation + caption, matching an MMT-style
/// dedicated loading screen. Previously this was a translucent
/// `ModalBarrier` letting the form (and that form's own button spinner)
/// show through underneath, which read as two loaders stacked on screen at
/// once; now this is the only loading indicator visible while it's up.
class Flight_ProgressBar extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final String caption;

  const Flight_ProgressBar({
    super.key,
    required this.child,
    required this.inAsyncCall,
    this.caption = 'Please wait…',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (inAsyncCall)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.white,
              child: Center(
                child: TravelLoadingIndicator(size: 220, caption: caption),
              ),
            ),
          ),
      ],
    );
  }
}
