import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/flights/models/flights_list_model.dart';
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart' show Datum;
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/flights/providers/airport_name_cache.dart';
import 'package:outc/dashboard/flights/screens/search_flights.dart';
import 'package:outc/dashboard/flights/widgets/flight_fares_sheet.dart';
import 'package:outc/dashboard/flights/widgets/flight_filters_sheet.dart';
import 'package:outc/dashboard/flights/widgets/flight_quick_filter_bar.dart';
import 'package:outc/dashboard/flights/widgets/flight_result_card.dart';
import 'package:outc/dashboard/flights/widgets/flight_trip_summary_bar.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class OneWayFlightlistPage extends StatefulWidget {
  List<FlightDetail>? originalData;

  FiltersObj? filterData;

  int noOfFlights;
  int adultcount, childcount, infantcount;
  String traceId;
  OneWayFlightlistPage(
      {super.key,
      required this.originalData,
      // required this.dataFlightDetails,
      required this.noOfFlights,
      required this.adultcount,
      required this.childcount,
      required this.infantcount,
      required this.filterData,
      required this.traceId});

  @override
  State<OneWayFlightlistPage> createState() => _OneWayFlightlistPageState();
}

class _OneWayFlightlistPageState extends State<OneWayFlightlistPage> {
  bool flightDetailsFlag = false;
  // String traceId = "";

  List<FlightDetail>? flightsdata = [];

  RangeValues _currentRangeValues = const RangeValues(0, 0);
  FlightSortOption? _sortOption;
  bool directStop = false;
  bool oneStop = false;
  bool depOne = false;
  bool depTwo = false;
  bool depThree = false;
  bool depFour = false;
  bool arvlOne = false;
  bool arvlTwo = false;
  bool arvlThree = false;
  bool arvlFour = false;
  bool refund = false;
  bool nonrefund = false;

  double? adultfare,
      childfare,
      infantfare,
      adulttaxfare,
      childtaxfare,
      infanttaxfare;

  /// The Filters panel used to read `widget.filterData!.stops![0]`/`[1]`
  /// assuming the API always returns exactly a "Direct" and a "1 Stop (s)"
  /// entry, in that order — it crashed with a RangeError whenever a result
  /// set's `stops` came back shorter than that (e.g. empty, as happens for
  /// an all-direct route). Looked up by label instead of position so a
  /// missing/reordered/empty `stops` list just hides that chip.
  bool _hasStopFilter(String label) =>
      widget.filterData?.stops?.any((stop) => stop.label == label) ?? false;

  /// The Price Range slider read `widget.filterData!.price!.minPrice`/
  /// `maxPrice` directly and showed "0.00 INR" to "0.00 INR" whenever the
  /// backend didn't populate that range for a route (both fields 0) — a
  /// slider with `min == max` is also unusable. Falls back to the actual
  /// min/max fare across this search's results when the backend range isn't
  /// usable, so the slider always has real bounds to work with.
  (double, double) _priceBounds() {
    final rawMin = widget.filterData?.price?.minPrice?.toDouble() ?? 0;
    final rawMax = widget.filterData?.price?.maxPrice?.toDouble() ?? 0;
    if (rawMax > rawMin && rawMin >= 0) return (rawMin, rawMax);

    final currency = double.tryParse(SharedPrefServices.getcurrencyAmount().toString()) ?? 1;
    final fares = (widget.originalData ?? const <FlightDetail>[])
        .map((f) => f.fareFamilies!.fareFamilies![0].adultPublishFare! * currency)
        .toList();
    if (fares.isEmpty) return (0, 1);
    final min = fares.reduce((a, b) => a < b ? a : b);
    final max = fares.reduce((a, b) => a > b ? a : b);
    return (min, max > min ? max : min + 1);
  }

  // List of checkbox models
  List<ConnectingLocationsCheckboxModel> _connectingLocationcheckboxList = [];
  List<AirlinesCheckboxModel> _airLinescheckboxList = [];

  // Trip summary bar (edit-search) state — resolved async since the results
  // themselves only carry origin/destination IATA codes (see
  // AirportNameCache's doc comment); starts null and fills in once the
  // lookup completes, same pattern as FlightFaresSheet's route recap.
  Datum? _originLookup;
  Datum? _destLookup;

  @override
  void initState() {
    super.initState();

    updateData();
    final bounds = _priceBounds();
    _currentRangeValues = RangeValues(bounds.$1, bounds.$2);
    fillConnectingLocationList();
    fillAirLinesList();
    _resolveTripSummaryNames();
  }

