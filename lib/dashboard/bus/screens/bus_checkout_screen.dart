import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:outc/core/payment_gateway.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/app_top_bar.dart';
import 'package:outc/core/widgets/bottom_sheet_shell.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/dashboard/bus/providers/bus_checkout_provider.dart';
import 'package:outc/dashboard/bus/screens/bus_eticket_screen.dart';
import 'package:outc/core/widgets/booking_step_overlay.dart';
import 'package:outc/loginflow/auth_gate.dart';

/// Checkout screen (spec 0009) — trip summary, price breakup, and passenger
/// details, reached from `BusPickupDropScreen`'s "Next". "Proceed" gates on
/// `ensureLoggedIn` (a guest has no real customerId to book against — same
/// guard flights' booking screens use), then calls
/// `BusCheckoutProvider.blockSeats()`, routes through `paymentGatewayFor`
/// (`lib/core/payment_gateway.dart` — the same mock-Cashfree/wallet
/// abstraction flights already uses), and on payment success calls
/// `confirmBooking()` and pushes `BusETicketScreen`, keyed by the booking's
/// `referenceNo` (the same ref `ticketDetails` is fetched by).
class BusCheckoutScreen extends StatelessWidget {
  const BusCheckoutScreen({
    super.key,
    required this.searchId,
    required this.tripId,
    required this.trip,
    required this.selectedSeats,
    required this.boardingPoint,
    required this.droppingPoint,
  });

  final String searchId;
  final String tripId;
  final BusTrip trip;
  final List<BusSeat> selectedSeats;
  final BusBoardingPoint boardingPoint;
  final BusBoardingPoint droppingPoint;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BusCheckoutProvider(
        searchId: searchId,
        tripId: tripId,
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
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.panelBackground,
              appBar: const AppTopBar(title: 'Review & Passenger Details'),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionCard(child: _TripSummary(provider: provider)),
                    const SizedBox(height: 12),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Traveller Details',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 14),
                          for (var i = 0; i < provider.selectedSeats.length; i++) ...[
                            if (i > 0) ...[
                              const SizedBox(height: 14),
                              Divider(height: 1, color: Colors.grey.shade200),
                              const SizedBox(height: 14),
                            ],
                            _PassengerForm(
                              index: i,
                              seatCode: provider.selectedSeats[i].seatCode,
                              provider: provider,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SectionCard(child: _ContactDetails(provider: provider)),
                    const SizedBox(height: 12),
                    _TermsRow(provider: provider),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              bottomNavigationBar: _BottomBar(provider: provider),
            ),
            // Covers the passenger-details form during both blockSeats()
            // (before payment) and confirmBooking() (after payment) — for
            // the latter, this also stops the raw form flashing back on
            // screen for the length of that network call between the
            // payment webview closing and the ticket screen replacing this
            // one.
            if (provider.phase == BookingPhase.reservingSeat)
              BookingStepOverlay(
                icon: Icons.event_seat,
                title: 'Reserving your seat',
                subtitle: "We're securing your selected seats before taking you to payment.",
                steps: provider.activeSteps,
                currentStep: provider.currentStep,
                footerIcon: Icons.lock_outline,
                footerText: 'Your selected seats are being held for you. This usually takes 2–5 seconds.',
                footerColor: Theme.of(context).colorScheme.primary,
              )
            else if (provider.phase == BookingPhase.bookingTrip)
              BookingStepOverlay(
                icon: Icons.confirmation_number,
                title: 'Booking your trip',
                subtitle: "Your payment was successful. We're confirming your booking.",
                steps: provider.activeSteps,
                currentStep: provider.currentStep,
                footerIcon: Icons.check_circle_outline,
                footerText: 'Your payment is safe and secure. This usually takes a few seconds.',
                footerColor: AppColors.success,
              ),
          ],
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
        Text(trip.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(provider.boardingPoint.name,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            SizedBox(
              width: 76,
              child: Column(
                children: [
                  Text(trip.duration,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 11)),
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(provider.droppingPoint.name,
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12)),
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
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashGap)).floor();
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
      primaryActionColor: Theme.of(context).colorScheme.primary,
      onPrimaryAction: () => Navigator.of(context).pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Base Fare',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          for (final seat in provider.selectedSeats)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Seat ${seat.seatCode}',
                      style: TextStyle(color: Colors.grey.shade700)),
                  Text('₹${seat.fare.toStringAsFixed(0)}'),
                ],
              ),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Amount to be paid',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '₹${provider.totalFare.toStringAsFixed(0)}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PassengerForm extends StatelessWidget {
  const _PassengerForm(
      {required this.index, required this.seatCode, required this.provider});
  final int index;
  final String seatCode;
  final BusCheckoutProvider provider;

  @override
  Widget build(BuildContext context) {
    final passenger = provider.passengers[index];
    // No "Passenger N · Seat X" heading here — the selected seats are
    // already listed once in _TripSummary above, repeating them per row
    // was redundant (MMT doesn't repeat it either, it's implicit by order).
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            decoration: _decoration(context, 'Full Name'),
            onChanged: (value) => provider.updatePassenger(index, name: value),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: _decoration(context, 'Age'),
            onChanged: (value) => provider.updatePassenger(index, age: value),
          ),
        ),
        const SizedBox(width: 10),
        _GenderToggle(
          selected: passenger.gender,
          onChanged: (value) => provider.updatePassenger(index, gender: value),
        ),
      ],
    );
  }

  // Outlined, not filled-gray — matches the reference bus-booking app's
  // field style. Same decoration _ContactDetails uses elsewhere on this
  // screen, so Name/Age look identical to Phone/Email.
  InputDecoration _decoration(BuildContext context, String label) => InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400)),
      );
}

