import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/models/flights_list_model.dart';
import 'package:outc/core/widgets/bottom_sheet_shell.dart';

/// Shared "Filters" sheet + its predicate, used by the oneway results
/// screen, the round-trip dual-pane screen (spec 0015), and the multi-city
/// results screen (spec 0016) — extracted so none of them carry separate,
/// driftable copies of the same ~350 lines. Every filter group is open and
/// multi-selectable at once (replacing spec 0014's drill-down "tap a row,
/// open its own sub-sheet" version), with a live "Show N" count on the
/// Apply button.
///
/// Generic over `T` via `FlightFilterAdapter<T>` (spec 0016) — oneway and
/// round trip filter a flat `List<FlightDetail>` (one price/one set of
/// segments per item), but multi-city filters a `List<DataFlightDetail>`
/// (one *combo* per item, itself holding N legs and one shared fare) — a
/// second nominal type with the same filtering *shape* (price range, sort,
/// direct/stops, time buckets, refundable, airlines, connecting locations)
/// but different field paths to reach each of those. Rather than duplicate
/// this file a third time, both `applyFlightFilters` and `FlightFiltersSheet`
/// take an adapter that knows how to pull each of those out of a `T`; the
/// predicate/sort/UI logic itself stays in exactly one place.

enum FlightSortOption {
  priceLowToHigh,
  priceHighToLow,
  durationShortest,
  departureEarliest;

  String get label => switch (this) {
        FlightSortOption.priceLowToHigh => 'Price: Low to High',
        FlightSortOption.priceHighToLow => 'Price: High to Low',
        FlightSortOption.durationShortest => 'Duration: Shortest',
        FlightSortOption.departureEarliest => 'Departure: Earliest',
      };
}

Duration journeyDuration(FlightDetail flight) {
  final segments = flight.flightSegments ?? const [];
  if (segments.isEmpty) return Duration.zero;
  final departure = segments.first.departureDateTime;
  final arrival = segments.last.arrivalDateTime;
  if (departure == null || arrival == null) return Duration.zero;
  return arrival.difference(departure);
}

/// Everything `applyFlightFilters`/`FlightFiltersSheet` need to know how to
/// pull out of a `T` — one instance per result type. See the file-level
/// doc comment for why this exists instead of a third copy of this file.
class FlightFilterAdapter<T> {
  const FlightFilterAdapter({
    required this.price,
    required this.isDirect,
    required this.isOneStop,
    required this.departureTime,
    required this.arrivalTime,
    required this.isRefundable,
    required this.airlines,
    required this.connectingLocations,
    required this.duration,
  });

  final double Function(T item, double currency) price;
  final bool Function(T item) isDirect;
  final bool Function(T item) isOneStop;
  final DateTime? Function(T item) departureTime;
  final DateTime? Function(T item) arrivalTime;
  final bool? Function(T item) isRefundable;

  /// Every airline flying `item` — usually one entry; more than one for a
  /// multi-leg itinerary flown on different carriers.
  final Set<String> Function(T item) airlines;

  /// Every layover/connecting airport code across however many legs/stops
  /// `item` has.
  final Set<String> Function(T item) connectingLocations;

  final Duration Function(T item) duration;
}

/// The adapter for the existing flat per-flight result type — every oneway
/// and round-trip call site uses this, field-for-field identical to what
/// this file did before it was generalized.
final FlightFilterAdapter<FlightDetail> flightDetailFilterAdapter = FlightFilterAdapter<FlightDetail>(
  price: (flight, currency) => flight.fareFamilies!.fareFamilies![0].adultPublishFare! * currency,
  isDirect: (flight) => (flight.flightSegments?.length ?? 0) == 1,
  isOneStop: (flight) => (flight.flightSegments?.length ?? 0) == 2,
  departureTime: (flight) =>
      flight.flightSegments?.isNotEmpty == true ? flight.flightSegments!.first.departureDateTime : null,
  arrivalTime: (flight) =>
      flight.flightSegments?.isNotEmpty == true ? flight.flightSegments!.first.arrivalDateTime : null,
  isRefundable: (flight) => flight.isRefundable,
  airlines: (flight) => {if (flight.airLineName != null) flight.airLineName!},
  connectingLocations: (flight) => {
        if (flight.flightSegments?.isNotEmpty == true) flight.flightSegments!.first.destinationName,
      }.whereType<String>().toSet(),
  duration: journeyDuration,
);

bool _isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
  return (time.hour > start.hour || (time.hour == start.hour && time.minute >= start.minute)) &&
      (time.hour < end.hour || (time.hour == end.hour && time.minute <= end.minute));
}

