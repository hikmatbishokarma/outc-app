import 'package:flutter/material.dart';

import 'package:outc/core/widgets/calendar/calendar_day.dart';
import 'package:outc/core/widgets/calendar/calendar_month.dart';

/// Continuously vertically-scrolling month list (specs/0010) — a fixed
/// Mon–Sun week header, then every month's grid stacked below it with one
/// reactive month/year label pinned to the top of the viewport, updating to
/// whichever month is currently at the top as the user scrolls. Replaces
/// the previous horizontal `PageView` + prev/next chevron pager. Promoted
/// from the flights module so other modules (e.g. bus) can reuse the same
/// date-picking UI without a cross-module import — shared by flights'
/// departure+return and single-date screens, and bus's single-date screen.
///
/// The pinned label is a single overlay widget, not one `SliverPersistentHeader`
/// per month — plain adjacent pinned sliver headers don't replace each other
/// once a month's content has fully scrolled past (they stack up together
/// instead, since each independently "sticks" once reached). A single label
/// driven by scroll position avoids that entirely.
class CalendarPager extends StatefulWidget {
  const CalendarPager({
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
  State<CalendarPager> createState() => _CalendarPagerState();
}

class _CalendarPagerState extends State<CalendarPager> {
  // These sizes must stay in lockstep with the actual rendered layout below
  // — the offset table is precomputed math, not measured, so if any of
  // these change, `_sectionOffsets` must change with them or scroll-to-month
  // (and the reactive header label) will drift onto the wrong week/month.
  static const double _headerExtent = 44;
  static const double _monthGap = 12;

  late List<double> _sectionOffsets;
  late final ScrollController _scrollController;
  late int _currentMonthIndex;

  DateTime _monthAt(int page) => DateTime(widget.baseMonth.year, widget.baseMonth.month + page);

  List<double> _buildSectionOffsets() {
    final offsets = List<double>.filled(widget.monthCount + 1, 0);
    for (int i = 0; i < widget.monthCount; i++) {
      final sectionHeight = _headerExtent +
          CalendarMonth.rowCount(_monthAt(i)) * CalendarDay.cellHeight +
          _monthGap;
      offsets[i + 1] = offsets[i] + sectionHeight;
    }
    return offsets;
  }

  // Tolerance for comparing the scroll offset against a precomputed section
  // boundary — `animateTo`'s final rest position can land a fraction of a
  // pixel short of the exact target due to floating-point interpolation,
  // which without this would leave the label showing the previous month
  // right as an auto-scroll (e.g. Departure -> Return) lands.
  static const double _offsetEpsilon = 1.0;

  int _indexForOffset(double offset) {
    final clamped = offset.clamp(0.0, _sectionOffsets.last);
    var result = 0;
    for (var i = 0; i < widget.monthCount; i++) {
      if (_sectionOffsets[i] <= clamped + _offsetEpsilon) {
        result = i;
      } else {
        break;
      }
    }
    return result;
  }

  void _onScroll() {
    final index = _indexForOffset(_scrollController.offset);
    if (index != _currentMonthIndex) {
      setState(() => _currentMonthIndex = index);
    }
  }

  @override
  void initState() {
    super.initState();
    _sectionOffsets = _buildSectionOffsets();
    final startPage = widget.initialPage.clamp(0, widget.monthCount - 1);
    _currentMonthIndex = startPage;
    _scrollController = ScrollController(initialScrollOffset: _sectionOffsets[startPage]);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant CalendarPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.baseMonth != oldWidget.baseMonth || widget.monthCount != oldWidget.monthCount) {
      _sectionOffsets = _buildSectionOffsets();
    }
    if (widget.initialPage != oldWidget.initialPage) {
      _scrollToMonth(widget.initialPage);
    }
  }

  void _scrollToMonth(int page) {
    if (!_scrollController.hasClients) return;
    final clampedPage = page.clamp(0, widget.monthCount - 1);
    final target = _sectionOffsets[clampedPage].clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController
        .animateTo(
          target,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        )
        // `_onScroll` already tracks the label during the animation, but this
        // forces one more check right as it settles — a defensive correction
        // in case the final rest offset lands a hair short of `target`.
        .whenComplete(() {
      if (mounted) _onScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: CalendarWeekHeader(),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  for (int i = 0; i < widget.monthCount; i++)
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: i == widget.monthCount - 1 ? 0 : _monthGap,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Reserved blank space the overlay label sits on
                            // top of — kept in the layout (rather than
                            // rendering the label here) so it counts toward
                            // `_sectionOffsets` exactly like before.
                            const SizedBox(height: _headerExtent),
                            CalendarMonth(
                              month: _monthAt(i),
                              minDate: widget.minDate,
                              start: widget.start,
                              end: widget.end,
                              onDateTap: widget.onDateTap,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              IgnorePointer(
                child: Container(
                  height: _headerExtent,
                  // Opaque — the grid scrolls underneath this label, so
                  // without a solid fill the passing day cells would bleed
                  // through the text as they scroll past.
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    CalendarMonth.monthLabel(_monthAt(_currentMonthIndex)),
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
