import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/flights/models/flights_list_model.dart';
import 'package:outc/dashboard/flights/screens/book_flight_formpage.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/app_top_bar.dart';
import 'package:outc/core/widgets/bottom_sheet_shell.dart';
import 'package:outc/dashboard/flights/widgets/ticketdesign.dart';

import 'package:outc/widgets/components/components.dart';
import 'package:outc/widgets/components/dialogtabsview.dart';
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

  @override
  void initState() {
    super.initState();

    updateData();
    final bounds = _priceBounds();
    _currentRangeValues = RangeValues(bounds.$1, bounds.$2);
    fillConnectingLocationList();
    fillAirLinesList();
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
      appBar: AppTopBar(
        title: 'Flight Results',
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: _hasActiveFilters ? Theme.of(context).colorScheme.primary : null),
            onPressed: () => _showFiltersSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                        itemCount: flightsdata!.length,
                        itemBuilder: (context, index) {
                          // double amt = flightsdata![index]
                          //         .fareFamilies!
                          //         .fareFamilies![0]
                          //         .adultPublishFare! *
                          //     double.parse(
                          //         SharedPrefServices.getcurrencyAmount()
                          //             .toString());

                          double amt = flightsdata![index]
                                  .fareFamilies!
                                  .fareFamilies![0]
                                  .totalPublishFare! *
                              double.parse(
                                  SharedPrefServices.getcurrencyAmount()
                                      .toString());
                          return TicketDesign(
                            width: double.infinity,
                            // height: 350,
                            isCornerRounded: true,
                            color: Colors.grey.shade300,
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade100),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Image(
                                                  //   image: NetworkImage(
                                                  //     widget.dataFlightDetails![index]
                                                  // .flightDetails![0]
                                                  //         .airLineLogo!,
                                                  //   ),
                                                  //   fit: BoxFit.fill,
                                                  //   height: 30.0,
                                                  //   width: 30.0,
                                                  // ),

                                                  Text(
                                                    "${flightsdata![index].airLineName} (${flightsdata![index].airLine}-${flightsdata![index].flightSegments![0].flightNumber})",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: AppColors.primary,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    flightsdata![index]
                                                                .flightSegments!
                                                                .length ==
                                                            1
                                                        ? "Direct"
                                                        : "${flightsdata![index].flightSegments!.length - 1} Stop",
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Class: Economy",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // works below
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.flight_takeoff,
                                                size: 30,
                                                color: AppColors.primary,
                                              ),
                                              Text(
                                                flightsdata![index]
                                                            .isRefundable ==
                                                        true
                                                    ? "Refundable"
                                                    : "Non Refundable",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: flightsdata![index]
                                                              .isRefundable ==
                                                          true
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              Icon(
                                                Icons.flight_land,
                                                size: 30,
                                                color: AppColors.primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                flightsdata![index]
                                                    .originCity
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: Divider(
                                                  color: AppColors.primary,
                                                  thickness: 3,
                                                ),
                                              ),
                                              Text(
                                                flightsdata![index]
                                                    .destinationCity
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                DateFormat('HH:mm').format(
                                                    flightsdata![index]
                                                            .flightSegments![0]
                                                            .departureDateTime ??
                                                        DateTime.now()),
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              Text(
                                                "${flightsdata![index].duration}",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              Text(
                                                DateFormat('HH:mm').format(
                                                    flightsdata![index]
                                                            .flightSegments![0]
                                                            .arrivalDateTime ??
                                                        DateTime.now()),
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // working above.....

                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Wrap(
                                                      // height: 150,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text(
                                                              "Baggage Details",
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: AppColors
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors
                                                              .grey.shade400,
                                                          thickness: 1.0,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .flight_takeoff,
                                                                      color: AppColors
                                                                          .primary,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "${flightsdata![index].origin} - ${flightsdata![index].destination}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: AppColors
                                                                        .primary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${flightsdata![index].airLineName} - ${flightsdata![index].airLine}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: AppColors
                                                                        .textSecondary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .luggage_outlined,
                                                                  color: AppColors
                                                                      .secondary,
                                                                ),
                                                                Text(
                                                                  "${flightsdata![index].flightSegments![0].checkInBaggage} CheckedIn Baggage",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: AppColors
                                                                        .secondary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .luggage_outlined,
                                                                  color: AppColors
                                                                      .secondary,
                                                                ),
                                                                Text(
                                                                  flightsdata![
                                                                              index]
                                                                          .flightSegments![
                                                                              0]
                                                                          .cabinBaggage!
                                                                          .isEmpty
                                                                      ? "7 kgs Cabin Baggage"
                                                                      : "${flightsdata![index].flightSegments![0].cabinBaggage} Cabin Baggage",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: AppColors
                                                                        .secondary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              thickness: 1.0,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Card(
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: AppColors.textSecondary,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Baggage",
                                                    style: textStyleHeading(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return TabviewDialog(
                                                  flightsdata: flightsdata!,
                                                  index: index,
                                                );
                                              },
                                            );
                                          },
                                          child: Card(
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: AppColors.textSecondary,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "flight details",
                                                    style: textStyleHeading(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                      margin: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        bottom: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  SharedPrefServices
                                                          .getcurrencycode()
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'poppins',
                                                  )),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(amt.toStringAsFixed(2),
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'poppins',
                                                  )),
                                            ],
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                adultfare = flightsdata![index]
                                                    .fareFamilies!
                                                    .fareFamilies![0]
                                                    .adultFare;
                                                adulttaxfare = double.parse(
                                                    flightsdata![index]
                                                        .fareFamilies!
                                                        .fareFamilies![0]
                                                        .markup
                                                        .toString());

                                                childfare = double.parse(
                                                    flightsdata![index]
                                                        .fareFamilies!
                                                        .fareFamilies![0]
                                                        .childNetFare
                                                        .toString());
                                                childtaxfare = 0;
                                                infantfare = double.parse(
                                                    flightsdata![index]
                                                        .fareFamilies!
                                                        .fareFamilies![0]
                                                        .infantNetFare
                                                        .toString());
                                                infanttaxfare = 0;
                                                print(widget.traceId);

                                                print('Print Fare Id one way');

                                                print(flightsdata![index]
                                                    .fareFamilies!
                                                    .fareFamilies![0]
                                                    .fareId
                                                    .toString());

                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      // airlineLogo,

                                                      return BookFlightFormpage(
                                                          traceId: widget
                                                              .traceId,
                                                          flightId: flightsdata![index]
                                                              .flightId
                                                              .toString(),
                                                          fareId: flightsdata![index]
                                                              .fareFamilies!
                                                              .fareFamilies![0]
                                                              .fareId
                                                              .toString(),
                                                          airlineLogo:
                                                              flightsdata![index]
                                                                  .airLineLogo!,
                                                          airlineName:
                                                              "${flightsdata![index].airLineName} (${flightsdata![index].airLine}-${flightsdata![index].flightSegments![0].flightNumber})",
                                                          airlineStop: flightsdata![index]
                                                                      .flightSegments!
                                                                      .length ==
                                                                  1
                                                              ? "Direct"
                                                              : "${flightsdata![index].flightSegments!.length - 1} Stop",
                                                          airlineClass:
                                                              "Economy",
                                                          airlineRefund: flightsdata![index].isRefundable == true
                                                              ? "Refundable"
                                                              : "Non Refundable",
                                                          airlineStart:
                                                              flightsdata![index]
                                                                  .originCity
                                                                  .toString(),
                                                          airlineEnd:
                                                              flightsdata![index]
                                                                  .destinationCity
                                                                  .toString(),
                                                          airlineStartTime: DateFormat('HH:mm').format(flightsdata![index]
                                                                  .flightSegments![0]
                                                                  .departureDateTime ??
                                                              DateTime.now()),
                                                          airlineEndTime: DateFormat('HH:mm').format(flightsdata![index].flightSegments![0].arrivalDateTime ?? DateTime.now()),
                                                          airlineDuration: flightsdata![index].duration.toString(),
                                                          adultBasefare: amt,
                                                          adulttaxfare: adulttaxfare ?? 0,
                                                          childBasefare: childfare ?? 0,
                                                          childtaxfare: childtaxfare ?? 0,
                                                          infantBasefare: infantfare ?? 0,
                                                          infanttaxfare: infanttaxfare ?? 0,
                                                          adultCount: widget.adultcount.toDouble(),
                                                          childCount: widget.childcount.toDouble(),
                                                          infantCount: widget.infantcount.toDouble());
                                                    },
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                              child: Text("Book Now",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  )))
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          );
                        }),
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

  /// Whether any customer-chosen filter is currently narrowing the result
  /// set — drives the funnel icon's tint so it's obvious filters are active
  /// without opening the sheet.
  bool get _hasActiveFilters =>
      directStop ||
      oneStop ||
      depOne ||
      depTwo ||
      depThree ||
      depFour ||
      arvlOne ||
      arvlTwo ||
      arvlThree ||
      arvlFour ||
      refund ||
      nonrefund ||
      _connectingLocationcheckboxList.any((f) => f.isChecked) ||
      _airLinescheckboxList.any((f) => f.isChecked);

  Duration _journeyDuration(FlightDetail flight) {
    final segments = flight.flightSegments ?? const [];
    if (segments.isEmpty) return Duration.zero;
    final departure = segments.first.departureDateTime;
    final arrival = segments.last.arrivalDateTime;
    if (departure == null || arrival == null) return Duration.zero;
    return arrival.difference(departure);
  }

  /// Rebuilds `flightsdata` from `widget.originalData` against every active
  /// filter as one combined (AND'd) predicate, then applies the chosen
  /// sort. Previously each filter category re-derived `flightsdata` from
  /// `originalData` independently and overwrote the previous category's
  /// result — so only the *last* active filter ever actually applied
  /// instead of all of them narrowing the list together. This also adds
  /// sorting, which didn't exist before.
  updateFilterData() {
    setState(() {
      bool isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
        return (time.hour > start.hour ||
                (time.hour == start.hour && time.minute >= start.minute)) &&
            (time.hour < end.hour ||
                (time.hour == end.hour && time.minute <= end.minute));
      }

      bool inSelectedBuckets(DateTime? time, bool b1, bool b2, bool b3, bool b4) {
        if (time == null) return true;
        if (!(b1 || b2 || b3 || b4)) return true;
        final t = TimeOfDay(hour: time.hour, minute: time.minute);
        return (b1 && isTimeInRange(const TimeOfDay(hour: 0, minute: 0), t, const TimeOfDay(hour: 6, minute: 0))) ||
            (b2 && isTimeInRange(const TimeOfDay(hour: 6, minute: 0), t, const TimeOfDay(hour: 12, minute: 0))) ||
            (b3 && isTimeInRange(const TimeOfDay(hour: 12, minute: 0), t, const TimeOfDay(hour: 18, minute: 0))) ||
            (b4 && isTimeInRange(const TimeOfDay(hour: 18, minute: 0), t, const TimeOfDay(hour: 23, minute: 59)));
      }

      final currency = double.tryParse(SharedPrefServices.getcurrencyAmount().toString()) ?? 1;
      final selectedConnectingLocations =
          _connectingLocationcheckboxList.where((f) => f.isChecked).map((f) => f.title).toSet();
      final selectedAirlines = _airLinescheckboxList.where((f) => f.isChecked).map((f) => f.title).toSet();

      flightsdata = (widget.originalData ?? const <FlightDetail>[]).where((flight) {
        final fare = flight.fareFamilies!.fareFamilies![0].adultPublishFare! * currency;
        if (fare < _currentRangeValues.start || fare > _currentRangeValues.end) return false;

        if (directStop && flight.flightSegments!.length != 1) return false;
        if (oneStop && flight.flightSegments!.length != 2) return false;

        if (!inSelectedBuckets(
            flight.flightSegments?[0].departureDateTime, depOne, depTwo, depThree, depFour)) {
          return false;
        }
        if (!inSelectedBuckets(
            flight.flightSegments?[0].arrivalDateTime, arvlOne, arvlTwo, arvlThree, arvlFour)) {
          return false;
        }

        if (refund && flight.isRefundable != true) return false;
        if (nonrefund && flight.isRefundable != false) return false;

        if (selectedConnectingLocations.isNotEmpty &&
            !selectedConnectingLocations.contains(flight.flightSegments?[0].destinationName)) {
          return false;
        }
        if (selectedAirlines.isNotEmpty && !selectedAirlines.contains(flight.airLineName)) {
          return false;
        }

        return true;
      }).toList();

      final sortOption = _sortOption;
      if (sortOption != null) {
        flightsdata!.sort((a, b) {
          switch (sortOption) {
            case FlightSortOption.priceLowToHigh:
              return a.fareFamilies!.fareFamilies![0].adultPublishFare!
                  .compareTo(b.fareFamilies!.fareFamilies![0].adultPublishFare!);
            case FlightSortOption.priceHighToLow:
              return b.fareFamilies!.fareFamilies![0].adultPublishFare!
                  .compareTo(a.fareFamilies!.fareFamilies![0].adultPublishFare!);
            case FlightSortOption.durationShortest:
              return _journeyDuration(a).compareTo(_journeyDuration(b));
            case FlightSortOption.departureEarliest:
              final aDep = a.flightSegments?[0].departureDateTime;
              final bDep = b.flightSegments?[0].departureDateTime;
              if (aDep == null || bDep == null) return 0;
              return aDep.compareTo(bDep);
          }
        });
      }
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

  /// Main "Filters" bottom sheet — a row per filter group, each drilling
  /// into its own sheet, mirroring the pattern already shipped for bus
  /// (`BusFilterSheets`/spec 0007) via the shared `BottomSheetShell`. This
  /// replaces the old always-inline, unstyled green filter panel.
  void _showFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BottomSheetShell(
        title: 'Filters',
        primaryActionLabel: 'Done',
        onPrimaryAction: () => Navigator.of(sheetContext).pop(),
        secondaryActionLabel: 'Clear All',
        onSecondaryAction: () {
          setState(() {
            directStop = oneStop = depOne = depTwo = depThree = depFour =
                arvlOne = arvlTwo = arvlThree = arvlFour = refund = nonrefund = false;
            turnOffLocations();
            _sortOption = null;
            final bounds = _priceBounds();
            _currentRangeValues = RangeValues(bounds.$1, bounds.$2);
          });
          updateFilterData();
          Navigator.of(sheetContext).pop();
        },
        primaryActionColor: Theme.of(context).colorScheme.primary,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterRow(label: 'Sort By', onTap: () => _showSortBySheet(context)),
            _FilterRow(label: 'Price Range', onTap: () => _showPriceRangeSheet(context)),
            _FilterRow(label: 'Stops', onTap: () => _showStopsSheet(context)),
            _FilterRow(label: 'Departure Time', onTap: () => _showDepartureTimeSheet(context)),
            _FilterRow(label: 'Arrival Time', onTap: () => _showArrivalTimeSheet(context)),
            _FilterRow(label: 'Airlines', onTap: () => _showAirlinesSheet(context)),
            if (widget.filterData?.connect?.isNotEmpty ?? false)
              _FilterRow(label: 'Connecting Locations', onTap: () => _showConnectingLocationsSheet(context)),
            _FilterRow(label: 'Refundable', onTap: () => _showRefundableSheet(context)),
          ],
        ),
      ),
    );
  }

  void _showSortBySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SortBySheet(
        selected: _sortOption,
        onApply: (option) {
          setState(() => _sortOption = option);
          updateFilterData();
        },
      ),
    );
  }

  void _showPriceRangeSheet(BuildContext context) {
    final bounds = _priceBounds();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PriceRangeSheet(
        min: bounds.$1,
        max: bounds.$2,
        current: _currentRangeValues,
        onApply: (range) {
          setState(() => _currentRangeValues = range);
          updateFilterData();
        },
        onClear: () {
          setState(() => _currentRangeValues = RangeValues(bounds.$1, bounds.$2));
          updateFilterData();
        },
      ),
    );
  }

  void _showStopsSheet(BuildContext context) {
    final options = [
      if (_hasStopFilter('Direct')) _ToggleOption(label: 'Direct', icon: Icons.flight, selected: directStop),
      if (_hasStopFilter('1 Stop (s)'))
        _ToggleOption(label: '1 Stop (s)', icon: Icons.flight_land, selected: oneStop),
    ];
    _showToggleSheet(context, title: 'Stops', options: options, onApply: (result) {
      setState(() {
        directStop = result.any((o) => o.label == 'Direct' && o.selected);
        oneStop = result.any((o) => o.label == '1 Stop (s)' && o.selected);
      });
      updateFilterData();
    }, onClear: () {
      setState(() => directStop = oneStop = false);
      updateFilterData();
    });
  }

  void _showDepartureTimeSheet(BuildContext context) {
    _showTimeBucketSheet(
      context,
      title: 'Departure Time',
      selected: (depOne, depTwo, depThree, depFour),
      onApply: (b1, b2, b3, b4) {
        setState(() {
          depOne = b1;
          depTwo = b2;
          depThree = b3;
          depFour = b4;
        });
        updateFilterData();
      },
      onClear: () {
        setState(() => depOne = depTwo = depThree = depFour = false);
        updateFilterData();
      },
    );
  }

  void _showArrivalTimeSheet(BuildContext context) {
    _showTimeBucketSheet(
      context,
      title: 'Arrival Time',
      selected: (arvlOne, arvlTwo, arvlThree, arvlFour),
      onApply: (b1, b2, b3, b4) {
        setState(() {
          arvlOne = b1;
          arvlTwo = b2;
          arvlThree = b3;
          arvlFour = b4;
        });
        updateFilterData();
      },
      onClear: () {
        setState(() => arvlOne = arvlTwo = arvlThree = arvlFour = false);
        updateFilterData();
      },
    );
  }

  void _showTimeBucketSheet(
    BuildContext context, {
    required String title,
    required (bool, bool, bool, bool) selected,
    required void Function(bool, bool, bool, bool) onApply,
    required VoidCallback onClear,
  }) {
    final options = [
      _ToggleOption(label: '00-06', icon: Icons.bedtime_outlined, selected: selected.$1),
      _ToggleOption(label: '06-12', icon: Icons.wb_sunny_outlined, selected: selected.$2),
      _ToggleOption(label: '12-18', icon: Icons.light_mode_outlined, selected: selected.$3),
      _ToggleOption(label: '18-23', icon: Icons.nights_stay_outlined, selected: selected.$4),
    ];
    _showToggleSheet(context, title: title, options: options, onApply: (result) {
      onApply(result[0].selected, result[1].selected, result[2].selected, result[3].selected);
    }, onClear: onClear);
  }

  void _showRefundableSheet(BuildContext context) {
    final options = [
      _ToggleOption(label: 'Refundable', icon: Icons.check_circle_outline, selected: refund),
      _ToggleOption(label: 'Non Refundable', icon: Icons.block, selected: nonrefund),
    ];
    _showToggleSheet(context, title: 'Refundable', options: options, singleSelect: true, onApply: (result) {
      setState(() {
        refund = result.any((o) => o.label == 'Refundable' && o.selected);
        nonrefund = result.any((o) => o.label == 'Non Refundable' && o.selected);
      });
      updateFilterData();
    }, onClear: () {
      setState(() => refund = nonrefund = false);
      updateFilterData();
    });
  }

  void _showConnectingLocationsSheet(BuildContext context) {
    final options = [
      for (final loc in _connectingLocationcheckboxList)
        _ToggleOption(label: loc.title, icon: Icons.location_on_outlined, selected: loc.isChecked),
    ];
    _showToggleSheet(context, title: 'Connecting Locations', options: options, onApply: (result) {
      setState(() {
        for (var i = 0; i < _connectingLocationcheckboxList.length; i++) {
          _connectingLocationcheckboxList[i].isChecked = result[i].selected;
        }
      });
      updateFilterData();
    }, onClear: () {
      setState(() {
        for (final loc in _connectingLocationcheckboxList) {
          loc.isChecked = false;
        }
      });
      updateFilterData();
    });
  }

  void _showAirlinesSheet(BuildContext context) {
    final options = [
      for (final airline in _airLinescheckboxList)
        _ToggleOption(label: airline.title, icon: Icons.flight_outlined, selected: airline.isChecked),
    ];
    _showToggleSheet(context, title: 'Airlines', options: options, onApply: (result) {
      setState(() {
        for (var i = 0; i < _airLinescheckboxList.length; i++) {
          _airLinescheckboxList[i].isChecked = result[i].selected;
        }
      });
      updateFilterData();
    }, onClear: () {
      setState(() {
        for (final airline in _airLinescheckboxList) {
          airline.isChecked = false;
        }
      });
      updateFilterData();
    });
  }

  void _showToggleSheet(
    BuildContext context, {
    required String title,
    required List<_ToggleOption> options,
    required ValueChanged<List<_ToggleOption>> onApply,
    required VoidCallback onClear,
    bool singleSelect = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ToggleFilterSheet(
        title: title,
        options: options,
        singleSelect: singleSelect,
        onApply: onApply,
        onClear: onClear,
      ),
    );
  }
}

