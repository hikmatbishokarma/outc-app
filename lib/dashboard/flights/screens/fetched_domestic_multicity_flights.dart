import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/dashboard/flights/models/flight_domestic_roundtrip_model.dart';
import 'package:outc/dashboard/flights/models/flights_list_model.dart' as shared;
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart' show Datum;
import 'package:outc/dashboard/flights/screens/book_domestic_flight.dart';
import 'package:outc/dashboard/flights/screens/search_flights.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/flights/providers/airport_name_cache.dart';
import 'package:outc/dashboard/flights/widgets/flight_filters_sheet.dart';
import 'package:outc/dashboard/flights/widgets/flight_quick_filter_bar.dart';
import 'package:outc/dashboard/flights/widgets/flight_result_card.dart';
import 'package:outc/dashboard/flights/widgets/flight_trip_summary_bar.dart';

import 'package:outc/widgets/sharedprefservices.dart';

/// Round-trip results — domestic only (spec 0015; international round trip
/// via `FetchedRoundtripFlights`/`FetchedMulticityFlights` is a separate,
/// not-yet-done follow-up, per the spec's Out of scope section).
///
/// Previously this screen showed onward and return as two *sequential*
/// full-screen lists (`view1` toggled between them, and tapping a return
/// card booked immediately using whatever onward card had been tapped
/// earlier) — there was no way to see both legs, compare, or change a pick
/// without starting over. This is now a two-pane horizontally-draggable
/// view: onward fills most of the width, return peeks in from the right
/// edge as a column of compact mini-cards (and vice versa once you've
/// dragged to the return pane) — tapping a card *selects* it for that leg
/// (no immediate booking), and a bottom bar shows the combined total with
/// one Book action once both legs are picked.
///
/// `originalData`/`returnFlightDetails`/`filterData` arrive typed against
/// `flight_domestic_roundtrip_model.dart` (that's what
/// `matchingDomesticFlightRoundtripList` parses into, and changing that
/// shared API/model file is out of scope here) — but every shared widget
/// built for spec 0015 (`FlightResultCard`, `AirportNameCache`,
/// `applyFlightFilters`, `FlightFiltersSheet`) is typed against
/// `flights_list_model.dart`'s near-identical `FlightDetail`/`FiltersObj`
/// (confirmed field-for-field equivalent — both are generated from the same
/// backend shape). Rather than fork another copy of those widgets for a
/// second nominal type, `initState` converts once via a JSON round-trip
/// (`shared.FlightDetail.fromJson(domesticFlight.toJson())`), and the rest
/// of this screen works entirely in the shared type.
///
/// One field doesn't survive the round-trip with real data:
/// `FareFamily.isRefundable` is commented out (never parsed) on the
/// domestic model, so it comes through as null on the shared side too —
/// this screen never reads it (only the flight-level `isRefundable`, which
/// *is* on both models), but if a future pass reuses `FlightFaresSheet`
/// (which does read the per-fare-family flag) for domestic round trip, fix
/// `flight_domestic_roundtrip_model.dart`'s `FareFamily` first or that
/// sheet's refundable tag will read wrong here.
class FetchedDomesticMulticityFlights extends StatefulWidget {
  FiltersObj? filterData;
  List<FlightDetail>? originalData;
  List<FlightDetail>? returnFlightDetails;

  int noOfFlights;
  int adultcount, childcount, infantcount;
  String traceId;
  FetchedDomesticMulticityFlights(
      {super.key,
      required this.originalData,
      required this.returnFlightDetails,
      required this.noOfFlights,
      required this.adultcount,
      required this.childcount,
      required this.infantcount,
      required this.filterData,
      required this.traceId});

  @override
  State<FetchedDomesticMulticityFlights> createState() => _FetchedDomesticMulticityFlightsState();
}

class _FetchedDomesticMulticityFlightsState extends State<FetchedDomesticMulticityFlights> {
  late final List<shared.FlightDetail> _onwardAll;
  late final List<shared.FlightDetail> _returnAll;

  List<shared.FlightDetail> _onwardFiltered = [];
  List<shared.FlightDetail> _returnFiltered = [];

  shared.FlightDetail? _selectedOnward;
  shared.FlightDetail? _selectedReturn;

