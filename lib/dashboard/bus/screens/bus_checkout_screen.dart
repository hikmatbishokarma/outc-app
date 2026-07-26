import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:outc/core/widgets/bottom_sheet_shell.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/dashboard/bus/providers/bus_checkout_provider.dart';
import 'package:outc/widgets/colors/colors.dart';

const _titles = ['Mr', 'Mrs', 'Ms'];

/// Checkout screen (spec 0009) — trip summary, price breakup, and passenger
/// details, reached from `BusPickupDropScreen`'s "Next". Still stops short
/// of an actual booking submission (no block/book endpoint captured yet) —
/// "Proceed" shows the same "coming soon" stub used across specs 0006-0008.
class BusCheckoutScreen extends StatelessWidget {
  const BusCheckoutScreen({
    super.key,
    required this.trip,
    required this.selectedSeats,
    required this.boardingPoint,
    required this.droppingPoint,
  });

  final BusTrip trip;
  final List<BusSeat> selectedSeats;
  final BusBoardingPoint boardingPoint;
  final BusBoardingPoint droppingPoint;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BusCheckoutProvider(
        trip: trip,
        selectedSeats: selectedSeats,
        boardingPoint: boardingPoint,
        droppingPoint: droppingPoint,
      ),
      child: const _BusCheckoutView(),
    );
  }
}

class _BusCheckoutView extends StatelessWidget {
  const _BusCheckoutView();

  @override
  Widget build(BuildContext context) {
    return Consumer<BusCheckoutProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Review & Passenger Details'),
            backgroundColor: Colours.strongRed,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionCard(child: _TripSummary(provider: provider)),
                const SizedBox(height: 12),
                for (var i = 0; i < provider.selectedSeats.length; i++) ...[
                  _SectionCard(
                    child: _PassengerForm(
                      index: i,
                      seatCode: provider.selectedSeats[i].seatCode,
                      provider: provider,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                _SectionCard(child: _ContactDetails(provider: provider)),
                const SizedBox(height: 12),
                _TermsRow(provider: provider),
                const SizedBox(height: 100),
              ],
            ),
          ),
          bottomNavigationBar: _BottomBar(provider: provider),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}

class _TripSummary extends StatelessWidget {
  const _TripSummary({required this.provider});
  final BusCheckoutProvider provider;

