import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:outc/core/payment_gateway.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/app_top_bar.dart';
import 'package:outc/core/widgets/booking_step_overlay.dart';
import 'package:outc/core/widgets/bottom_sheet_shell.dart';
import 'package:outc/dashboard/flights/models/flight_checkout_draft.dart';
import 'package:outc/dashboard/flights/models/flight_eticket_data.dart';
import 'package:outc/dashboard/flights/providers/flight_checkout_provider.dart';
import 'package:outc/dashboard/flights/screens/flight_eticket_screen.dart';
import 'package:outc/loginflow/auth_gate.dart';
import 'package:outc/widgets/sharedprefservices.dart';

/// Passenger-details + payment step for the oneway/roundtrip/multicity
/// flight flow (spec 0013), reached from `oneway_flight_list.dart`,
/// `fetched_roundtrip_flights.dart`, and `fetched_multicity_flights.dart`.
/// Same public constructor as before this redesign, so none of those
/// callers needed changes. Mirrors bus's `BusCheckoutScreen`: a
/// `FlightCheckoutProvider` owns validation and the price -> block -> pay ->
/// book sequence, `BookingStepOverlay` (from `lib/core/widgets/`, shared
/// with bus) covers the form while pricing/booking is in flight, and a
/// successful booking lands on `FlightETicketScreen` instead of the old
/// static `TicketView`.
class BookFlightFormpage extends StatelessWidget {
  const BookFlightFormpage({
    super.key,
    required this.airlineLogo,
    required this.airlineName,
    required this.airlineStop,
    required this.airlineClass,
    required this.airlineRefund,
    required this.airlineStart,
    required this.airlineEnd,
    required this.traceId,
    required this.flightId,
    required this.fareId,
    required this.airlineDuration,
    required this.airlineStartTime,
    required this.airlineEndTime,
    required this.adultBasefare,
    required this.adulttaxfare,
    required this.childBasefare,
    required this.childtaxfare,
    required this.infantBasefare,
    required this.infanttaxfare,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  });

  final String airlineLogo;
  final String airlineName;
  final String airlineStop;
  final String airlineClass;
  final String airlineRefund;
  final String airlineStart;
  final String airlineEnd;
  final String traceId;
  final String flightId;
  final String fareId;
  final String airlineDuration;
  final String airlineStartTime;
  final String airlineEndTime;
  final double adultBasefare;
  final double adulttaxfare;
  final double childBasefare;
  final double childtaxfare;
  final double infantBasefare;
  final double infanttaxfare;
  final double adultCount;
  final double childCount;
  final double infantCount;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlightCheckoutProvider(
        traceId: traceId,
        flightId: flightId,
        fareId: fareId,
        adultCount: adultCount.toInt(),
        childCount: childCount.toInt(),
        infantCount: infantCount.toInt(),
        adultBasefare: adultBasefare,
        adulttaxfare: adulttaxfare,
        childBasefare: childBasefare,
        childtaxfare: childtaxfare,
        infantBasefare: infantBasefare,
        infanttaxfare: infanttaxfare,
      ),
      child: _FormView(widget: this),
    );
  }
}

class _FormView extends StatelessWidget {
  const _FormView({required this.widget});
  final BookFlightFormpage widget;

