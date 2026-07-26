import 'package:flutter/material.dart';

import 'package:outc/widgets/colors/colors.dart';

/// One day cell in a month calendar grid. Promoted from the flights module
/// (`flight_calendar_day.dart`) to `core` so other modules (e.g. bus) can
/// reuse the same date-picking UI without a cross-module import.
///
/// Deliberately carries a couple of optional, unused-for-now slots
/// ([priceLabel], [isHoliday]) so a future pass can light up fare/holiday
/// layers by passing data through, without touching this widget's layout
/// again. Neither renders anything today; both default to null/false.
class CalendarDay extends StatelessWidget {
  const CalendarDay({
    super.key,
    required this.date,
    required this.isDisabled,
    required this.isToday,
    required this.isSelectedStart,
    required this.isSelectedEnd,
    required this.isInRange,
    required this.onTap,
    this.priceLabel,
    this.isHoliday = false,
  });

  final DateTime? date;
  final bool isDisabled;
  final bool isToday;
  final bool isSelectedStart;
  final bool isSelectedEnd;
  final bool isInRange;
  final VoidCallback? onTap;

  /// Reserved for a future fare-calendar layer. Unused today.
  final String? priceLabel;

  /// Reserved for a future holiday-indicator layer. Unused today.
  final bool isHoliday;

  bool get _isSelected => isSelectedStart || isSelectedEnd;

  @override
  Widget build(BuildContext context) {
    if (date == null) return const SizedBox.shrink();

    final canTap = !isDisabled && onTap != null;

    return InkWell(
      onTap: canTap ? onTap : null,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 46,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isInRange)
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: EdgeInsets.only(
                  left: isSelectedStart ? 20 : 0,
                  right: isSelectedEnd ? 20 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colours.strongRed.withValues(alpha: 0.10),
                ),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isSelected ? Colours.strongRed : Colors.transparent,
                border: isToday && !_isSelected
                    ? Border.all(color: Colours.strongRed, width: 1.2)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                '${date!.day}',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: _isSelected
                      ? Colors.white
                      : isDisabled
                          ? Colors.grey.shade400
                          : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