  // Onward and return each filter their own results independently — an
  // earlier version of this screen shared one filter selection across both
  // panes (matching spec 0015's original text), but that meant e.g. picking
  // "Direct" while looking at onward also silently hid connecting *return*
  // flights you hadn't even looked at yet. Each leg now gets its own
  // `_LegFilterState`, its own options (derived from that leg's own flights,
  // not a single shared `FiltersObj` — the backend doesn't actually send a
  // return-specific one), and its own "N Filters" indicator; the filter
  // icon in the AppBar acts on whichever pane is currently focused.
  final _LegFilterState _onwardFilters = _LegFilterState();
  final _LegFilterState _returnFilters = _LegFilterState();
  int _focusedLeg = 0; // 0 = onward, 1 = return

  Datum? _originLookup;
  Datum? _destLookup;

  @override
  void initState() {
    super.initState();
    _onwardAll = (widget.originalData ?? const <FlightDetail>[])
        .map((f) => shared.FlightDetail.fromJson(f.toJson()))
        .toList();
    _returnAll = (widget.returnFlightDetails ?? const <FlightDetail>[])
        .map((f) => shared.FlightDetail.fromJson(f.toJson()))
        .toList();

    _fillFilterOptions(_onwardFilters, _onwardAll);
    _fillFilterOptions(_returnFilters, _returnAll);
    _updateFilterFor(true);
    _updateFilterFor(false);
    _resolveTripSummaryNames();
  }

  shared.FlightDetail? get _firstOnward => _onwardAll.isNotEmpty ? _onwardAll.first : null;
  shared.FlightDetail? get _firstReturn => _returnAll.isNotEmpty ? _returnAll.first : null;

  String _tripSummarySubtitle() {
    final departureDate =
        _firstOnward?.flightSegments?.isNotEmpty == true ? _firstOnward!.flightSegments!.first.departureDateTime : null;
    final returnDate =
        _firstReturn?.flightSegments?.isNotEmpty == true ? _firstReturn!.flightSegments!.first.departureDateTime : null;
    final travellerCount = widget.adultcount + widget.childcount + widget.infantcount;
    return [
      if (departureDate != null)
        '${DateFormat('dd MMM').format(departureDate)}${returnDate != null ? ' – ${DateFormat('dd MMM yyyy').format(returnDate)}' : ''}',
      '$travellerCount Traveller${travellerCount == 1 ? '' : 's'}',
      'Economy',
    ].join(' · ');
  }

  Future<void> _resolveTripSummaryNames() async {
    if (_onwardAll.isEmpty) return;
    final first = _onwardAll.first;
    final results = await Future.wait([
      AirportNameCache.resolve(first.origin),
      AirportNameCache.resolve(first.destination),
    ]);
    if (!mounted) return;
    setState(() {
      _originLookup = results[0];
      _destLookup = results[1];
    });
  }

  // Fallback price bounds computed straight from a leg's own flights — no
  // per-leg price range comes back from the backend (only one combined
  // `FiltersObj` for the whole search), so rather than reuse that one
  // object for both legs' sliders, each leg's bounds are derived from what
  // it actually has, same fallback spirit as the oneway screen's
  // `_priceBounds()`.
  (double, double) _priceBoundsFor(List<shared.FlightDetail> flights) {
    final currency = _currency;
    final fares = flights.map((f) => f.fareFamilies!.fareFamilies![0].adultPublishFare! * currency).toList();
    if (fares.isEmpty) return (0, 1);
    final min = fares.reduce((a, b) => a < b ? a : b);
    final max = fares.reduce((a, b) => a > b ? a : b);
    return (min, max > min ? max : min + 1);
  }

  bool _hasDirect(List<shared.FlightDetail> flights) => flights.any((f) => (f.flightSegments?.length ?? 0) <= 1);
  bool _hasOneStop(List<shared.FlightDetail> flights) => flights.any((f) => (f.flightSegments?.length ?? 0) == 2);

  static bool _isUsableLabel(String? value) =>
      value != null && value.trim().isNotEmpty && value.trim().toLowerCase() != 'null';

