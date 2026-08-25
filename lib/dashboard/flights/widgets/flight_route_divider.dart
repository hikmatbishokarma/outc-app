import 'package:flutter/material.dart';

import 'package:outc/core/theme/design_tokens.dart';

/// The dashed departure-to-arrival line, shared by `FlightResultCard` and
/// `FlightFaresSheet`'s route recap so the two don't drift out of sync.
/// Previously this centered a plane glyph on the line (`Icons.flight`,
/// rotated to sit horizontally) — now it's a plain timeline instead: a dot
/// at the origin, a dot at the destination, and — only when the flight has
/// a layover — a third dot *in between*, in a different color from the two
/// endpoints so the stop reads as the one point that matters, with the
/// connecting airport's code labeled under it.
class FlightRouteDivider extends StatelessWidget {
  const FlightRouteDivider({super.key, this.dotSize = 6, this.stopLabel});

  /// Size of the origin/destination endpoint dots. The stop dot (when
  /// present) is drawn slightly larger so it stands out as the one along
  /// the line that isn't just an endpoint.
  final double dotSize;

  /// The connecting airport's code (or name) for a 1-stop-or-more flight —
  /// previously a stop only showed up as the "1 Stop" badge elsewhere on
  /// the card, with nothing on the route line itself to say *where*. Null
  /// for a direct flight — the line then just runs endpoint to endpoint.
  final String? stopLabel;

  @override
  Widget build(BuildContext context) {
    final lineColor = Colors.grey.shade400;
    final endpointColor = Colors.grey.shade400;
    return Row(
      children: [
        _RouteDot(size: dotSize, color: endpointColor),
        Expanded(child: _DashedLine(color: lineColor)),
        if (stopLabel != null) ...[
          _StopDot(label: stopLabel!, color: AppColors.secondary, size: dotSize + 2),
          Expanded(child: _DashedLine(color: lineColor)),
        ],
        _RouteDot(size: dotSize, color: endpointColor),
      ],
    );
  }
}

class _RouteDot extends StatelessWidget {
  const _RouteDot({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _StopDot extends StatelessWidget {
  const _StopDot({required this.label, required this.color, required this.size});
  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 3.0;
        const gap = 3.0;
        final count = (constraints.maxWidth / (dashWidth + gap)).floor().clamp(1, 1000);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (_) => Container(width: dashWidth, height: 1.4, color: color)),
        );
      },
    );
  }
}
