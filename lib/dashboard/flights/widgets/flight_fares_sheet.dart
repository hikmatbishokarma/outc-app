import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/bottom_sheet_shell.dart';
import 'package:outc/dashboard/flights/models/flights_list_model.dart';
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart' show Datum;
import 'package:outc/dashboard/flights/providers/airport_name_cache.dart';
import 'package:outc/dashboard/flights/screens/book_flight_formpage.dart';
import 'package:outc/dashboard/flights/widgets/flight_route_divider.dart';
import 'package:outc/widgets/sharedprefservices.dart';

/// `FlightDetail`'s `fromJson` calls `.toString()` on every string field, so
/// a field the API omitted or sent as `null` doesn't come through as Dart
/// `null` (which `??` could catch) — it comes through as the literal
/// 4-character string `"null"`. Every place in this file that falls back
/// through a chain of fields (`originCity` -> `originName` -> `origin`)
/// needs to treat that string as absent too, or the fallback never fires.
String? _clean(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
  return trimmed;
}

/// Opened by tapping a `FlightResultCard` — spec 0015. Replaces the old
/// per-card "Baggage Details" / "Flight details" `AlertDialog` popups (which
/// read as desktop browser alerts on a phone) and the "Book Now" button that
/// used to sit directly on the card.
///
/// Shows a route/time/duration recap, then one fare block per entry in
/// `flight.fareFamilies.fareFamilies` — that's already a list in the API
/// response (`FareFamily` carries its own price, `isRefundable`, `baggage`,
/// and `fareRules`), but the rest of this module has always hardcoded index
/// `[0]` and silently dropped any other fare on offer. Today most flights
/// still only return one fare family, so most of the time this renders one
/// block — that's expected, not a shortfall of this sheet.
class FlightFaresSheet extends StatelessWidget {
  const FlightFaresSheet({
    super.key,
    required this.flight,
    required this.traceId,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  });

  final FlightDetail flight;
  final String traceId;
  final int adultCount;
  final int childCount;
  final int infantCount;