// Model class for the ConnectingLocations checkbox item
class ConnectingLocationsCheckboxModel {
  String title;
  bool isChecked;

  ConnectingLocationsCheckboxModel(
      {required this.title, this.isChecked = false});
}

// Model class for the Airlines checkbox item
class AirlinesCheckboxModel {
  String title;
  bool isChecked;

  AirlinesCheckboxModel({required this.title, this.isChecked = false});
}

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

  IconData get icon => switch (this) {
        FlightSortOption.priceLowToHigh => Icons.arrow_upward,
        FlightSortOption.priceHighToLow => Icons.arrow_downward,
        FlightSortOption.durationShortest => Icons.timelapse,
        FlightSortOption.departureEarliest => Icons.schedule,
      };
}

/// A row in the main "Filters" sheet that drills into its own sub-sheet —
/// same shape as bus's `_AllFiltersRow` (`bus_filter_sheets.dart`).
class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }
}

class _ToggleOption {
  _ToggleOption({required this.label, this.icon, required this.selected});
  final String label;
  final IconData? icon;
  bool selected;
}

/// Generic multi-select (or, with [singleSelect], radio-style) sheet reused
/// for Stops, Departure/Arrival Time, Refundable, Connecting Locations, and
/// Airlines — the six filter groups that all boil down to "toggle a few
/// named options on or off". Mirrors bus's `_CheckboxSheetContent`.
class _ToggleFilterSheet extends StatefulWidget {
  const _ToggleFilterSheet({
    required this.title,
    required this.options,
    required this.onApply,
    required this.onClear,
    this.singleSelect = false,
  });

