import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/providers/bus_results_provider.dart';
import 'package:outc/dashboard/bus/screens/bus_seat_selection_screen.dart';
import 'package:outc/dashboard/bus/widgets/bus_filter_sheets.dart';

/// Real bus results/filters screen (spec 0007) — replaces the spec-0006
/// placeholder wholesale. Filtering/sorting is client-side against the
/// trips already fetched by search (spec 0007's resolved assumption).
class BusResultsScreen extends StatelessWidget {
  const BusResultsScreen({
    super.key,
    required this.originName,
    required this.destinationName,
    required this.journeyDate,
    required this.passengerCount,
    required this.trips,
    required this.filters,
    required this.searchId,
  });

  final String originName;
  final String destinationName;
  final DateTime journeyDate;
  final int passengerCount;
  final List<BusTrip> trips;
  final BusFilters filters;
  final String? searchId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BusResultsProvider(allTrips: trips, filters: filters),
      child: _BusResultsView(
        originName: originName,
        destinationName: destinationName,
        journeyDate: journeyDate,
        passengerCount: passengerCount,
        searchId: searchId,
      ),
    );
  }
}

class _BusResultsView extends StatelessWidget {
  const _BusResultsView({
    required this.originName,
    required this.destinationName,
    required this.journeyDate,
    required this.passengerCount,
    required this.searchId,
  });

  final String originName;
  final String destinationName;
  final DateTime journeyDate;
  final int passengerCount;
  final String? searchId;

  @override
  Widget build(BuildContext context) {
    return Consumer<BusResultsProvider>(
      builder: (context, provider, _) {
        final visible = provider.visibleTrips;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$originName → $destinationName',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${DateFormat('dd MMM yyyy, EEE').format(journeyDate)} | $passengerCount ${passengerCount == 1 ? 'Adult' : 'Adults'}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              InkWell(
                onTap: () => BusFilterSheets.showAllFilters(context, provider),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.grey.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.filter_list, size: 18, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Sort & Filter',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        '${visible.length} Buses Found',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? const Center(child: Text('No buses match the selected filters.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: visible.length,
                        itemBuilder: (context, index) => _TripCard(
                          trip: visible[index],
                          searchId: searchId,
                          passengerCount: passengerCount,
                        ),
                      ),
              ),
            ],
          ),
          bottomNavigationBar: _QuickFilterBar(provider: provider),
        );
      },
    );
  }
}

class _QuickFilterBar extends StatelessWidget {
  const _QuickFilterBar({required this.provider});
  final BusResultsProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickFilterButton(
                label: 'Seat',
                icon: Icons.event_seat_outlined,
                onTap: () => BusFilterSheets.showSeatType(context, provider),
              ),
              _QuickFilterButton(
                label: 'Timing',
                icon: Icons.schedule,
                onTap: () => BusFilterSheets.showTiming(context, provider),
              ),
              _QuickFilterButton(
                label: 'AC',
                icon: Icons.ac_unit,
                onTap: () => BusFilterSheets.showAcType(context, provider),
              ),
              _QuickFilterButton(
                label: 'Sort',
                icon: Icons.swap_vert,
                onTap: () => BusFilterSheets.showSortBy(context, provider),
              ),
              _QuickFilterButton(
                label: 'All Filters',
                icon: Icons.tune,
                onTap: () => BusFilterSheets.showAllFilters(context, provider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickFilterButton extends StatelessWidget {
  const _QuickFilterButton({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip, required this.searchId, required this.passengerCount});
  final BusTrip trip;
  final String? searchId;
  final int passengerCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(trip.busType, style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Text(
                  '₹${trip.fare.toStringAsFixed(0)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(trip.departureTime, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(trip.duration, style: TextStyle(color: Colors.grey.shade600)),
                Text(trip.arrivalTime, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${trip.availableSeats} seats available',
                    style: TextStyle(color: Colors.grey.shade600)),
                TextButton(
                  onPressed: () {
                    final id = searchId;
                    if (id == null || id.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Search session expired. Please search again.')),
                      );
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BusSeatSelectionScreen(
                          searchId: id,
                          tripId: trip.id,
                          trip: trip,
                          passengerCount: passengerCount,
                        ),
                      ),
                    );
                  },
                  child: Text('Show Seats', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
