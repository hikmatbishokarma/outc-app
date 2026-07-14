import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/flights/models/flights_list_model.dart';
import 'package:outc/dashboard/flights/screens/book_flight_formpage.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';
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

  bool filterIcon = false;
  String filterName = '';
  RangeValues _currentRangeValues = const RangeValues(0, 0);
  double _startValue = 0;
  double _endValue = 0;
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

  // List of checkbox models
  List<ConnectingLocationsCheckboxModel> _connectingLocationcheckboxList = [];
  List<AirlinesCheckboxModel> _airLinescheckboxList = [];

  @override
  void initState() {
    super.initState();

    updateData();
    _currentRangeValues = RangeValues(
        double.parse(widget.filterData!.price!.minPrice.toString()),
        double.parse(widget.filterData!.price!.maxPrice.toString()));
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

    _startValue = double.parse(widget.filterData!.price!.minPrice.toString());
    _endValue = double.parse(widget.filterData!.price!.maxPrice.toString());

    RangeLabels labels = RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "AnjMal",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'poppins',
            color: Flights_Colours.strongRed,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              color: Flights_Colours.strongRed,
              icon: Icon(
                Icons.wallet,
                size: 28,
                color: Flights_Colours.strongRed,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        content: Container(
                          color: Colors.transparent,
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
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
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Flights_Colours.strongRed,
                                  fontFamily: 'Poppins',
                                  // fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          IconButton(
            color: Flights_Colours.strongRed,
            icon: const ImageIcon(
              AssetImage(
                "images/notifybell.png",
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Flights_Colours.veryDarkGrey,
                        // color: Colors.transparent,
                        size: 20,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  Text(
                    "Flights List OneWay",
                    // ${filteredList.length}",
                    style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16.0,
                        color: Flights_Colours.strongRed,
                        fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.filter_alt,
                        color: Flights_Colours.strongRed,
                        // color: Colors.transparent,
                        size: 20,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        filterIcon = true;
                      });
                    },
                  ),
                ],
              ),
            ),
            flightsdata!.isEmpty
                ? Center(
                    child: Text(
                      "No Flights Available",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Flights_Colours.strongRed,
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
                                          color: Flights_Colours.strongRed,
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
                                                      color: Flights_Colours
                                                          .strongRed,
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
                                                color:
                                                    Flights_Colours.strongRed,
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
                                                color:
                                                    Flights_Colours.strongRed,
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
                                                  color:
                                                      Flights_Colours.strongRed,
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
                                                                color: Flights_Colours
                                                                    .strongRed,
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
                                                                      color: Flights_Colours
                                                                          .strongRed,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "${flightsdata![index].origin} - ${flightsdata![index].destination}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Flights_Colours
                                                                        .strongRed,
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
                                                                    color: Flights_Colours
                                                                        .veryDarkGrey,
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
                                                                  color: Flights_Colours
                                                                      .dardModerateBlue,
                                                                ),
                                                                Text(
                                                                  "${flightsdata![index].flightSegments![0].checkInBaggage} CheckedIn Baggage",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Flights_Colours
                                                                        .dardModerateBlue,
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
                                                                  color: Flights_Colours
                                                                      .dardModerateBlue,
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
                                                                    color: Flights_Colours
                                                                        .dardModerateBlue,
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
                                                color: Flights_Colours
                                                    .veryDarkGrey,
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
                                                color: Flights_Colours
                                                    .veryDarkGrey,
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
                                                    color: Flights_Colours
                                                        .strongRed,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'poppins',
                                                  )),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(amt.toStringAsFixed(2),
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Flights_Colours
                                                        .strongRed,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'poppins',
                                                  )),
                                            ],
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
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
                                                      Flights_Colours.strongRed,
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
            filterIcon
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.green[100],
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.only(right: 15, left: 15),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                      color: Flights_Colours.strongRed)),
                              child: Container(
                                margin:
                                    const EdgeInsets.only(right: 15, left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Filters",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              directStop = oneStop = depOne =
                                                  depTwo = depThree = depFour =
                                                      arvlOne = arvlTwo =
                                                          arvlThree = arvlFour =
                                                              refund =
                                                                  nonrefund =
                                                                      false;
                                              turnOffLocations();

                                              _currentRangeValues = RangeValues(
                                                  double.parse(widget
                                                      .filterData!
                                                      .price!
                                                      .minPrice
                                                      .toString()),
                                                  double.parse(widget
                                                      .filterData!
                                                      .price!
                                                      .maxPrice
                                                      .toString()));
                                            });
                                          },
                                          child: Text(
                                            "Clear all",
                                            style: GoogleFonts.poppins(
                                                color: Flights_Colours
                                                    .dardModerateBlue,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: Flights_Colours.veryDarkGrey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Price Range",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _currentRangeValues = RangeValues(
                                                  double.parse(widget
                                                      .filterData!
                                                      .price!
                                                      .minPrice
                                                      .toString()),
                                                  double.parse(widget
                                                      .filterData!
                                                      .price!
                                                      .maxPrice
                                                      .toString()));
                                            });
                                          },
                                          child: Text(
                                            "Clear",
                                            style: GoogleFonts.poppins(
                                                color: Flights_Colours
                                                    .veryDarkGrey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${_currentRangeValues.start.toStringAsFixed(2)} INR',
                                          style: TextStyle(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          '${_currentRangeValues.end.toStringAsFixed(2)} INR',
                                          style: TextStyle(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    SliderTheme(
                                      data: SliderThemeData(
                                          rangeThumbShape:
                                              const RoundRangeSliderThumbShape(
                                                  enabledThumbRadius: 7),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                            overlayRadius: 5.0,
                                          ),
                                          trackHeight: 2,
                                          inactiveTrackColor:
                                              Flights_Colours.veryDarkGrey),
                                      child: RangeSlider(
                                        activeColor: Flights_Colours.strongRed,
                                        values: _currentRangeValues,
                                        divisions: 10,
                                        labels: labels,
                                        min: _startValue,
                                        max: _endValue,
                                        onChanged: (RangeValues values) {
                                          setState(() {
                                            _currentRangeValues = values;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: Flights_Colours.veryDarkGrey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Stops",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              directStop = oneStop = false;
                                            });
                                          },
                                          child: Text(
                                            "Clear",
                                            style: GoogleFonts.poppins(
                                                color: Flights_Colours
                                                    .veryDarkGrey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        widget.filterData!.stops![0].label ==
                                                "Direct"
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      directStop = !directStop;
                                                      // arrivalthree
                                                      //     ? arrivalthree = false
                                                      //     : arrivalthree = true;
                                                    });
                                                  },
                                                  child: Card(
                                                    color: directStop
                                                        ? Colors.blue
                                                        : Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              "Direct",
                                                              style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        widget.filterData!.stops![1].label ==
                                                "1 Stop (s)"
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      oneStop = !oneStop;
                                                      // arrivalthree
                                                      //     ? arrivalthree = false
                                                      //     : arrivalthree = true;
                                                    });
                                                  },
                                                  child: Card(
                                                    color: oneStop
                                                        ? Colors.blue
                                                        : Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              "1 Stop (s)",
                                                              style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: Flights_Colours.veryDarkGrey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Departure Time",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              depOne = depTwo =
                                                  depThree = depFour = false;
                                            });
                                          },
                                          child: Text(
                                            "Clear",
                                            style: GoogleFonts.poppins(
                                                color: Flights_Colours
                                                    .veryDarkGrey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                depOne = !depOne;
                                              });
                                            },
                                            child: Card(
                                              color: depOne
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 4,
                                                              right: 4),
                                                      child: Icon(
                                                        Icons.sunny,
                                                        color: Flights_Colours
                                                            .strongRed,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "00-06",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                depTwo = !depTwo;
                                              });
                                            },
                                            child: Card(
                                              color: depTwo
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 4,
                                                              right: 4),
                                                      child: Icon(
                                                        Icons.sunny,
                                                        color: Flights_Colours
                                                            .strongRed,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "06-12",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                depThree = !depThree;
                                              });
                                            },
                                            child: Card(
                                              color: depThree
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 4,
                                                              right: 4),
                                                      child: Icon(
                                                        Icons.sunny,
                                                        color: Flights_Colours
                                                            .strongRed,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "12-18",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                depFour = !depFour;
                                              });
                                            },
                                            child: Card(
                                              color: depFour
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 4,
                                                              right: 4),
                                                      child: Icon(
                                                        Icons.sunny,
                                                        color: Flights_Colours
                                                            .strongRed,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "18-23",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: Flights_Colours.veryDarkGrey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Arrival Time",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              arvlOne = arvlTwo =
                                                  arvlThree = arvlFour = false;
                                            });
                                          },
                                          child: Text(
                                            "Clear",
                                            style: GoogleFonts.poppins(
                                                color: Flights_Colours
                                                    .veryDarkGrey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                arvlOne = !arvlOne;
                                              });
                                            },
                                            child: Card(
                                              color: arvlOne
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 4,
                                                              right: 4),
                                                      child: Icon(
                                                        Icons.sunny,
                                                        color: Flights_Colours
                                                            .strongRed,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "00-06",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                arvlTwo = !arvlTwo;
                                              });
                                            },
                                            child: Card(
                                              color: arvlTwo
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 4,
                                                              right: 4),
                                                      child: Icon(
                                                        Icons.sunny,
                                                        color: Flights_Colours
                                                            .strongRed,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "06-12",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                arvlThree = !arvlThree;
                                              });
                                            },
                                            child: Card(
                                              color: arvlThree
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 4,
                                                              right: 4),
                                                      child: Icon(
                                                        Icons.sunny,
                                                        color: Flights_Colours
                                                            .strongRed,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "12-18",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                arvlFour = !arvlFour;
                                              });
                                            },
                                            child: Card(
                                              color: arvlFour
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 4,
                                                              right: 4),
                                                      child: Icon(
                                                        Icons.sunny,
                                                        color: Flights_Colours
                                                            .strongRed,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "18-23",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: Flights_Colours.veryDarkGrey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Fire Type",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              refund = nonrefund = false;
                                            });
                                          },
                                          child: Text(
                                            "Clear",
                                            style: GoogleFonts.poppins(
                                                color: Flights_Colours
                                                    .veryDarkGrey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                refund = !refund;
                                              });
                                            },
                                            child: Card(
                                              color: refund
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "Refundable",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                nonrefund = !nonrefund;
                                              });
                                            },
                                            child: Card(
                                              color: nonrefund
                                                  ? Colors.blue
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "Non Refundable",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: Flights_Colours.veryDarkGrey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Connecting Locations",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              // refund = nonrefund = false;
                                              for (var loc
                                                  in _connectingLocationcheckboxList) {
                                                loc.isChecked = false;
                                              }
                                            });
                                          },
                                          child: Text(
                                            "Clear",
                                            style: GoogleFonts.poppins(
                                                color: Flights_Colours
                                                    .veryDarkGrey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 32 *
                                          double.parse(widget
                                              .filterData!.connect!.length
                                              .toString()),
                                      child: ListView.builder(
                                          itemCount:
                                              _connectingLocationcheckboxList
                                                  .length,
                                          itemBuilder: (context, index) {
                                            return _buildCheckboxListTile(
                                                _connectingLocationcheckboxList[
                                                    index]);
                                          }),
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: Flights_Colours.veryDarkGrey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Air Lines",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours.strongRed,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              for (var airLine
                                                  in _airLinescheckboxList) {
                                                airLine.isChecked = false;
                                              }
                                            });
                                          },
                                          child: Text(
                                            "Clear",
                                            style: GoogleFonts.poppins(
                                                color: Flights_Colours
                                                    .veryDarkGrey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 32 *
                                          double.parse(widget
                                              .filterData!.airlines!.length
                                              .toString()),
                                      child: ListView.builder(
                                          itemCount:
                                              _airLinescheckboxList.length,
                                          itemBuilder: (context, index) {
                                            return _buildAirlinesCheckboxListTile(
                                                _airLinescheckboxList[index]);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade400,
                              thickness: 1.2,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: const EdgeInsets.only(right: 15),
                                height: 40,
                                width: 100,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        updateFilterData();
                                        filterIcon = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Flights_Colours.strongRed,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                    child: Text("Apply",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500))),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
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

  updateFilterData() {
    // hotelsData!.clear();
    setState(() {
      flightsdata = widget.originalData!.where((hotel) {
        return ((hotel.fareFamilies!.fareFamilies![0].adultPublishFare! *
                    double.parse(
                        SharedPrefServices.getcurrencyAmount().toString())) >=
                _currentRangeValues.start &&
            (hotel.fareFamilies!.fareFamilies![0].adultPublishFare! *
                    double.parse(
                        SharedPrefServices.getcurrencyAmount().toString())) <=
                _currentRangeValues.end);
      }).toList();

      if (directStop) {
        flightsdata = widget.originalData!.where((hotel) {
          return (hotel.flightSegments!.length == 1 &&
              (hotel.fareFamilies!.fareFamilies![0].adultPublishFare! *
                      double.parse(
                          SharedPrefServices.getcurrencyAmount().toString())) >=
                  _currentRangeValues.start &&
              (hotel.fareFamilies!.fareFamilies![0].adultPublishFare! *
                      double.parse(
                          SharedPrefServices.getcurrencyAmount().toString())) <=
                  _currentRangeValues.end);
        }).toList();
      }
      if (oneStop) {
        flightsdata = widget.originalData!.where((hotel) {
          return (hotel.flightSegments!.length == 2 &&
              (hotel.fareFamilies!.fareFamilies![0].adultPublishFare! *
                      double.parse(
                          SharedPrefServices.getcurrencyAmount().toString())) >=
                  _currentRangeValues.start &&
              (hotel.fareFamilies!.fareFamilies![0].adultPublishFare! *
                      double.parse(
                          SharedPrefServices.getcurrencyAmount().toString())) <=
                  _currentRangeValues.end);
        }).toList();
      }

      bool isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
        return (time.hour > start.hour ||
                (time.hour == start.hour && time.minute >= start.minute)) &&
            (time.hour < end.hour ||
                (time.hour == end.hour && time.minute <= end.minute));
      }

      if (depOne) {
        flightsdata = widget.originalData!.where((hotel) {
          return (isTimeInRange(
              const TimeOfDay(hour: 0, minute: 0),
              TimeOfDay(
                  hour: hotel.flightSegments![0].departureDateTime!.hour,
                  minute: hotel.flightSegments![0].departureDateTime!.minute),
              const TimeOfDay(hour: 6, minute: 0)));
        }).toList();
      }
      if (depTwo) {
        flightsdata = widget.originalData!.where((hotel) {
          return (isTimeInRange(
              const TimeOfDay(hour: 6, minute: 0),
              TimeOfDay(
                  hour: hotel.flightSegments![0].departureDateTime!.hour,
                  minute: hotel.flightSegments![0].departureDateTime!.minute),
              const TimeOfDay(hour: 12, minute: 0)));
        }).toList();
      }
      if (depThree) {
        flightsdata = widget.originalData!.where((hotel) {
          return (isTimeInRange(
              const TimeOfDay(hour: 12, minute: 0),
              TimeOfDay(
                  hour: hotel.flightSegments![0].departureDateTime!.hour,
                  minute: hotel.flightSegments![0].departureDateTime!.minute),
              const TimeOfDay(hour: 18, minute: 0)));
        }).toList();
      }
      if (depOne) {
        flightsdata = widget.originalData!.where((hotel) {
          return (isTimeInRange(
              const TimeOfDay(hour: 18, minute: 0),
              TimeOfDay(
                  hour: hotel.flightSegments![0].departureDateTime!.hour,
                  minute: hotel.flightSegments![0].departureDateTime!.minute),
              const TimeOfDay(hour: 23, minute: 59)));
        }).toList();
      }
      //arrival filters
      if (arvlOne) {
        flightsdata = widget.originalData!.where((hotel) {
          return (isTimeInRange(
              const TimeOfDay(hour: 0, minute: 0),
              TimeOfDay(
                  hour: hotel.flightSegments![0].arrivalDateTime!.hour,
                  minute: hotel.flightSegments![0].arrivalDateTime!.minute),
              const TimeOfDay(hour: 6, minute: 0)));
        }).toList();
      }
      if (arvlTwo) {
        flightsdata = widget.originalData!.where((hotel) {
          return (isTimeInRange(
              const TimeOfDay(hour: 6, minute: 0),
              TimeOfDay(
                  hour: hotel.flightSegments![0].arrivalDateTime!.hour,
                  minute: hotel.flightSegments![0].arrivalDateTime!.minute),
              const TimeOfDay(hour: 12, minute: 0)));
        }).toList();
      }
      if (arvlThree) {
        flightsdata = widget.originalData!.where((hotel) {
          return (isTimeInRange(
              const TimeOfDay(hour: 12, minute: 0),
              TimeOfDay(
                  hour: hotel.flightSegments![0].arrivalDateTime!.hour,
                  minute: hotel.flightSegments![0].arrivalDateTime!.minute),
              const TimeOfDay(hour: 18, minute: 0)));
        }).toList();
      }
      if (arvlFour) {
        flightsdata = widget.originalData!.where((hotel) {
          return (isTimeInRange(
              const TimeOfDay(hour: 18, minute: 0),
              TimeOfDay(
                  hour: hotel.flightSegments![0].arrivalDateTime!.hour,
                  minute: hotel.flightSegments![0].arrivalDateTime!.minute),
              const TimeOfDay(hour: 23, minute: 59)));
        }).toList();
      }
      if (refund) {
        flightsdata = widget.originalData!.where((hotel) {
          return (hotel.isRefundable == true);
        }).toList();
      }
      if (nonrefund) {
        flightsdata = widget.originalData!.where((hotel) {
          return (hotel.isRefundable == false);
        }).toList();
      }

      for (var filter in _connectingLocationcheckboxList) {
        if (filter.isChecked) {
          flightsdata = widget.originalData!.where((hotel) {
            print(hotel.flightSegments![0].destinationName == filter.title);
            return (hotel.flightSegments![0].destinationName == filter.title);
          }).toList();
        }
      }

      for (var filter in _airLinescheckboxList) {
        if (filter.isChecked) {
          flightsdata = widget.originalData!.where((hotel) {
            print(hotel.airLineName == filter.title);
            return (hotel.airLineName == filter.title);
          }).toList();
        }
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

  Widget _buildCheckboxListTile(
      ConnectingLocationsCheckboxModel connectingLocationcheckboxList) {
    return CheckboxListTile(
      activeColor: Colors.blue,
      title: Text(
        connectingLocationcheckboxList.title,
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
      ),
      value: connectingLocationcheckboxList.isChecked,
      onChanged: (bool? value) {
        setState(() {
          connectingLocationcheckboxList.isChecked = value ?? false;
        });
      },
    );
  }

  Widget _buildAirlinesCheckboxListTile(
      AirlinesCheckboxModel airlinesCheckboxModel) {
    return CheckboxListTile(
      activeColor: Colors.blue,
      title: Text(
        airlinesCheckboxModel.title,
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
      ),
      value: airlinesCheckboxModel.isChecked,
      onChanged: (bool? value) {
        setState(() {
          airlinesCheckboxModel.isChecked = value ?? false;
        });
      },
    );
  }

  turnOffLocations() {
    for (var loc in _connectingLocationcheckboxList) {
      loc.isChecked = false;
    }
    for (var airLine in _airLinescheckboxList) {
      airLine.isChecked = false;
    }
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