  final String title;
  final List<_ToggleOption> options;
  final ValueChanged<List<_ToggleOption>> onApply;
  final VoidCallback onClear;
  final bool singleSelect;

  @override
  State<_ToggleFilterSheet> createState() => _ToggleFilterSheetState();
}

class _ToggleFilterSheetState extends State<_ToggleFilterSheet> {
  late final List<_ToggleOption> _options = [
    for (final option in widget.options)
      _ToggleOption(label: option.label, icon: option.icon, selected: option.selected),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: widget.title,
      primaryActionLabel: 'Apply',
      primaryActionColor: Theme.of(context).colorScheme.primary,
      onPrimaryAction: () {
        widget.onApply(_options);
        Navigator.of(context).pop();
      },
      secondaryActionLabel: 'Clear',
      onSecondaryAction: () {
        widget.onClear();
        Navigator.of(context).pop();
      },
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in _options)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: option.selected,
              secondary:
                  option.icon != null ? Icon(option.icon, color: Theme.of(context).colorScheme.primary) : null,
              title: Text(option.label),
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (checked) {
                setState(() {
                  if (widget.singleSelect && (checked ?? false)) {
                    for (final other in _options) {
                      other.selected = false;
                    }
                  }
                  option.selected = checked ?? false;
                });
              },
            ),
          if (_options.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text('No options available', style: TextStyle(color: Colors.grey.shade600)),
            ),
        ],
      ),
    );
  }
}