  static String _formatTime(String isoTime) {
    final parsed = DateTime.tryParse(isoTime);
    if (parsed == null) return '';
    return DateFormat('HH:mm').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final trip = provider.trip;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(trip.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(trip.busType, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 14),
        // Horizontal itinerary row — departure on the left, duration + a
        // dashed timeline in the middle, arrival on the right — matching the
        // reference bus-booking app instead of a stacked icon/label/value
        // list for boarding/dropping/duration.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatTime(provider.boardingPoint.time),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(provider.boardingPoint.name,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            SizedBox(
              width: 76,
              child: Column(
                children: [
                  Text(trip.duration,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  const SizedBox(height: 6),
                  const _DashedLine(),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_formatTime(provider.droppingPoint.time),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(provider.droppingPoint.name,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Selected Seats: ${provider.selectedSeats.map((s) => s.seatCode).join(', ')}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}

/// Small dashed horizontal line under the duration label in the itinerary
/// row — no dashed-line widget exists in this codebase yet, so this is a
/// plain `Row` of short dash segments rather than pulling in a dependency
/// for one visual element.
class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashGap = 4.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashGap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            dashCount,
            (_) => Container(
              width: dashWidth,
              height: 1.5,
              margin: const EdgeInsets.symmetric(horizontal: dashGap / 2),
              color: Colors.grey.shade400,
            ),
          ),
        );
      },
    );
  }
}

/// Fare Summary — reached via the small info icon next to the price in the
/// bottom bar, not shown inline in the main scroll body. Matches the
/// reference bus-booking app's "Fare Summary" bottom sheet pattern.
class _FareSummarySheet extends StatelessWidget {
  const _FareSummarySheet({required this.provider});
  final BusCheckoutProvider provider;

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: 'Fare Summary',
      primaryActionLabel: 'Close',
      primaryActionColor: Colours.strongRed,
      onPrimaryAction: () => Navigator.of(context).pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Base Fare', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          for (final seat in provider.selectedSeats)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Seat ${seat.seatCode}', style: TextStyle(color: Colors.grey.shade700)),
                  Text('₹${seat.fare.toStringAsFixed(0)}'),
                ],
              ),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Amount to be paid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '₹${provider.totalFare.toStringAsFixed(0)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colours.strongRed),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PassengerForm extends StatelessWidget {
  const _PassengerForm({required this.index, required this.seatCode, required this.provider});
  final int index;
  final String seatCode;
  final BusCheckoutProvider provider;

  @override
  Widget build(BuildContext context) {
    final passenger = provider.passengers[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Passenger ${index + 1} · Seat $seatCode',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 68,
              child: DropdownButtonFormField<String>(
                initialValue: passenger.title,
                isExpanded: true,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                icon: const Icon(Icons.arrow_drop_down, size: 16),
                decoration: _decoration('Title'),
                items: _titles.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) {
                  if (value != null) provider.updatePassenger(index, title: value);
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                style: const TextStyle(fontSize: 13),
                decoration: _decoration('Name'),
                onChanged: (value) => provider.updatePassenger(index, name: value),
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 48,
              child: TextField(
                style: const TextStyle(fontSize: 13),
                keyboardType: TextInputType.number,
                decoration: _decoration('Age'),
                onChanged: (value) => provider.updatePassenger(index, age: value),
              ),
            ),
            const SizedBox(width: 6),
            _GenderToggle(
              selected: passenger.gender,
              onChanged: (value) => provider.updatePassenger(index, gender: value),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      );
}

/// Compact male/female icon-toggle — matches the reference bus-booking app's
/// inline avatar-style gender picker instead of a two-line `RadioListTile`
/// pair, so the whole passenger row (title/name/age/gender) fits in one
/// horizontal line.
class _GenderToggle extends StatelessWidget {
  const _GenderToggle({required this.selected, required this.onChanged});
  final String? selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Plain man/woman person icons instead of the male/female
        // astrological (mars/venus) symbols — clearer at a glance than a
        // symbol most people don't immediately read as a gender marker.
        _icon(Icons.man, 'Male'),
        const SizedBox(width: 3),
        _icon(Icons.woman, 'Female'),
      ],
    );
  }

  Widget _icon(IconData icon, String value) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: isSelected ? Colours.strongRed : Colors.grey.shade100,
        child: Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey.shade500),
      ),
    );
  }
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails({required this.provider});
  final BusCheckoutProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text('For the whole booking, not per passenger',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.phone,
          decoration: _decoration('Phone'),
          onChanged: provider.setPhone,
        ),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: _decoration('Email'),
          onChanged: provider.setEmail,
        ),
      ],
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      );
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.provider});
  final BusCheckoutProvider provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: provider.termsAccepted,
          activeColor: Colours.strongRed,
          onChanged: (value) => provider.setTermsAccepted(value ?? false),
        ),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('I agree to the '),
              _LegalLink(label: 'Terms & Conditions', onTap: () => _showLegalSheet(context, 'Terms & Conditions')),
              const Text(' and '),
              _LegalLink(label: 'Privacy Policy', onTap: () => _showLegalSheet(context, 'Privacy Policy')),
            ],
          ),
        ),
      ],
    );
  }

  void _showLegalSheet(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BottomSheetShell(
        title: title,
        primaryActionLabel: 'Close',
        primaryActionColor: Colours.strongRed,
        onPrimaryAction: () => Navigator.of(context).pop(),
        body: Text(
          '$title content will appear here once available.',
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(color: Colours.strongRed, fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.provider});
  final BusCheckoutProvider provider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => _FareSummarySheet(provider: provider),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₹${provider.totalFare.toStringAsFixed(0)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colours.strongRed),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colours.strongRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              onPressed: provider.canProceed
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking coming soon')),
                      );
                    }
                  : null,
              child: const Text('Proceed', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
