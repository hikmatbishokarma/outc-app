import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:outc/core/widgets/segmented_control.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/dashboard/flights/models/flights_search_payloadmodel.dart';
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart';
import 'package:outc/dashboard/flights/providers/flight_search_form_provider.dart';
import 'package:outc/dashboard/flights/screens/airport_search_screen.dart';
import 'package:outc/dashboard/flights/screens/fetched_domestic_multicity_flights.dart';
import 'package:outc/dashboard/flights/screens/fetched_multicity_flights.dart';
import 'package:outc/dashboard/flights/screens/oneway_flight_list.dart';
import 'package:outc/dashboard/flights/widgets/calendar/flight_calendar_screen.dart';
import 'package:outc/dashboard/flights/widgets/calendar/flight_single_date_calendar_screen.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';
import 'package:outc/dashboard/flights/widgets/flight_marketing_section.dart';
import 'package:outc/dashboard/flights/widgets/multi_city_form.dart';
import 'package:outc/dashboard/flights/widgets/one_way_round_trip_form.dart';
import 'package:outc/dashboard/flights/widgets/progressbar.dart';
import 'package:outc/dashboard/flights/widgets/traveller_bottom_sheet.dart';

import 'package:outc/services/api_services_list.dart';

import 'package:outc/widgets/components/toast.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class FlightsListPage extends StatefulWidget {
  const FlightsListPage({super.key});

  @override
  State<FlightsListPage> createState() => _FlightsListPageState();
}

class _FlightsListPageState extends State<FlightsListPage> {
  bool isApiCallProcess = false;
  List dest = [];

  DateTime raw_dep_date = DateTime.now();
  DateTime? raw_arrival_date;
  String depDateFormated = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? arrDateFormated;

