import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/flights/models/flight_roundtrip_model.dart';
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart' show Datum;
import 'package:outc/dashboard/flights/providers/airport_name_cache.dart';
import 'package:outc/dashboard/flights/screens/search_flights.dart';
import 'package:outc/dashboard/flights/widgets/flight_filters_sheet.dart';
import 'package:outc/dashboard/flights/widgets/flight_multicity_card.dart';
import 'package:outc/dashboard/flights/widgets/flight_multicity_filters.dart';
import 'package:outc/dashboard/flights/widgets/flight_multicity_trip_sheet.dart';
import 'package:outc/dashboard/flights/widgets/flight_quick_filter_bar.dart';
import 'package:outc/dashboard/flights/widgets/flight_trip_summary_bar.dart';

import 'package:outc/widgets/sharedprefservices.dart';

/// Multi-city results — spec 0016. One card per priced itinerary *combo*
/// (`DataFlightDetail`, the same shape `flight_roundtrip_model.dart` already
/// models, confirmed against the live backend — see the spec's API contract
/// section), each combo holding however many legs it actually has. No leg
/// count is hardcoded anywhere in this screen; if the backend ever returns
/// combos with more than 2 legs, this renders them without any client
/// change.
class FetchedMulticityResults extends StatefulWidget {
  const FetchedMulticityResults({
    super.key,
    required this.originalData,
    required this.filterData,
    required this.traceId,
    required this.adultcount,
    required this.childcount,
    required this.infantcount,
  });

  final List<DataFlightDetail> originalData;
  final FiltersObj? filterData;
  final String traceId;
  final int adultcount;
  final int childcount;
  final int infantcount;

  @override
  State<FetchedMulticityResults> createState() => _FetchedMulticityResultsState();
}

class _FetchedMulticityResultsState extends State<FetchedMulticityResults> {
  List<DataFlightDetail> _filtered = [];

  final _LegFilterState _filters = _LegFilterState();

  // One `Datum?` per waypoint in the chain (origin, each stop, final
  // destination) — resolved from the *first* itinerary's own legs, same
  // "every combo is priced options for the same requested route" precedent
  // the oneway/round-trip trip bars already rely on.
  List<Datum?> _waypointLookups = [];
  List<String?> _waypointCodes = [];

  double get _currency => double.tryParse(SharedPrefServices.getcurrencyAmount().toString()) ?? 1;

  @override
  void initState() {
    super.initState();
    _fillFilterOptions();
    _updateFilterData();
    _resolveWaypointNames();
  }

  List<FlightDetailFlightDetail> get _representativeLegs =>
      widget.originalData.isNotEmpty ? (widget.originalData.first.flightDetails ?? const []) : const [];

  Future<void> _resolveWaypointNames() async {
    final legs = _representativeLegs;
    if (legs.isEmpty) return;
    final codes = <String?>[
      legs.first.origin,
      for (final leg in legs) leg.destination,
    ];
    final lookups = await Future.wait(codes.map(AirportNameCache.resolve));
    if (!mounted) return;
    setState(() {
      _waypointCodes = codes;
      _waypointLookups = lookups;
    });
  }

  (double, double) _priceBounds() {
    final fares = widget.originalData.map((combo) => multicityFilterAdapter.price(combo, _currency)).toList();
    if (fares.isEmpty) return (0, 1);
    final min = fares.reduce((a, b) => a < b ? a : b);
    final max = fares.reduce((a, b) => a > b ? a : b);
    return (min, max > min ? max : min + 1);
  }

  void _fillFilterOptions() {
    final airlineLabels = <String>{};
    final connectingLabels = <String>{};
    for (final combo in widget.originalData) {
      airlineLabels.addAll(multicityFilterAdapter.airlines(combo));
      connectingLabels.addAll(multicityFilterAdapter.connectingLocations(combo));
    }
    _filters.airlines = [
      for (final label in airlineLabels.toList()..sort()) AirlinesCheckboxModel(title: label),
    ];
    _filters.connecting = [
      for (final label in connectingLabels.toList()..sort()) ConnectingLocationsCheckboxModel(title: label),
    ];
    final bounds = _priceBounds();
    _filters.range = RangeValues(bounds.$1, bounds.$2);
  }

  void _updateFilterData() {
    final filtered = applyFlightFilters(
      widget.originalData,
      adapter: multicityFilterAdapter,
      range: _filters.range,
      directStop: _filters.directStop,
      oneStop: false,
      dep: (_filters.dep1, _filters.dep2, _filters.dep3, _filters.dep4),
      arv: (_filters.arv1, _filters.arv2, _filters.arv3, _filters.arv4),
      refund: _filters.refund,
      nonrefund: _filters.nonrefund,
      connectingLocations: _filters.connecting.where((f) => f.isChecked).map((f) => f.title).toSet(),
      airlines: _filters.airlines.where((f) => f.isChecked).map((f) => f.title).toSet(),
      currency: _currency,
      sort: _filters.sort,
    );
    setState(() => _filtered = filtered);
  }