  static Future<void> show(
    BuildContext context, {
    required FlightDetail flight,
    required String traceId,
    required int adultCount,
    required int childCount,
    required int infantCount,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FlightFaresSheet(
        flight: flight,
        traceId: traceId,
        adultCount: adultCount,
        childCount: childCount,
        infantCount: infantCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final segments = flight.flightSegments ?? const [];
    final firstSegment = segments.isNotEmpty ? segments.first : null;
    final lastSegment = segments.isNotEmpty ? segments.last : null;
    final fareFamilies = flight.fareFamilies?.fareFamilies ?? const [];

    return BottomSheetShell(
      // No bottom action bar — the header's × already closes this, and
      // each fare block below carries its own Book button; a "Close" bar
      // pinned under those would just be a second, redundant way to
      // dismiss the sheet.
      title: 'Flight & Fares',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RouteRecap(flight: flight, firstSegment: firstSegment, lastSegment: lastSegment),
          const SizedBox(height: 16),
          if (fareFamilies.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('No fare details available for this flight.',
                  style: TextStyle(color: Colors.grey.shade600)),
            )
          else
            for (var i = 0; i < fareFamilies.length; i++) ...[
              _FareBlock(
                flight: flight,
                fareFamily: fareFamilies[i],
                fareIndex: i,
                fareCount: fareFamilies.length,
                recommended: fareFamilies.length > 1 && i == 0,
                traceId: traceId,
                adultCount: adultCount,
                childCount: childCount,
                infantCount: infantCount,
              ),
              if (i != fareFamilies.length - 1) const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _RouteRecap extends StatefulWidget {
  const _RouteRecap({required this.flight, required this.firstSegment, required this.lastSegment});
  final FlightDetail flight;
  final FlightSegment? firstSegment;
  final FlightSegment? lastSegment;

  @override
  State<_RouteRecap> createState() => _RouteRecapState();
}

class _RouteRecapState extends State<_RouteRecap> {
  Datum? _originLookup;
  Datum? _destLookup;

  @override
  void initState() {
    super.initState();
    _resolveNames();
  }

  /// The search response's own `originCity`/`originName`/`destinationCity`/
  /// `destiantionName` came back empty on a live check — only the IATA
  /// codes and segment times are populated. Falls back to looking the
  /// codes up via the same `getCitiesbySearch` endpoint the airport-picker
  /// screen already uses (cached — see `AirportNameCache`), rather than
  /// leaving the customer with bare 3-letter codes.
  Future<void> _resolveNames() async {
    final originCode = _clean(widget.firstSegment?.origin) ?? _clean(widget.flight.origin);
    final destCode = _clean(widget.lastSegment?.destination) ?? _clean(widget.flight.destination);
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

  /// City + IATA code + full airport name, falling back gracefully:
  /// segment-level city/airport/code first (each leg's own data), then the
  /// flight-level fields, then the resolved lookup, then the code alone if
  /// that's all there is.
  static (String headline, String? airport) _place({
    String? segmentCity,
    String? segmentAirport,
    String? segmentCode,
    String? flightCity,
    String? flightAirport,
    String? flightCode,
    Datum? lookup,
  }) {
    final city = _clean(segmentCity) ?? _clean(flightCity) ?? _clean(lookup?.city);
    final code = _clean(segmentCode) ?? _clean(flightCode) ?? _clean(lookup?.airportCode);
    final airport = _clean(segmentAirport) ?? _clean(flightAirport) ?? _clean(lookup?.airportDesc);
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
    final flight = widget.flight;
    final firstSegment = widget.firstSegment;
    final lastSegment = widget.lastSegment;
    final segments = flight.flightSegments ?? const [];
    final stopsLabel = segments.length <= 1 ? 'Direct' : '${segments.length - 1} Stop';
    final stopCode = segments.length > 1 ? (_clean(segments[0].destination) ?? _clean(segments[0].destinationName)) : null;

    final (originHeadline, originAirport) = _place(
      segmentCity: firstSegment?.originCity,
      segmentAirport: firstSegment?.originName,
      segmentCode: firstSegment?.origin,
      flightCity: flight.originCity,
      flightAirport: flight.originName,
      flightCode: flight.origin,
      lookup: _originLookup,
    );
    final (destHeadline, destAirport) = _place(
      segmentCity: lastSegment?.destinationCity,
      segmentAirport: lastSegment?.destinationName,
      segmentCode: lastSegment?.destination,
      flightCity: flight.destinationCity,
      flightAirport: flight.destiantionName,
      flightCode: flight.destination,
      lookup: _destLookup,
    );
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: AppColors.subtleBackground, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(originHeadline,
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward, size: 15, color: AppColors.textSecondary),
              ),
              Expanded(
                child: Text(destHeadline,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (originAirport != null || destAirport != null) ...[
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(originAirport ?? '',
                      style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600)),
                ),
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
                    Text('$stopsLabel · ${_clean(flight.duration) ?? ''}',
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

class _FareBlock extends StatefulWidget {
  const _FareBlock({
    required this.flight,
    required this.fareFamily,
    required this.fareIndex,
    required this.fareCount,
    required this.recommended,
    required this.traceId,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  });

  final FlightDetail flight;
  final FareFamily fareFamily;
  final int fareIndex;
  final int fareCount;
  final bool recommended;
  final String traceId;
  final int adultCount;
  final int childCount;
  final int infantCount;

  @override
  State<_FareBlock> createState() => _FareBlockState();
}

class _FareBlockState extends State<_FareBlock> {
  bool _rulesOpen = false;

  /// A fare family's `fareId` is an opaque booking token, not a display
  /// name — showing it verbatim ("Fare qi9wo5yza02/gkAMhLYG7Pr...") is what
  /// this used to do. The pax-level `flightFares` entries carry an actual
  /// human fare label (`fareTag`/`fareDescription`/`fareCode`); fall back to
  /// an ordinal ("Fare Option 2") only when there's more than one fare to
  /// tell apart, and to nothing at all for the common single-fare case.
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
                    Text(
                      fareLabel ?? (isRefundable ? 'Refundable Fare' : 'Standard Fare'),
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
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
                  Text('₹${price.toStringAsFixed(0)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primary)),
                  Text('per adult', style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
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
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: isRefundable ? AppColors.success : AppColors.error)),
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
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: primary, decoration: TextDecoration.underline)),
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
              onPressed: () => _bookThisFare(context, price),
              child: const Text('Book this fare', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  void _bookThisFare(BuildContext context, double totalFare) {
    final flight = widget.flight;
    final fareFamily = widget.fareFamily;
    final segments = flight.flightSegments ?? const [];
    final firstSegment = segments.isNotEmpty ? segments.first : null;
    final lastSegment = segments.isNotEmpty ? segments.last : null;
    final now = DateTime.now();

    // adultBasefare is the fare family's own totalPublishFare * currency
    // (this sheet's `totalFare`) — not `adultFare`, matching the original
    // per-card "Book Now" handler this replaces exactly.
    final adultTaxFare = double.tryParse(fareFamily.markup.toString()) ?? 0;
    final childFare = double.tryParse(fareFamily.childNetFare.toString()) ?? 0;
    final infantFare = double.tryParse(fareFamily.infantNetFare.toString()) ?? 0;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookFlightFormpage(
          traceId: widget.traceId,
          flightId: flight.flightId.toString(),
          fareId: fareFamily.fareId.toString(),
          airlineLogo: flight.airLineLogo ?? '',
          airlineName: '${flight.airLineName} (${flight.airLine}-${firstSegment?.flightNumber ?? ''})',
          airlineStop: segments.length == 1 ? 'Direct' : '${segments.length - 1} Stop',
          airlineClass: 'Economy',
          airlineRefund: fareFamily.isRefundable == true ? 'Refundable' : 'Non Refundable',
          airlineStart: _clean(flight.originCity) ?? _clean(flight.origin) ?? '',
          airlineEnd: _clean(flight.destinationCity) ?? _clean(flight.destination) ?? '',
          airlineStartTime: firstSegment?.departureDateTime != null
              ? DateFormat('HH:mm').format(firstSegment!.departureDateTime!)
              : DateFormat('HH:mm').format(now),
          airlineEndTime: lastSegment?.arrivalDateTime != null
              ? DateFormat('HH:mm').format(lastSegment!.arrivalDateTime!)
              : DateFormat('HH:mm').format(now),
          airlineDuration: flight.duration.toString(),
          adultBasefare: totalFare,
          adulttaxfare: adultTaxFare,
          childBasefare: childFare,
          childtaxfare: 0,
          infantBasefare: infantFare,
          infanttaxfare: 0,
          adultCount: widget.adultCount.toDouble(),
          childCount: widget.childCount.toDouble(),
          infantCount: widget.infantCount.toDouble(),
          selectedFlightDetail: flight,
        ),
      ),
    );
  }
}
