import 'package:flutter/material.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/flights/providers/flight_search_form_provider.dart';
import 'package:outc/dashboard/flights/widgets/route_card.dart';
import 'package:outc/dashboard/flights/widgets/search_button.dart';
import 'package:outc/dashboard/flights/widgets/traveller_bottom_sheet.dart';

/// Multi-City search card: FROM/TO/DATE column headers shown once, a dynamic
/// list of `RouteCard` leg rows underneath, "+ Add City", the travellers/
/// cabin summary row, and the SEARCH button — all flowing directly on the
/// page background rather than boxed into separate per-section cards.
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
    this.searchButtonLabel = 'SEARCH FLIGHTS',
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
  final String searchButtonLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Column headers shown once, above the whole list of leg rows —
        // each row below reuses these instead of repeating a "FLIGHT N"
        // card + inline FROM/TO/DATE labels per leg (MMT-style).
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            children: [
              Expanded(child: _ColumnHeader('FROM')),
              SizedBox(width: 8),
              Expanded(child: _ColumnHeader('TO')),
              SizedBox(width: 8),
              Expanded(child: _ColumnHeader('DATE')),
              SizedBox(width: RouteCard.removeSlotWidth),
            ],
          ),
        ),
        const SizedBox(height: 6),
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
        // isLoading deliberately not tied to isSearching — see the matching
        // comment in one_way_round_trip_form.dart. The full-screen
        // Flight_ProgressBar overlay already shows the loading animation;
        // onPressed still disables the tap.
        SearchButton(onPressed: isSearching ? null : onSearch, label: searchButtonLabel),
      ],
    );
  }
}

/// Small caps column caption ("FROM"/"TO"/"DATE") shown once above the leg
/// rows — the MMT-style header this whole layout replaces per-row labels
/// with.
class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 11,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: AppColors.primary,
      ),
    );
  }
}
