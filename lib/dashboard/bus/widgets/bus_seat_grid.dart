import 'package:flutter/material.dart';

import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/widgets/colors/colors.dart';

/// Positions one deck's seats in a real 2D grid derived from each seat's own
/// `row`/`column`/`length`/`width` (spec 0008) — the legacy mock's flat
/// fixed-2-column `GridView` can't express variable spans, and the layout
/// shape isn't fixed across operators, so this can't be a static grid.
///
/// Confirmed against live captures: `row` is the *across-the-bus* axis (a
/// seater deck has exactly two-ish values — left seat vs right seat) and
/// `column` is the *along-the-bus* axis (many values, one per position along
/// the bus's length). Rendered **vertically** — matching how bus-booking
/// apps (RedBus etc.) actually lay this out on a phone: narrow width across
/// the aisle, tall scroll along the bus's length — so `row` drives the
/// horizontal axis and `column` drives the vertical one. A sleeper berth's
/// `length: 2` therefore spans two units of the *vertical* (column) axis;
/// `width` spans the horizontal (row) axis.
///
/// Two different operators encode `column` two different ways: one pads it
/// so raw values are already spaced by each seat's own `length` (1, 3, 5...
/// for 2-long berths); another just uses a plain sequential index (1, 2,
/// 3...) regardless of length, which overlaps neighbouring seats if
/// positioned by that raw value directly. Trusting the raw column *number*
/// only works for the first convention. Instead, within each row, seats are
/// laid out by cumulative length in column *order* — this never depends on
/// the numbers being pre-spaced, so it's correct for either convention.
class SeatDeckGrid extends StatelessWidget {
  const SeatDeckGrid({
    super.key,
    required this.seats,
    required this.selectedSeatCodes,
    required this.onTap,
  });

  final List<BusSeat> seats;
  final Set<String> selectedSeatCodes;
  final ValueChanged<BusSeat> onTap;

  static const double _unit = 44;

  @override
  Widget build(BuildContext context) {
    if (seats.isEmpty) return const SizedBox.shrink();

    // Horizontal axis: `row` values aren't necessarily contiguous (e.g. a
    // walkway/step between the seater and sleeper sections skips a value)
    // — rank-compress so seats pack tight instead of leaving dead space
    // wherever a row number is skipped.
    final rowRank = _rankOf(seats.map((s) => s.row));

    // Vertical axis: group by row, sort each row's seats by their raw
    // `column` (order only, not magnitude), then lay them out top-to-bottom
    // by cumulative `length` — see class doc for why raw column values
    // can't be trusted directly.
    final topOffset = <String, double>{};
    final byRow = <int, List<BusSeat>>{};
    for (final seat in seats) {
      byRow.putIfAbsent(seat.row, () => []).add(seat);
    }
    var maxColumnHeight = 0.0;
    for (final rowSeats in byRow.values) {
      rowSeats.sort((a, b) => a.column.compareTo(b.column));
      var cursor = 0.0;
      for (final seat in rowSeats) {
        topOffset[seat.seatCode] = cursor;
        cursor += seat.length * _unit;
      }
      if (cursor > maxColumnHeight) maxColumnHeight = cursor;
    }

    final maxRowWidth = seats.map((s) => rowRank[s.row]! + s.width).reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: maxRowWidth * _unit,
          height: maxColumnHeight,
          child: Stack(
            children: [
              for (final seat in seats)
                Positioned(
                  left: rowRank[seat.row]! * _unit,
                  top: topOffset[seat.seatCode]!,
                  width: seat.width * _unit,
                  height: seat.length * _unit,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: _SeatTile(
                      seat: seat,
                      isSelected: selectedSeatCodes.contains(seat.seatCode),
                      onTap: () => onTap(seat),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Maps each distinct value in `values` to its sorted rank (0, 1, 2, ...),
  /// closing any gaps left by non-sequential row numbering.
  static Map<int, int> _rankOf(Iterable<int> values) {
    final sorted = values.toSet().toList()..sort();
    return {for (var i = 0; i < sorted.length; i++) sorted[i]: i};
  }
}

class _SeatTile extends StatelessWidget {
  const _SeatTile({required this.seat, required this.isSelected, required this.onTap});

  final BusSeat seat;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color fillColor;
    Color borderColor;
    Color textColor;

    if (!seat.isAvailableSeat) {
      fillColor = Colors.grey.shade300;
      borderColor = Colors.grey.shade400;
      textColor = Colors.grey.shade600;
    } else if (isSelected) {
      fillColor = Colours.strongRed;
      borderColor = Colours.strongRed;
      textColor = Colors.white;
    } else if (seat.isLadiesSeat) {
      fillColor = Colors.pink.shade50;
      borderColor = Colors.pinkAccent;
      textColor = Colors.pink.shade700;
    } else if (seat.isMaleSeat) {
      fillColor = Colors.blue.shade50;
      borderColor = Colors.blueAccent;
      textColor = Colors.blue.shade700;
    } else {
      fillColor = Colors.white;
      borderColor = Colors.grey.shade400;
      textColor = Colors.black87;
    }

    // A 1-unit-tall seater tile only has ~38px of usable height after
    // padding — stacking a gender icon above two lines of text overflows it.
    // Render the icon as a small corner badge instead, so it never competes
    // with the text for vertical space regardless of the tile's own height
    // (which varies by `width`, not by whether it's a reserved seat).
    // Plain man/woman icons rather than the male/female astrological
    // symbols — clearer at a glance for most people.
    Widget? badge;
    if (!isSelected && seat.isLadiesSeat) {
      badge = const Icon(Icons.woman, size: 10, color: Colors.pinkAccent);
    } else if (!isSelected && seat.isMaleSeat) {
      badge = const Icon(Icons.man, size: 10, color: Colors.blueAccent);
    }

    return GestureDetector(
      onTap: seat.isAvailableSeat ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: fillColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    seat.seatCode,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textColor),
                  ),
                  Text('₹${seat.fare.toStringAsFixed(0)}', style: TextStyle(fontSize: 9, color: textColor)),
                ],
              ),
            ),
            if (badge != null) Positioned(top: 2, right: 2, child: badge),
          ],
        ),
      ),
    );
  }
}