  // Mirrors of the provider's passenger counts. getFlightsListmethod() and
  // getFlightsMulticityListmethod() below reference these bare fields
  // directly (kept verbatim from before this redesign) — _onSearchPressed
  // syncs them from FlightSearchFormProvider immediately before calling
  // either method, so the provider stays the single source of truth for
  // everything the UI displays/edits.
  int adultcount = 1;
  int children = 0;
  int infants = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlightSearchFormProvider(),
      child: Flight_ProgressBar(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        child: Consumer<FlightSearchFormProvider>(
          builder: (context, form, _) => uiSetup(context, form),
        ),
      ),
    );
  }

  Widget uiSetup(BuildContext context, FlightSearchFormProvider form) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "OutC",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'poppins',
            color: Flights_Colours.strongRed,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.grey),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            color: Flights_Colours.strongRed,
            icon: Icon(Icons.home, size: 28, color: Flights_Colours.strongRed),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              color: Flights_Colours.strongRed,
              icon: Icon(Icons.wallet, size: 28, color: Flights_Colours.strongRed),
              onPressed: () => _showWalletDialog(context),
            ),
          ),
          IconButton(
            color: Flights_Colours.strongRed,
            icon: const ImageIcon(AssetImage("images/notifybell.png")),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Pinned: stays visible while the content below scrolls, so the
            // trip-type selector is always reachable without scrolling back
            // to the top (specs/0003 sticky-header follow-up).
            _buildHeader(context, form),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            child: child,
                          ),
                        ),
                        child: form.tripType == TripType.multiCity
                            ? KeyedSubtree(
                                key: const ValueKey('multiCityForm'),
                                child: _buildMultiCityForm(context, form),
                              )
                            : KeyedSubtree(
                                key: const ValueKey('oneWayRoundTripForm'),
                                child: _buildOneWayRoundTripForm(context, form),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const FlightMarketingSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FlightSearchFormProvider form) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        color: Colors.blue,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SegmentedControl(
            labels: const ['ONE WAY', 'ROUND TRIP', 'MULTI CITY'],
            selectedIndex: form.tripType.index,
            activeColor: Flights_Colours.dardModerateBlue,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            inactiveTextColor: Colors.white70,
            onChanged: (index) => _onTripTypeChanged(form, TripType.values[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildOneWayRoundTripForm(BuildContext context, FlightSearchFormProvider form) {
    return OneWayRoundTripFormCard(
      tripType: form.tripType,
      fromCity: _nullIfEmpty(SharedPrefServices.getcityFrom()),
      fromCode: _nullIfEmpty(SharedPrefServices.getairportcodeFrom()),
      fromCountry: _nullIfEmpty(SharedPrefServices.getcountryFrom()),
      toCity: _nullIfEmpty(SharedPrefServices.getcityTo()),
      toCode: _nullIfEmpty(SharedPrefServices.getairportcodeTo()),
      toCountry: _nullIfEmpty(SharedPrefServices.getcountryTo()),
      departureDate: raw_dep_date,
      returnDate: raw_arrival_date,
      adultCount: form.adultCount,
      childCount: form.childCount,
      infantCount: form.infantCount,
      cabinClass: form.cabinClass,
      onPickFrom: () => _pickAirport(context, isOrigin: true),
      onPickTo: () => _pickAirport(context, isOrigin: false),
      onSwapCities: _swapCities,
      onPickDeparture: () => _pickDates(context, form, FlightCalendarField.departure),
      onPickReturn: () => _pickDates(context, form, FlightCalendarField.returnDate),
      onTravellersChanged: (selection) => _applyTravellerSelection(form, selection),
      onSearch: () => _onSearchOneWayRoundTrip(form),
      isSearching: isApiCallProcess,
    );
  }

  Widget _buildMultiCityForm(BuildContext context, FlightSearchFormProvider form) {
    return MultiCityFormCard(
      segments: form.multiCitySegments,
      adultCount: form.adultCount,
      childCount: form.childCount,
      infantCount: form.infantCount,
      cabinClass: form.cabinClass,
      onPickFrom: (index) => _pickMultiCityAirport(context, form, index, isOrigin: true),
      onPickTo: (index) => _pickMultiCityAirport(context, form, index, isOrigin: false),
      onPickDate: (index) => _pickMultiCitySegmentDate(context, form, index),
      onAddSegment: form.addSegment,
      onRemoveSegment: form.removeSegment,
      onTravellersChanged: (selection) => _applyTravellerSelection(form, selection),
      onSearch: () => _onSearchMultiCity(form),
      isSearching: isApiCallProcess,
      minSegments: FlightSearchFormProvider.minMultiCitySegments,
    );
  }

  static String? _nullIfEmpty(String? value) =>
      (value == null || value.trim().isEmpty) ? null : value;

  void _onTripTypeChanged(FlightSearchFormProvider form, TripType type) {
    // Switching to Round Trip with no return date yet defaults it to
    // departure + 1 day (matching the reference behavior), instead of
    // leaving the field showing an empty "Select Date" placeholder.
    if (type == TripType.roundTrip && raw_arrival_date == null) {
      final defaultReturn = raw_dep_date.add(const Duration(days: 1));
      final formattedDate = DateFormat.yMMMEd().format(defaultReturn);
      setState(() {
        SharedPrefServices.setarrivalDate(formattedDate);
        raw_arrival_date = defaultReturn;
        arrDateFormated = DateFormat('yyyy-MM-dd').format(defaultReturn);
      });
    }
    form.setTripType(type);
  }

  void _applyTravellerSelection(FlightSearchFormProvider form, TravellerSelection selection) {
    form.setPassengers(
      adults: selection.adults,
      children: selection.children,
      infants: selection.infants,
    );
    form.setCabinClass(selection.cabinClass);
  }

  Future<void> _pickAirport(
    BuildContext context, {
    required bool isOrigin,
  }) async {
    final result = await Navigator.of(context).push<AirportSearchResult>(
      MaterialPageRoute(
        builder: (_) => AirportSearchScreen(
          initialField: isOrigin ? AirportSearchField.origin : AirportSearchField.destination,
          initialOrigin: _datumFrom(
            city: SharedPrefServices.getcityFrom(),
            code: SharedPrefServices.getairportcodeFrom(),
            country: SharedPrefServices.getcountryFrom(),
          ),
          initialDestination: _datumFrom(
            city: SharedPrefServices.getcityTo(),
            code: SharedPrefServices.getairportcodeTo(),
            country: SharedPrefServices.getcountryTo(),
          ),
        ),
      ),
    );
    if (result == null) return;
    if (result.origin != null) {
      await SharedPrefServices.setcityFrom(result.origin!.city ?? '');
      await SharedPrefServices.setairportcodeFrom(result.origin!.airportCode ?? '');
      await SharedPrefServices.setcountryFrom(result.origin!.country ?? '');
    }
    if (result.destination != null) {
      await SharedPrefServices.setcityTo(result.destination!.city ?? '');
      await SharedPrefServices.setairportcodeTo(result.destination!.airportCode ?? '');
      await SharedPrefServices.setcountryTo(result.destination!.country ?? '');
    }
    if (mounted) setState(() {});
  }

  static Datum? _datumFrom({required String? city, required String? code, required String? country}) {
    if (city == null || city.trim().isEmpty) return null;
    return Datum(city: city, airportCode: code, country: country);
  }

  void _swapCities() {
    final city = SharedPrefServices.getcityFrom();
    final code = SharedPrefServices.getairportcodeFrom();
    final country = SharedPrefServices.getcountryFrom();

    SharedPrefServices.setcityFrom(SharedPrefServices.getcityTo() ?? '');
    SharedPrefServices.setairportcodeFrom(SharedPrefServices.getairportcodeTo() ?? '');
    SharedPrefServices.setcountryFrom(SharedPrefServices.getcountryTo() ?? '');

    SharedPrefServices.setcityTo(city ?? '');
    SharedPrefServices.setairportcodeTo(code ?? '');
    SharedPrefServices.setcountryTo(country ?? '');

    setState(() {});
  }

  Future<void> _pickMultiCityAirport(
    BuildContext context,
    FlightSearchFormProvider form,
    int index, {
    required bool isOrigin,
  }) async {
    final segment = form.multiCitySegments[index];
    final result = await Navigator.of(context).push<AirportSearchResult>(
      MaterialPageRoute(
        builder: (_) => AirportSearchScreen(
          initialField: isOrigin ? AirportSearchField.origin : AirportSearchField.destination,
          initialOrigin: _datumFrom(
            city: segment.originCity,
            code: segment.originAirportCode,
            country: segment.originCountry,
          ),
          initialDestination: _datumFrom(
            city: segment.destinationCity,
            code: segment.destinationAirportCode,
            country: segment.destinationCountry,
          ),
        ),
      ),
    );
    if (result == null) return;
    var updated = form.multiCitySegments[index];
    if (result.origin != null) updated = updated.withOrigin(result.origin!);
    if (result.destination != null) updated = updated.withDestination(result.destination!);
    form.updateSegment(index, updated);
  }

  Future<void> _pickDates(
    BuildContext context,
    FlightSearchFormProvider form,
    FlightCalendarField initialField,
  ) async {
    final result = await Navigator.of(context).push<FlightDateSelection>(
      MaterialPageRoute(
        builder: (_) => FlightCalendarScreen(
          initialField: initialField,
          initialDeparture: raw_dep_date,
          // Only show a pre-filled Return Date while already in Round
          // Trip — otherwise a return date preserved from an earlier
          // Round Trip visit would confusingly appear already selected
          // while the user is just picking a One Way departure date.
          // The underlying value is preserved either way; not passing it
          // here only means this particular visit starts it empty.
          initialReturn: form.tripType == TripType.roundTrip ? raw_arrival_date : null,
        ),
      ),
    );
    if (result == null) return;

    final departureFormatted = DateFormat.yMMMEd().format(result.departure);
    setState(() {
      SharedPrefServices.setdepartureDate(departureFormatted);
      depDateFormated = DateFormat('yyyy-MM-dd').format(result.departure);
      raw_dep_date = result.departure;

      if (result.returnDate != null) {
        final returnFormatted = DateFormat.yMMMEd().format(result.returnDate!);
        SharedPrefServices.setarrivalDate(returnFormatted);
        raw_arrival_date = result.returnDate;
        arrDateFormated = DateFormat('yyyy-MM-dd').format(result.returnDate!);
      }
    });

    // Trip type is derived on Done, not on entry (specs/0005): a return
    // date picked here — regardless of whether the user opened this screen
    // via the DEPARTURE or RETURN card — upgrades a one-way search to round
    // trip. There is no downgrade path since the calendar never clears an
    // existing return date.
    if (result.returnDate != null && form.tripType == TripType.oneWay) {
      form.setTripType(TripType.roundTrip);
    }
  }

  Future<void> _pickMultiCitySegmentDate(
    BuildContext context,
    FlightSearchFormProvider form,
    int index,
  ) async {
    final segment = form.multiCitySegments[index];
    final firstAllowed = index == 0 ? DateTime.now() : form.multiCitySegments[index - 1].date;
    final routeLabel =
        '${segment.originAirportCode ?? segment.originCity ?? '—'} → '
        '${segment.destinationAirportCode ?? segment.destinationCity ?? '—'}';
    final pickedDate = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute(
        builder: (_) => FlightSingleDateCalendarScreen(
          routeLabel: routeLabel,
          initialDate: segment.date,
          minDate: firstAllowed,
        ),
      ),
    );
    if (pickedDate == null) return;
    form.updateSegment(index, segment.copyWith(date: pickedDate));
  }

  void _showWalletDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            color: Colors.transparent,
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "My Wallet Balance",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "INR ${SharedPrefServices.getwalletblc()}",
                  style: TextStyle(fontSize: 20.0, color: Flights_Colours.strongRed, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSearchOneWayRoundTrip(FlightSearchFormProvider form) {
    dest.clear();
    if (form.tripType == TripType.roundTrip) {
      dest = [
        {
          "departureDateTime": depDateFormated,
          "origin": SharedPrefServices.getairportcodeFrom().toString(),
          "destination": SharedPrefServices.getairportcodeTo().toString(),
          "flightDateFlex": 1
        },
        {
          "departureDateTime": arrDateFormated ?? depDateFormated,
          "origin": SharedPrefServices.getairportcodeTo().toString(),
          "destination": SharedPrefServices.getairportcodeFrom().toString(),
          "flightDateFlex": 1
        }
      ];
    } else {
      dest = [
        {
          "departureDateTime": depDateFormated,
          "origin": SharedPrefServices.getairportcodeFrom().toString(),
          "destination": SharedPrefServices.getairportcodeTo().toString(),
          "flightDateFlex": 1
        }
      ];
    }

    adultcount = form.adultCount;
    children = form.childCount;
    infants = form.infantCount;

    ListModel list = ListModel(
        originDestinations: dest,
        adultCount: adultcount,
        childCount: children,
        infantCount: infants,
        cabinClass: "Economy",
        includeCarrier: "",
        excludeCarrier: "",
        stopOver: "none",
        airTravelType: SharedPrefServices.getselecedscroller().toString(),
        flightDateFlex: 3,
        itineraryViewType: "1",
        priceForTrip: "REGULAR",
        userId: 1,
        roleType: 4,
        membership: 1);

    print(list);
    inspect(list);
    setState(() {
      isApiCallProcess = true;
    });
    if (form.tripType == TripType.oneWay) {
      getFlightsListmethod(list);
    } else if (form.tripType == TripType.roundTrip) {
      getFlightsMulticityListmethod(list);
    }
  }

  void _onSearchMultiCity(FlightSearchFormProvider form) {
    dest.clear();
    dest = form.multiCitySegments
        .map((segment) => {
              "departureDateTime": DateFormat('yyyy-MM-dd').format(segment.date),
              "origin": (segment.originAirportCode ?? "").toString(),
              "destination": (segment.destinationAirportCode ?? "").toString(),
              "flightDateFlex": 3
            })
        .toList();

    adultcount = form.adultCount;
    children = form.childCount;
    infants = form.infantCount;

    ListModel list = ListModel(
        originDestinations: dest,
        adultCount: adultcount,
        childCount: children,
        infantCount: infants,
        cabinClass: "Economy",
        includeCarrier: "",
        excludeCarrier: "",
        stopOver: "none",
        airTravelType: SharedPrefServices.getselecedscroller().toString(),
        flightDateFlex: 3,
        itineraryViewType: "1",
        priceForTrip: "REGULAR",
        userId: 1,
        roleType: 4,
        membership: 1);

    print(list);
    inspect(list);
    setState(() {
      isApiCallProcess = true;
    });
    getFlightsMulticityListmethod(list);
  }

  Future getFlightsListmethod(var data) async {
    print(json.encode(data.toJson()));
    var sendingdata = json.encode(data.toJson());

    try {
      APIService apiService = APIService();
      apiService.matchingFlightsList(sendingdata).then((value) async {
        const invalidsnackbar = SnackBar(
          content: Text('Data fetched. one way'),
        );
        ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
        inspect(value.statusCode);
        print(value.data!.flightDetails!);
        inspect(value.data!.flightDetails!);
        print("StatusCode ${value.statusCode} ");
        if (value.statusCode == 203) {
          setState(() {
            isApiCallProcess = false;
          });
          const invalidsnackbar = SnackBar(
            content: Text('Data not Found. try again'),
          );
          ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);

          // print(value.data);
        } else if (value.statusCode == 200) {
          setState(() {
            isApiCallProcess = false;
          });

          // showToast('Data found successfully.');
          if (value.data!.flightDetails!.isEmpty) {
            const invalidsnackbar = SnackBar(
              content: Text('No Flights available. try again'),
            );
            ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
          } else if (value.data!.flightDetails!.isNotEmpty) {
            // print(value.data!.flightDetails!);
            // inspect(value.data!.flightDetails);

            print(value.data!.filtersObj);
            inspect(value.data!.filtersObj);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return OneWayFlightlistPage(
                    // dataFlightDetails: value.data!.flightDetails,
                    traceId: value.data!.traceId!,
                    originalData: value.data!.flightDetails,
                    noOfFlights: value.data!.flightDetails!.length,
                    adultcount: adultcount,
                    childcount: children,
                    infantcount: infants,
                    filterData: value.data!.filtersObj,
                  );
                },
              ),
            );
          }
        } else if (value.statusCode == 201) {
          setState(() {
            isApiCallProcess = false;
          });

          // showToast('Data found successfully.');
          if (value.data!.flightDetails!.isEmpty) {
            const invalidsnackbar = SnackBar(
              content: Text('No Flights available. try again'),
            );
            ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
          } else if (value.data!.flightDetails!.isNotEmpty) {
            print(value.data!.flightDetails!);
            inspect(value.data!.flightDetails);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return OneWayFlightlistPage(
                    // dataFlightDetails: value.data!.flightDetails,
                    traceId: value.data!.traceId!,
                    originalData: value.data!.flightDetails,
                    noOfFlights: value.data!.flightDetails!.length,
                    adultcount: adultcount,
                    childcount: children,
                    infantcount: infants,
                    filterData: value.data!.filtersObj,
                  );
                },
              ),
            );
          }
        } else if (value.statusCode == 404) {
          setState(() {
            isApiCallProcess = false;
          });

          showToast('Data NOT found');
        } else {
          setState(() {
            isApiCallProcess = false;
          });
          final snackbar = SnackBar(
            content: Text("${value.message}"),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        isApiCallProcess = false;
      });
      rethrow;
    }
  }

  Future getFlightsMulticityListmethod(var data) async {
    print(json.encode(data.toJson()));
    var sendingdata = json.encode(data.toJson());
    print("Get country from : ${SharedPrefServices.getcountryFrom()}");
    print("Get country to : ${SharedPrefServices.getcountryTo()}");

    if (SharedPrefServices.getcountryFrom() == "India" &&
        SharedPrefServices.getcountryTo() == "India") {
      print("now trigger domestic");
      try {
        APIService apiService = APIService();
        apiService
            .matchingDomesticFlightRoundtripList(sendingdata)
            .then((value) async {
          inspect(value.statusCode);
          print('Payload data');
          print(sendingdata);
          print("StatusCode ${value.statusCode} ");
          if (value.statusCode == 203) {
            setState(() {
              isApiCallProcess = false;
            });
            const invalidsnackbar = SnackBar(
              content: Text('Data not Found. try again'),
            );
            ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);

            // print(value.data);
          } else if (value.statusCode == 200 || value.statusCode == 201) {
            setState(() {
              isApiCallProcess = false;
            });

            // showToast('Data found successfully.');
            if (value.data!.flightDetails!.isEmpty) {
              const invalidsnackbar = SnackBar(
                content: Text('No Flights available. try again'),
              );
              ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
            } else if (value.data!.flightDetails!.isNotEmpty) {
              print('Round Trip Testing');
              print(value.data!.flightDetails!);
              inspect(value.data!.flightDetails!);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return FetchedDomesticMulticityFlights(
                      // adultPublishFare: value.data!.flightDetails![0].fareFamilies!.fareFamilies![0].adultPublishFare!.toStringAsFixed(2).toString(),
                      filterData: value.data!.filtersObj,

                      originalData: value.data!.flightDetails!,
                      returnFlightDetails: value.data!.ibFlightDetails,
                      traceId: value.data!.traceId!,
                      // fulldata: value.data!.flightDetails,
                      noOfFlights: value.data!.flightDetails!.length,
                      adultcount: adultcount,
                      childcount: children,
                      infantcount: infants,
                    );
                  },
                ),
              );
            }
          } else if (value.statusCode == 404) {
            setState(() {
              isApiCallProcess = false;
            });

            showToast('Data NOT found');
          } else {
            setState(() {
              isApiCallProcess = false;
            });
            final snackbar = SnackBar(
              content: Text("${value.message}"),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        });
      } catch (e) {
        print(e);
        setState(() {
          isApiCallProcess = false;
        });
        rethrow;
      }
    } else {
      try {
        APIService apiService = APIService();
        apiService.matchingFlightRoundtripList(sendingdata).then((value) async {
          inspect(value.statusCode);
          print("StatusCode ${value.statusCode} ");
          if (value.statusCode == 203) {
            setState(() {
              isApiCallProcess = false;
            });
            const invalidsnackbar = SnackBar(
              content: Text('Data not Found. try again'),
            );
            ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);

            // print(value.data);
          } else if (value.statusCode == 200 || value.statusCode == 201) {
            setState(() {
              isApiCallProcess = false;
            });

            // showToast('Data found successfully.');
            if (value.data!.flightDetails!.isEmpty) {
              const invalidsnackbar = SnackBar(
                content: Text('No Flights available. try again'),
              );
              ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
            } else if (value
                .data!.flightDetails![0].flightDetails!.isNotEmpty) {
              print(value.data!.flightDetails![0].flightDetails!);
              inspect(value.data!.flightDetails![0].flightDetails!);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return FetchedMulticityFlights(
                      // adultPublishFare: value.data!.flightDetails![0].fareFamilies!.fareFamilies![0].adultPublishFare!.toStringAsFixed(2).toString(),
                      filterData: value.data!.filtersObj,

                      originalData: value.data!.flightDetails!,
                      traceId: value.data!.traceId!,
                      fulldata: value.data!.flightDetails![0].flightDetails,
                      noOfFlights:
                          value.data!.flightDetails![0].flightDetails!.length,
                      adultcount: adultcount,
                      childcount: children,
                      infantcount: infants,
                    );
                  },
                ),
              );
            }
          } else if (value.statusCode == 404) {
            setState(() {
              isApiCallProcess = false;
            });

            showToast('Data NOT found');
          } else {
            setState(() {
              isApiCallProcess = false;
            });
            final snackbar = SnackBar(
              content: Text("${value.message}"),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        });
      } catch (e) {
        print(e);
        setState(() {
          isApiCallProcess = false;
        });
        rethrow;
      }
    }
  }
}