bool _inSelectedBuckets(DateTime? time, bool b1, bool b2, bool b3, bool b4) {
  if (time == null) return true;
  if (!(b1 || b2 || b3 || b4)) return true;
  final t = TimeOfDay(hour: time.hour, minute: time.minute);
  return (b1 && _isTimeInRange(const TimeOfDay(hour: 0, minute: 0), t, const TimeOfDay(hour: 6, minute: 0))) ||
      (b2 && _isTimeInRange(const TimeOfDay(hour: 6, minute: 0), t, const TimeOfDay(hour: 12, minute: 0))) ||
      (b3 && _isTimeInRange(const TimeOfDay(hour: 12, minute: 0), t, const TimeOfDay(hour: 18, minute: 0))) ||
      (b4 && _isTimeInRange(const TimeOfDay(hour: 18, minute: 0), t, const TimeOfDay(hour: 23, minute: 59)));
}

/// The combined (AND'd) filter predicate + sort, shared by each screen's
/// `updateFilterData()` (applies it for real) and `FlightFiltersSheet`'s
/// live "Show N" count (previews it against in-progress, not-yet-applied
/// selections) — one place filtering logic lives, generic over `T` via
/// `adapter` (see the file-level doc comment).
List<T> applyFlightFilters<T>(
  List<T> data, {
  required FlightFilterAdapter<T> adapter,
  required RangeValues range,
  required bool directStop,
  required bool oneStop,
  required (bool, bool, bool, bool) dep,
  required (bool, bool, bool, bool) arv,
  required bool refund,
  required bool nonrefund,
  required Set<String> connectingLocations,
  required Set<String> airlines,
  required double currency,
  FlightSortOption? sort,
}) {
  final result = data.where((item) {
    final fare = adapter.price(item, currency);
    if (fare < range.start || fare > range.end) return false;

    if (directStop && !adapter.isDirect(item)) return false;
    if (oneStop && !adapter.isOneStop(item)) return false;

    if (!_inSelectedBuckets(adapter.departureTime(item), dep.$1, dep.$2, dep.$3, dep.$4)) {
      return false;
    }
    if (!_inSelectedBuckets(adapter.arrivalTime(item), arv.$1, arv.$2, arv.$3, arv.$4)) {
      return false;
    }

    if (refund && adapter.isRefundable(item) != true) return false;
    if (nonrefund && adapter.isRefundable(item) != false) return false;

    if (connectingLocations.isNotEmpty && adapter.connectingLocations(item).intersection(connectingLocations).isEmpty) {
      return false;
    }
    if (airlines.isNotEmpty && adapter.airlines(item).intersection(airlines).isEmpty) return false;

    return true;
  }).toList();

  if (sort != null) {
    result.sort((a, b) {
      switch (sort) {
        case FlightSortOption.priceLowToHigh:
          return adapter.price(a, currency).compareTo(adapter.price(b, currency));
        case FlightSortOption.priceHighToLow:
          return adapter.price(b, currency).compareTo(adapter.price(a, currency));
        case FlightSortOption.durationShortest:
          return adapter.duration(a).compareTo(adapter.duration(b));
        case FlightSortOption.departureEarliest:
          final aDep = adapter.departureTime(a);
          final bDep = adapter.departureTime(b);
          if (aDep == null || bDep == null) return 0;
          return aDep.compareTo(bDep);
      }
    });
  }
  return result;
}

/// Everything `FlightFiltersSheet.onApply` hands back in one shot — Apply
/// commits every group together, there's no per-group Apply.
class FiltersResult {
  FiltersResult({
    required this.range,
    required this.sort,
    required this.directStop,
    required this.oneStop,
    required this.dep,
    required this.arv,
    required this.refund,
    required this.nonrefund,
    required this.connecting,
    required this.airlines,
  });

  final RangeValues range;
  final FlightSortOption? sort;
  final bool directStop;
  final bool oneStop;
  final (bool, bool, bool, bool) dep;
  final (bool, bool, bool, bool) arv;
  final bool refund;
  final bool nonrefund;
  final List<bool> connecting;
  final List<bool> airlines;
}

// Model class for the ConnectingLocations checkbox item
class ConnectingLocationsCheckboxModel {
  String title;
  bool isChecked;

  ConnectingLocationsCheckboxModel({required this.title, this.isChecked = false});
}

// Model class for the Airlines checkbox item
class AirlinesCheckboxModel {
  String title;
  bool isChecked;

  AirlinesCheckboxModel({required this.title, this.isChecked = false});
}

