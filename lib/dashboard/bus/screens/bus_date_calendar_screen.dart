import 'package:flutter/material.dart';

import 'package:outc/core/widgets/calendar/calendar_pager.dart';

/// Bus's single-date picker — same calendar-grid UI as flights'
/// `FlightSingleDateCalendarScreen` (via the shared `core/widgets/calendar`
/// pieces promoted from that module), styled with the bus module's own navy
/// chrome instead of duplicating flights' header/button widgets, which stay
/// flights-specific. Bus is one-way only (spec 0006), so there's no
/// departure/return pair to manage — just a single selection, returned via
/// `Navigator.pop`.
class BusDateCalendarScreen extends StatefulWidget {
  const BusDateCalendarScreen({super.key, required this.initialDate, required this.minDate});

  final DateTime initialDate;
  final DateTime minDate;

  @override
  State<BusDateCalendarScreen> createState() => _BusDateCalendarScreenState();
}

class _BusDateCalendarScreenState extends State<BusDateCalendarScreen> {
  late DateTime _selected = _dateOnly(widget.initialDate);

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final minDate = _dateOnly(widget.minDate);
    final baseMonth = DateTime(minDate.year, minDate.month);
    final initialPage =
        (_selected.year - baseMonth.year) * 12 + (_selected.month - baseMonth.month);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Journey Date'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: CalendarPager(
                baseMonth: baseMonth,
                minDate: minDate,
                initialPage: initialPage.clamp(0, 23),
                start: _selected,
                end: _selected,
                onDateTap: (date) => setState(() => _selected = _dateOnly(date)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
