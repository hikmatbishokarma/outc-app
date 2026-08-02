import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/app_top_bar.dart';
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
          backgroundColor: AppColors.panelBackground,
          appBar: AppTopBar(
            title: '$originName → $destinationName',
            subtitle:
                '${DateFormat('dd MMM yyyy, EEE').format(journeyDate)} | $passengerCount ${passengerCount == 1 ? 'Adult' : 'Adults'}',
          ),
          body: Column(
            children: [
              InkWell(
                onTap: () => BusFilterSheets.showAllFilters(context, provider),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.grey.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.filter_list,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Sort & Filter',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600),
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
                    ? const Center(
                        child: Text('No buses match the selected filters.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
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
  const _QuickFilterButton(
      {required this.label, required this.icon, required this.onTap});
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
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard(
      {required this.trip,
      required this.searchId,
      required this.passengerCount});
  final BusTrip trip;
  final String? searchId;
  final int passengerCount;

  bool get _isAc {
    final type = trip.busType.toUpperCase();
    return type.contains('AC') && !type.contains('NON-AC') && !type.contains('NON AC');
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _isAc
                              ? AppColors.skyBlue.withValues(alpha: 0.18)
                              : AppColors.surfaceGrey.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          trip.busType,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _isAc
                                ? AppColors.secondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${trip.fare.toStringAsFixed(0)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 13),
            _RouteRow(
              departureTime: trip.departureTime,
              arrivalTime: trip.arrivalTime,
              duration: trip.duration,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${trip.availableSeats} seats available',
                    style: const TextStyle(color: AppColors.textSecondary)),
                TextButton(
                  onPressed: () {
                    final id = searchId;
                    if (id == null || id.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Search session expired. Please search again.')),
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
                  child: Text('Show Seats',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Pickup → drop indicator: two direction-coded dots joined by a dashed
/// line, with the duration + a bus glyph sitting inline at the midpoint.
class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
  });

  final String departureTime;
  final String arrivalTime;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(departureTime,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(width: 6),
        _dot(AppColors.secondary),
        const Expanded(child: _DashedLine()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.directions_bus_rounded,
                  size: 13, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text(duration,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
            ],
          ),
        ),
        const Expanded(child: _DashedLine()),
        _dot(AppColors.skyBlue),
        const SizedBox(width: 6),
        Text(arrivalTime,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _dot(Color color) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(
        size: const Size(double.infinity, 1),
        painter: _DashedLinePainter(color: AppColors.border),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashWidth = 3.0;
    const gapWidth = 3.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