  List<String> _connectingLabelsFor(List<shared.FlightDetail> flights) {
    final labels = <String>{};
    for (final flight in flights) {
      final segments = flight.flightSegments ?? const [];
      if (segments.length <= 1) continue;
      final name = segments.first.destinationName;
      if (_isUsableLabel(name)) labels.add(name!);
    }
    return labels.toList()..sort();
  }

  List<String> _airlineLabelsFor(List<shared.FlightDetail> flights) {
    final labels = <String>{};
    for (final flight in flights) {
      if (_isUsableLabel(flight.airLineName)) labels.add(flight.airLineName!);
    }
    return labels.toList()..sort();
  }

  void _fillFilterOptions(_LegFilterState state, List<shared.FlightDetail> flights) {
    state.connecting = [for (final label in _connectingLabelsFor(flights)) ConnectingLocationsCheckboxModel(title: label)];
    state.airlines = [for (final label in _airlineLabelsFor(flights)) AirlinesCheckboxModel(title: label)];
    final bounds = _priceBoundsFor(flights);
    state.range = RangeValues(bounds.$1, bounds.$2);
  }

  void _updateFilterFor(bool isOnward) {
    final state = isOnward ? _onwardFilters : _returnFilters;
    final source = isOnward ? _onwardAll : _returnAll;
    final filtered = applyFlightFilters(
      source,
      adapter: flightDetailFilterAdapter,
      range: state.range,
      directStop: state.directStop,
      oneStop: state.oneStop,
      dep: (state.dep1, state.dep2, state.dep3, state.dep4),
      arv: (state.arv1, state.arv2, state.arv3, state.arv4),
      refund: state.refund,
      nonrefund: state.nonrefund,
      connectingLocations: state.connecting.where((f) => f.isChecked).map((f) => f.title).toSet(),
      airlines: state.airlines.where((f) => f.isChecked).map((f) => f.title).toSet(),
      currency: _currency,
      sort: state.sort,
    );
    setState(() {
      if (isOnward) {
        _onwardFiltered = filtered;
      } else {
        _returnFiltered = filtered;
      }
    });
  }