class FlightFiltersSheet<T> extends StatefulWidget {
  const FlightFiltersSheet({
    super.key,
    required this.originalData,
    required this.adapter,
    required this.hasDirect,
    required this.hasOneStop,
    required this.connectingLocationLabels,
    required this.airlineLabels,
    required this.priceBounds,
    required this.initialRange,
    required this.initialSort,
    required this.initialDirectStop,
    required this.initialOneStop,
    required this.initialDep,
    required this.initialArv,
    required this.initialRefund,
    required this.initialNonrefund,
    required this.initialConnecting,
    required this.initialAirlines,
    required this.currency,
    required this.onApply,
    this.title = 'Filters',
  });

  /// Round trip (spec 0015 revision): onward and return each have their own
  /// independent filter state and results, not one filter shared across
  /// both legs — this sheet is opened per-leg, so its title says which one
  /// ("Onward Filters"/"Return Filters") instead of a bare "Filters".
  final String title;

  final List<T> originalData;
  final FlightFilterAdapter<T> adapter;
  final bool hasDirect;
  final bool hasOneStop;
  final List<String> connectingLocationLabels;
  final List<String> airlineLabels;
  final (double, double) priceBounds;
  final RangeValues initialRange;
  final FlightSortOption? initialSort;
  final bool initialDirectStop;
  final bool initialOneStop;
  final (bool, bool, bool, bool) initialDep;
  final (bool, bool, bool, bool) initialArv;
  final bool initialRefund;
  final bool initialNonrefund;
  final List<bool> initialConnecting;
  final List<bool> initialAirlines;
  final double currency;
  final ValueChanged<FiltersResult> onApply;

  @override
  State<FlightFiltersSheet<T>> createState() => _FlightFiltersSheetState<T>();
}

class _FlightFiltersSheetState<T> extends State<FlightFiltersSheet<T>> {
  late RangeValues _range = widget.initialRange;
  FlightSortOption? _sort;
  late bool _directStop = widget.initialDirectStop;
  late bool _oneStop = widget.initialOneStop;
  bool _dep1 = false, _dep2 = false, _dep3 = false, _dep4 = false;
  bool _arv1 = false, _arv2 = false, _arv3 = false, _arv4 = false;
  late bool _refund = widget.initialRefund;
  late bool _nonrefund = widget.initialNonrefund;
  late List<bool> _connecting = List.of(widget.initialConnecting);
  late List<bool> _airlines = List.of(widget.initialAirlines);

  @override
  void initState() {
    super.initState();
    _sort = widget.initialSort;
    _dep1 = widget.initialDep.$1;
    _dep2 = widget.initialDep.$2;
    _dep3 = widget.initialDep.$3;
    _dep4 = widget.initialDep.$4;
    _arv1 = widget.initialArv.$1;
    _arv2 = widget.initialArv.$2;
    _arv3 = widget.initialArv.$3;
    _arv4 = widget.initialArv.$4;
  }

  int get _matchCount => applyFlightFilters(
        widget.originalData,
        adapter: widget.adapter,
        range: _range,
        directStop: _directStop,
        oneStop: _oneStop,
        dep: (_dep1, _dep2, _dep3, _dep4),
        arv: (_arv1, _arv2, _arv3, _arv4),
        refund: _refund,
        nonrefund: _nonrefund,
        connectingLocations: {
          for (var i = 0; i < widget.connectingLocationLabels.length; i++)
            if (_connecting[i]) widget.connectingLocationLabels[i],
        },
        airlines: {
          for (var i = 0; i < widget.airlineLabels.length; i++)
            if (_airlines[i]) widget.airlineLabels[i],
        },
        currency: widget.currency,
      ).length;

  void _clearAll() {
    setState(() {
      _range = RangeValues(widget.priceBounds.$1, widget.priceBounds.$2);
      _sort = null;
      _directStop = false;
      _oneStop = false;
      _dep1 = _dep2 = _dep3 = _dep4 = false;
      _arv1 = _arv2 = _arv3 = _arv4 = false;
      _refund = false;
      _nonrefund = false;
      _connecting = List.filled(_connecting.length, false);
      _airlines = List.filled(_airlines.length, false);
    });
  }

