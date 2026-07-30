import 'package:flutter/material.dart';
import 'package:outc/core/theme/design_tokens.dart';

/// Reusable rounded card shell used for the flight search form's outer
/// container and its internal field rows. Purely presentational.
class FlightFieldCard extends StatelessWidget {
  const FlightFieldCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// A single bordered/filled field "chip" — FROM, TO, a date, travellers,
/// cabin class — giving each field a visible boundary instead of floating
/// as plain text inside the outer [FlightFieldCard]. Matches the boxed
/// field style from the reference screenshots.
class FlightFieldBox extends StatelessWidget {
  const FlightFieldBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: child,
    );
  }
}
