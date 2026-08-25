import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/bottom_sheet_shell.dart';
import 'package:outc/dashboard/flights/models/flight_roundtrip_model.dart';
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart' show Datum;
import 'package:outc/dashboard/flights/providers/airport_name_cache.dart';
import 'package:outc/dashboard/flights/widgets/flight_route_divider.dart';
import 'package:outc/widgets/sharedprefservices.dart';

String? _clean(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
  return trimmed;
}

/// Opened by tapping a `FlightMulticityCard` — spec 0016, the N-leg sibling
/// of `FlightFaresSheet`. Shows one route/time recap per leg (however many
/// that is), then one fare block per entry in the itinerary's
/// `fareFamilies.fareFamilies[]` — same "don't hardcode `[0]`" precedent as
/// the oneway sheet. Selecting a fare shows an honest "coming soon" state
/// instead of navigating anywhere — see spec 0016's Out of scope: a
/// multicity combo shares one fare across N legs, and there's no existing
/// block/book request shape in this codebase for that yet.
class FlightMulticityTripSheet extends StatelessWidget {
  const FlightMulticityTripSheet({super.key, required this.itinerary});

  final DataFlightDetail itinerary;

  static Future<void> show(BuildContext context, {required DataFlightDetail itinerary}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FlightMulticityTripSheet(itinerary: itinerary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final legs = itinerary.flightDetails ?? const [];
    final fareFamilies = itinerary.fareFamilies?.fareFamilies ?? const [];

    return BottomSheetShell(
      // No bottom action bar, same reasoning as the oneway fare sheet: the
      // header's × already closes this, and each fare block below carries
      // its own action.
      title: 'Trip & Fares',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < legs.length; i++) ...[
            _LegRouteRecap(leg: legs[i], legNumber: i + 1, legCount: legs.length),
            if (i != legs.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 16),
          if (fareFamilies.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('No fare details available for this itinerary.',
                  style: TextStyle(color: Colors.grey.shade600)),
            )
          else
            for (var i = 0; i < fareFamilies.length; i++) ...[
              _MulticityFareBlock(
                fareFamily: fareFamilies[i],
                fareIndex: i,
                fareCount: fareFamilies.length,
                recommended: fareFamilies.length > 1 && i == 0,
              ),
              if (i != fareFamilies.length - 1) const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _LegRouteRecap extends StatefulWidget {
  const _LegRouteRecap({required this.leg, required this.legNumber, required this.legCount});
  final FlightDetailFlightDetail leg;
  final int legNumber;
  final int legCount;

  @override
  State<_LegRouteRecap> createState() => _LegRouteRecapState();
}

class _LegRouteRecapState extends State<_LegRouteRecap> {
  Datum? _originLookup;
  Datum? _destLookup;

  @override
  void initState() {
    super.initState();
    _resolveNames();
  }

  Future<void> _resolveNames() async {
    final segments = widget.leg.flightSegments ?? const [];
    final first = segments.isNotEmpty ? segments.first : null;
    final last = segments.isNotEmpty ? segments.last : null;
    final originCode = _clean(first?.origin) ?? _clean(widget.leg.origin);
    final destCode = _clean(last?.destination) ?? _clean(widget.leg.destination);
    final results = await Future.wait([
      AirportNameCache.resolve(originCode),
      AirportNameCache.resolve(destCode),
    ]);
    if (!mounted) return;
    setState(() {
      _originLookup = results[0];
      _destLookup = results[1];
    });
  }

  static (String headline, String? airport) _place({
    String? segmentCity,
    String? segmentAirport,
    String? segmentCode,
    String? legCity,
    String? legAirport,
    String? legCode,
    Datum? lookup,
  }) {
    final city = _clean(segmentCity) ?? _clean(legCity) ?? _clean(lookup?.city);
    final code = _clean(segmentCode) ?? _clean(legCode) ?? _clean(lookup?.airportCode);
    final airport = _clean(segmentAirport) ?? _clean(legAirport) ?? _clean(lookup?.airportDesc);
    final headline = switch ((city, code)) {
      (String c, String cd) => '$c ($cd)',
      (String c, null) => c,
      (null, String cd) => cd,
      (null, null) => 'Unknown',
    };
    return (headline, airport);
  }

  @override
  Widget build(BuildContext context) {
    final leg = widget.leg;
    final segments = leg.flightSegments ?? const [];
    final firstSegment = segments.isNotEmpty ? segments.first : null;
    final lastSegment = segments.isNotEmpty ? segments.last : null;
    final stopsLabel = segments.length <= 1 ? 'Direct' : '${segments.length - 1} Stop';
    final stopCode = segments.length > 1 ? (_clean(segments[0].destination) ?? _clean(segments[0].destinationName)) : null;

    final (originHeadline, originAirport) = _place(
      segmentCity: firstSegment?.originCity,
      segmentAirport: firstSegment?.originName,
      segmentCode: firstSegment?.origin,
      legCity: leg.originCity,
      legAirport: leg.originName,
      legCode: leg.origin,
      lookup: _originLookup,
    );
    final (destHeadline, destAirport) = _place(
      segmentCity: lastSegment?.destinationCity,
      segmentAirport: lastSegment?.destinationName,
      segmentCode: lastSegment?.destination,
      legCity: leg.destinationCity,
      legAirport: leg.destiantionName,
      legCode: leg.destination,
      lookup: _destLookup,
    );

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: AppColors.subtleBackground, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.legCount > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('LEG ${widget.legNumber} OF ${widget.legCount}',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                      color: Theme.of(context).colorScheme.primary)),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(originHeadline, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward, size: 15, color: AppColors.textSecondary),
              ),
              Expanded(
                child: Text(destHeadline,
                    textAlign: TextAlign.end, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (originAirport != null || destAirport != null) ...[
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(originAirport ?? '', style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600))),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(destAirport ?? '',
                      textAlign: TextAlign.end, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600)),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    firstSegment?.departureDateTime != null
                        ? DateFormat('HH:mm').format(firstSegment!.departureDateTime!)
                        : '--:--',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (firstSegment?.departureDateTime != null)
                    Text(DateFormat('dd MMM yyyy').format(firstSegment!.departureDateTime!),
                        style: TextStyle(fontSize: 9.5, color: Colors.grey.shade500)),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('$stopsLabel · ${_clean(leg.duration) ?? ''}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    FlightRouteDivider(dotSize: 6.5, stopLabel: stopCode),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    lastSegment?.arrivalDateTime != null
                        ? DateFormat('HH:mm').format(lastSegment!.arrivalDateTime!)
                        : '--:--',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (lastSegment?.arrivalDateTime != null)
                    Text(DateFormat('dd MMM yyyy').format(lastSegment!.arrivalDateTime!),
                        style: TextStyle(fontSize: 9.5, color: Colors.grey.shade500)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MulticityFareBlock extends StatefulWidget {
  const _MulticityFareBlock({
    required this.fareFamily,
    required this.fareIndex,
    required this.fareCount,
    required this.recommended,
  });

  final FareFamily fareFamily;
  final int fareIndex;
  final int fareCount;
  final bool recommended;

  @override
  State<_MulticityFareBlock> createState() => _MulticityFareBlockState();
}

class _MulticityFareBlockState extends State<_MulticityFareBlock> {
  bool _rulesOpen = false;

  String? _fareLabel(FareFamily fareFamily) {
    final flightFares = fareFamily.flightFares ?? const [];
    for (final fare in flightFares) {
      final label = _clean(fare.fareTag) ?? _clean(fare.fareDescription) ?? _clean(fare.fareCode);
      if (label != null) return label;
    }
    return widget.fareCount > 1 ? 'Fare Option ${widget.fareIndex + 1}' : null;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final fareFamily = widget.fareFamily;
    final currency = double.tryParse(SharedPrefServices.getcurrencyAmount().toString()) ?? 1;
    final price = (fareFamily.totalPublishFare ?? 0) * currency;
    final isRefundable = fareFamily.isRefundable == true;
    final baggage = fareFamily.baggage ?? const [];
    final fareRules = fareFamily.fareRules ?? const [];
    final fareLabel = _fareLabel(fareFamily);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.recommended ? primary : Colors.grey.shade200, width: widget.recommended ? 1.4 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text(fareLabel ?? (isRefundable ? 'Refundable Fare' : 'Standard Fare'),
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                    if (widget.recommended)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(5)),
                        child: const Text('RECOMMENDED',
                            style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${price.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primary)),
                  Text('for this itinerary', style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: (isRefundable ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(isRefundable ? 'Refundable' : 'Non-refundable',
                style: TextStyle(
                    fontSize: 9.5, fontWeight: FontWeight.w600, color: isRefundable ? AppColors.success : AppColors.error)),
          ),
          const SizedBox(height: 9),
          if (baggage.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.luggage_outlined, size: 15, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    baggage
                        .map((b) {
                          final cabin = _clean(b.cabinBaggageInfo);
                          final checkIn = _clean(b.baggageInfo);
                          final parts = [
                            if (cabin != null) '$cabin cabin',
                            if (checkIn != null) '$checkIn check-in',
                          ];
                          return parts.join(' · ');
                        })
                        .where((s) => s.isNotEmpty)
                        .join(' · '),
                    style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          if (fareRules.isNotEmpty) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => setState(() => _rulesOpen = !_rulesOpen),
              child: Row(
                children: [
                  Text('Fare rules',
                      style: TextStyle(
                          fontSize: 10.5, fontWeight: FontWeight.w600, color: primary, decoration: TextDecoration.underline)),
                  Icon(_rulesOpen ? Icons.expand_less : Icons.expand_more, size: 16, color: primary),
                ],
              ),
            ),
            if (_rulesOpen)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final rule in fareRules)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          _clean(rule.fareRuleDetail) ?? _clean(rule.fareRestriction) ?? 'Rules not available for this fare.',
                          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700, height: 1.4),
                        ),
                      ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 11),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
              onPressed: () => _showComingSoon(context),
              child: const Text('Select this fare', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  // Multi-city booking needs its own price/block/book request shape (a
  // combo shares one fare across N legs — the existing oneway/round-trip
  // flows don't have anything for that, see spec 0016's Out of scope). This
  // is an honest placeholder, not a silent no-op or a fabricated booking
  // call against real payment endpoints.
  void _showComingSoon(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Coming soon'),
        content: const Text('Booking for multi-city trips is coming soon. You can compare fares and itineraries for now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
