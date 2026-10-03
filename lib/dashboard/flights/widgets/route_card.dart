import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/providers/flight_search_form_provider.dart';
import 'package:outc/dashboard/flights/widgets/airport_selector.dart';
import 'package:outc/dashboard/flights/widgets/flight_date_field.dart';
import 'package:outc/dashboard/flights/widgets/flight_field_card.dart';

/// One multi-city leg: FROM, TO, and DATE as three compact columns, plus a
/// trailing remove button when this leg can be deleted. Deliberately no card
/// chrome (border/background/padding) and no per-leg "FLIGHT N" caption —
/// `MultiCityFormCard` renders the FROM/TO/DATE column headers once, above
/// the whole list of these rows (MMT-style), instead of wrapping each leg in
/// its own boxed card and repeating the headers inside it.
class RouteCard extends StatelessWidget {
  const RouteCard({
    super.key,
    required this.segment,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onPickDate,
    this.onRemove,
  });

  final RouteSegmentData segment;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onPickDate;
  final VoidCallback? onRemove;

  /// Reserved on every row — including ones that can't be removed — so the
  /// FROM/TO/DATE columns stay lined up under the shared header regardless
  /// of which individual rows actually show the delete button.
  static const double removeSlotWidth = 28;

  @override
  Widget build(BuildContext context) {
    // IntrinsicHeight + stretch: FROM/TO (AirportSelector, 2 text lines) and
    // DATE (FlightDateField, 2 text lines) don't always share the exact same
    // natural content height, and FlightFieldBox is a plain Container that
    // just hugs whatever it's given — left as CrossAxisAlignment.start, a
    // shorter box could end up visibly out of step with the other two,
    // breaking the three-column row's alignment.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FlightFieldBox(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: AirportSelector(
                label: 'FROM',
                city: segment.originCity,
                airportCode: segment.originAirportCode,
                country: segment.originCountry,
                onTap: onPickFrom,
                compact: true,
                showLabel: false,
                placeholder: 'From',
                emphasizePlaceholder: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FlightFieldBox(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: AirportSelector(
                label: 'TO',
                city: segment.destinationCity,
                airportCode: segment.destinationAirportCode,
                country: segment.destinationCountry,
                onTap: onPickTo,
                compact: true,
                showLabel: false,
                placeholder: 'To',
                emphasizePlaceholder: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FlightFieldBox(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: FlightDateField(
                label: 'DATE',
                date: segment.date,
                onTap: onPickDate,
                compact: true,
                showLabel: false,
              ),
            ),
          ),
          SizedBox(
            width: removeSlotWidth,
            child: onRemove == null
                ? null
                : Center(
                    child: InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(14),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close, size: 18, color: Colors.grey),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
