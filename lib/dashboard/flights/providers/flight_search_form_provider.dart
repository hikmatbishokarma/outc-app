import 'package:flutter/foundation.dart';

import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart';
import 'package:outc/widgets/sharedprefservices.dart';

enum TripType { oneWay, roundTrip, multiCity }

enum CabinClass { economyPremiumEconomy, economy, business, first }

extension CabinClassDisplay on CabinClass {
  String get label {
    switch (this) {
      case CabinClass.economyPremiumEconomy:
        return 'Economy/Premium Economy';
      case CabinClass.economy:
        return 'Economy';
      case CabinClass.business:
        return 'Business Class';
      case CabinClass.first:
        return 'First Class';
    }
  }

  String get description {
    switch (this) {
      case CabinClass.economyPremiumEconomy:
        return 'Standard comfort, best value';
      case CabinClass.economy:
        return 'Standard comfort, best value';
      case CabinClass.business:
        return 'Extra legroom, priority service';
      case CabinClass.first:
        return 'Premium comfort, top amenities';
    }
  }
}

/// One multi-city leg's origin/destination/date. Legs 1-2 mirror into the
/// existing `SharedPrefServices` city keys (unchanged, since other code
/// still reads those); legs 3+ live only here.
class RouteSegmentData {
  RouteSegmentData({
    this.originCity,
    this.originAirportCode,
    this.originCountry,
    this.destinationCity,
    this.destinationAirportCode,
    this.destinationCountry,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  final String? originCity;
  final String? originAirportCode;
  final String? originCountry;
  final String? destinationCity;
  final String? destinationAirportCode;
  final String? destinationCountry;
  final DateTime date;

  RouteSegmentData copyWith({
    String? originCity,
    String? originAirportCode,
    String? originCountry,
    String? destinationCity,
    String? destinationAirportCode,
    String? destinationCountry,
    DateTime? date,
  }) {
    return RouteSegmentData(
      originCity: originCity ?? this.originCity,
      originAirportCode: originAirportCode ?? this.originAirportCode,
      originCountry: originCountry ?? this.originCountry,
      destinationCity: destinationCity ?? this.destinationCity,
      destinationAirportCode: destinationAirportCode ?? this.destinationAirportCode,
      destinationCountry: destinationCountry ?? this.destinationCountry,
      date: date ?? this.date,
    );
  }

  RouteSegmentData withOrigin(Datum airport) => copyWith(
        originCity: airport.city,
        originAirportCode: airport.airportCode,
        originCountry: airport.country,
      );

  RouteSegmentData withDestination(Datum airport) => copyWith(
        destinationCity: airport.city,
        destinationAirportCode: airport.airportCode,
        destinationCountry: airport.country,
      );
}

/// Single source of truth for the flight search form's trip type, passenger
/// counts, cabin class, and multi-city leg list. Scoped locally to
/// `FlightsListPage` (not app-wide) — see search_flights.dart.
///
/// City/date persistence for legs 1-2 and one-way/round-trip dates still
/// goes through `SharedPrefServices` exactly as before this redesign; this
/// provider only replaces what used to live as bare `State` fields on
/// `_FlightsListPageState` (which were destroyed every time a city picker
/// pushed a fresh `FlightsListPage` — see specs/0003).
class FlightSearchFormProvider extends ChangeNotifier {
  FlightSearchFormProvider() {
    tripType = _tripTypeFromSharedPref(SharedPrefServices.getselecedscroller());
    multiCitySegments = [
      RouteSegmentData(
        originCity: _nullIfEmpty(SharedPrefServices.getcityFrom()),
        originAirportCode: _nullIfEmpty(SharedPrefServices.getairportcodeFrom()),
        originCountry: _nullIfEmpty(SharedPrefServices.getcountryFrom()),
        destinationCity: _nullIfEmpty(SharedPrefServices.getcityTo()),
        destinationAirportCode: _nullIfEmpty(SharedPrefServices.getairportcodeTo()),
        destinationCountry: _nullIfEmpty(SharedPrefServices.getcountryTo()),
      ),
      RouteSegmentData(
        originCity: _nullIfEmpty(SharedPrefServices.getcityFromTwo()),
        originAirportCode: _nullIfEmpty(SharedPrefServices.getairportcodeFromTwo()),
        originCountry: _nullIfEmpty(SharedPrefServices.getcountryFromTwo()),
        destinationCity: _nullIfEmpty(SharedPrefServices.getcityToTwo()),
        destinationAirportCode: _nullIfEmpty(SharedPrefServices.getairportcodeToTwo()),
        destinationCountry: _nullIfEmpty(SharedPrefServices.getcountryToTwo()),
      ),
    ];
  }

  static String? _nullIfEmpty(String? value) =>
      (value == null || value.trim().isEmpty) ? null : value;

  TripType tripType = TripType.oneWay;
  int adultCount = 1;
  int childCount = 0;
  int infantCount = 0;
  CabinClass cabinClass = CabinClass.economyPremiumEconomy;
  List<RouteSegmentData> multiCitySegments = [RouteSegmentData(), RouteSegmentData()];

  static const int minMultiCitySegments = 2;

  int get totalPassengers => adultCount + childCount + infantCount;

  static TripType _tripTypeFromSharedPref(String? value) {
    switch (value) {
      case 'roundTrip':
        return TripType.roundTrip;
      case 'multidestination':
        return TripType.multiCity;
      default:
        return TripType.oneWay;
    }
  }

  static String tripTypeSharedPrefValue(TripType type) {
    switch (type) {
      case TripType.oneWay:
        return 'oneWay';
      case TripType.roundTrip:
        return 'roundTrip';
      case TripType.multiCity:
        return 'multidestination';
    }
  }

  void setTripType(TripType type) {
    if (tripType == type) return;
    tripType = type;
    SharedPrefServices.setselecedscroller(tripTypeSharedPrefValue(type));
    notifyListeners();
  }

  void setPassengers({int? adults, int? children, int? infants}) {
    adultCount = adults ?? adultCount;
    childCount = children ?? childCount;
    infantCount = infants ?? infantCount;
    notifyListeners();
  }

  void setCabinClass(CabinClass cabin) {
    cabinClass = cabin;
    notifyListeners();
  }

  void addSegment() {
    multiCitySegments.add(RouteSegmentData());
    notifyListeners();
  }

  void removeSegment(int index) {
    if (multiCitySegments.length <= minMultiCitySegments) return;
    multiCitySegments.removeAt(index);
    notifyListeners();
  }

  void updateSegment(int index, RouteSegmentData data) {
    multiCitySegments[index] = data;
    notifyListeners();
  }
}