  void _showFiltersSheetFor(BuildContext context, bool isOnward) {
    final state = isOnward ? _onwardFilters : _returnFilters;
    final source = isOnward ? _onwardAll : _returnAll;
    final currency = _currency;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FlightFiltersSheet<shared.FlightDetail>(
        title: isOnward ? 'Onward Filters' : 'Return Filters',
        originalData: source,
        adapter: flightDetailFilterAdapter,
        hasDirect: _hasDirect(source),
        hasOneStop: _hasOneStop(source),
        connectingLocationLabels: [for (final loc in state.connecting) loc.title],
        airlineLabels: [for (final airline in state.airlines) airline.title],
        priceBounds: _priceBoundsFor(source),
        initialRange: state.range,
        initialSort: state.sort,
        initialDirectStop: state.directStop,
        initialOneStop: state.oneStop,
        initialDep: (state.dep1, state.dep2, state.dep3, state.dep4),
        initialArv: (state.arv1, state.arv2, state.arv3, state.arv4),
        initialRefund: state.refund,
        initialNonrefund: state.nonrefund,
        initialConnecting: [for (final loc in state.connecting) loc.isChecked],
        initialAirlines: [for (final airline in state.airlines) airline.isChecked],
        currency: currency,
        onApply: (result) {
          setState(() {
            state.range = result.range;
            state.sort = result.sort;
            state.directStop = result.directStop;
            state.oneStop = result.oneStop;
            state.dep1 = result.dep.$1;
            state.dep2 = result.dep.$2;
            state.dep3 = result.dep.$3;
            state.dep4 = result.dep.$4;
            state.arv1 = result.arv.$1;
            state.arv2 = result.arv.$2;
            state.arv3 = result.arv.$3;
            state.arv4 = result.arv.$4;
            state.refund = result.refund;
            state.nonrefund = result.nonrefund;
            for (var i = 0; i < state.connecting.length; i++) {
              state.connecting[i].isChecked = result.connecting[i];
            }
            for (var i = 0; i < state.airlines.length; i++) {
              state.airlines[i].isChecked = result.airlines[i];
            }
          });
          _updateFilterFor(isOnward);
        },
      ),
    );
  }

  void _toggleOnward(shared.FlightDetail flight) {
    setState(() => _selectedOnward = identical(_selectedOnward, flight) ? null : flight);
  }

  void _toggleReturn(shared.FlightDetail flight) {
    setState(() => _selectedReturn = identical(_selectedReturn, flight) ? null : flight);
  }

  double get _currency => double.tryParse(SharedPrefServices.getcurrencyAmount().toString()) ?? 1;

  double _fareOf(shared.FlightDetail? flight) {
    if (flight == null) return 0;
    return (flight.fareFamilies?.fareFamilies?.first.totalPublishFare ?? 0) * _currency;
  }

  /// Ports the original selection-time fare math verbatim (same fields,
  /// same "return leg's adult tax is always zeroed" quirk the legacy code
  /// had) — this is a UI-structure change, not a fare-calculation change,
  /// so the numbers going into `BookDomesticFlight` stay exactly as they
  /// were for a given picked onward+return pair.
  _LegFare _legFare(shared.FlightDetail flight, {required bool zeroAdultTax}) {
    final ff = flight.fareFamilies!.fareFamilies![0];
    return _LegFare(
      basefare: (ff.totalPublishFare ?? 0) * _currency,
      adultTaxFare: zeroAdultTax ? 0 : (double.tryParse(ff.markup.toString()) ?? 0),
      childFare: double.tryParse(ff.childNetFare.toString()) ?? 0,
      infantFare: double.tryParse(ff.infantNetFare.toString()) ?? 0,
    );
  }

  _LegBookingFields _legFields(shared.FlightDetail flight) {
    final segments = flight.flightSegments ?? const [];
    final first = segments.isNotEmpty ? segments.first : null;
    return _LegBookingFields(
      name: '${flight.airLineName} (${flight.airLine}-${first?.flightNumber})',
      stop: segments.length <= 1 ? 'Direct' : '${segments.length - 1} Stop',
      refund: flight.isRefundable == true ? 'Refundable' : 'Non Refundable',
      start: flight.originCity.toString(),
      end: flight.destinationCity.toString(),
      startTime: first?.departureDateTime != null ? DateFormat('HH:mm').format(first!.departureDateTime!) : '--:--',
      endTime: first?.arrivalDateTime != null ? DateFormat('HH:mm').format(first!.arrivalDateTime!) : '--:--',
      duration: flight.duration.toString(),
    );
  }

  void _proceedToBooking() {
    final onward = _selectedOnward;
    final returnFlight = _selectedReturn;
    if (onward == null || returnFlight == null) return;

    final onwardFields = _legFields(onward);
    final returnFields = _legFields(returnFlight);
    final onwardFare = _legFare(onward, zeroAdultTax: false);
    final returnFare = _legFare(returnFlight, zeroAdultTax: true);

    // Legacy quirk kept as-is: `adultBasefare` is round-tripped through
    // shared prefs rather than passed straight through — some other part of
    // the booking flow may still read `getdomesticAmount()` later, so the
    // write stays even though the value used below is the same number.
    SharedPrefServices.setdomesticAmount(onwardFare.basefare.toStringAsFixed(2));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookDomesticFlight(
          traceId1: widget.traceId,
          flightId1: onward.flightId.toString(),
          fareId1: onward.fareFamilies!.fareFamilies![0].fareId.toString(),
          airlineLogo1: onward.airLineLogo ?? '',
          airlineName1: onwardFields.name,
          airlineStop1: onwardFields.stop,
          airlineClass1: 'Economy',
          airlineRefund1: onwardFields.refund,
          airlineStart1: onwardFields.start,
          airlineEnd1: onwardFields.end,
          airlineStartTime1: onwardFields.startTime,
          airlineEndTime1: onwardFields.endTime,
          airlineDuration1: onwardFields.duration,
          traceId2: widget.traceId,
          flightId2: returnFlight.flightId.toString(),
          fareId2: returnFlight.fareFamilies!.fareFamilies![0].fareId.toString(),
          airlineLogo2: returnFlight.airLineLogo ?? '',
          airlineName2: returnFields.name,
          airlineStop2: returnFields.stop,
          airlineClass2: 'Economy',
          airlineRefund2: returnFields.refund,
          airlineStart2: returnFields.start,
          airlineEnd2: returnFields.end,
          airlineStartTime2: returnFields.startTime,
          airlineEndTime2: returnFields.endTime,
          airlineDuration2: returnFields.duration,
          adultBasefare: onwardFare.basefare,
          adulttaxfare: onwardFare.adultTaxFare,
          childBasefare: onwardFare.childFare,
          childtaxfare: 0,
          infantBasefare: onwardFare.infantFare,
          infanttaxfare: 0,
          returnAdultBasefare: returnFare.basefare,
          returnAdultTaxfare: returnFare.adultTaxFare,
          returnChildBasefare: returnFare.childFare,
          returnChildTaxfare: 0,
          returnInfantBasefare: returnFare.infantFare,
          returnInfantTaxfare: 0,
          adultCount: widget.adultcount.toDouble(),
          childCount: widget.childcount.toDouble(),
          infantCount: widget.infantcount.toDouble(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canBook = _selectedOnward != null && _selectedReturn != null;

    final focusedFilters = _focusedLeg == 0 ? _onwardFilters : _returnFilters;

    return Scaffold(
      backgroundColor: AppColors.panelBackground,
      // No separate "Flight Results" app-bar — see the same call on the
      // oneway results screen.
      body: SafeArea(
        child: Column(
          children: [
            FlightTripSummaryBar(
              routeLabel: '${placeLabel(_firstOnward?.origin, _originLookup)} ⇄ '
                  '${placeLabel(_firstOnward?.destination, _destLookup)}',
              subtitle: _tripSummarySubtitle(),
              onBack: () => Navigator.of(context).pop(),
              onEdit: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                builder: (_) => FractionallySizedBox(
                  heightFactor: 0.94,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: const FlightsListPage(isModifyMode: true),
                  ),
                ),
              ),
            ),
            FlightQuickFilterBar(
              key: ValueKey(_focusedLeg), // fresh chip state per leg on swap
              isCheapestFirstActive: focusedFilters.sort == FlightSortOption.priceLowToHigh,
              onToggleCheapestFirst: () {
                setState(() {
                  focusedFilters.sort = focusedFilters.sort == FlightSortOption.priceLowToHigh
                      ? null
                      : FlightSortOption.priceLowToHigh;
                });
                _updateFilterFor(_focusedLeg == 0);
              },
              isNonStopActive: focusedFilters.directStop,
              onToggleNonStop: () {
                setState(() => focusedFilters.directStop = !focusedFilters.directStop);
                _updateFilterFor(_focusedLeg == 0);
              },
              activeFilterCount: focusedFilters.activeFilterCount,
              onTapFilters: () => _showFiltersSheetFor(context, _focusedLeg == 0),
            ),
            Expanded(
              child: _DualPaneFlights(
                onward: _onwardFiltered,
                returnFlights: _returnFiltered,
                selectedOnward: _selectedOnward,
                selectedReturn: _selectedReturn,
                onSelectOnward: _toggleOnward,
                onSelectReturn: _toggleReturn,
                currency: _currency,
                onFocusChanged: (leg) => setState(() => _focusedLeg = leg),
              ),
            ),
            _BookingBar(
              onwardFare: _fareOf(_selectedOnward),
              returnFare: _fareOf(_selectedReturn),
              canBook: canBook,
              onBook: _proceedToBooking,
            ),
          ],
        ),
      ),
    );
  }
}

