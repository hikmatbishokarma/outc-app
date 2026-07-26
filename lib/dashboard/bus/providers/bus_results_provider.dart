import 'package:flutter/material.dart';

import 'package:outc/dashboard/bus/models/bus_search_models.dart';

enum BusSortOption { priceLowToHigh, priceHighToLow, departureEarliest, durationShortest }

extension BusSortOptionLabel on BusSortOption {
  String get label {
    switch (this) {
      case BusSortOption.priceLowToHigh:
        return 'Price: Low to High';
      case BusSortOption.priceHighToLow:
        return 'Price: High to Low';
      case BusSortOption.departureEarliest:
        return 'Departure: Earliest First';
      case BusSortOption.durationShortest:
        return 'Duration: Shortest First';
    }
  }
}

const _seatTypeKeywords = ['Seater', 'Semi Sleeper', 'Sleeper'];
const _acTypeKeywords = ['AC', 'NON AC'];

/// Filter/sort state for the bus results screen (spec 0007). Scoped to this
/// screen only — separate from `BusSearchProvider`, which owns the search
/// form. Filtering is client-side against the trip list already fetched by
/// the search call (spec 0007's resolved working assumption).
class BusResultsProvider extends ChangeNotifier {
  BusResultsProvider({required this.allTrips, required this.filters}) {
    priceRange = RangeValues(filters.priceMin, filters.priceMax);
  }

  final List<BusTrip> allTrips;
  final BusFilters filters;

  final Set<String> selectedSeatTypes = {};
  final Set<String> selectedAcTypes = {};
  final Set<String> selectedDepartureBuckets = {};
  final Set<String> selectedAmenities = {};
  final Set<String> selectedOperators = {};
  late RangeValues priceRange;
  BusSortOption sortBy = BusSortOption.priceLowToHigh;

  List<String> get availableAmenities {
    final set = <String>{};
    for (final trip in allTrips) {
      set.addAll(trip.amenities);
    }
    final list = set.toList()..sort();
    return list;
  }

  List<String> get availableOperators {
    final set = allTrips.map((t) => t.displayName).where((n) => n.isNotEmpty).toSet();
    final list = set.toList()..sort();
    return list;
  }

  List<BusTypeFacet> get seatTypeFacets =>
      filters.busTypes.where((f) => _seatTypeKeywords.contains(f.type)).toList();

  List<BusTypeFacet> get acTypeFacets =>
      filters.busTypes.where((f) => _acTypeKeywords.contains(f.type)).toList();

  /// A trip's `busType` is free text (e.g. "Bharat Benz AC Seater/Sleeper")
  /// that can contain both an AC/Non-AC keyword and a seat-type keyword.
  /// "NON AC" must be checked before "AC" so a NON-AC trip isn't
  /// misclassified as AC via substring match. Hyphens are normalized to
  /// spaces first — confirmed against a live capture that `busType` uses
  /// both "NON AC" and "NON-AC" inconsistently.
  bool _tripMatchesKeyword(BusTrip trip, String keyword) {
    final busType = trip.busType.toUpperCase().replaceAll('-', ' ');
    final normalizedKeyword = keyword.toUpperCase().replaceAll('-', ' ');
    if (normalizedKeyword == 'AC') {
      return busType.contains('AC') && !busType.contains('NON AC');
    }
    return busType.contains(normalizedKeyword);
  }

  List<BusTrip> get visibleTrips {
    var trips = allTrips.where((trip) {
      if (selectedSeatTypes.isNotEmpty &&
          !selectedSeatTypes.any((keyword) => _tripMatchesKeyword(trip, keyword))) {
        return false;
      }
      if (selectedAcTypes.isNotEmpty &&
          !selectedAcTypes.any((keyword) => _tripMatchesKeyword(trip, keyword))) {
        return false;
      }
      if (selectedDepartureBuckets.isNotEmpty &&
          !selectedDepartureBuckets.contains(_departureBucketFor(trip.departureTime))) {
        return false;
      }
      if (selectedAmenities.isNotEmpty &&
          !selectedAmenities.every((a) => trip.amenities.contains(a))) {
        return false;
      }
      if (selectedOperators.isNotEmpty && !selectedOperators.contains(trip.displayName)) {
        return false;
      }
      if (trip.fare < priceRange.start || trip.fare > priceRange.end) {
        return false;
      }
      return true;
    }).toList();

    trips.sort((a, b) {
      switch (sortBy) {
        case BusSortOption.priceLowToHigh:
          return a.fare.compareTo(b.fare);
        case BusSortOption.priceHighToLow:
          return b.fare.compareTo(a.fare);
        case BusSortOption.departureEarliest:
          return a.departureTime.compareTo(b.departureTime);
        case BusSortOption.durationShortest:
          return _durationMinutes(a.duration).compareTo(_durationMinutes(b.duration));
      }
    });

    return trips;
  }

  static String _departureBucketFor(String departureTime) {
    final hour = int.tryParse(departureTime.split(':').first) ?? 0;
    if (hour < 6) return '12AM to 06AM';
    if (hour < 12) return '06AM to 12PM';
    if (hour < 18) return '12PM to 06PM';
    return '06PM to 12AM';
  }

  /// Parses e.g. "10:00 hr" into total minutes. Falls back to 0 (sorts
  /// first) for any duration string that doesn't match the expected shape.
  static int _durationMinutes(String duration) {
    final match = RegExp(r'(\d+):(\d+)').firstMatch(duration);
    if (match == null) return 0;
    final hours = int.tryParse(match.group(1) ?? '') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '') ?? 0;
    return hours * 60 + minutes;
  }

  /// Replaces the contents of one of this provider's own selection sets
  /// (e.g. `selectedSeatTypes`) with [values] and notifies listeners — used
  /// by the filter sheets to commit a batch of checkbox changes in one go.
  void applySelection(Set<String> target, Set<String> values) {
    target
      ..clear()
      ..addAll(values);
    notifyListeners();
  }

  void toggleSeatType(String keyword) {
    _toggle(selectedSeatTypes, keyword);
  }

  void toggleAcType(String keyword) {
    _toggle(selectedAcTypes, keyword);
  }

  void toggleDepartureBucket(String bucket) {
    _toggle(selectedDepartureBuckets, bucket);
  }

  void toggleAmenity(String amenity) {
    _toggle(selectedAmenities, amenity);
  }

  void toggleOperator(String operatorName) {
    _toggle(selectedOperators, operatorName);
  }

  void _toggle(Set<String> set, String value) {
    if (!set.remove(value)) set.add(value);
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    priceRange = range;
    notifyListeners();
  }

  void setSort(BusSortOption option) {
    sortBy = option;
    notifyListeners();
  }

  void clearSeatTypes() {
    selectedSeatTypes.clear();
    notifyListeners();
  }

  void clearAcTypes() {
    selectedAcTypes.clear();
    notifyListeners();
  }

  void clearDepartureBuckets() {
    selectedDepartureBuckets.clear();
    notifyListeners();
  }

  void clearAmenities() {
    selectedAmenities.clear();
    notifyListeners();
  }

  void clearOperators() {
    selectedOperators.clear();
    notifyListeners();
  }

  void clearPriceRange() {
    priceRange = RangeValues(filters.priceMin, filters.priceMax);
    notifyListeners();
  }

  void clearAll() {
    selectedSeatTypes.clear();
    selectedAcTypes.clear();
    selectedDepartureBuckets.clear();
    selectedAmenities.clear();
    selectedOperators.clear();
    priceRange = RangeValues(filters.priceMin, filters.priceMax);
    notifyListeners();
  }
}
