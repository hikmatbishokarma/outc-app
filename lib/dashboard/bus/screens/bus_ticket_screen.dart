import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/app_top_bar.dart';
import 'package:outc/dashboard/bus/models/bus_booking_models.dart';
import 'package:outc/dashboard/bus/models/bus_passenger_model.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/dashboard/dashboard.dart';

/// Ticket/confirmation screen (spec 0009's booking step) shown after
/// `BusCheckoutProvider.submitBooking()` confirms the booking. The bus
/// module's one glass-surface hero slot is already spent on the
/// seat-selection legend sheet (`docs/architecture.md` §4), so this screen
/// uses the same flat rounded-card style as `BusCheckoutScreen` rather than
/// a second `GlassSurface` in the same flow.
class BusTicketScreen extends StatelessWidget {
  const BusTicketScreen({
    super.key,
    required this.booking,
    required this.trip,
    required this.selectedSeats,
    required this.boardingPoint,
    required this.droppingPoint,
    required this.passengers,
    required this.totalFare,
  });

  final BusBookResponse booking;
  final BusTrip trip;
  final List<BusSeat> selectedSeats;
  final BusBoardingPoint boardingPoint;
  final BusBoardingPoint droppingPoint;
  final List<BusPassengerDetails> passengers;
  final double totalFare;

  static String _formatTime(String isoTime) {
    final parsed = DateTime.tryParse(isoTime);
    if (parsed == null) return '';
    return DateFormat('HH:mm').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final data = booking.data!;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.panelBackground,
        appBar: const AppTopBar(
            title: 'Booking Confirmed', automaticallyImplyLeading: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionCard(
                  child: _StatusBanner(pnr: data.pnr, status: data.status)),
              const SizedBox(height: 12),
              _SectionCard(
                  child: _TripSummary(
                      trip: trip,
                      boardingPoint: boardingPoint,
                      droppingPoint: droppingPoint)),
              const SizedBox(height: 12),
              _SectionCard(
                child: _PassengerList(
                    selectedSeats: selectedSeats, passengers: passengers),
              ),
              const SizedBox(height: 12),
              _SectionCard(child: _FareRow(totalFare: totalFare)),
              const SizedBox(height: 24),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const Dashboard()),
                  (route) => false,
                ),
                child: const Text('Go to Home',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
      ),
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

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.pnr, required this.status});
  final String pnr;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle, color: AppColors.success, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status == 'CONFIRMED' ? 'Booking Confirmed' : status,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'PNR: $pnr',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TripSummary extends StatelessWidget {
  const _TripSummary(
      {required this.trip,
      required this.boardingPoint,
      required this.droppingPoint});
  final BusTrip trip;
  final BusBoardingPoint boardingPoint;
  final BusBoardingPoint droppingPoint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(trip.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(trip.busType, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(BusTicketScreen._formatTime(boardingPoint.time),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(boardingPoint.name,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  if (boardingPoint.address.isNotEmpty)
                    Text(boardingPoint.address,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, size: 18, color: Colors.grey.shade400),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(BusTicketScreen._formatTime(droppingPoint.time),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(droppingPoint.name,
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  if (droppingPoint.address.isNotEmpty)
                    Text(droppingPoint.address,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PassengerList extends StatelessWidget {
  const _PassengerList({required this.selectedSeats, required this.passengers});
  final List<BusSeat> selectedSeats;
  final List<BusPassengerDetails> passengers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Passengers',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        for (var i = 0; i < selectedSeats.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(passengers[i].gender == 'Female' ? Icons.woman : Icons.man,
                    size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      '${passengers[i].name} · ${passengers[i].age} yrs',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                Text('Seat ${selectedSeats[i].seatCode}',
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
              ],
            ),
          ),
      ],
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow({required this.totalFare});
  final double totalFare;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Amount Paid',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(
          '₹${totalFare.toStringAsFixed(0)}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
