import 'package:outc/dashboard/flights/models/flight_roundtrip_model.dart';
import 'package:outc/dashboard/flights/widgets/flight_filters_sheet.dart';

/// `FlightFilterAdapter` for a multi-city itinerary combo (`DataFlightDetail`
/// — see `flight_roundtrip_model.dart` and spec 0016's API contract section
/// for why this is the shape the backend actually returns for a
/// "multidestination" search). Unlike `flightDetailFilterAdapter`'s flat
/// per-flight fields, a combo bundles N legs under *one* shared
/// `fareFamilies`/price, so "price"/"refundable" come from the combo's fare
/// rather than any single leg, "direct" means every leg is direct, and
/// "airlines"/"connecting locations" union across every leg instead of
/// reading one flight's own fields.

String? _cleanLabel(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
  return trimmed;
}

Duration _legDuration(FlightDetailFlightDetail leg) {
  final segments = leg.flightSegments ?? const [];
  if (segments.isEmpty) return Duration.zero;
  final departure = segments.first.departureDateTime;
  final arrival = segments.last.arrivalDateTime;
  if (departure == null || arrival == null) return Duration.zero;
  return arrival.difference(departure);
}

final FlightFilterAdapter<DataFlightDetail> multicityFilterAdapter = FlightFilterAdapter<DataFlightDetail>(
  price: (combo, currency) {
    final fareFamilies = combo.fareFamilies?.fareFamilies;
    final fare = fareFamilies != null && fareFamilies.isNotEmpty ? (fareFamilies.first.adultPublishFare ?? 0) : 0;
    return fare * currency;
  },
  // "Non Stop"/"Direct" for a whole itinerary only makes sense as "every
  // leg is direct" — there's no single "1 stop" number across N legs with
  // potentially different stop counts each, so `isOneStop` always reads
  // false here and that chip simply never renders (`hasOneStop: false` at
  // the results-screen call site).
  isDirect: (combo) => (combo.flightDetails ?? const []).every((leg) => (leg.flightSegments?.length ?? 0) <= 1),
  isOneStop: (_) => false,
  departureTime: (combo) {
    final legs = combo.flightDetails ?? const [];
    if (legs.isEmpty) return null;
    final segments = legs.first.flightSegments ?? const [];
    return segments.isNotEmpty ? segments.first.departureDateTime : null;
  },
  // The itinerary's overall arrival is its *last* leg's *last* segment
  // landing — not the first leg's, unlike the flat adapter's "arrival"
  // (which is really "first segment's arrival," a pre-existing quirk kept
  // as-is for `FlightDetail` rather than changed here).
  arrivalTime: (combo) {
    final legs = combo.flightDetails ?? const [];
    if (legs.isEmpty) return null;
    final segments = legs.last.flightSegments ?? const [];
    return segments.isNotEmpty ? segments.last.arrivalDateTime : null;
  },
  isRefundable: (combo) {
    final fareFamilies = combo.fareFamilies?.fareFamilies;
    return fareFamilies != null && fareFamilies.isNotEmpty ? fareFamilies.first.isRefundable : null;
  },
  airlines: (combo) => {
        for (final leg in combo.flightDetails ?? const [])
          if (_cleanLabel(leg.airLineName) != null) _cleanLabel(leg.airLineName)!,
      },
  connectingLocations: (combo) => {
        for (final leg in combo.flightDetails ?? const [])
          if ((leg.flightSegments?.length ?? 0) > 1 && _cleanLabel(leg.flightSegments!.first.destinationName) != null)
            _cleanLabel(leg.flightSegments!.first.destinationName)!,
      },
  duration: (combo) =>
      (combo.flightDetails ?? const []).fold(Duration.zero, (sum, leg) => sum + _legDuration(leg)),
);
