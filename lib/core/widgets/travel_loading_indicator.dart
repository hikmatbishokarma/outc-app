import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A calm, branded loading animation for async fetches across the app —
/// trip search, results, booking confirmation, itinerary loading. Pure
/// Flutter (one `AnimationController` + `CustomPainter`s), no packages, and
/// fully driven by `Theme.of(context)` so it adapts to light/dark and to
/// whatever `ColorScheme` the surrounding screen is using.
///
/// One 3-second loop, one controller, every element reads the same `t` so
/// nothing can drift out of sync with anything else:
///   0.0–1.0s  Flight — plane glides a short top arc (240°→300°, eased),
///             confined near its own station; a short fading trail follows.
///   1.0–2.0s  Bus — bus drives a short lower-left arc (115°→175°, eased),
///             confined near its own station, with a light suspension
///             bounce and spinning wheels.
///   2.0–2.7s  Hotel — hotel station glows, its windows light up one by
///             one, a sparkle pops above the roof, and the center pin
///             emits one expanding ripple.
///   2.7–3.0s  Reset — everything eases back toward the loop point so the
///             repeat reads as continuous motion, not a jump cut.
///
/// Each sprite's arc is deliberately short and centered on its own
/// station (not a wide sweep across the whole route) — restrained motion
/// near home base reads as premium; a big dramatic sweep across a
/// neighboring station's territory reads as a generic loader.
///
/// Only one sprite is ever in motion at a time — the other two stations
/// just hold a soft "visited" glow — so the eye always has exactly one
/// thing to follow.
class TravelLoadingIndicator extends StatefulWidget {
  const TravelLoadingIndicator({
    super.key,
    this.size = 300,
    this.caption = 'Planning your journey',
    this.subcaption,
    this.accentColor,
    this.showCaption = true,
  });

  /// Overall footprint (square). Everything — route radius, sprite scale,
  /// dot spacing — scales off this, so it's safe to drop in at any size.
  final double size;

  final String caption;
  final String? subcaption;

  /// Defaults to `Theme.of(context).colorScheme.primary`.
  final Color? accentColor;

  final bool showCaption;

  @override
  State<TravelLoadingIndicator> createState() => _TravelLoadingIndicatorState();
}

class _TravelLoadingIndicatorState extends State<TravelLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = widget.accentColor ?? scheme.primary;
    final warm = scheme.tertiary;

    return Center(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Route + pin never change frame-to-frame — isolated in its
              // own layer so the GPU never has to re-rasterize it while the
              // sprites above it animate at 60fps.
              RepaintBoundary(
                child: CustomPaint(
                  size: Size.square(widget.size),
                  painter: _StaticRoutePainter(
                    dotColor: scheme.outlineVariant,
                    pinColor: accent,
                    size: widget.size,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    size: Size.square(widget.size),
                    painter: _MotionPainter(
                      t: _controller.value * 3, // seconds, 0..3
                      size: widget.size,
                      accent: accent,
                      warm: warm,
                      ink: scheme.onSurface,
                      surface: scheme.surface,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        if (widget.showCaption) ...[
          SizedBox(height: widget.size * 0.08),
          _AnimatedCaption(text: widget.caption, color: scheme.onSurface, fontSize: widget.size * 0.05),
          if (widget.subcaption != null) ...[
            SizedBox(height: widget.size * 0.02),
            Text(
              widget.subcaption!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.size * 0.0417,
                fontWeight: FontWeight.w500,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ],
      ),
    );
  }
}

/// "Planning your journey..." with three dots pulsing on a staggered loop —
/// independent of the main 3s travel loop since it's a much shorter, purely
/// decorative cycle.
class _AnimatedCaption extends StatefulWidget {
  const _AnimatedCaption({required this.text, required this.color, required this.fontSize});

  final String text;
  final Color color;
  final double fontSize;

  @override
  State<_AnimatedCaption> createState() => _AnimatedCaptionState();
}

class _AnimatedCaptionState extends State<_AnimatedCaption> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _dotOpacity(double t, double delay) {
    final local = ((t - delay) % 1.0 + 1.0) % 1.0;
    // 0->0.2 fade in, hold, fade out — mirrors a gentle pulse rather than a hard blink.
    if (local < 0.28) return 0.2 + 0.8 * (local / 0.28);
    if (local < 0.5) return 1.0;
    if (local < 0.78) return 1.0 - 0.8 * ((local - 0.5) / 0.28);
    return 0.2;
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.w600, color: widget.color);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.text, style: style),
            for (final delay in const [0.0, 0.14, 0.28])
              Opacity(opacity: _dotOpacity(t, delay), child: Text('.', style: style)),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Shared geometry helpers
// ---------------------------------------------------------------------------

/// Route radius as a fraction of [TravelLoadingIndicator.size]. Kept well
/// under half so the graphic sits inside the box with real margin on every
/// side, rather than filling the frame edge-to-edge.
const double _kRouteRadiusRatio = 0.36;

double _smoothstep(double a, double b, double x) {
  final t = ((x - a) / (b - a)).clamp(0.0, 1.0);
  return t * t * (3 - 2 * t);
}

/// Mirrors `Curves.easeInOut` — kept local so the painter has no Flutter
/// `Curve` object allocation per frame.
double _easeInOut(double t) => t < 0.5 ? 2 * t * t : 1 - math.pow(-2 * t + 2, 2) / 2;

/// A point at [deg] degrees around the route circle centered on the canvas.
Offset _pointOnRoute(double deg, double cx, double cy, double r) {
  final rad = deg * math.pi / 180;
  return Offset(cx + r * math.cos(rad), cy + r * math.sin(rad));
}

void _paintGlyph(Canvas canvas, IconData icon, Offset center, double glyphSize, Color color, {double opacity = 1}) {
  if (opacity <= 0) return;
  final painter = TextPainter(textDirection: TextDirection.ltr)
    ..text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: glyphSize,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: color.withValues(alpha: opacity),
      ),
    )
    ..layout();
  painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
}

