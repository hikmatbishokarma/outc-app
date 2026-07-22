import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/widgets/calendar/flight_calendar_month.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';

/// Swipeable month-by-month calendar body: a fixed month/year title with
/// prev/next chevrons, a fixed Mon–Sun week header, and a `PageView` of
/// [FlightCalendarMonth] grids beneath. Shared by both the departure+return
/// and single-date flight calendar screens.
class FlightCalendarPager extends StatefulWidget {
  const FlightCalendarPager({
    super.key,
    required this.baseMonth,
    required this.minDate,
    required this.initialPage,
    required this.onDateTap,
    this.start,
    this.end,
    this.monthCount = 24,
  });

  final DateTime baseMonth;
  final DateTime minDate;
  final int initialPage;
  final ValueChanged<DateTime> onDateTap;
  final DateTime? start;
  final DateTime? end;
  final int monthCount;

  @override
  State<FlightCalendarPager> createState() => _FlightCalendarPagerState();
}

class _FlightCalendarPagerState extends State<FlightCalendarPager> {
  late final PageController _controller = PageController(initialPage: widget.initialPage);
  late int _currentPage = widget.initialPage;

  DateTime _monthAt(int page) => DateTime(widget.baseMonth.year, widget.baseMonth.month + page);

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: Flights_Colours.strongRed,
                onPressed: _currentPage > 0 ? () => _goTo(_currentPage - 1) : null,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  FlightCalendarMonth.monthLabel(_monthAt(_currentPage)),
                  key: ValueKey(_currentPage),
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: Flights_Colours.strongRed,
                onPressed:
                    _currentPage < widget.monthCount - 1 ? () => _goTo(_currentPage + 1) : null,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: FlightCalendarWeekHeader(),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.monthCount,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, page) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FlightCalendarMonth(
                  month: _monthAt(page),
                  minDate: widget.minDate,
                  start: widget.start,
                  end: widget.end,
                  onDateTap: widget.onDateTap,
                  showMonthLabel: false,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
