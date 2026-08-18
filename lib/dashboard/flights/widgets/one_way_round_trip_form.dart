import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/providers/flight_search_form_provider.dart';
import 'package:outc/dashboard/flights/widgets/airport_selector.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/flights/widgets/flight_date_field.dart';
import 'package:outc/dashboard/flights/widgets/flight_field_card.dart';
import 'package:outc/dashboard/flights/widgets/search_button.dart';
import 'package:outc/dashboard/flights/widgets/traveller_bottom_sheet.dart';

/// One Way / Round Trip search card: FROM, TO, departure date, conditional
/// return date ("+ ADD RETURN DATE" when unset), travellers/cabin summary
/// row, and the SEARCH button.
class OneWayRoundTripFormCard extends StatelessWidget {
  const OneWayRoundTripFormCard({
    super.key,
    required this.tripType,
    required this.fromCity,
    required this.fromCode,
    required this.fromCountry,
    required this.toCity,
    required this.toCode,
    required this.toCountry,
    required this.departureDate,
    required this.returnDate,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.cabinClass,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSwapCities,
    required this.onPickDeparture,
    required this.onPickReturn,
    required this.onTravellersChanged,
    required this.onSearch,
    required this.isSearching,
  });

  final TripType tripType;
  final String? fromCity;
  final String? fromCode;
  final String? fromCountry;
  final String? toCity;
  final String? toCode;
  final String? toCountry;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final CabinClass cabinClass;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSwapCities;
  final VoidCallback onPickDeparture;
  final VoidCallback onPickReturn;
  final ValueChanged<TravellerSelection> onTravellersChanged;
  final VoidCallback onSearch;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final isRoundTrip = tripType == TripType.roundTrip;

    return FlightFieldCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: FlightFieldBox(
                      child: AirportSelector(
                        label: 'FROM',
                        city: fromCity,
                        airportCode: fromCode,
                        country: fromCountry,
                        onTap: onPickFrom,
                        compact: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FlightFieldBox(
                      child: AirportSelector(
                        label: 'TO',
                        city: toCity,
                        airportCode: toCode,
                        country: toCountry,
                        onTap: onPickTo,
                        compact: true,
                      ),
                    ),
                  ),
                ],
              ),
              _SwapCitiesButton(onTap: onSwapCities),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FlightFieldBox(
                  child: FlightDateField(
                    label: 'DEPARTURE DATE',
                    date: departureDate,
                    onTap: onPickDeparture,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FlightFieldBox(
                  child: FlightDateField(
                    label: 'RETURN DATE',
                    // Only show as "set" while actually in Round Trip — a
                    // date picked during an earlier Round Trip visit is
                    // preserved internally (so switching back keeps it) but
                    // must display as empty while on One Way.
                    date: isRoundTrip ? returnDate : null,
                    placeholder: isRoundTrip ? 'Select Date' : '+ Add Return Date',
                    helperText: isRoundTrip ? null : 'Save more on round trips!',
                    emphasizePlaceholder: !isRoundTrip,
                    onTap: onPickReturn,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
          // isLoading is deliberately not tied to isSearching here — the
          // screen already covers itself with Flight_ProgressBar's full-
          // screen TravelLoadingIndicator overlay while a search is in
          // flight, so also swapping this button's own content for a
          // spinner produced two loaders on screen at once. onPressed still
          // disables the tap.
          SearchButton(onPressed: isSearching ? null : onSearch),
        ],
      ),
    );
  }
}

/// Small circular swap icon centered between FROM and TO, matching the
/// reference travel-app UX. Spins 180° each tap.
class _SwapCitiesButton extends StatefulWidget {
  const _SwapCitiesButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_SwapCitiesButton> createState() => _SwapCitiesButtonState();
}

class _SwapCitiesButtonState extends State<_SwapCitiesButton> {
  double _turns = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: CircleBorder(side: BorderSide(color: AppColors.primary, width: 1.2)),
      elevation: 1.5,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          setState(() => _turns += 0.5);
          widget.onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedRotation(
            turns: _turns,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: Icon(Icons.swap_horiz, size: 18, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