// ---------------------------------------------------------------------------
// Static layer: dotted route + destination pin
// ---------------------------------------------------------------------------

class _StaticRoutePainter extends CustomPainter {
  _StaticRoutePainter({required this.dotColor, required this.pinColor, required this.size});

  final Color dotColor;
  final Color pinColor;
  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final cx = canvasSize.width / 2;
    final cy = canvasSize.height / 2;
    final r = size * _kRouteRadiusRatio;

    // Thin, quiet dots — a hairline thread around the route rather than a
    // string of beads. Left at moderate opacity so it still reads clearly
    // against both light and dark surfaces without competing with the
    // sprites for attention.
    final dotPaint = Paint()..color = dotColor.withValues(alpha: dotColor.a * 0.55);
    const dotCount = 84;
    final dotRadius = size * 0.0022;
    for (var i = 0; i < dotCount; i++) {
      final angle = (2 * math.pi / dotCount) * i;
      canvas.drawCircle(Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)), dotRadius, dotPaint);
    }

    final pinAnchor = Offset(cx, cy - size * 0.045);

    // A soft, blurred halo behind the pin for a little depth — subtle
    // enough to read as polish rather than a decoration of its own.
    canvas.drawCircle(
      pinAnchor,
      size * 0.05,
      Paint()
        ..color = pinColor.withValues(alpha: 0.16)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, size * 0.02),
    );

    // Destination pin — tip anchored exactly at the canvas center, which is
    // also where the hotel-phase ripple originates.
    _paintGlyph(canvas, Icons.location_on, pinAnchor, size * 0.1, pinColor);
  }

  @override
  bool shouldRepaint(covariant _StaticRoutePainter oldDelegate) =>
      oldDelegate.dotColor != dotColor || oldDelegate.pinColor != pinColor || oldDelegate.size != size;
}

// ---------------------------------------------------------------------------
// Motion layer: everything that animates, driven by t in seconds (0..3)
// ---------------------------------------------------------------------------

class _MotionPainter extends CustomPainter {
  _MotionPainter({
    required this.t,
    required this.size,
    required this.accent,
    required this.warm,
    required this.ink,
    required this.surface,
  });

  final double t;
  final double size;
  final Color accent;
  final Color warm;
  final Color ink;
  final Color surface;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final cx = canvasSize.width / 2;
    final cy = canvasSize.height / 2;
    final r = size * _kRouteRadiusRatio;
    Offset point(double deg) => _pointOnRoute(deg, cx, cy, r);