  void _apply() {
    widget.onApply(FiltersResult(
      range: _range,
      sort: _sort,
      directStop: _directStop,
      oneStop: _oneStop,
      dep: (_dep1, _dep2, _dep3, _dep4),
      arv: (_arv1, _arv2, _arv3, _arv4),
      refund: _refund,
      nonrefund: _nonrefund,
      connecting: _connecting,
      airlines: _airlines,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final bounds = widget.priceBounds;
    final matchCount = _matchCount;
    return BottomSheetShell(
      title: widget.title,
      primaryActionLabel: 'Show $matchCount flight${matchCount == 1 ? '' : 's'}',
      primaryActionColor: primary,
      onPrimaryAction: _apply,
      secondaryActionLabel: 'Clear All',
      onSecondaryAction: _clearAll,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GroupTitle('Sort By'),
          _ChipWrap([
            for (final option in FlightSortOption.values)
              _FilterChip(
                label: option.label,
                selected: _sort == option,
                onTap: () => setState(() => _sort = _sort == option ? null : option),
              ),
          ]),
          const SizedBox(height: 18),
          const _GroupTitle('Price Range'),
          const SizedBox(height: 6),
          Text('INR ${_range.start.toStringAsFixed(0)} - INR ${_range.end.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          RangeSlider(
            values: _range,
            min: bounds.$1,
            max: bounds.$2,
            activeColor: primary,
            labels: RangeLabels('INR ${_range.start.toStringAsFixed(0)}', 'INR ${_range.end.toStringAsFixed(0)}'),
            onChanged: (values) => setState(() => _range = values),
          ),
          if (widget.hasDirect || widget.hasOneStop) ...[
            const SizedBox(height: 8),
            const _GroupTitle('Stops'),
            _ChipWrap([
              if (widget.hasDirect)
                _FilterChip(label: 'Direct', selected: _directStop, onTap: () => setState(() => _directStop = !_directStop)),
              if (widget.hasOneStop)
                _FilterChip(label: '1 Stop', selected: _oneStop, onTap: () => setState(() => _oneStop = !_oneStop)),
            ]),
            const SizedBox(height: 18),
          ],
          const _GroupTitle('Departure Time'),
          _ChipWrap([
            _FilterChip(label: '00-06', selected: _dep1, onTap: () => setState(() => _dep1 = !_dep1)),
            _FilterChip(label: '06-12', selected: _dep2, onTap: () => setState(() => _dep2 = !_dep2)),
            _FilterChip(label: '12-18', selected: _dep3, onTap: () => setState(() => _dep3 = !_dep3)),
            _FilterChip(label: '18-23', selected: _dep4, onTap: () => setState(() => _dep4 = !_dep4)),
          ]),
          const SizedBox(height: 18),
          const _GroupTitle('Arrival Time'),
          _ChipWrap([
            _FilterChip(label: '00-06', selected: _arv1, onTap: () => setState(() => _arv1 = !_arv1)),
            _FilterChip(label: '06-12', selected: _arv2, onTap: () => setState(() => _arv2 = !_arv2)),
            _FilterChip(label: '12-18', selected: _arv3, onTap: () => setState(() => _arv3 = !_arv3)),
            _FilterChip(label: '18-23', selected: _arv4, onTap: () => setState(() => _arv4 = !_arv4)),
          ]),
          if (widget.airlineLabels.isNotEmpty) ...[
            const SizedBox(height: 18),
            const _GroupTitle('Airlines'),
            _ChipWrap([
              for (var i = 0; i < widget.airlineLabels.length; i++)
                _FilterChip(
                  label: widget.airlineLabels[i],
                  selected: _airlines[i],
                  onTap: () => setState(() => _airlines[i] = !_airlines[i]),
                ),
            ]),
          ],
          if (widget.connectingLocationLabels.isNotEmpty) ...[
            const SizedBox(height: 18),
            const _GroupTitle('Connecting Locations'),
            _ChipWrap([
              for (var i = 0; i < widget.connectingLocationLabels.length; i++)
                _FilterChip(
                  label: widget.connectingLocationLabels[i],
                  selected: _connecting[i],
                  onTap: () => setState(() => _connecting[i] = !_connecting[i]),
                ),
            ]),
          ],
          const SizedBox(height: 18),
          const _GroupTitle('Refundable'),
          _ChipWrap([
            _FilterChip(
              label: 'Refundable',
              selected: _refund,
              onTap: () => setState(() {
                _refund = !_refund;
                if (_refund) _nonrefund = false;
              }),
            ),
            _FilterChip(
              label: 'Non-Refundable',
              selected: _nonrefund,
              onTap: () => setState(() {
                _nonrefund = !_nonrefund;
                if (_nonrefund) _refund = false;
              }),
            ),
          ]),
        ],
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label,
          style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.03,
              textBaseline: TextBaseline.alphabetic)),
    );
  }
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap(this.children);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Wrap(spacing: 8, runSpacing: 8, children: children);
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: selected ? primary : Colors.grey.shade300, width: selected ? 1.4 : 1),
          color: selected ? primary.withValues(alpha: 0.08) : Colors.white,
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: selected ? primary : Colors.grey.shade700)),
      ),
    );
  }
}
