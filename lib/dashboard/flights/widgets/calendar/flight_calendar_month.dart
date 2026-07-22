import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/widgets/calendar/flight_calendar_day.dart';

const _weekDayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

/// Mon–Sun header row, shared above every month grid.
class FlightCalendarWeekHeader extends StatelessWidget {
  const FlightCalendarWeekHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _weekDayLabels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

/// One month's day grid (Mon-first weeks, leading/trailing blanks so every
/// row has exactly 7 cells). [minDate] disables/dims anything earlier.
/// Selection is expressed generically as an optional [start]/[end] pair so
/// the same widget serves both single-date (start==end) and range
/// selection (One Way/Round Trip vs Multi City).
class FlightCalendarMonth extends StatelessWidget {
  const FlightCalendarMonth({
    super.key,
    required this.month,
    required this.minDate,
    required this.onDateTap,
    this.start,
    this.end,
    this.showMonthLabel = true,
  });

  final DateTime month;
  final DateTime minDate;
  final DateTime? start;
  final DateTime? end;
  final ValueChanged<DateTime> onDateTap;

  /// The pager shows a fixed month/year title of its own and suppresses
  /// this per-page label to avoid showing two titles while swiping.
  final bool showMonthLabel;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // DateTime.weekday: Mon=1..Sun=7 — matches our Mon-first header directly.
    final leadingBlanks = firstOfMonth.weekday - 1;

    final cells = <DateTime?>[
      ...List.filled(leadingBlanks, null),
      for (int d = 1; d <= daysInMonth; d++) DateTime(month.year, month.month, d),
    ];
    final trailingBlanks = (7 - (cells.length % 7)) % 7;
    cells.addAll(List.filled(trailingBlanks, null));

    final today = _dateOnly(DateTime.now());
    final min = _dateOnly(minDate);
    final startDate = start == null ? null : _dateOnly(start!);
    final endDate = end == null ? null : _dateOnly(end!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showMonthLabel)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              monthLabel(month),
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        for (int row = 0; row < cells.length ~/ 7; row++)
          Row(
            children: [
              for (int col = 0; col < 7; col++)
                Expanded(
                  child: Builder(builder: (context) {
                    final date = cells[row * 7 + col];
                    if (date == null) return const SizedBox(height: 46);
                    final normalized = _dateOnly(date);
                    final isDisabled = normalized.isBefore(min);
                    final isStart = startDate != null && normalized == startDate;
                    final isEnd = endDate != null && normalized == endDate;
                    final isInRange = startDate != null &&
                        endDate != null &&
                        normalized.isAfter(startDate) &&
                        normalized.isBefore(endDate);
                    return FlightCalendarDay(
                      date: date,
                      isDisabled: isDisabled,
                      isToday: normalized == today,
                      isSelectedStart: isStart,
                      isSelectedEnd: isEnd || (isStart && endDate == null),
                      isInRange: isInRange,
                      onTap: () => onDateTap(date),
                    );
                  }),
                ),
            ],
          ),
      ],
    );
  }

  static String monthLabel(DateTime month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${names[month.month - 1]} ${month.year}';
  }
}