  FlightDetail? get _firstFlight =>
      (widget.originalData ?? const <FlightDetail>[]).isNotEmpty ? widget.originalData!.first : null;

  String _tripSummarySubtitle() {
    final departureDate = _firstFlight?.flightSegments?.isNotEmpty == true
        ? _firstFlight!.flightSegments!.first.departureDateTime
        : null;
    final travellerCount = widget.adultcount + widget.childcount + widget.infantcount;
    return [
      if (departureDate != null) DateFormat('dd MMM yyyy').format(departureDate),
      '$travellerCount Traveller${travellerCount == 1 ? '' : 's'}',
      'Economy',
    ].join(' · ');
  }

  Future<void> _resolveTripSummaryNames() async {
    final first = (widget.originalData ?? const <FlightDetail>[]).isNotEmpty
        ? widget.originalData!.first
        : null;
    if (first == null) return;
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.filterData);
    print('Testing members');
    print(widget.adultcount);
    print(widget.childcount);
    print(widget.infantcount);

    return Scaffold(
      backgroundColor: AppColors.panelBackground,
      // No separate "Flight Results" app-bar title/toolbar — the reference
      // apps' results screen opens straight into the route/date search bar
      // (back arrow built into that same row) with a quick-filter chip row
      // right underneath it, not a generic title strip above both.
      body: SafeArea(
        child: Column(
          children: [
            FlightTripSummaryBar(
              routeLabel: '${placeLabel(_firstFlight?.origin, _originLookup)} → '
                  '${placeLabel(_firstFlight?.destination, _destLookup)}',
              subtitle: _tripSummarySubtitle(),
              onBack: () => Navigator.of(context).pop(),
              // Show the search form as a "Modify Flight Search" modal sheet
              // *over* this results screen, instead of popping back to it or
              // pushing a full opaque page — either of those reads as
              // leaving the list entirely. A modal sheet keeps this list
              // (and its already-fetched data) visible, dimmed, right
              // underneath — matching the reference behavior — and Cancel
              // just dismisses the sheet, no re-fetch.
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
              isCheapestFirstActive: _sortOption == FlightSortOption.priceLowToHigh,
              onToggleCheapestFirst: () {
                setState(() {
                  _sortOption =
                      _sortOption == FlightSortOption.priceLowToHigh ? null : FlightSortOption.priceLowToHigh;
                });
                updateFilterData();
              },
              isNonStopActive: directStop,
              onToggleNonStop: () {
                setState(() => directStop = !directStop);
                updateFilterData();
              },
              activeFilterCount: _activeFilterCount,
              onTapFilters: () => _showFiltersSheet(context),
            ),
            flightsdata!.isEmpty
                ? Center(
                    child: Text(
                      "No Flights Available",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      itemCount: flightsdata!.length,
                      itemBuilder: (context, index) {
                        final flight = flightsdata![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FlightResultCard(
                            flight: flight,
                            onTap: () => FlightFaresSheet.show(
                              context,
                              flight: flight,
                              traceId: widget.traceId,
                              adultCount: widget.adultcount,
                              childCount: widget.childcount,
                              infantCount: widget.infantcount,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  removeDuplicatesfromList() {
    setState(() {
      flightsdata!.toSet().toList();
    });
  }

  updateData() {
    setState(() {
      flightsdata = widget.originalData;
    });
  }

  /// Feeds the "Filters" pill's badge in `FlightQuickFilterBar` — every
  /// individual active condition counts once (Non Stop counts here too once
  /// toggled, same as the reference apps' own badge).
  int get _activeFilterCount =>
      (directStop ? 1 : 0) +
      (oneStop ? 1 : 0) +
      (depOne ? 1 : 0) +
      (depTwo ? 1 : 0) +
      (depThree ? 1 : 0) +
      (depFour ? 1 : 0) +
      (arvlOne ? 1 : 0) +
      (arvlTwo ? 1 : 0) +
      (arvlThree ? 1 : 0) +
      (arvlFour ? 1 : 0) +
      (refund ? 1 : 0) +
      (nonrefund ? 1 : 0) +
      _connectingLocationcheckboxList.where((f) => f.isChecked).length +
      _airLinescheckboxList.where((f) => f.isChecked).length;

  /// Rebuilds `flightsdata` from `widget.originalData` against every active
  /// filter as one combined (AND'd) predicate, then applies the chosen
  /// sort. Previously each filter category re-derived `flightsdata` from
  /// `originalData` independently and overwrote the previous category's
  /// result — so only the *last* active filter ever actually applied
  /// instead of all of them narrowing the list together. This also adds
  /// sorting, which didn't exist before.
  updateFilterData() {
    final currency = double.tryParse(SharedPrefServices.getcurrencyAmount().toString()) ?? 1;
    setState(() {
      flightsdata = applyFlightFilters(
        widget.originalData ?? const <FlightDetail>[],
        adapter: flightDetailFilterAdapter,
        range: _currentRangeValues,
        directStop: directStop,
        oneStop: oneStop,
        dep: (depOne, depTwo, depThree, depFour),
        arv: (arvlOne, arvlTwo, arvlThree, arvlFour),
        refund: refund,
        nonrefund: nonrefund,
        connectingLocations:
            _connectingLocationcheckboxList.where((f) => f.isChecked).map((f) => f.title).toSet(),
        airlines: _airLinescheckboxList.where((f) => f.isChecked).map((f) => f.title).toSet(),
        currency: currency,
        sort: _sortOption,
      );
    });
    removeDuplicatesfromList();
  }

  fillConnectingLocationList() {
    _connectingLocationcheckboxList = List.generate(
        widget.filterData!.connect!.length,
        (index) => ConnectingLocationsCheckboxModel(
            title: widget.filterData!.connect![index].label.toString()));
  }

  fillAirLinesList() {
    _airLinescheckboxList = List.generate(
        widget.filterData!.airlines!.length,
        (index) => AirlinesCheckboxModel(
            title: widget.filterData!.airlines![index].label.toString()));
  }

  turnOffLocations() {
    for (var loc in _connectingLocationcheckboxList) {
      loc.isChecked = false;
    }
    for (var airLine in _airLinescheckboxList) {
      airLine.isChecked = false;
    }
  }

  /// Main "Filters" bottom sheet (spec 0015) — every group open and
  /// multi-selectable at once, replacing spec 0014's drill-down "tap a row,
  /// open its own sub-sheet, come back" version. A live "Show N flights"
  /// count on the Apply button updates as any chip is toggled, using the
  /// same `applyFlightFilters` predicate `updateFilterData()` applies for
  /// real once Apply is tapped.
  void _showFiltersSheet(BuildContext context) {
    final currency = double.tryParse(SharedPrefServices.getcurrencyAmount().toString()) ?? 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FlightFiltersSheet<FlightDetail>(
        originalData: widget.originalData ?? const <FlightDetail>[],
        adapter: flightDetailFilterAdapter,
        hasDirect: _hasStopFilter('Direct'),
        hasOneStop: _hasStopFilter('1 Stop (s)'),
        connectingLocationLabels: [for (final loc in _connectingLocationcheckboxList) loc.title],
        airlineLabels: [for (final airline in _airLinescheckboxList) airline.title],
        priceBounds: _priceBounds(),
        initialRange: _currentRangeValues,
        initialSort: _sortOption,
        initialDirectStop: directStop,
        initialOneStop: oneStop,
        initialDep: (depOne, depTwo, depThree, depFour),
        initialArv: (arvlOne, arvlTwo, arvlThree, arvlFour),
        initialRefund: refund,
        initialNonrefund: nonrefund,
        initialConnecting: [for (final loc in _connectingLocationcheckboxList) loc.isChecked],
        initialAirlines: [for (final airline in _airLinescheckboxList) airline.isChecked],
        currency: currency,
        onApply: (result) {
          setState(() {
            _currentRangeValues = result.range;
            _sortOption = result.sort;
            directStop = result.directStop;
            oneStop = result.oneStop;
            depOne = result.dep.$1;
            depTwo = result.dep.$2;
            depThree = result.dep.$3;
            depFour = result.dep.$4;
            arvlOne = result.arv.$1;
            arvlTwo = result.arv.$2;
            arvlThree = result.arv.$3;
            arvlFour = result.arv.$4;
            refund = result.refund;
            nonrefund = result.nonrefund;
            for (var i = 0; i < _connectingLocationcheckboxList.length; i++) {
              _connectingLocationcheckboxList[i].isChecked = result.connecting[i];
            }
            for (var i = 0; i < _airLinescheckboxList.length; i++) {
              _airLinescheckboxList[i].isChecked = result.airlines[i];
            }
          });
          updateFilterData();
        },
      ),
    );
  }
}