class _SortBySheet extends StatefulWidget {
  const _SortBySheet({required this.selected, required this.onApply});
  final FlightSortOption? selected;
  final ValueChanged<FlightSortOption?> onApply;

  @override
  State<_SortBySheet> createState() => _SortBySheetState();
}

class _SortBySheetState extends State<_SortBySheet> {
  late FlightSortOption? _selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: 'Sort By',
      primaryActionLabel: 'Apply',
      primaryActionColor: Theme.of(context).colorScheme.primary,
      onPrimaryAction: () {
        widget.onApply(_selected);
        Navigator.of(context).pop();
      },
      secondaryActionLabel: 'Clear',
      onSecondaryAction: () {
        widget.onApply(null);
        Navigator.of(context).pop();
      },
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in FlightSortOption.values)
            RadioListTile<FlightSortOption>(
              contentPadding: EdgeInsets.zero,
              value: option,
              groupValue: _selected,
              activeColor: Theme.of(context).colorScheme.primary,
              secondary: Icon(option.icon, color: Theme.of(context).colorScheme.primary),
              title: Text(option.label),
              onChanged: (value) => setState(() => _selected = value),
            ),
        ],
      ),
    );
  }
}

class _PriceRangeSheet extends StatefulWidget {
  const _PriceRangeSheet({
    required this.min,
    required this.max,
    required this.current,
    required this.onApply,
    required this.onClear,
  });

  final double min;
  final double max;
  final RangeValues current;
  final ValueChanged<RangeValues> onApply;
  final VoidCallback onClear;

  @override
  State<_PriceRangeSheet> createState() => _PriceRangeSheetState();
}

class _PriceRangeSheetState extends State<_PriceRangeSheet> {
  late RangeValues _range = widget.current;

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: 'Price Range',
      primaryActionLabel: 'Apply',
      primaryActionColor: Theme.of(context).colorScheme.primary,
      onPrimaryAction: () {
        widget.onApply(_range);
        Navigator.of(context).pop();
      },
      secondaryActionLabel: 'Clear',
      onSecondaryAction: () {
        widget.onClear();
        Navigator.of(context).pop();
      },
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'INR ${_range.start.toStringAsFixed(0)} - INR ${_range.end.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          RangeSlider(
            values: _range,
            min: widget.min,
            max: widget.max,
            activeColor: Theme.of(context).colorScheme.primary,
            labels: RangeLabels(
              'INR ${_range.start.toStringAsFixed(0)}',
              'INR ${_range.end.toStringAsFixed(0)}',
            ),
            onChanged: (values) => setState(() => _range = values),
          ),
        ],
      ),
    );
  }
}
