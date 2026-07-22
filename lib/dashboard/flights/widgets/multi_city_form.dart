import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/providers/flight_search_form_provider.dart';
import 'package:outc/dashboard/flights/widgets/flight_field_card.dart';
import 'package:outc/dashboard/flights/widgets/route_card.dart';
import 'package:outc/dashboard/flights/widgets/search_button.dart';
import 'package:outc/dashboard/flights/widgets/traveller_bottom_sheet.dart';

/// Multi-City search card: a dynamic list of `RouteCard`s, "+ Add City",
/// the travellers/cabin summary row, and the SEARCH button.
class MultiCityFormCard extends StatelessWidget {
  const MultiCityFormCard({
    super.key,
    required this.segments,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.cabinClass,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onPickDate,
    required this.onAddSegment,
    required this.onRemoveSegment,
    required this.onTravellersChanged,
    required this.onSearch,
    required this.isSearching,
    this.minSegments = 2,
  });

  final List<RouteSegmentData> segments;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final CabinClass cabinClass;
  final ValueChanged<int> onPickFrom;
  final ValueChanged<int> onPickTo;
  final ValueChanged<int> onPickDate;
  final VoidCallback onAddSegment;
  final ValueChanged<int> onRemoveSegment;
  final ValueChanged<TravellerSelection> onTravellersChanged;
  final VoidCallback onSearch;
  final bool isSearching;
  final int minSegments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: Column(
            children: [
              for (int i = 0; i < segments.length; i++)
                Padding(
                  key: ValueKey('route-card-$i'),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RouteCard(
                    segment: segments[i],
                    legNumber: i + 1,
                    onPickFrom: () => onPickFrom(i),
                    onPickTo: () => onPickTo(i),
                    onPickDate: () => onPickDate(i),
                    onRemove: segments.length > minSegments ? () => onRemoveSegment(i) : null,
                  ),
                ),
            ],
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onAddSegment,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade400,
                style: BorderStyle.solid,
              ),
            ),
            child: const Center(
              child: Text(
                '+ ADD CITY',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FlightFieldCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TravellerSummaryFields(
                adultCount: adultCount,
                childCount: childCount,
                infantCount: infantCount,
                cabinClass: cabinClass,
                onTapTravellers: () async {
                  final result = await showTravellersBottomSheet(
                    context: context,
                    initialAdults: adultCount,
                    initialChildren: childCount,
                    initialInfants: infantCount,
                  );
                  if (result != null) {
                    onTravellersChanged(TravellerSelection(
                      adults: result.adults,
                      children: result.children,
                      infants: result.infants,
                      cabinClass: cabinClass,
                    ));
                  }
                },
                onTapCabinClass: () async {
                  final result = await showCabinClassBottomSheet(
                    context: context,
                    initialCabinClass: cabinClass,
                  );
                  if (result != null) {
                    onTravellersChanged(TravellerSelection(
                      adults: adultCount,
                      children: childCount,
                      infants: infantCount,
                      cabinClass: result,
                    ));
                  }
                },
              ),
              const SizedBox(height: 20),
              SearchButton(onPressed: isSearching ? null : onSearch, isLoading: isSearching),
            ],
          ),
        ),
      ],
    );
  }
}
