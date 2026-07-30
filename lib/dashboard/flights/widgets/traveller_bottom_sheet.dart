import 'package:flutter/material.dart';

import 'package:outc/core/widgets/bottom_sheet_shell.dart';
import 'package:outc/core/widgets/stepper_control.dart';
import 'package:outc/dashboard/flights/providers/flight_search_form_provider.dart';
import 'package:outc/dashboard/flights/widgets/cabin_selector.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/flights/widgets/flight_field_card.dart';

class TravellerSelection {
  const TravellerSelection({
    required this.adults,
    required this.children,
    required this.infants,
    required this.cabinClass,
  });

  final int adults;
  final int children;
  final int infants;
  final CabinClass cabinClass;
}

class TravellerCounts {
  const TravellerCounts({required this.adults, required this.children, required this.infants});

  final int adults;
  final int children;
  final int infants;
}

/// Opens the Travellers sheet (Adults/Children/Infants only), matching the
/// reference's dedicated "Select Travellers & Class" sheet for this field.
Future<TravellerCounts?> showTravellersBottomSheet({
  required BuildContext context,
  required int initialAdults,
  required int initialChildren,
  required int initialInfants,
}) {
  return showModalBottomSheet<TravellerCounts>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _TravellersSheetContent(
      initialAdults: initialAdults,
      initialChildren: initialChildren,
      initialInfants: initialInfants,
    ),
  );
}

/// Opens the Cabin Class sheet on its own, matching the reference's
/// dedicated "Select Cabin Class" sheet for this field.
Future<CabinClass?> showCabinClassBottomSheet({
  required BuildContext context,
  required CabinClass initialCabinClass,
}) {
  return showModalBottomSheet<CabinClass>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CabinClassSheetContent(initialCabinClass: initialCabinClass),
  );
}

/// Travellers and Cabin Class shown as two separate side-by-side tappable
/// fields (matching the reference layout), each opening its own dedicated
/// bottom sheet.
class TravellerSummaryFields extends StatelessWidget {
  const TravellerSummaryFields({
    super.key,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.cabinClass,
    required this.onTapTravellers,
    required this.onTapCabinClass,
  });

  final int adultCount;
  final int childCount;
  final int infantCount;
  final CabinClass cabinClass;
  final VoidCallback onTapTravellers;
  final VoidCallback onTapCabinClass;

  @override
  Widget build(BuildContext context) {
    final total = adultCount + childCount + infantCount;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FlightFieldBox(
            child: _SummaryFieldTile(
              label: 'TRAVELLERS',
              icon: Icons.person_outline,
              value: '$total Traveller${total == 1 ? '' : 's'}',
              onTap: onTapTravellers,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FlightFieldBox(
            child: _SummaryFieldTile(
              label: 'CABIN CLASS',
              icon: Icons.airline_seat_recline_normal_outlined,
              value: cabinClass.label,
              onTap: onTapCabinClass,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryFieldTile extends StatelessWidget {
  const _SummaryFieldTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TravellersSheetContent extends StatefulWidget {
  const _TravellersSheetContent({
    required this.initialAdults,
    required this.initialChildren,
    required this.initialInfants,
  });

  final int initialAdults;
  final int initialChildren;
  final int initialInfants;

  @override
  State<_TravellersSheetContent> createState() => _TravellersSheetContentState();
}

class _TravellersSheetContentState extends State<_TravellersSheetContent> {
  late int adults = widget.initialAdults;
  late int children = widget.initialChildren;
  late int infants = widget.initialInfants;

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: 'Select Travellers & Class',
      primaryActionLabel: 'DONE',
      primaryActionColor: AppColors.primary,
      onPrimaryAction: () {
        Navigator.of(context).pop(
          TravellerCounts(adults: adults, children: children, infants: infants),
        );
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepperControl(
            label: 'Adults',
            sublabel: '12 years & above',
            value: adults,
            min: 1,
            max: 9,
            accentColor: AppColors.primary,
            onChanged: (v) => setState(() => adults = v),
          ),
          const SizedBox(height: 18),
          StepperControl(
            label: 'Children',
            sublabel: '2 - 12 years',
            value: children,
            min: 0,
            max: 9,
            accentColor: AppColors.primary,
            onChanged: (v) => setState(() => children = v),
          ),
          const SizedBox(height: 18),
          StepperControl(
            label: 'Infants',
            sublabel: 'Under 2 years',
            value: infants,
            min: 0,
            max: 9,
            accentColor: AppColors.primary,
            onChanged: (v) => setState(() => infants = v),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _CabinClassSheetContent extends StatefulWidget {
  const _CabinClassSheetContent({required this.initialCabinClass});

  final CabinClass initialCabinClass;

  @override
  State<_CabinClassSheetContent> createState() => _CabinClassSheetContentState();
}

class _CabinClassSheetContentState extends State<_CabinClassSheetContent> {
  late CabinClass cabinClass = widget.initialCabinClass;

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: 'Select Cabin Class',
      primaryActionLabel: 'DONE',
      primaryActionColor: AppColors.primary,
      onPrimaryAction: () => Navigator.of(context).pop(cabinClass),
      body: CabinSelector(
        selected: cabinClass,
        onChanged: (c) => setState(() => cabinClass = c),
      ),
    );
  }
}