/// One leg's (onward's or return's) own independent filter selection — see
/// the doc comment on `_FetchedDomesticMulticityFlightsState`'s
/// `_onwardFilters`/`_returnFilters` fields for why this isn't shared.
class _LegFilterState {
  RangeValues range = const RangeValues(0, 0);
  FlightSortOption? sort;
  bool directStop = false;
  bool oneStop = false;
  bool dep1 = false, dep2 = false, dep3 = false, dep4 = false;
  bool arv1 = false, arv2 = false, arv3 = false, arv4 = false;
  bool refund = false;
  bool nonrefund = false;
  List<ConnectingLocationsCheckboxModel> connecting = [];
  List<AirlinesCheckboxModel> airlines = [];

  bool get hasActiveFilters =>
      directStop ||
      oneStop ||
      dep1 ||
      dep2 ||
      dep3 ||
      dep4 ||
      arv1 ||
      arv2 ||
      arv3 ||
      arv4 ||
      refund ||
      nonrefund ||
      connecting.any((f) => f.isChecked) ||
      airlines.any((f) => f.isChecked);

  /// Feeds the quick-filter bar's "Filters" badge for this leg.
  int get activeFilterCount =>
      (directStop ? 1 : 0) +
      (oneStop ? 1 : 0) +
      (dep1 ? 1 : 0) +
      (dep2 ? 1 : 0) +
      (dep3 ? 1 : 0) +
      (dep4 ? 1 : 0) +
      (arv1 ? 1 : 0) +
      (arv2 ? 1 : 0) +
      (arv3 ? 1 : 0) +
      (arv4 ? 1 : 0) +
      (refund ? 1 : 0) +
      (nonrefund ? 1 : 0) +
      connecting.where((f) => f.isChecked).length +
      airlines.where((f) => f.isChecked).length;
}