  void _showFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FlightFiltersSheet<DataFlightDetail>(
        title: 'Filters',
        originalData: widget.originalData,
        adapter: multicityFilterAdapter,
        hasDirect: widget.originalData.any(multicityFilterAdapter.isDirect),
        hasOneStop: false,
        connectingLocationLabels: [for (final loc in _filters.connecting) loc.title],
        airlineLabels: [for (final airline in _filters.airlines) airline.title],
        priceBounds: _priceBounds(),
        initialRange: _filters.range,
        initialSort: _filters.sort,
        initialDirectStop: _filters.directStop,
        initialOneStop: false,
        initialDep: (_filters.dep1, _filters.dep2, _filters.dep3, _filters.dep4),
        initialArv: (_filters.arv1, _filters.arv2, _filters.arv3, _filters.arv4),
        initialRefund: _filters.refund,
        initialNonrefund: _filters.nonrefund,
        initialConnecting: [for (final loc in _filters.connecting) loc.isChecked],
        initialAirlines: [for (final airline in _filters.airlines) airline.isChecked],
        currency: _currency,
        onApply: (result) {
          setState(() {
            _filters.range = result.range;
            _filters.sort = result.sort;
            _filters.directStop = result.directStop;
            _filters.dep1 = result.dep.$1;
            _filters.dep2 = result.dep.$2;
            _filters.dep3 = result.dep.$3;
            _filters.dep4 = result.dep.$4;
            _filters.arv1 = result.arv.$1;
            _filters.arv2 = result.arv.$2;
            _filters.arv3 = result.arv.$3;
            _filters.arv4 = result.arv.$4;
            _filters.refund = result.refund;
            _filters.nonrefund = result.nonrefund;
            for (var i = 0; i < _filters.connecting.length; i++) {
              _filters.connecting[i].isChecked = result.connecting[i];
            }
            for (var i = 0; i < _filters.airlines.length; i++) {
              _filters.airlines[i].isChecked = result.airlines[i];
            }
          });
          _updateFilterData();
        },
      ),
    );
  }

  String _routeLabel() {
    if (_waypointCodes.isEmpty) return '';
    final names = <String>[
      for (var i = 0; i < _waypointCodes.length; i++)
        _place(_waypointCodes[i], i < _waypointLookups.length ? _waypointLookups[i] : null),
    ];
    return names.join(' → ');
  }

  static String? _clean(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
    return trimmed;
  }

  static String _place(String? code, Datum? lookup) {
    final city = _clean(lookup?.city);
    final cleanCode = _clean(code) ?? _clean(lookup?.airportCode);
    return cleanCode ?? city ?? 'Unknown';
  }

  String _tripSummarySubtitle() {
    final legs = _representativeLegs;
    final dates = <String>[
      for (final leg in legs)
        if (leg.flightSegments?.isNotEmpty == true && leg.flightSegments!.first.departureDateTime != null)
          DateFormat('dd MMM').format(leg.flightSegments!.first.departureDateTime!),
    ];
    final travellerCount = widget.adultcount + widget.childcount + widget.infantcount;
    return [
      if (dates.isNotEmpty) dates.join(' · '),
      '$travellerCount Traveller${travellerCount == 1 ? '' : 's'}',
      'Economy',
    ].join(' · ');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.panelBackground,
      body: SafeArea(
        child: Column(
          children: [
            FlightTripSummaryBar(
              routeLabel: _routeLabel(),
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
              isCheapestFirstActive: _filters.sort == FlightSortOption.priceLowToHigh,
              onToggleCheapestFirst: () {
                setState(() {
                  _filters.sort = _filters.sort == FlightSortOption.priceLowToHigh ? null : FlightSortOption.priceLowToHigh;
                });
                _updateFilterData();
              },
              isNonStopActive: _filters.directStop,
              nonStopLabel: 'All Direct',
              onToggleNonStop: () {
                setState(() => _filters.directStop = !_filters.directStop);
                _updateFilterData();
              },
              activeFilterCount: _filters.activeFilterCount,
              onTapFilters: () => _showFiltersSheet(context),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text('No itineraries available',
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final itinerary = _filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FlightMulticityCard(
                            itinerary: itinerary,
                            onTap: () => FlightMulticityTripSheet.show(context, itinerary: itinerary),
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
}

/// This screen's own filter selection — a flat itinerary list, so (unlike
/// round trip's per-leg `_LegFilterState`) there's only ever one of these.
class _LegFilterState {
  RangeValues range = const RangeValues(0, 0);
  FlightSortOption? sort;
  bool directStop = false;
  bool dep1 = false, dep2 = false, dep3 = false, dep4 = false;
  bool arv1 = false, arv2 = false, arv3 = false, arv4 = false;
  bool refund = false;
  bool nonrefund = false;
  List<ConnectingLocationsCheckboxModel> connecting = [];
  List<AirlinesCheckboxModel> airlines = [];

  int get activeFilterCount =>
      (directStop ? 1 : 0) +
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
