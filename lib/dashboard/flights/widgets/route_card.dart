import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/providers/flight_search_form_provider.dart';
import 'package:outc/dashboard/flights/widgets/airport_selector.dart';
import 'package:outc/dashboard/flights/widgets/flight_date_field.dart';
import 'package:outc/dashboard/flights/widgets/flight_field_card.dart';

/// One multi-city leg: FROM, TO, and DATE as three compact columns (matching
/// the reference multi-city layout), plus a delete button when removable.
class RouteCard extends StatelessWidget {
  const RouteCard({
    super.key,
    required this.segment,
    required this.legNumber,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onPickDate,
    this.onRemove,
  });

  final RouteSegmentData segment;
  final int legNumber;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onPickDate;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FLIGHT $legNumber',
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Colors.grey.shade500,
                ),
              ),
              if (onRemove != null)
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(14),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 18, color: Colors.grey),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