/// Male/female icon picker — each icon keeps its own colored border at rest
/// (blue for male, pink for female) so the two are distinguishable before
/// picking either one, not just after. Selecting one fills its circle solid;
/// distinct man/woman glyphs, not the same icon recolored, so they're
/// actually readable as different at a glance.
class _GenderToggle extends StatelessWidget {
  const _GenderToggle({required this.selected, required this.onChanged});
  final String? selected;
  final ValueChanged<String> onChanged;

  static const _maleColor = Color(0xFF2F6FED);
  static const _femaleColor = Color(0xFFE0459C);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _icon(Icons.man, 'Male', _maleColor),
        const SizedBox(width: 8),
        _icon(Icons.woman, 'Female', _femaleColor),
      ],
    );
  }

  Widget _icon(IconData icon, String value, Color color) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Icon(icon, size: 20, color: isSelected ? Colors.white : color),
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
        const Text('Contact Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text('For the whole booking, not per passenger',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.phone,
          decoration: _decoration(context, 'Phone Number', prefixText: '+91  '),
          onChanged: provider.setPhone,
        ),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration:
              _decoration(context, 'Email Address', prefixIcon: Icons.email_outlined),
          onChanged: provider.setEmail,
        ),
      ],
    );
  }

  // Same outlined style as _PassengerForm's Name/Age fields. Phone gets a
  // +91 text prefix (country code is more useful here than an icon); Email
  // gets an icon (a country code doesn't apply) — whichever fits the field.
  // Both go through prefixIcon, not InputDecoration.prefixText — prefixText
  // sits behind the resting (unfocused+empty) label and only becomes
  // visible once focused, which hid +91 entirely at rest.
  InputDecoration _decoration(BuildContext context, String label,
          {String? prefixText, IconData? prefixIcon}) =>
      InputDecoration(
        labelText: label,
        isDense: true,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(prefixIcon, size: 20, color: Colors.grey.shade500),
              )
            : prefixText != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 4),
                    child: Center(
                      widthFactor: 1,
                      child: Text(prefixText,
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                    ),
                  )
                : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400)),
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
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (value) => provider.setTermsAccepted(value ?? false),
        ),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('I agree to the '),
              _LegalLink(
                  label: 'Terms & Conditions',
                  onTap: () => _showLegalSheet(context, 'Terms & Conditions')),
              const Text(' and '),
              _LegalLink(
                  label: 'Privacy Policy',
                  onTap: () => _showLegalSheet(context, 'Privacy Policy')),
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
        primaryActionColor: Theme.of(context).colorScheme.primary,
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
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline),
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
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, -2)),
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.info_outline,
                        size: 16, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              onPressed: provider.canProceed && !provider.isBooking
                  ? () => _submit(context, provider)
                  : null,
              child: provider.isBooking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Proceed',
                      style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(
      BuildContext context, BusCheckoutProvider provider) async {
    final loggedIn = await ensureLoggedIn(context);
    if (!context.mounted) return;
    if (!loggedIn) return;

    final blockData = await provider.blockSeats();
    if (!context.mounted) return;
    if (blockData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                provider.errorMessage ?? 'Booking failed. Please try again.')),
      );
      return;
    }

    paymentGatewayFor(blockData.pgType).open(
      context,
      PgBlockPaymentData(
        paymentLink: blockData.paymentLink ?? '',
        pgType: blockData.pgType,
      ),
      onResult: (pgResult) async {
        if (pgResult.status != PgResultStatus.success) return;

        final result = await provider.confirmBooking();
        if (!context.mounted) return;
        if (result == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(provider.errorMessage ??
                    'Booking failed. Please try again.')),
          );
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => BusETicketScreen(refNo: result.data!.referenceNo),
          ),
        );
      },
    );
  }
}
