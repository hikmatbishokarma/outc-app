import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/widgets/calendar/flight_calendar_pager.dart';
import 'package:outc/dashboard/flights/widgets/calendar/flight_date_card.dart';
import 'package:outc/dashboard/flights/widgets/search_button.dart';

/// Single-date picker for one multi-city leg (specs/0005) — shows the leg's
/// route (e.g. "HYD → BOM") and a single selection card, no return date.
class FlightSingleDateCalendarScreen extends StatefulWidget {
  const FlightSingleDateCalendarScreen({
    super.key,
    required this.routeLabel,
    required this.initialDate,
    required this.minDate,
  });

  final String routeLabel;
  final DateTime initialDate;
  final DateTime minDate;

  @override
  State<FlightSingleDateCalendarScreen> createState() =>
      _FlightSingleDateCalendarScreenState();
}

class _FlightSingleDateCalendarScreenState extends State<FlightSingleDateCalendarScreen> {
  late DateTime _selected = _dateOnly(widget.initialDate);

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final minDate = _dateOnly(widget.minDate);
    final baseMonth = DateTime(minDate.year, minDate.month);
    final initialPage =
        (_selected.year - baseMonth.year) * 12 + (_selected.month - baseMonth.month);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          widget.routeLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FlightDateCard(
                label: 'SELECTED DATE',
                date: _selected,
                isActive: true,
                onTap: () {},
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FlightCalendarPager(
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
              child: SearchButton(
                label: 'DONE',
                onPressed: () => Navigator.of(context).pop(_selected),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