class _LegFare {
  const _LegFare({required this.basefare, required this.adultTaxFare, required this.childFare, required this.infantFare});
  final double basefare;
  final double adultTaxFare;
  final double childFare;
  final double infantFare;
}

class _LegBookingFields {
  const _LegBookingFields({
    required this.name,
    required this.stop,
    required this.refund,
    required this.start,
    required this.end,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });
  final String name;
  final String stop;
  final String refund;
  final String start;
  final String end;
  final String startTime;
  final String endTime;
  final String duration;
}


/// The dual pane itself: onward and return each fill the full page width
/// (standard `PageView` swipe between them), with a compact "peek" rail of
/// mini price/time cards for the *other* leg fading in along the trailing
/// edge as you drag towards it — tapping the rail (or finishing the drag)
/// brings that pane into full focus. Both panes scroll vertically on their
/// own `ListView`, independent of the horizontal page drag (different
/// gesture axes, so Flutter's gesture arena doesn't need any special
/// handling to keep them from fighting each other).
class _DualPaneFlights extends StatefulWidget {
  const _DualPaneFlights({
    required this.onward,
    required this.returnFlights,
    required this.selectedOnward,
    required this.selectedReturn,
    required this.onSelectOnward,
    required this.onSelectReturn,
    required this.currency,
    required this.onFocusChanged,
  });

  final List<shared.FlightDetail> onward;
  final List<shared.FlightDetail> returnFlights;
  final shared.FlightDetail? selectedOnward;
  final shared.FlightDetail? selectedReturn;
  final ValueChanged<shared.FlightDetail> onSelectOnward;
  final ValueChanged<shared.FlightDetail> onSelectReturn;
  final double currency;

  /// Fires (0 or 1) whenever the in-focus pane changes, so the parent
  /// screen's AppBar filter icon knows which leg's `_LegFilterState` to
  /// open/tint for.
  final ValueChanged<int> onFocusChanged;

  @override
  State<_DualPaneFlights> createState() => _DualPaneFlightsState();
}

class _DualPaneFlightsState extends State<_DualPaneFlights> {
  static const _peekWidth = 108.0;

  late final PageController _controller = PageController()..addListener(_onScroll);
  double _page = 0;
  int _lastReportedFocus = 0;

