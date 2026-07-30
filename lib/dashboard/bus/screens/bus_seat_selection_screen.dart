import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:outc/core/widgets/async_state_view.dart';
import 'package:outc/core/widgets/bottom_sheet_shell.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/dashboard/bus/providers/bus_seat_selection_provider.dart';
import 'package:outc/dashboard/bus/screens/bus_pickup_drop_screen.dart';
import 'package:outc/dashboard/bus/widgets/bus_seat_grid.dart';

/// Real seat-selection screen (spec 0008) — replaces the "Seat selection
/// coming soon" stub on the results screen's "Show Seats" button. Fetches
/// the real seat map from `tripAvailability` and lets the customer select
/// seats up to the passenger count they searched with, then hands off to
/// `BusPickupDropScreen` for boarding/dropping-point selection — matching
/// how real bus-booking apps sequence the flow (seats first, pickup/drop
/// second) rather than showing both at once. Stops there — booking/payment
/// has no captured endpoint yet (see spec's Out of scope).
class BusSeatSelectionScreen extends StatelessWidget {
  const BusSeatSelectionScreen({
    super.key,
    required this.searchId,
    required this.tripId,
    required this.trip,
    required this.passengerCount,
  });

  final String searchId;
  final String tripId;
  final BusTrip trip;
  final int passengerCount;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BusSeatSelectionProvider(
        searchId: searchId,
        tripId: tripId,
        passengerCount: passengerCount,
      )..load(),
      child: _BusSeatSelectionView(trip: trip),
    );
  }
}

class _BusSeatSelectionView extends StatelessWidget {
  const _BusSeatSelectionView({required this.trip});
  final BusTrip trip;

  @override
  Widget build(BuildContext context) {
    return Consumer<BusSeatSelectionProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(trip.displayName,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                Text(trip.busType, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => _showLegendSheet(context),
                icon: const Icon(Icons.info_outline, color: Colors.white),
                tooltip: 'Seat info',
              ),
            ],
          ),
          body: _buildBody(context, provider),
          bottomNavigationBar: _BottomBar(provider: provider, trip: trip),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BusSeatSelectionProvider provider) {
    return AsyncStateView<List<BusSeat>>(
      state: provider.state,
      onRetry: provider.load,
      emptyMessage: 'No seats available for this trip right now.',
      dataBuilder: (context, _) => Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _DeckPanel(
                      title: 'Lower Deck',
                      child: SeatDeckGrid(
                        seats: provider.lowerDeckSeats,
                        selectedSeatCodes: provider.selectedSeatCodes,
                        onTap: provider.toggleSeat,
                      ),
                    ),
                  ),
                  if (provider.hasUpperDeck) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DeckPanel(
                        title: 'Upper Deck',
                        child: SeatDeckGrid(
                          seats: provider.upperDeckSeats,
                          selectedSeatCodes: provider.selectedSeatCodes,
                          onTap: provider.toggleSeat,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLegendSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _LegendSheet(),
    );
  }
}

/// "Know before you book" legend — matches the reference bus-booking app's
/// info sheet: an available/booked pair, then reserved-vs-booked pairs for
/// each gender, plus a recommendation note. Reachable via the seat-selection
/// AppBar's INFO action rather than shown inline, so it doesn't permanently
/// eat into the seat map's vertical space.
class _LegendSheet extends StatelessWidget {
  const _LegendSheet();

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: 'Know before you book',
      primaryActionLabel: 'GOT IT',
      primaryActionColor: Theme.of(context).colorScheme.primary,
      onPrimaryAction: () => Navigator.of(context).pop(),
      glass: true,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Important info about your seats', style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _LegendItem(
                        icon: Icons.event_seat,
                        color: Colors.grey.shade700,
                        label: 'Available Seat',
                      ),
                    ),
                    Expanded(
                      child: _LegendItem(
                        icon: Icons.event_seat,
                        color: Colors.grey.shade400,
                        label: 'Booked Seat',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _LegendItem(
                        icon: Icons.event_seat,
                        color: Colors.pinkAccent,
                        badge: Icons.woman,
                        label: 'Seat reserved for',
                        highlight: 'Female passengers',
                        highlightColor: Colors.pinkAccent,
                      ),
                    ),
                    Expanded(
                      child: _LegendItem(
                        icon: Icons.event_seat,
                        color: Colors.blueAccent,
                        badge: Icons.man,
                        label: 'Seat reserved for',
                        highlight: 'Male passengers',
                        highlightColor: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _LegendItem(
                        icon: Icons.event_seat,
                        color: Colors.grey.shade400,
                        badge: Icons.woman,
                        label: 'Seat booked for',
                        highlight: 'Female passengers',
                        highlightColor: Colors.pink.shade200,
                      ),
                    ),
                    Expanded(
                      child: _LegendItem(
                        icon: Icons.event_seat,
                        color: Colors.grey.shade400,
                        badge: Icons.man,
                        label: 'Seat booked for',
                        highlight: 'Male passengers',
                        highlightColor: Colors.blue.shade200,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade800, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'We recommend users to book the seats as per the gender specified on the '
                    'seat by the bus operator for the best experience.',
                    style: TextStyle(color: Colors.amber.shade900, fontSize: 12.5),
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

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.icon,
    required this.color,
    required this.label,
    this.badge,
    this.highlight,
    this.highlightColor,
  });

  final IconData icon;
  final Color color;
  final IconData? badge;
  final String label;
  final String? highlight;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 34, color: color),
            if (badge != null) Icon(badge, size: 14, color: color),
          ],
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        if (highlight != null)
          Text(
            highlight!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: highlightColor),
          ),
      ],
    );
  }
}

class _DeckPanel extends StatelessWidget {
  const _DeckPanel({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 8),
          Flexible(child: child),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.provider, required this.trip});
  final BusSeatSelectionProvider provider;
  final BusTrip trip;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${provider.selectedSeatCodes.length}/${provider.passengerCount} selected',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                  Text(
                    '₹${provider.totalFare.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              onPressed: provider.canContinue
                  ? () {
                      final selectedSeats = provider.seats
                          .where((s) => provider.selectedSeatCodes.contains(s.seatCode))
                          .toList();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BusPickupDropScreen(
                            trip: trip,
                            selectedSeats: selectedSeats,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