    // Reset window (2.7–3.0s): fades everything toward the loop point so
    // the repeat never reads as a jump cut.
    final fade = t > 2.7 ? (1 - (t - 2.7) / 0.3).clamp(0.0, 1.0) : 1.0;

    // ---- Phase 1 (0–1s): flight ----
    // A short ±30° arc centered on the flight station (270°) — restrained,
    // stays clear of the bus/hotel stations 120° away on either side.
    final pt = t.clamp(0.0, 1.0);
    final pp = _easeInOut(pt);
    final planeAngle = 240 + 60 * pp;
    final planePos = point(planeAngle);
    final bank = 5 * math.sin(pp * math.pi);
    final planeOpacity = (t < 1 ? 1.0 : (1 - (t - 1) / 0.12).clamp(0.0, 1.0)) * fade;
    // A short, tightly-spaced, fast-fading trail reads as motion blur behind
    // the plane rather than as several distinct flight icons — a wide
    // spread or high opacity here looks like duplicated sprites instead.
    for (final i in const [2, 1]) {
      final gpt = (pt - i * 0.03).clamp(0.0, 1.0);
      final gpp = _easeInOut(gpt);
      final gAngle = 240 + 60 * gpp;
      _paintRotatedGlyph(canvas, Icons.flight_outlined, point(gAngle), size * 0.055,
          accent.withValues(alpha: (planeOpacity * (0.08 / i)).clamp(0.0, 1.0)),
          gAngle + 90 + 5 * math.sin(gpp * math.pi));
    }
    _paintRotatedGlyph(canvas, Icons.flight_outlined, planePos, size * 0.07, accent.withValues(alpha: planeOpacity),
        planeAngle + 90 + bank);

    // ---- Phase 2 (1–2s): bus ----
    // A short arc centered on the bus station (150°), fully inside the
    // lower-left quadrant — never crosses toward the hotel's side.
    final bt = (t - 1).clamp(0.0, 1.0);
    final bpp = _easeInOut(bt);
    final busAngle = 115 + 60 * bpp;
    final busAngleRad = busAngle * math.pi / 180;
    final bounce = 1.4 * math.sin(bt * 7 * math.pi) * (size / 400);
    final busPos = point(busAngle) -
        Offset(math.cos(busAngleRad), math.sin(busAngleRad)) * bounce;
    final busOpacity =
        (t >= 1 && t < 2 ? 1.0 : (t >= 2 ? (1 - (t - 2) / 0.12).clamp(0.0, 1.0) : 0.0)) * fade;
    if (busOpacity > 0) {
      _paintBus(canvas, busPos, busAngle, bt * 900, accent.withValues(alpha: busOpacity), size);
    }

    // ---- Station glows (persist softly once "visited") ----
    final aF = (t < 1 ? _smoothstep(0.1, 0.5, pt) : 0.4) * fade;
    final aB = (t < 1 ? 0.0 : (t < 2 ? _smoothstep(0.1, 0.5, t - 1) : 0.4)) * fade;
    final aH = (t < 2 ? 0.0 : _smoothstep(0, 0.5, (t - 2) / 0.7)) * fade;
    _paintStation(canvas, point(270), Icons.flight_takeoff_outlined, accent, ink, surface, aF, size);
    _paintStation(canvas, point(150), Icons.directions_bus_outlined, accent, ink, surface, aB, size);
    _paintStation(canvas, point(30), Icons.hotel_outlined, warm, ink, surface, aH, size, windowGlow: aH);

