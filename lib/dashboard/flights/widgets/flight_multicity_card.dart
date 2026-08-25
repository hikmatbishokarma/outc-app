import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/flights/models/flight_roundtrip_model.dart';
import 'package:outc/dashboard/flights/widgets/flight_result_card.dart' show FlightAirlineLogo;
import 'package:outc/dashboard/flights/widgets/flight_route_divider.dart';
import 'package:outc/widgets/sharedprefservices.dart';

/// Same "null"-string guard every other flight widget needs (see
/// `FlightResultCard`'s doc comment) — `fromJson` calls `.toString()` on
/// every field, so a missing one comes through as the literal word "null".
String? _clean(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
  return trimmed;
}

/// One priced multi-city itinerary (spec 0016) — a `DataFlightDetail`
/// "combo": N legs (`flightDetails`, however many that is — no leg-count
/// assumption anywhere here) sharing *one* price (`fareFamilies`), unlike
/// `FlightResultCard`'s flat, independently-priced flight. Button-free like
/// its sibling, same precedent: the whole card is the tap target, opening
/// `FlightMulticityTripSheet` for fare/baggage/rules detail.
class FlightMulticityCard extends StatelessWidget {
  const FlightMulticityCard({super.key, required this.itinerary, required this.onTap});

  final DataFlightDetail itinerary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final legs = itinerary.flightDetails ?? const [];
    final currency = double.tryParse(SharedPrefServices.getcurrencyAmount().toString()) ?? 1;
    final fareFamily = itinerary.fareFamilies?.fareFamilies?.isNotEmpty == true
        ? itinerary.fareFamilies!.fareFamilies!.first
        : null;
    final price = (fareFamily?.totalPublishFare ?? 0) * currency;
    final isRefundable = fareFamily?.isRefundable == true;

    final airlineNames = <String>{
      for (final leg in legs)
        if (_clean(leg.airLineName) != null) _clean(leg.airLineName)!,
    };
    final headerLabel = airlineNames.length == 1 ? airlineNames.first : 'Multiple Airlines';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (legs.isNotEmpty) FlightAirlineLogo(url: legs.first.airLineLogo, size: 20),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      headerLabel,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration:
                        BoxDecoration(color: AppColors.subtleBackground, borderRadius: BorderRadius.circular(999)),
                    child: Text('${legs.length} Leg${legs.length == 1 ? '' : 's'}',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade700)),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              for (var i = 0; i < legs.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                _LegRow(leg: legs[i]),
              ],
              Container(
                margin: const EdgeInsets.only(top: 9),
                padding: const EdgeInsets.only(top: 9),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade100))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹${price.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary)),
                        Text(isRefundable ? 'Refundable' : 'Non-refundable',
                            style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: isRefundable ? AppColors.success : AppColors.error)),
                      ],
                    ),
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

/// One leg's compact time/route row within a multicity card — same visual
/// language as `FlightResultCard`'s single row, repeated once per leg.
class _LegRow extends StatelessWidget {
  const _LegRow({required this.leg});
  final FlightDetailFlightDetail leg;

  @override
  Widget build(BuildContext context) {
    final segments = leg.flightSegments ?? const [];
    final first = segments.isNotEmpty ? segments.first : null;
    final last = segments.isNotEmpty ? segments.last : null;
    final stopsLabel = segments.length <= 1 ? 'Direct' : '${segments.length - 1} Stop';
    final stopCode = segments.length > 1 ? (_clean(segments[0].destination) ?? _clean(segments[0].destinationName)) : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                first?.departureDateTime != null ? DateFormat('HH:mm').format(first!.departureDateTime!) : '--:--',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                  _clean(first?.originCity) ?? _clean(leg.originCity) ?? _clean(first?.origin) ?? _clean(leg.origin) ?? '',
                  style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        SizedBox(
          width: 60,
          child: Column(
            children: [
              FlightRouteDivider(dotSize: 5, stopLabel: stopCode),
              const SizedBox(height: 2),
              Text(stopsLabel, style: TextStyle(fontSize: 8.5, color: Colors.grey.shade500)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                last?.arrivalDateTime != null ? DateFormat('HH:mm').format(last!.arrivalDateTime!) : '--:--',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                  _clean(last?.destinationCity) ??
                      _clean(leg.destinationCity) ??
                      _clean(last?.destination) ??
                      _clean(leg.destination) ??
                      '',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