  @override
  Widget build(BuildContext context) {
    return Consumer<FlightCheckoutProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.panelBackground,
              appBar: const AppTopBar(title: 'Booking Details'),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionCard(child: _FlightSummary(widget: widget)),
                    const SizedBox(height: 12),
                    _SectionCard(child: _ContactDetailsCard(provider: provider)),
                    const SizedBox(height: 12),
                    _SectionCard(child: _PassengerSection(provider: provider)),
                    const SizedBox(height: 12),
                    _TermsRow(provider: provider),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              bottomNavigationBar: _BottomBar(provider: provider, widget: widget),
            ),
            // Covers the form during both priceAndBlock() (before payment)
            // and confirmBooking() (after payment) — same treatment as
            // BusCheckoutScreen's overlay stack.
            if (provider.phase == FlightBookingPhase.pricing)
              BookingStepOverlay(
                icon: Icons.confirmation_number_outlined,
                title: 'Holding your fare',
                subtitle: "We're confirming the latest price and holding your seat before payment.",
                steps: provider.activeSteps,
                currentStep: provider.currentStep,
                footerIcon: Icons.lock_outline,
                footerText: 'Your fare is being held for you. This usually takes a few seconds.',
                footerColor: Theme.of(context).colorScheme.primary,
              )
            else if (provider.phase == FlightBookingPhase.booking)
              BookingStepOverlay(
                icon: Icons.flight_takeoff,
                title: 'Booking your flight',
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

class _FlightSummary extends StatelessWidget {
  const _FlightSummary({required this.widget});
  final BookFlightFormpage widget;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(widget.airlineName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Text(widget.airlineStop, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _InfoChip(label: widget.airlineClass, icon: Icons.event_seat_outlined),
            const SizedBox(width: 8),
            _InfoChip(
              label: widget.airlineRefund,
              icon: widget.airlineRefund.toLowerCase().contains('non')
                  ? Icons.block
                  : Icons.check_circle_outline,
              color: widget.airlineRefund.toLowerCase().contains('non')
                  ? AppColors.error
                  : AppColors.success,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.airlineStartTime,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(widget.airlineStart,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            SizedBox(
              width: 76,
              child: Column(
                children: [
                  Text(widget.airlineDuration,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: _DashedLine(color: Colors.grey.shade400)),
                      Icon(Icons.flight, size: 14, color: primary),
                      Expanded(child: _DashedLine(color: Colors.grey.shade400)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.airlineEndTime,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(widget.airlineEnd,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon, this.color});
  final String label;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Colors.grey.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: chipColor),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: chipColor, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Small dashed horizontal line either side of the route icon — same
/// approach as `FlightETicketScreen`'s private `_DashedLine` (built from
/// boxes via `LayoutBuilder`, not a `CustomPainter`).
class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const gap = 3.0;
        final count = (constraints.maxWidth / (dashWidth + gap)).floor().clamp(1, 1000);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(width: dashWidth, height: 1.5, color: color),
          ),
        );
      },
    );
  }
}

InputDecoration _fieldDecoration(BuildContext context, String label,
    {String? prefixText, IconData? prefixIcon}) {
  return InputDecoration(
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
                  child: Text(prefixText, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                ),
              )
            : null,
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
  );
}

class _ContactDetailsCard extends StatefulWidget {
  const _ContactDetailsCard({required this.provider});
  final FlightCheckoutProvider provider;

  @override
  State<_ContactDetailsCard> createState() => _ContactDetailsCardState();
}

class _ContactDetailsCardState extends State<_ContactDetailsCard> {
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: SharedPrefServices.getphonenumber());
    _emailController = TextEditingController(text: SharedPrefServices.getemail());
    _addressController = TextEditingController();
    // Push whatever pre-filled from the saved session straight into the
    // provider so a returning logged-in customer doesn't have to touch
    // these fields for `validate()` to pass, matching the original screen's
    // pre-filled-controller behavior.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.provider.setPhone(_phoneController.text);
      widget.provider.setEmail(_emailController.text);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: _fieldDecoration(context, 'Phone Number', prefixText: '+91  ').copyWith(
            counterText: '',
          ),
          onChanged: widget.provider.setPhone,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _fieldDecoration(context, 'Email Address', prefixIcon: Icons.email_outlined),
          onChanged: widget.provider.setEmail,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _addressController,
          maxLines: 3,
          decoration: _fieldDecoration(context, 'Address', prefixIcon: Icons.home_outlined),
          onChanged: widget.provider.setAddress,
        ),
      ],
    );
  }
}

class _PassengerSection extends StatelessWidget {
  const _PassengerSection({required this.provider});
  final FlightCheckoutProvider provider;

  @override
  Widget build(BuildContext context) {
    final passengers = provider.passengers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Traveller Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 14),
        for (var i = 0; i < passengers.length; i++) ...[
          if (i > 0) ...[
            const SizedBox(height: 14),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 14),
          ],
          Text(_passengerLabel(passengers, i),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          _PassengerFormCard(index: i, provider: provider),
        ],
      ],
    );
  }

  static String _passengerLabel(List<FlightPassengerDraft> passengers, int index) {
    final type = passengers[index].paxType;
    final typeLabel = switch (type) {
      FlightPaxType.adult => 'Adult',
      FlightPaxType.child => 'Child',
      FlightPaxType.infant => 'Infant',
    };
    final ordinal = passengers.take(index + 1).where((p) => p.paxType == type).length;
    return '$typeLabel $ordinal';
  }
}

class _PassengerFormCard extends StatefulWidget {
  const _PassengerFormCard({required this.index, required this.provider});
  final int index;
  final FlightCheckoutProvider provider;

