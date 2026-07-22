import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/widgets/calendar/flight_calendar_pager.dart';
import 'package:outc/dashboard/flights/widgets/calendar/flight_date_card.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';
import 'package:outc/dashboard/flights/widgets/search_button.dart';

enum FlightCalendarField { departure, returnDate }

/// What the user picked by the time Done was tapped. [returnDate] is only
/// non-null if a return date was actually selected during this visit — the
/// caller derives One Way vs Round Trip from that, rather than the screen
/// dictating trip type itself.
class FlightDateSelection {
  const FlightDateSelection({required this.departure, this.returnDate});

  final DateTime departure;
  final DateTime? returnDate;
}

/// Unified Departure+Return date picker (specs/0005) — mirrors the FROM/TO
/// unification of the airport search screen (specs/0004). Both cards are
/// always shown; picking a departure date auto-advances focus to Return.
class FlightCalendarScreen extends StatefulWidget {
  const FlightCalendarScreen({
    super.key,
    required this.initialField,
    required this.initialDeparture,
    this.initialReturn,
  });

  final FlightCalendarField initialField;
  final DateTime initialDeparture;
  final DateTime? initialReturn;

  @override
  State<FlightCalendarScreen> createState() => _FlightCalendarScreenState();
}

class _FlightCalendarScreenState extends State<FlightCalendarScreen> {
  late FlightCalendarField _activeField = widget.initialField;
  late DateTime _departure = _dateOnly(widget.initialDeparture);
  DateTime? _returnDate;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  void initState() {
    super.initState();
    _returnDate = widget.initialReturn == null ? null : _dateOnly(widget.initialReturn!);
  }

  DateTime get _minDate => _activeField == FlightCalendarField.returnDate
      ? _departure
      : _dateOnly(DateTime.now());

  void _onDateTap(DateTime date) {
    final picked = _dateOnly(date);
    setState(() {
      if (_activeField == FlightCalendarField.departure) {
        _departure = picked;
        if (_returnDate != null && _returnDate!.isBefore(_departure)) {
          _returnDate = null;
        }
        _activeField = FlightCalendarField.returnDate;
      } else {
        _returnDate = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseMonth = DateTime(DateTime.now().year, DateTime.now().month);
    final activeMonth = _activeField == FlightCalendarField.departure
        ? _departure
        : (_returnDate ?? _departure);
    final initialPage =
        (activeMonth.year - baseMonth.year) * 12 + (activeMonth.month - baseMonth.month);

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
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(text: 'Select '),
                        TextSpan(
                          text: _activeField == FlightCalendarField.departure
                              ? 'Departure'
                              : 'Return',
                          style: TextStyle(color: Flights_Colours.strongRed),
                        ),
                        const TextSpan(text: ' Date'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: FlightDateCard(
                      label: 'DEPARTURE DATE',
                      date: _departure,
                      isActive: _activeField == FlightCalendarField.departure,
                      onTap: () => setState(() => _activeField = FlightCalendarField.departure),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FlightDateCard(
                      label: 'RETURN DATE',
                      date: _returnDate,
                      placeholder: 'Select Return Date',
                      isActive: _activeField == FlightCalendarField.returnDate,
                      onTap: () => setState(() => _activeField = FlightCalendarField.returnDate),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FlightCalendarPager(
                key: ValueKey(_activeField),
                baseMonth: baseMonth,
                minDate: _minDate,
                initialPage: initialPage.clamp(0, 23),
                start: _departure,
                end: _returnDate,
                onDateTap: _onDateTap,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchButton(
                label: 'DONE',
                onPressed: () => Navigator.of(context).pop(
                  FlightDateSelection(departure: _departure, returnDate: _returnDate),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
