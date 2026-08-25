import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/flights/models/flights_list_model.dart';
import 'package:outc/dashboard/flights/widgets/flight_route_divider.dart';
import 'package:outc/widgets/sharedprefservices.dart';

/// `FlightDetail`'s `fromJson` calls `.toString()` on every string field, so
/// an omitted/null API field comes through as the literal string `"null"`,
/// not Dart `null` — a plain `??` fallback never catches that. Every field
/// read here needs this filter first, or "null" renders verbatim on screen.
String? _clean(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
  return trimmed;
}

/// `FlightDetail.duration` comes straight from the backend and is usually
/// fine (oneway search), but the domestic round-trip endpoint has been seen
/// to send back a placeholder ("00:00 hrs") instead of a real value for
/// every result. Rather than show that literally, fall back to computing it
/// from the first/last segment's own times whenever the backend's value
/// looks like a placeholder — same spirit as `_priceBounds()`'s fallback
/// for an unusable backend price range.
String _durationLabel(FlightDetail flight) {
  final raw = _clean(flight.duration);
  final digitsOnly = raw?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
  final looksReal = raw != null && digitsOnly.contains(RegExp(r'[1-9]'));
  if (looksReal) return raw;

  final segments = flight.flightSegments ?? const [];
  final departure = segments.isNotEmpty ? segments.first.departureDateTime : null;
  final arrival = segments.isNotEmpty ? segments.last.arrivalDateTime : null;
  if (departure == null || arrival == null) return raw ?? '';
  final diff = arrival.difference(departure);
  if (diff.inMinutes <= 0) return raw ?? '';
  return '${diff.inHours}h ${diff.inMinutes % 60}m';
}

/// A single flight result — spec 0015. Button-free: airline, times, route,
/// duration, direct/stop badge, and price are the only things on it, and
/// the whole card is the tap target (opens `FlightFaresSheet`). Previously
/// each result also carried Baggage/Flight-details/Book Now buttons,
/// stacked underneath a much taller "ticket" card design.
///
/// Shared by the oneway results list and both panes of the round-trip
/// dual-pane view — one widget, not copies.
class FlightResultCard extends StatelessWidget {
  const FlightResultCard({
    super.key,
    required this.flight,
    required this.onTap,
    this.dense = false,
    this.selected = false,
  });

  final FlightDetail flight;
  final VoidCallback onTap;

  /// Slightly tighter padding/type for the round-trip dual-pane, whose
  /// onward pane is narrower than a full-width oneway list.
  final bool dense;

  /// Round trip only: this is the flight currently picked for its leg —
  /// drawn with a colored border so the choice stays visible even after
  /// the user drags to the other pane and back. Oneway never sets this.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final segments = flight.flightSegments ?? const [];
    final firstSegment = segments.isNotEmpty ? segments.first : null;
    final lastSegment = segments.isNotEmpty ? segments.last : null;
    final stopsLabel = segments.length <= 1 ? 'Direct' : '${segments.length - 1} Stop';
    // The layover airport for a 1-stop-or-more flight is where the first
    // segment lands — shown as a dot + code on the route line itself, not
    // just the "1 Stop" badge, per the reference apps.
    final stopCode = segments.length > 1 ? (_clean(segments[0].destination) ?? _clean(segments[0].destinationName)) : null;
    final currency = double.tryParse(SharedPrefServices.getcurrencyAmount().toString()) ?? 1;
    final fareFamily = flight.fareFamilies?.fareFamilies?.isNotEmpty == true
        ? flight.fareFamilies!.fareFamilies!.first
        : null;
    final price = (fareFamily?.totalPublishFare ?? 0) * currency;
    final isRefundable = flight.isRefundable == true;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(dense ? 10 : 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? primary : Colors.grey.shade200, width: selected ? 1.6 : 1),
            color: selected ? primary.withValues(alpha: 0.04) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FlightAirlineLogo(url: flight.airLineLogo, size: dense ? 18 : 20),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      [
                        if (_clean(flight.airLineName) case final name?) name,
                        if (_clean(flight.airLine) case final code?)
                          '$code${_clean(firstSegment?.flightNumber) != null ? '-${firstSegment!.flightNumber}' : ''}',
                      ].join(' · '),
                      style: TextStyle(
                          fontSize: dense ? 11.5 : 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(stopsLabel,
                        style: const TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              SizedBox(height: dense ? 6 : 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstSegment?.departureDateTime != null
                              ? DateFormat('HH:mm').format(firstSegment!.departureDateTime!)
                              : '--:--',
                          style: TextStyle(fontSize: dense ? 13 : 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            _clean(firstSegment?.originCity) ??
                                _clean(flight.originCity) ??
                                _clean(firstSegment?.origin) ??
                                _clean(flight.origin) ??
                                '',
                            style: TextStyle(fontSize: dense ? 9.5 : 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: dense ? 56 : 72,
                    child: Column(
                      children: [
                        FlightRouteDivider(dotSize: dense ? 5 : 6, stopLabel: stopCode),
                        const SizedBox(height: 2),
                        Text(_durationLabel(flight),
                            style: TextStyle(fontSize: dense ? 8.5 : 9.5, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          lastSegment?.arrivalDateTime != null
                              ? DateFormat('HH:mm').format(lastSegment!.arrivalDateTime!)
                              : '--:--',
                          style: TextStyle(fontSize: dense ? 13 : 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            _clean(lastSegment?.destinationCity) ??
                                _clean(flight.destinationCity) ??
                                _clean(lastSegment?.destination) ??
                                _clean(flight.destination) ??
                                '',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: dense ? 9.5 : 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: dense ? 6 : 9),
              Container(
                padding: EdgeInsets.only(top: dense ? 6 : 9),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade100))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹${price.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: dense ? 14 : 16, fontWeight: FontWeight.bold, color: primary)),
                        Text(isRefundable ? 'Refundable' : 'Non-refundable',
                            style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: isRefundable ? AppColors.success : AppColors.error)),
                      ],
                    ),
                    if (!dense)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('View fares', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: primary)),
                          Icon(Icons.chevron_right, size: 16, color: primary),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The airline logo chip — public so the round-trip dual pane's peek-rail
/// mini-cards can show it too, not just the full result card.
class FlightAirlineLogo extends StatelessWidget {
  const FlightAirlineLogo({super.key, required this.url, required this.size});
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty || url == 'null') {
      return _fallback();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.network(
        url!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _fallback(),
        loadingBuilder: (context, child, progress) => progress == null ? child : _fallback(),
      ),
    );
  }

  Widget _fallback() => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(5)),
        child: const Icon(Icons.flight, color: Colors.white, size: 11),
      );
}