  void _onScroll() {
    if (!_controller.hasClients) return;
    final page = _controller.page;
    if (page == null) return;
    if (page != _page) setState(() => _page = page);
    final rounded = page.round().clamp(0, 1);
    if (rounded != _lastReportedFocus) {
      _lastReportedFocus = rounded;
      widget.onFocusChanged(rounded);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _focus(int page) {
    _controller.animateToPage(page, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final returnOpacity = (1 - _page).clamp(0.0, 1.0);
    final onwardPeekOpacity = _page.clamp(0.0, 1.0);

    return Stack(
      children: [
        PageView(
          controller: _controller,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12, right: _peekWidth + 4, top: 8, bottom: 8),
              child: _LegListView(
                label: 'Onward',
                flights: widget.onward,
                selected: widget.selectedOnward,
                onSelect: widget.onSelectOnward,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: _peekWidth + 4, right: 12, top: 8, bottom: 8),
              child: _LegListView(
                label: 'Return',
                flights: widget.returnFlights,
                selected: widget.selectedReturn,
                onSelect: widget.onSelectReturn,
              ),
            ),
          ],
        ),
        if (returnOpacity > 0.01)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: _peekWidth,
            child: IgnorePointer(
              ignoring: returnOpacity < 0.05,
              child: Opacity(
                opacity: returnOpacity,
                child: _PeekRail(
                  label: 'Return',
                  flights: widget.returnFlights,
                  selected: widget.selectedReturn,
                  currency: widget.currency,
                  onTap: () => _focus(1),
                ),
              ),
            ),
          ),
        if (onwardPeekOpacity > 0.01)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: _peekWidth,
            child: IgnorePointer(
              ignoring: onwardPeekOpacity < 0.05,
              child: Opacity(
                opacity: onwardPeekOpacity,
                child: _PeekRail(
                  label: 'Onward',
                  flights: widget.onward,
                  selected: widget.selectedOnward,
                  currency: widget.currency,
                  onTap: () => _focus(0),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LegListView extends StatelessWidget {
  const _LegListView({required this.label, required this.flights, required this.selected, required this.onSelect});

  final String label;
  final List<shared.FlightDetail> flights;
  final shared.FlightDetail? selected;
  final ValueChanged<shared.FlightDetail> onSelect;

  @override
  Widget build(BuildContext context) {
    if (flights.isEmpty) {
      return Center(
        child: Text('No $label flights available', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      );
    }
    return ListView.builder(
      itemCount: flights.length,
      itemBuilder: (context, index) {
        final flight = flights[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FlightResultCard(
            flight: flight,
            dense: true,
            selected: identical(selected, flight),
            onTap: () => onSelect(flight),
          ),
        );
      },
    );
  }
}

/// The peeking column of compact mini-cards for the leg not currently in
/// focus — a static (non-scrolling) strip capped to a handful of flights,
/// since its job is to signal "there's a return leg here too, drag/tap to
/// see it," not to be a fully usable list on its own.
class _PeekRail extends StatelessWidget {
  const _PeekRail({
    required this.label,
    required this.flights,
    required this.selected,
    required this.currency,
    required this.onTap,
  });

  final String label;
  final List<shared.FlightDetail> flights;
  final shared.FlightDetail? selected;
  final double currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Material(
      color: AppColors.subtleBackground,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(label,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final flight in flights.take(6)) _buildMiniCard(context, flight, primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCard(BuildContext context, shared.FlightDetail flight, Color primary) {
    final isSelected = identical(selected, flight);
    final segments = flight.flightSegments ?? const [];
    final time = segments.isNotEmpty && segments.first.departureDateTime != null
        ? DateFormat('HH:mm').format(segments.first.departureDateTime!)
        : '--:--';
    final fareFamily = flight.fareFamilies?.fareFamilies?.isNotEmpty == true ? flight.fareFamilies!.fareFamilies!.first : null;
    final price = (fareFamily?.totalPublishFare ?? 0) * currency;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: isSelected ? primary : Colors.grey.shade200, width: isSelected ? 1.6 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FlightAirlineLogo(url: flight.airLineLogo, size: 14),
              const SizedBox(width: 5),
              Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 3),
          Text('₹${price.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: primary)),
        ],
      ),
    );
  }
}

/// Bottom bar: combined round-trip total once both legs are picked, one
/// Book action — no "Lock Price" (spec 0015: not a feature this app's data
/// model/backend supports, not invented here).
class _BookingBar extends StatelessWidget {
  const _BookingBar({
    required this.onwardFare,
    required this.returnFare,
    required this.canBook,
    required this.onBook,
  });

  final double onwardFare;
  final double returnFare;
  final bool canBook;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final total = onwardFare + returnFare;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 10 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  canBook ? '₹${total.toStringAsFixed(0)}' : 'Select onward & return',
                  style: TextStyle(
                      fontSize: canBook ? 18 : 13,
                      fontWeight: FontWeight.bold,
                      color: canBook ? AppColors.textPrimary : Colors.grey.shade600),
                ),
                if (canBook)
                  Text('Onward + Return · Total fare', style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: canBook ? onBook : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Book', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
