import 'package:flutter/material.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart' show Datum;

/// Cleans a `FlightDetail` string field for display — `fromJson` calls
/// `.toString()` on every field, so a missing one comes through as the
/// literal string "null", not Dart `null` (a plain `??` fallback never
/// catches that).
String? cleanFlightFieldLabel(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
  return trimmed;
}

/// The city name if the airport-name lookup resolved one for this code,
/// else the bare IATA code — shared by both results screens' trip bar so
/// the "prefer city, fall back to code" rule stays in one place.
String placeLabel(String? code, Datum? lookup) {
  final city = cleanFlightFieldLabel(lookup?.city);
  final cleanCode = cleanFlightFieldLabel(code) ?? cleanFlightFieldLabel(lookup?.airportCode);
  if (city != null && cleanCode != null) return city;
  return cleanCode ?? 'Unknown';
}

/// The editable trip bar pinned above a results list/dual-pane: a back
/// arrow (no separate app-bar toolbar above it — this bar *is* the top of
/// the screen), the route, an "Edit" link into the "Modify Flight Search"
/// sheet, and a subtitle line (date(s)/travellers/cabin). Shared by oneway
/// and round trip so the two don't carry duplicate copies of the same
/// chrome — they previously did (`_TripSummaryBar` / `_RoundTripSummaryBar`,
/// near-identical classes), and only differ in the route-label separator
/// (`→` vs `⇄`) and whether the subtitle carries one date or a range, both
/// of which the caller already has to build anyway.
class FlightTripSummaryBar extends StatelessWidget {
  const FlightTripSummaryBar({
    super.key,
    required this.routeLabel,
    required this.subtitle,
    required this.onBack,
    required this.onEdit,
  });

  final String routeLabel;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 6, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Text(
                  routeLabel,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: const Text('Edit', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Text(subtitle, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }
}