  @override
  State<_PassengerFormCard> createState() => _PassengerFormCardState();
}

class _PassengerFormCardState extends State<_PassengerFormCard> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _dobController;
  late final TextEditingController _nationalityController;

  FlightPassengerDraft get _passenger => widget.provider.passengers[widget.index];

  @override
  void initState() {
    super.initState();
    final passenger = _passenger;
    _firstNameController = TextEditingController(text: passenger.firstName);
    _lastNameController = TextEditingController(text: passenger.lastName);
    _dobController = TextEditingController(text: passenger.dob);
    _nationalityController = TextEditingController(text: passenger.nationality);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 30),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    final formatted = DateFormat('dd-MM-yyyy').format(picked);
    setState(() => _dobController.text = formatted);
    widget.provider.updatePassenger(widget.index, dob: formatted);
  }

  @override
  Widget build(BuildContext context) {
    final passenger = _passenger;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 96,
              child: DropdownButtonFormField<String>(
                initialValue: passenger.title,
                decoration: _fieldDecoration(context, 'Title'),
                items: [
                  for (final title in passenger.paxType.titleOptions)
                    DropdownMenuItem(value: title, child: Text(title)),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  widget.provider.updatePassenger(widget.index, title: value);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _firstNameController,
                decoration: _fieldDecoration(context, 'First Name'),
                onChanged: (value) =>
                    widget.provider.updatePassenger(widget.index, firstName: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _lastNameController,
          decoration: _fieldDecoration(context, 'Last Name'),
          onChanged: (value) => widget.provider.updatePassenger(widget.index, lastName: value),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _dobController,
                readOnly: true,
                onTap: _pickDob,
                decoration: _fieldDecoration(context, 'Date of Birth'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _nationalityController,
                decoration: _fieldDecoration(context, 'Nationality'),
                onChanged: (value) =>
                    widget.provider.updatePassenger(widget.index, nationality: value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.provider});
  final FlightCheckoutProvider provider;

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
              const Text('I agree to all the '),
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

/// Fare Summary — reached via the small info icon next to the price in the
/// bottom bar, same "not shown inline in the main scroll" pattern bus's
/// `_FareSummarySheet` uses. Also carries the (decorative, non-functional —
/// same as before this redesign) promo-code field.
class _FareSummarySheet extends StatelessWidget {
  const _FareSummarySheet({required this.provider});
  final FlightCheckoutProvider provider;

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
          _fareLine('Base Fare', provider.basefare),
          const SizedBox(height: 6),
          _fareLine('Taxes and Fees', provider.taxes),
          const SizedBox(height: 6),
          _fareLine('Convenience Fee', FlightCheckoutProvider.convenienceFee),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                'INR ${provider.grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Apply Promo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: _fieldDecoration(context, 'Enter Your Promo Code'),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                // Same as before this redesign: no promo backend exists yet,
                // so this stays a decorative no-op.
                onPressed: () {},
                child: const Text('APPLY'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fareLine(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        Text('INR ${amount.toStringAsFixed(2)}'),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.provider, required this.widget});
  final FlightCheckoutProvider provider;
  final BookFlightFormpage widget;

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
                      'INR ${provider.grandTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              onPressed: provider.isBooking ? null : () => _submit(context, provider),
              child: provider.isBooking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Proceed', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, FlightCheckoutProvider provider) async {
    final validationError = provider.validate();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(validationError)));
      return;
    }

    final loggedIn = await ensureLoggedIn(context);
    if (!context.mounted) return;
    if (!loggedIn) return;

    final blockData = await provider.priceAndBlock();
    if (!context.mounted) return;
    if (blockData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Booking failed. Please try again.')),
      );
      return;
    }

    paymentGatewayFor(blockData.pgType).open(
      context,
      PgBlockPaymentData(paymentLink: blockData.paymentLink, pgType: blockData.pgType),
      onResult: (pgResult) async {
        if (pgResult.status != PgResultStatus.success) return;

        final bookResponse = await provider.confirmBooking();
        if (!context.mounted) return;
        if (bookResponse == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage ?? 'Booking failed. Please try again.')),
          );
          return;
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => FlightETicketScreen(
              data: FlightETicketData(
                ticketAllData: bookResponse.charges.ticketAllData,
                cabinClass: widget.airlineClass,
                refundPolicy: widget.airlineRefund,
              ),
            ),
          ),
        );
      },
    );
  }
}
