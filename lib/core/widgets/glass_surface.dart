import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:outc/core/theme/design_tokens.dart';

/// The one frosted/translucent surface treatment in the app — see
/// `docs/architecture.md` §4. Used on exactly one hero surface per flow
/// (home tile row, the flight booking-confirmed status card, the bus
/// seat-selection legend sheet). Never copy [BackdropFilter] into a screen
/// directly; add a parameter here instead if a new hero needs a variant.
///
/// All visual params default from [GlassThemeExtension] so most call sites
/// only need `GlassSurface(child: ...)`.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.blurSigma,
    this.tintColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final double? blurSigma;
  final Color? tintColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final GlassStyle style =
        Theme.of(context).extension<GlassThemeExtension>()?.hero ??
            GlassThemeExtension.light.hero;
    final double radius = borderRadius ?? style.borderRadius;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma ?? style.blurSigma,
          sigmaY: blurSigma ?? style.blurSigma,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tintColor ?? style.tintColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor ?? style.borderColor,
              width: borderWidth ?? style.borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