    // ---- Phase 3 (2–2.7s): hotel sparkle + ripple ----
    if (t >= 2) {
      final sp = math.sin(((t - 2.05) / 0.55).clamp(0.0, 1.0) * math.pi);
      if (sp > 0) {
        final sparkleCenter = point(30) - Offset(0, size * 0.075);
        canvas.save();
        canvas.translate(sparkleCenter.dx, sparkleCenter.dy);
        canvas.rotate(sp * math.pi / 2);
        canvas.scale(0.4 + 0.6 * sp);
        _paintSparkle(canvas, size * 0.045, warm.withValues(alpha: (sp * fade).clamp(0.0, 1.0)));
        canvas.restore();
      }
      if (t < 2.85) {
        final rp = ((t - 2.1) / 0.75).clamp(0.0, 1.0);
        if (t >= 2.1 && rp < 1) {
          final ripplePaint = Paint()
            ..color = accent.withValues(alpha: (0.5 * (1 - rp) * fade).clamp(0.0, 1.0))
            ..style = PaintingStyle.stroke
            ..strokeWidth = size * 0.006;
          canvas.drawCircle(Offset(cx, cy - size * 0.045), size * (0.025 + 0.115 * rp), ripplePaint);
        }
      }
    }
  }

  void _paintRotatedGlyph(Canvas canvas, IconData icon, Offset center, double glyphSize, Color color, double headingDeg) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(headingDeg * math.pi / 180);
    _paintGlyph(canvas, icon, Offset.zero, glyphSize, color);
    canvas.restore();
  }

  void _paintStation(Canvas canvas, Offset center, IconData icon, Color activeColor, Color ink, Color surface,
      double activeAmount, double sizeRef, {double windowGlow = 0}) {
    // Same disc radius and icon-to-disc ratio for all three stations —
    // consistent sizing is what makes the set read as one family rather
    // than three unrelated badges.
    final discRadius = sizeRef * 0.05;
    final scale = 1 + 0.05 * activeAmount;

    if (activeAmount > 0.01) {
      final glowPaint = Paint()
        ..color = activeColor.withValues(alpha: activeAmount * 0.2)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, sizeRef * 0.012);
      canvas.drawCircle(center, discRadius * scale * 1.4, glowPaint);
    }

    final discPaint = Paint()..color = surface;
    final borderPaint = Paint()
      ..color = Color.lerp(ink.withValues(alpha: 0.16), activeColor, activeAmount)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = sizeRef * 0.0032;
    canvas.drawCircle(center, discRadius * scale, discPaint);
    canvas.drawCircle(center, discRadius * scale, borderPaint);

    _paintGlyph(canvas, icon, center, discRadius * 0.9, Color.lerp(ink, activeColor, activeAmount)!);

    // Hotel only: a small row of window-lights beneath the roofline,
    // staggered so they visibly switch on one at a time rather than
    // fading in together.
    if (windowGlow > 0.01) {
      for (var i = 0; i < 3; i++) {
        final threshold = i * 0.22;
        final local = ((windowGlow - threshold) / (1 - threshold)).clamp(0.0, 1.0);
        if (local <= 0) continue;
        final wx = (i - 1) * discRadius * 0.42;
        final wp = center + Offset(wx, discRadius * 0.62);
        canvas.drawCircle(wp, sizeRef * 0.0055, Paint()..color = activeColor.withValues(alpha: local));
      }
    }
  }

  void _paintBus(Canvas canvas, Offset center, double headingDeg, double wheelDeg, Color color, double sizeRef) {
    final k = sizeRef / 400;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate((headingDeg - 90) * math.pi / 180);

    final body = Paint()..color = color;
    final windowPaint = Paint()..color = Colors.white.withValues(alpha: 0.9 * color.a);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: 28 * k, height: 15 * k), Radius.circular(5.5 * k)),
      body,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, -2 * k), width: 20 * k, height: 5 * k), Radius.circular(2 * k)),
      windowPaint,
    );

    for (final wx in const [8.0, -8.0]) {
      canvas.save();
      canvas.translate(wx * k, 6 * k);
      canvas.rotate(wheelDeg * math.pi / 180);
      canvas.drawCircle(Offset.zero, 3.6 * k, Paint()..color = color);
      final spoke = Paint()
        ..color = Colors.white.withValues(alpha: 0.9 * color.a)
        ..strokeWidth = k;
      canvas.drawLine(Offset(0, -3.6 * k), Offset(0, 3.6 * k), spoke);
      canvas.restore();
    }
    canvas.restore();
  }

  void _paintSparkle(Canvas canvas, double armLength, Color color) {
    final path = Path()
      ..moveTo(0, -armLength)
      ..quadraticBezierTo(armLength * 0.15, -armLength * 0.15, armLength, 0)
      ..quadraticBezierTo(armLength * 0.15, armLength * 0.15, 0, armLength)
      ..quadraticBezierTo(-armLength * 0.15, armLength * 0.15, -armLength, 0)
      ..quadraticBezierTo(-armLength * 0.15, -armLength * 0.15, 0, -armLength)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MotionPainter oldDelegate) => oldDelegate.t != t;
}
