import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/dashboard/bus/screens/bus_checkout_screen.dart';

/// Boarding/dropping-point selection — the step after seat selection (spec
/// 0008), matching how real bus-booking apps sequence the flow rather than
/// showing pickup/drop alongside the seat map. Uses `BusTrip.boardingPoints`/
/// `.droppingPoints`, already fetched by search (spec 0007) — no new API
/// call needed here. "Next" hands off to `BusCheckoutScreen` (spec 0009) —
/// booking/payment itself still has no captured endpoint (see that spec's
/// Out of scope).
class BusPickupDropScreen extends StatefulWidget {
  const BusPickupDropScreen({
    super.key,
    required this.trip,
    required this.selectedSeats,
  });

  final BusTrip trip;
  final List<BusSeat> selectedSeats;

  @override
  State<BusPickupDropScreen> createState() => _BusPickupDropScreenState();
}

enum _PickupDropTab { pickup, drop }

class _BusPickupDropScreenState extends State<BusPickupDropScreen> {
  _PickupDropTab _activeTab = _PickupDropTab.pickup;
  BusBoardingPoint? _boarding;
  BusBoardingPoint? _dropping;

  bool get _canProceed => _boarding != null && _dropping != null;

  @override
  Widget build(BuildContext context) {
    final points =
        _activeTab == _PickupDropTab.pickup ? widget.trip.boardingPoints : widget.trip.droppingPoints;
    final selected = _activeTab == _PickupDropTab.pickup ? _boarding : _dropping;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Pickup & Drop Points'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _TabHeader(
            active: _activeTab,
            boardingName: _boarding?.name,
            droppingName: _dropping?.name,
            onChanged: (tab) => setState(() => _activeTab = tab),
          ),
          const Divider(height: 1),
          Expanded(
            child: points.isEmpty
                ? Center(
                    child: Text('No points available', style: TextStyle(color: Colors.grey.shade600)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: points.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final point = points[index];
                      return RadioListTile<String>(
                        value: point.pointId,
                        groupValue: selected?.pointId,
                        activeColor: Theme.of(context).colorScheme.primary,
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 56,
                              child: Text(
                                _formatTime(point.time),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(point.name,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                  if (point.address.isNotEmpty)
                                    Text(point.address,
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onChanged: (_) => setState(() {
                          if (_activeTab == _PickupDropTab.pickup) {
                            _boarding = point;
                            // Auto-advance to Drop Points, same pattern as
                            // flights' departure→return calendar — picking
                            // one shouldn't require a manual tab switch.
                            _activeTab = _PickupDropTab.drop;
                          } else {
                            _dropping = point;
                          }
                        }),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'For ${widget.selectedSeats.length} ${widget.selectedSeats.length == 1 ? 'Seat' : 'Seats'}',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    ),
                    Text(
                      '₹${widget.selectedSeats.fold(0.0, (sum, s) => sum + s.fare).toStringAsFixed(0)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                onPressed: _canProceed
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BusCheckoutScreen(
                              trip: widget.trip,
                              selectedSeats: widget.selectedSeats,
                              boardingPoint: _boarding!,
                              droppingPoint: _dropping!,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatTime(String isoTime) {
    final parsed = DateTime.tryParse(isoTime);
    if (parsed == null) return '';
    return DateFormat('HH:mm').format(parsed);
  }
}

class _TabHeader extends StatelessWidget {
  const _TabHeader({
    required this.active,
    required this.boardingName,
    required this.droppingName,
    required this.onChanged,
  });

  final _PickupDropTab active;
  final String? boardingName;
  final String? droppingName;
  final ValueChanged<_PickupDropTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            title: 'PICKUP POINTS',
            subtitle: boardingName ?? 'Select a point',
            isActive: active == _PickupDropTab.pickup,
            onTap: () => onChanged(_PickupDropTab.pickup),
          ),
        ),
        Expanded(
          child: _TabButton(
            title: 'DROP POINTS',
            subtitle: droppingName ?? 'Select a point',
            isActive: active == _PickupDropTab.drop,
            onTap: () => onChanged(_PickupDropTab.drop),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isActive ? Theme.of(context).colorScheme.primary : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
