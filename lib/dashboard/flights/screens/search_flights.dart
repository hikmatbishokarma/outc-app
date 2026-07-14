import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/dashboard/flights/models/flights_search_payloadmodel.dart';
import 'package:outc/dashboard/flights/screens/fetched_domestic_multicity_flights.dart';
import 'package:outc/dashboard/flights/screens/fetched_multicity_flights.dart';

import 'package:outc/dashboard/flights/screens/from_city_dropdown.dart';
import 'package:outc/dashboard/flights/screens/oneway_flight_list.dart';
import 'package:outc/dashboard/flights/screens/to_city_dropdown.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';
import 'package:outc/dashboard/flights/widgets/progressbar.dart';

import 'package:outc/services/api_services_list.dart';

import 'package:outc/widgets/components/toast.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class FlightsListPage extends StatefulWidget {
  const FlightsListPage({super.key});

  @override
  State<FlightsListPage> createState() => _FlightsListPageState();
}

class _FlightsListPageState extends State<FlightsListPage> {
  // var isSelected = "ecopri";
  var _selectedTrip = "ecopri";
  // final List _locations = topCities;
  // String? _selectedLocation;
  bool isApiCallProcess = false;

  // String SharedPrefServices.getselecedscroller().toString() = "oneWay";
  final itemKey = GlobalKey();
  DateTime raw_dep_date = DateTime.now();
  DateTime raw_arrival_date = DateTime.now();
  // String selecteddate = DateFormat.yMMMEd().format(DateTime.now());
  String depDateFormated = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String arrDateFormated = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // String selectedArraivaldate = DateFormat.yMMMEd().format(DateTime.now());
  String tripType = "Economy/Premium Economy";
  int adultcount = 1;
  int children = 0;
  int infants = 0;
  List dest = [];

  String whyAjmal1 =
      "Our competitive rates and exclusive offers are what gives us a top notch over our competitors. We promise 'Unbeatable' services both in pricing and quality. Here is the one stop destination for your Dream Destination. AnjMal provide you the best travel packages at the lowest possible pricing that gives the best value for your each penny. We are your Travel Companion and works for you so that can get the best travel experience and live some memorable moments.";

  String whyAjmal2 =
      "We give you the pros and cons for all the different travel products and allow you to decide what works best for you and your family. We combine first-hand knowledge with exceptional special offers, and we take care of every detail to create a holiday as unique as you are. You will no more need to worry about coordinating flight bookings, hotel reservations, visa stamps or tours as all your needs are taken care of under one roof.";

  String whyAjmal3 =
      "AnjMal can satisfy all your travel needs. Here, You can book flight tickets, hotels, bus tickets, activities and holiday packages at a cost-effective price. So, why go anywhere else? Visit us for a memorable travel experience in your budget.";

  @override
  Widget build(BuildContext context) {
    return Flight_ProgressBar(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: uiSetup(context),
    );
  }

  Widget uiSetup(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    int totalPassengers = adultcount + children + infants;
    if (_selectedTrip == "ecopri") {
      setState(() {
        tripType = "Economy/Premium Economy";
      });
    } else if (_selectedTrip == "eco") {
      setState(() {
        tripType = "Economy";
      });
    } else if (_selectedTrip == "firstclass") {
      setState(() {
        tripType = "First Class";
      });
    } else if (_selectedTrip == "businessclass") {
      setState(() {
        tripType = "Business Class";
      });
    }

    return Scaffold(
      key: scaffoldKey,
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
        leading: Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              color: Flights_Colours.strongRed,
              icon: Icon(
                Icons.home,
                size: 28,
                color: Flights_Colours.strongRed,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Dashboard();
                    },
                  ),
                );
              },
            )),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Colors.blue),
                  child: Container(
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Flights_Colours.veryDarkGrey,
                                  size: 20,
                                ),
                                onTap: () {
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) {
                                  //       return const HomePage();
                                  //     },
                                  //   ),
                                  // );
                                  Navigator.pop(context);
                                },
                              ),
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  child: Text(
                                    "Find Next Place To Visit",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.more_vert,
                                color: Colors.transparent,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                key: SharedPrefServices.getselecedscroller()
                                            .toString() ==
                                        "oneWay"
                                    ? itemKey
                                    : null,
                                onPressed: () async {
                                  setState(() {
                                    SharedPrefServices.setselecedscroller(
                                        "oneWay");
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          width: 1.0,
                                          color: SharedPrefServices
                                                          .getselecedscroller()
                                                      .toString() ==
                                                  "oneWay"
                                              ? Flights_Colours.dardModerateBlue
                                              : Flights_Colours.strongRed,
                                        )),
                                    backgroundColor:
                                        SharedPrefServices.getselecedscroller()
                                                    .toString() ==
                                                "oneWay"
                                            ? Flights_Colours.dardModerateBlue
                                            : Flights_Colours.strongRed,
                                    fixedSize: const Size(100, 40),
                                    textStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontFamily: 'Poppins-regular',
                                      fontWeight: FontWeight.w700,
                                    )),
                                child: const Text(
                                  'ONE WAY',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              ////

                              ElevatedButton(
                                key: SharedPrefServices.getselecedscroller()
                                            .toString() ==
                                        "roundTrip"
                                    ? itemKey
                                    : null,
                                onPressed: () async {
                                  setState(() {
                                    SharedPrefServices.setselecedscroller(
                                        "roundTrip");
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          width: 1.0,
                                          // color: Color(0xffFF6700),
                                          color: SharedPrefServices
                                                          .getselecedscroller()
                                                      .toString() ==
                                                  "roundTrip"
                                              ? Flights_Colours.dardModerateBlue
                                              : Flights_Colours.strongRed,
                                        )),
                                    backgroundColor:
                                        SharedPrefServices.getselecedscroller()
                                                    .toString() ==
                                                "roundTrip"
                                            ? Flights_Colours.dardModerateBlue
                                            : Flights_Colours.strongRed,
                                    fixedSize: const Size(100, 40),
                                    textStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontFamily: 'Poppins-regular',
                                      fontWeight: FontWeight.w700,
                                    )),
                                child: const Text(
                                  'ROUNDTRIP',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                key: SharedPrefServices.getselecedscroller()
                                            .toString() ==
                                        "multidestination"
                                    ? itemKey
                                    : null,
                                onPressed: () async {
                                  setState(() {
                                    SharedPrefServices.setselecedscroller(
                                        "multidestination");
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          width: 1.0,
                                          color: SharedPrefServices
                                                          .getselecedscroller()
                                                      .toString() ==
                                                  "multidestination"
                                              ? Flights_Colours.dardModerateBlue
                                              : Flights_Colours.strongRed,
                                        )),
                                    backgroundColor:
                                        SharedPrefServices.getselecedscroller()
                                                    .toString() ==
                                                "multidestination"
                                            ? Flights_Colours.dardModerateBlue
                                            : Flights_Colours.strongRed,
                                    fixedSize: const Size(100, 40),
                                    textStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontFamily: 'Poppins-regular',
                                      fontWeight: FontWeight.w700,
                                    )),
                                child: const Text(
                                  'MULTI-CITY',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              //////////
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(clipBehavior: Clip.none, children: [
                          SharedPrefServices.getselecedscroller().toString() ==
                                  "multidestination"
                              ? Card(
                                  color: Colors.white,
                                  shadowColor: Colors.blue.shade50,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Column(children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.flight_takeoff,
                                              size: 30,
                                              color: Flights_Colours.strongRed,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                            context) {
                                                          return SelectCity(
                                                              type: "one");
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "FROM",
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Flights_Colours
                                                              .strongRed,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 32),
                                                            children: [
                                                              TextSpan(
                                                                text: SharedPrefServices
                                                                            .getcityFrom()!
                                                                        .isEmpty
                                                                    ? "Select City"
                                                                    : "${SharedPrefServices.getcityFrom()} ",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: SharedPrefServices
                                                                        .getairportcodeFrom()
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                      Text(
                                                        SharedPrefServices
                                                                .getcountryFrom()
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 10.0,
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // Divider(
                                        //   color: Colors.grey.shade400,
                                        //   thickness: 1.0,
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.flight_land,
                                              size: 30,
                                              color: Flights_Colours.strongRed,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return ToSelectCity(
                                                          type: "one");
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "TO",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 32),
                                                        children: [
                                                          TextSpan(
                                                            text: SharedPrefServices
                                                                        .getcityTo()!
                                                                    .isEmpty
                                                                ? "Select City"
                                                                : "${SharedPrefServices.getcityTo()} ",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: SharedPrefServices
                                                                    .getairportcodeTo()
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                  Text(
                                                    SharedPrefServices
                                                            .getcountryTo()
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 10.0,
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // Divider(
                                        //   color: Colors.grey.shade400,
                                        //   thickness: 1.0,
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        InkWell(
                                          onTap: () {
                                            buildDatePickerfordate();

                                            print("triggered");
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.calendar_today,
                                                size: 24,
                                                color:
                                                    Flights_Colours.strongRed,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "DEPARTURE DATE",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Text(
                                                    // selecteddate.toString(),
                                                    SharedPrefServices
                                                            .getdepartureDate()
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1.0,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.flight_takeoff,
                                              size: 30,
                                              color: Flights_Colours.strongRed,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                            context) {
                                                          return SelectCity(
                                                              type: "two");
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "FROM",
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Flights_Colours
                                                              .strongRed,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 32),
                                                            children: [
                                                              TextSpan(
                                                                text: SharedPrefServices
                                                                            .getcityFromTwo()!
                                                                        .isEmpty
                                                                    ? "Select City"
                                                                    : "${SharedPrefServices.getcityFromTwo()} ",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: SharedPrefServices
                                                                        .getairportcodeFromTwo()
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                      Text(
                                                        SharedPrefServices
                                                                .getcountryFromTwo()
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 10.0,
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // Divider(
                                        //   color: Colors.grey.shade400,
                                        //   thickness: 1.0,
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.flight_land,
                                              size: 30,
                                              color: Flights_Colours.strongRed,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return ToSelectCity(
                                                          type: "two");
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "TO",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 32),
                                                        children: [
                                                          TextSpan(
                                                            text: SharedPrefServices
                                                                        .getcityToTwo()!
                                                                    .isEmpty
                                                                ? "Select City"
                                                                : "${SharedPrefServices.getcityToTwo()} ",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: SharedPrefServices
                                                                    .getairportcodeToTwo()
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                  Text(
                                                    SharedPrefServices
                                                            .getcountryToTwo()
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 10.0,
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // Divider(
                                        //   color: Colors.grey.shade400,
                                        //   thickness: 1.0,
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        InkWell(
                                          onTap: () {
                                            buildDatePickerforArraivaldate();

                                            print("triggered");
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.calendar_today,
                                                size: 24,
                                                color:
                                                    Flights_Colours.strongRed,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "DEPARTURE DATE",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Text(
                                                    SharedPrefServices
                                                            .getarrivalDate()
                                                        .toString(),
                                                    // selectedArraivaldate
                                                    //     .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 1.0,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Center(
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: double.infinity,
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Card(
                                                              child: Wrap(
                                                                children: [
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            30.0),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              IconButton(
                                                                                icon: Icon(
                                                                                  Icons.close,
                                                                                  color: Flights_Colours.strongRed,
                                                                                  size: 24,
                                                                                ),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                              Text('ADD NUMBER OF TRAVELLERS',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14.0,
                                                                                    color: Flights_Colours.strongRed,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontFamily: 'Poppins',
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            margin: const EdgeInsets.only(
                                                                                left: 10.0,
                                                                                right: 10.0,
                                                                                top: 10),
                                                                            width:
                                                                                double.infinity,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(8.0),
                                                                                    ),
                                                                                    boxShadow: [
                                                                                  BoxShadow(color: Color.fromARGB(255, 197, 197, 197), blurRadius: 2)
                                                                                ]),
                                                                            // height: 350,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      const Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                "Adults",
                                                                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'poppins', fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                                                                                              ),
                                                                                              Text(
                                                                                                "  12 years & above",
                                                                                                style: TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Text(
                                                                                            "on the day of travel",
                                                                                            style: TextStyle(fontSize: 12.0, color: Colors.grey, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Card(
                                                                                        elevation: 0.0,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          side: BorderSide(
                                                                                            color: Flights_Colours.strongRed,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                        ),
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xffFFFFF8),
                                                                                            borderRadius: BorderRadius.all(
                                                                                              Radius.circular(10.0),
                                                                                            ),
                                                                                          ),
                                                                                          child: Container(
                                                                                            margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Row(
                                                                                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.remove,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        if (adultcount > 1) {
                                                                                                          setState(() {
                                                                                                            adultcount--;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      adultcount.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontFamily: "Poppins",
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        fontSize: 16.0,
                                                                                                        color: Flights_Colours.strongRed,
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.add,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          adultcount++;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Container(
                                                                                  margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      const Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                "Children",
                                                                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'poppins', fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                                                                                              ),
                                                                                              Text(
                                                                                                "  2- 12 yrs",
                                                                                                style: TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Text(
                                                                                            "on the day of travel",
                                                                                            style: TextStyle(fontSize: 12.0, color: Colors.grey, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Card(
                                                                                        elevation: 0.0,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          side: BorderSide(
                                                                                            color: Flights_Colours.strongRed,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                        ),
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xffFFFFF8),
                                                                                            borderRadius: BorderRadius.all(
                                                                                              Radius.circular(10.0),
                                                                                            ),
                                                                                          ),
                                                                                          child: Container(
                                                                                            margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Row(
                                                                                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.remove,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        if (children > 1) {
                                                                                                          setState(() {
                                                                                                            children--;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      children.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontFamily: "Poppins",
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        fontSize: 16.0,
                                                                                                        color: Flights_Colours.strongRed,
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.add,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          children++;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      const Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                "Infant",
                                                                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'poppins', fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                                                                                              ),
                                                                                              Text(
                                                                                                "  Under 2 yrs",
                                                                                                style: TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Text(
                                                                                            "on the day of travel",
                                                                                            style: TextStyle(fontSize: 12.0, color: Colors.grey, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Card(
                                                                                        elevation: 0.0,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          side: BorderSide(
                                                                                            color: Flights_Colours.strongRed,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                        ),
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xffFFFFF8),
                                                                                            borderRadius: BorderRadius.all(
                                                                                              Radius.circular(10.0),
                                                                                            ),
                                                                                          ),
                                                                                          child: Container(
                                                                                            margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Row(
                                                                                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.remove,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        if (infants > 0) {
                                                                                                          setState(() {
                                                                                                            infants--;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      infants.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontFamily: "Poppins",
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        fontSize: 16.0,
                                                                                                        color: Flights_Colours.strongRed,
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.add,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          if (infants < adultcount) {
                                                                                                            infants++;
                                                                                                          }
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin: const EdgeInsets.only(
                                                                                left: 10.0,
                                                                                right: 10.0,
                                                                                top: 10),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Text('CHOOSE CABIN CLASS',
                                                                                    style: TextStyle(
                                                                                      fontSize: 14.0,
                                                                                      color: Flights_Colours.strongRed,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontFamily: 'Poppins',
                                                                                    )),
                                                                                Row(
                                                                                  children: [
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          _selectedTrip = "eco";
                                                                                        });
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                          shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              side: BorderSide(
                                                                                                width: 1.0,
                                                                                                // color: Color(0xffFF6700),
                                                                                                color: _selectedTrip == "eco" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey,
                                                                                              )),
                                                                                          backgroundColor: _selectedTrip == "eco" ? Colors.orange[50] : Colors.white,
                                                                                          fixedSize: const Size(110, 35),
                                                                                          textStyle: const TextStyle(
                                                                                            fontSize: 14.0,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Poppins-regular',
                                                                                            fontWeight: FontWeight.w700,
                                                                                          )),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: <Widget>[
                                                                                          if (_selectedTrip == "eco")
                                                                                            Icon(
                                                                                              Icons.check_circle,
                                                                                              color: Flights_Colours.strongRed,
                                                                                            ),
                                                                                          Text(
                                                                                            "Economy",
                                                                                            style: TextStyle(fontSize: 12, color: _selectedTrip == "eco" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          _selectedTrip = "businessclass";
                                                                                        });
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                          shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              side: BorderSide(
                                                                                                width: 1.0,
                                                                                                // color: Color(0xffFF6700),
                                                                                                color: _selectedTrip == "businessclass" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey,
                                                                                              )),
                                                                                          backgroundColor: _selectedTrip == "businessclass" ? Colors.orange[50] : Colors.white,
                                                                                          fixedSize: const Size(150, 35),
                                                                                          textStyle: const TextStyle(
                                                                                            fontSize: 14.0,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Poppins-regular',
                                                                                            fontWeight: FontWeight.w700,
                                                                                          )),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: <Widget>[
                                                                                          if (_selectedTrip == "businessclass")
                                                                                            Icon(
                                                                                              Icons.check_circle,
                                                                                              color: Flights_Colours.strongRed,
                                                                                            ),
                                                                                          Text(
                                                                                            "Business Class",
                                                                                            style: TextStyle(fontSize: 12, color: _selectedTrip == "businessclass" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 20,
                                                                                    ),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          _selectedTrip = "firstclass";
                                                                                        });
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                          shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              side: BorderSide(
                                                                                                width: 1.0,
                                                                                                color: _selectedTrip == "firstclass" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey,
                                                                                              )),
                                                                                          backgroundColor: _selectedTrip == "firstclass" ? Colors.orange[50] : Colors.white,
                                                                                          fixedSize: const Size(150, 35),
                                                                                          textStyle: const TextStyle(
                                                                                            fontSize: 14.0,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Poppins-regular',
                                                                                            fontWeight: FontWeight.w700,
                                                                                          )),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: <Widget>[
                                                                                          if (_selectedTrip == "firstclass")
                                                                                            Icon(
                                                                                              Icons.check_circle,
                                                                                              color: Flights_Colours.strongRed,
                                                                                            ),
                                                                                          Text(
                                                                                            "First Class",
                                                                                            style: TextStyle(fontSize: 12, color: _selectedTrip == "firstclass" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      _selectedTrip = "ecopri";
                                                                                    });
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                      shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          side: BorderSide(
                                                                                            width: 1.0,
                                                                                            // color: Color(0xffFF6700),
                                                                                            color: _selectedTrip == "ecopri" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey,
                                                                                          )),
                                                                                      backgroundColor: _selectedTrip == "ecopri" ? Colors.orange[50] : Colors.white,
                                                                                      fixedSize: const Size(250, 35),
                                                                                      textStyle: const TextStyle(
                                                                                        fontSize: 14.0,
                                                                                        color: Colors.white,
                                                                                        fontFamily: 'Poppins-regular',
                                                                                        fontWeight: FontWeight.w700,
                                                                                      )),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      if (_selectedTrip == "ecopri")
                                                                                        Icon(
                                                                                          Icons.check_circle,
                                                                                          color: Flights_Colours.strongRed,
                                                                                        ),
                                                                                      Text(
                                                                                        "Economy/Premium Economy",
                                                                                        style: TextStyle(fontSize: 12, color: _selectedTrip == "ecopri" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey, fontWeight: FontWeight.bold),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 20),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: 48,
                                                                                      child: ElevatedButton(
                                                                                        onPressed: () async {
                                                                                          SharedPrefServices.setadultCount(adultcount);
                                                                                          SharedPrefServices.setchildCount(children);
                                                                                          SharedPrefServices.setinfantCount(infants);

                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        style: ElevatedButton.styleFrom(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            backgroundColor: Flights_Colours.strongRed,
                                                                                            fixedSize: const Size(330, 48),
                                                                                            textStyle: const TextStyle(
                                                                                              fontSize: 14.0,
                                                                                              color: Colors.white,
                                                                                              fontFamily: 'Poppins-regular',
                                                                                              fontWeight: FontWeight.w700,
                                                                                            )),
                                                                                        child: const Text(
                                                                                          'DONE',
                                                                                          style: TextStyle(
                                                                                            fontSize: 14.0,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Poppins',
                                                                                            fontWeight: FontWeight.w700,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 20.0,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.person,
                                                size: 24,
                                                color:
                                                    Flights_Colours.strongRed,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "TRAVELLERS & CLASS",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Text(
                                                    "$totalPassengers $tripType",
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 1.0,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 48,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  dest.clear();

                                                  print(
                                                      "multi city service triggered");

                                                  dest = [
                                                    {
                                                      "departureDateTime":
                                                          depDateFormated,
                                                      "origin": SharedPrefServices
                                                              .getairportcodeFrom()
                                                          .toString(),
                                                      "destination":
                                                          SharedPrefServices
                                                                  .getairportcodeTo()
                                                              .toString(),
                                                      "flightDateFlex": 3
                                                    },
                                                    {
                                                      "departureDateTime":
                                                          arrDateFormated,
                                                      "origin": SharedPrefServices
                                                              .getairportcodeFromTwo()
                                                          .toString(),
                                                      "destination":
                                                          SharedPrefServices
                                                                  .getairportcodeToTwo()
                                                              .toString(),
                                                      "flightDateFlex": 3
                                                    }
                                                  ];

                                                  ListModel list = ListModel(
                                                      originDestinations: dest,
                                                      adultCount: adultcount,
                                                      childCount: children,
                                                      infantCount: infants,
                                                      cabinClass: "Economy",
                                                      includeCarrier: "",
                                                      excludeCarrier: "",
                                                      stopOver: "none",
                                                      airTravelType:
                                                          SharedPrefServices
                                                                  .getselecedscroller()
                                                              .toString(),
                                                      flightDateFlex: 3,
                                                      itineraryViewType: "1",
                                                      // flightType: 1,
                                                      priceForTrip: "REGULAR",
                                                      userId: 1,
                                                      roleType: 4,
                                                      membership: 1);

                                                  print(list);
                                                  inspect(list);
                                                  setState(() {
                                                    isApiCallProcess = true;
                                                  });
                                                  getFlightsMulticityListmethod(
                                                      list);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    backgroundColor:
                                                        Flights_Colours
                                                            .strongRed,
                                                    fixedSize:
                                                        const Size(330, 48),
                                                    textStyle: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                                child: const Text(
                                                  'SEARCH',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ])))
                              : Card(
                                  color: Colors.white,
                                  shadowColor: Colors.blue.shade50,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Column(children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.flight_takeoff,
                                              size: 30,
                                              color: Flights_Colours.strongRed,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                            context) {
                                                          return SelectCity(
                                                            type: "one",
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "FROM",
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Flights_Colours
                                                              .strongRed,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 32),
                                                            children: [
                                                              TextSpan(
                                                                text: SharedPrefServices
                                                                            .getcityFrom()!
                                                                        .isEmpty
                                                                    ? "Select City"
                                                                    : "${SharedPrefServices.getcityFrom()} ",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: SharedPrefServices
                                                                        .getairportcodeFrom()
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                      Text(
                                                        SharedPrefServices
                                                                .getcountryFrom()
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 10.0,
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 1.0,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.flight_land,
                                              size: 30,
                                              color: Flights_Colours.strongRed,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return ToSelectCity(
                                                          type: "one");
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "TO",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 32),
                                                        children: [
                                                          TextSpan(
                                                            text: SharedPrefServices
                                                                        .getcityTo()!
                                                                    .isEmpty
                                                                ? "Select City"
                                                                : "${SharedPrefServices.getcityTo()} ",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: SharedPrefServices
                                                                    .getairportcodeTo()
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                  Text(
                                                    SharedPrefServices
                                                            .getcountryTo()
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 10.0,
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 1.0,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            buildDatePickerfordate();

                                            print("triggered");
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.calendar_today,
                                                size: 24,
                                                color:
                                                    Flights_Colours.strongRed,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "DEPARTURE DATE",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Text(
                                                    SharedPrefServices
                                                            .getdepartureDate()
                                                        .toString(),
                                                    // selecteddate.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 1.0,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SharedPrefServices.getselecedscroller()
                                                    .toString() ==
                                                "roundTrip"
                                            ? InkWell(
                                                onTap: () {
                                                  buildDatePickerforArraivaldate();
                                                },
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.calendar_today,
                                                      size: 24,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "RETURN DATE",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            color:
                                                                Flights_Colours
                                                                    .strongRed,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                        Text(
                                                          SharedPrefServices
                                                                  .getarrivalDate()
                                                              .toString(),
                                                          // selectedArraivaldate
                                                          //     .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    SharedPrefServices
                                                        .setselecedscroller(
                                                            "roundTrip");
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.calendar_today,
                                                      size: 24,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "+ ADD RETURN DATE",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Flights_Colours
                                                                    .strongRed,
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                        const Text(
                                                          "See more on round trips",
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 1.0,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Center(
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: double.infinity,
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Card(
                                                              child: Wrap(
                                                                children: [
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            30.0),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              IconButton(
                                                                                icon: Icon(
                                                                                  Icons.close,
                                                                                  color: Flights_Colours.strongRed,
                                                                                  size: 24,
                                                                                ),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                              Text('ADD NUMBER OF TRAVELLERS',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14.0,
                                                                                    color: Flights_Colours.strongRed,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontFamily: 'Poppins',
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            margin: const EdgeInsets.only(
                                                                                left: 10.0,
                                                                                right: 10.0,
                                                                                top: 10),
                                                                            width:
                                                                                double.infinity,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(8.0),
                                                                                    ),
                                                                                    boxShadow: [
                                                                                  BoxShadow(color: Color.fromARGB(255, 197, 197, 197), blurRadius: 2)
                                                                                ]),
                                                                            // height: 350,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      const Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                "Adults",
                                                                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'poppins', fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                                                                                              ),
                                                                                              Text(
                                                                                                "  12 years & above",
                                                                                                style: TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Text(
                                                                                            "on the day of travel",
                                                                                            style: TextStyle(fontSize: 12.0, color: Colors.grey, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Card(
                                                                                        elevation: 0.0,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          side: BorderSide(
                                                                                            color: Flights_Colours.strongRed,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                        ),
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xffFFFFF8),
                                                                                            borderRadius: BorderRadius.all(
                                                                                              Radius.circular(10.0),
                                                                                            ),
                                                                                          ),
                                                                                          child: Container(
                                                                                            margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Row(
                                                                                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.remove,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        if (adultcount > 1) {
                                                                                                          setState(() {
                                                                                                            adultcount--;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      adultcount.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontFamily: "Poppins",
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        fontSize: 16.0,
                                                                                                        color: Flights_Colours.strongRed,
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.add,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          adultcount++;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Container(
                                                                                  margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      const Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                "Children",
                                                                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'poppins', fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                                                                                              ),
                                                                                              Text(
                                                                                                "  2- 12 yrs",
                                                                                                style: TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Text(
                                                                                            "on the day of travel",
                                                                                            style: TextStyle(fontSize: 12.0, color: Colors.grey, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Card(
                                                                                        elevation: 0.0,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          side: BorderSide(
                                                                                            color: Flights_Colours.strongRed,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                        ),
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xffFFFFF8),
                                                                                            borderRadius: BorderRadius.all(
                                                                                              Radius.circular(10.0),
                                                                                            ),
                                                                                          ),
                                                                                          child: Container(
                                                                                            margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Row(
                                                                                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.remove,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        if (children > 1) {
                                                                                                          setState(() {
                                                                                                            children--;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      children.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontFamily: "Poppins",
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        fontSize: 16.0,
                                                                                                        color: Flights_Colours.strongRed,
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.add,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          children++;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      const Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                "Infant",
                                                                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'poppins', fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                                                                                              ),
                                                                                              Text(
                                                                                                "  Under 2 yrs",
                                                                                                style: TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Text(
                                                                                            "on the day of travel",
                                                                                            style: TextStyle(fontSize: 12.0, color: Colors.grey, fontFamily: 'poppins', decoration: TextDecoration.none),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Card(
                                                                                        elevation: 0.0,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          side: BorderSide(
                                                                                            color: Flights_Colours.strongRed,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                        ),
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xffFFFFF8),
                                                                                            borderRadius: BorderRadius.all(
                                                                                              Radius.circular(10.0),
                                                                                            ),
                                                                                          ),
                                                                                          child: Container(
                                                                                            margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Row(
                                                                                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.remove,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        if (infants > 0) {
                                                                                                          setState(() {
                                                                                                            infants--;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      infants.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontFamily: "Poppins",
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        fontSize: 16.0,
                                                                                                        color: Flights_Colours.strongRed,
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5.0,
                                                                                                    ),
                                                                                                    IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.add,
                                                                                                        color: Flights_Colours.dardModerateBlue,
                                                                                                        size: 24,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          if (infants < adultcount) {
                                                                                                            infants++;
                                                                                                          }
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin: const EdgeInsets.only(
                                                                                left: 10.0,
                                                                                right: 10.0,
                                                                                top: 10),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Text('CHOOSE CABIN CLASS',
                                                                                    style: TextStyle(
                                                                                      fontSize: 14.0,
                                                                                      color: Flights_Colours.strongRed,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontFamily: 'Poppins',
                                                                                    )),
                                                                                Row(
                                                                                  children: [
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          _selectedTrip = "eco";
                                                                                        });
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                          shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              side: BorderSide(
                                                                                                width: 1.0,
                                                                                                // color: Color(0xffFF6700),
                                                                                                color: _selectedTrip == "eco" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey,
                                                                                              )),
                                                                                          backgroundColor: _selectedTrip == "eco" ? Colors.orange[50] : Colors.white,
                                                                                          fixedSize: const Size(110, 35),
                                                                                          textStyle: const TextStyle(
                                                                                            fontSize: 14.0,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Poppins-regular',
                                                                                            fontWeight: FontWeight.w700,
                                                                                          )),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: <Widget>[
                                                                                          if (_selectedTrip == "eco")
                                                                                            Icon(
                                                                                              Icons.check_circle,
                                                                                              color: Flights_Colours.strongRed,
                                                                                            ),
                                                                                          Text(
                                                                                            "Economy",
                                                                                            style: TextStyle(fontSize: 12, color: _selectedTrip == "eco" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          _selectedTrip = "businessclass";
                                                                                        });
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                          shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              side: BorderSide(
                                                                                                width: 1.0,
                                                                                                // color: Color(0xffFF6700),
                                                                                                color: _selectedTrip == "businessclass" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey,
                                                                                              )),
                                                                                          backgroundColor: _selectedTrip == "businessclass" ? Colors.orange[50] : Colors.white,
                                                                                          fixedSize: const Size(150, 35),
                                                                                          textStyle: const TextStyle(
                                                                                            fontSize: 14.0,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Poppins-regular',
                                                                                            fontWeight: FontWeight.w700,
                                                                                          )),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: <Widget>[
                                                                                          if (_selectedTrip == "businessclass")
                                                                                            Icon(
                                                                                              Icons.check_circle,
                                                                                              color: Flights_Colours.strongRed,
                                                                                            ),
                                                                                          Text(
                                                                                            "Business Class",
                                                                                            style: TextStyle(fontSize: 12, color: _selectedTrip == "businessclass" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 20,
                                                                                    ),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          _selectedTrip = "firstclass";
                                                                                        });
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                          shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              side: BorderSide(
                                                                                                width: 1.0,
                                                                                                color: _selectedTrip == "firstclass" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey,
                                                                                              )),
                                                                                          backgroundColor: _selectedTrip == "firstclass" ? Colors.orange[50] : Colors.white,
                                                                                          fixedSize: const Size(150, 35),
                                                                                          textStyle: const TextStyle(
                                                                                            fontSize: 14.0,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Poppins-regular',
                                                                                            fontWeight: FontWeight.w700,
                                                                                          )),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: <Widget>[
                                                                                          if (_selectedTrip == "firstclass")
                                                                                            Icon(
                                                                                              Icons.check_circle,
                                                                                              color: Flights_Colours.strongRed,
                                                                                            ),
                                                                                          Text(
                                                                                            "First Class",
                                                                                            style: TextStyle(fontSize: 12, color: _selectedTrip == "firstclass" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      _selectedTrip = "ecopri";
                                                                                    });
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                      shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          side: BorderSide(
                                                                                            width: 1.0,
                                                                                            // color: Color(0xffFF6700),
                                                                                            color: _selectedTrip == "ecopri" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey,
                                                                                          )),
                                                                                      backgroundColor: _selectedTrip == "ecopri" ? Colors.orange[50] : Colors.white,
                                                                                      fixedSize: const Size(250, 35),
                                                                                      textStyle: const TextStyle(
                                                                                        fontSize: 14.0,
                                                                                        color: Colors.white,
                                                                                        fontFamily: 'Poppins-regular',
                                                                                        fontWeight: FontWeight.w700,
                                                                                      )),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      if (_selectedTrip == "ecopri")
                                                                                        Icon(
                                                                                          Icons.check_circle,
                                                                                          color: Flights_Colours.strongRed,
                                                                                        ),
                                                                                      Text(
                                                                                        "Economy/Premium Economy",
                                                                                        style: TextStyle(fontSize: 12, color: _selectedTrip == "ecopri" ? Flights_Colours.strongRed : Flights_Colours.veryDarkGrey, fontWeight: FontWeight.bold),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 20),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: 48,
                                                                                      child: ElevatedButton(
                                                                                        onPressed: () async {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        style: ElevatedButton.styleFrom(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            backgroundColor: Flights_Colours.strongRed,
                                                                                            fixedSize: const Size(330, 48),
                                                                                            textStyle: const TextStyle(
                                                                                              fontSize: 14.0,
                                                                                              color: Colors.white,
                                                                                              fontFamily: 'Poppins-regular',
                                                                                              fontWeight: FontWeight.w700,
                                                                                            )),
                                                                                        child: const Text(
                                                                                          'DONE',
                                                                                          style: TextStyle(
                                                                                            fontSize: 14.0,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Poppins',
                                                                                            fontWeight: FontWeight.w700,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 20.0,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.person,
                                                size: 24,
                                                color:
                                                    Flights_Colours.strongRed,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "TRAVELLERS & CLASS",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Flights_Colours
                                                          .strongRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Text(
                                                    "$totalPassengers $tripType",
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 1.0,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 48,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  dest.clear();
                                                  if (SharedPrefServices
                                                              .getselecedscroller()
                                                          .toString() ==
                                                      "roundTrip") {
                                                    dest = [
                                                      {
                                                        "departureDateTime":
                                                            depDateFormated,
                                                        "origin": SharedPrefServices
                                                                .getairportcodeFrom()
                                                            .toString(),
                                                        "destination":
                                                            SharedPrefServices
                                                                    .getairportcodeTo()
                                                                .toString(),
                                                        "flightDateFlex": 1
                                                      },
                                                      {
                                                        "departureDateTime":
                                                            arrDateFormated,
                                                        "origin": SharedPrefServices
                                                                .getairportcodeTo()
                                                            .toString(),
                                                        "destination":
                                                            SharedPrefServices
                                                                    .getairportcodeFrom()
                                                                .toString(),
                                                        "flightDateFlex": 1
                                                      }
                                                    ];
                                                  } else if (SharedPrefServices
                                                              .getselecedscroller()
                                                          .toString() ==
                                                      "oneWay") {
                                                    dest = [
                                                      {
                                                        "departureDateTime":
                                                            depDateFormated,
                                                        "origin": SharedPrefServices
                                                                .getairportcodeFrom()
                                                            .toString(),
                                                        "destination":
                                                            SharedPrefServices
                                                                    .getairportcodeTo()
                                                                .toString(),
                                                        "flightDateFlex": 1
                                                      }
                                                    ];
                                                  }

                                                  ListModel list = ListModel(
                                                      originDestinations: dest,
                                                      adultCount: adultcount,
                                                      childCount: children,
                                                      infantCount: infants,
                                                      cabinClass: "Economy",
                                                      includeCarrier: "",
                                                      excludeCarrier: "",
                                                      stopOver: "none",
                                                      airTravelType:
                                                          SharedPrefServices
                                                                  .getselecedscroller()
                                                              .toString(),
                                                      flightDateFlex: 3,
                                                      itineraryViewType: "1",
                                                      // flightType: 1,
                                                      priceForTrip: "REGULAR",
                                                      userId: 1,
                                                      roleType: 4,
                                                      membership: 1);

                                                  print(list);
                                                  inspect(list);
                                                  setState(() {
                                                    isApiCallProcess = true;
                                                  });
                                                  if (SharedPrefServices
                                                              .getselecedscroller()
                                                          .toString() ==
                                                      "oneWay") {
                                                    getFlightsListmethod(list);
                                                  } else if (SharedPrefServices
                                                              .getselecedscroller()
                                                          .toString() ==
                                                      "roundTrip") {
                                                    // getFlightsRoundTripListmethod(
                                                    //     list);
                                                    getFlightsMulticityListmethod(
                                                        list);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    backgroundColor:
                                                        Flights_Colours
                                                            .strongRed,
                                                    fixedSize:
                                                        const Size(330, 48),
                                                    textStyle: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                                child: const Text(
                                                  'SEARCH',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ]))),
                          // Positioned(
                          //     top: 65,
                          //     right: -5,
                          //     child: Container(
                          //         decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             shape: BoxShape.circle,
                          //             border: Border.all(color: Colors.grey)),
                          //         child: Icon(
                          //           Icons.swap_vert,
                          //           color: Colors.grey.shade700,
                          //         )))
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Request for Group  Enquiry",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ]))),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  children: [
                    Card(
                        color: Colors.white,
                        shadowColor: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.grey.shade400)),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: Column(children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.privacy_tip_sharp,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "BEST PRICE GUARANTED",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours
                                                  .dardModerateBlue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                            width: 300,
                                            child: Text(
                                              "Trying Our level best to fetch lower price than others, try us once!!",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ]))),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                        color: Colors.white,
                        shadowColor: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.grey.shade400)),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: Column(children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.av_timer,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "24*7 SUPPORT",
                                          style: GoogleFonts.poppins(
                                              color: Flights_Colours
                                                  .dardModerateBlue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                            width: 300,
                                            child: Text(
                                              "We're always here for you - reach us 24 hours a day ,7 days a week",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ]))),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://i.insider.com/5d38ca7d36e03c5dfa2ed4e3?width=750&format=jpeg&auto=webp",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://www.indus.travel/aviator/qstvsndfvb/uploads/2018/07/most-visited-places-India-by-foreign-tourists.jpg",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Travel for less with our great deals",
                      style: GoogleFonts.poppins(
                          color: Flights_Colours.strongRed,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CarouselSlider(
                      items: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://www.indus.travel/aviator/qstvsndfvb/uploads/2018/07/most-visited-places-India-by-foreign-tourists.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://media.istockphoto.com/id/155439315/photo/passenger-airplane-flying-above-clouds-during-sunset.jpg?s=612x612&w=0&k=20&c=LJWadbs3B-jSGJBVy9s0f8gZMHi2NvWFXa3VJ2lFcL0="),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://media.istockphoto.com/id/685798804/vector/airline-ticket-or-boarding-pass-for-traveling-by-plane-isolated-on-white-vector-illustration.jpg?s=612x612&w=0&k=20&c=FTCc9XrAowwcyabXLV9gixzUXRgYU3zJFWnIWfe8W_Y="),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://media.istockphoto.com/id/1294721277/vector/two-young-adult-friends-check-into-fight-online-using-smartphones.jpg?s=612x612&w=0&k=20&c=FiSpm1e6R2KfbTCsVbvTW08ZUY5SqpJ-O-usrwJysy8="),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: 180.0,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Why AnjMal ?",
                        style: GoogleFonts.poppins(
                            color: Flights_Colours.strongRed,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Colors.grey.shade600,
                        indent: 150,
                        endIndent: 160,
                        thickness: 2.0,
                        height: 1.5,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Column(
                  children: [
                    Text(
                      whyAjmal1,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      whyAjmal2,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      whyAjmal3,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDatePickerfordate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat.yMMMEd().format(pickedDate);

      setState(() {
        SharedPrefServices.setdepartureDate(formattedDate);
        SharedPrefServices.setarrivalDate(formattedDate);
        // selecteddate = selectedArraivaldate = formattedDate;
        depDateFormated = DateFormat('yyyy-MM-dd').format(pickedDate);

        raw_dep_date = raw_arrival_date = pickedDate;
        //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  buildDatePickerforArraivaldate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: raw_dep_date, //get today's date
        firstDate: raw_dep_date,
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat.yMMMEd().format(pickedDate);

      setState(() {
        // selectedArraivaldate = formattedDate;
        SharedPrefServices.setarrivalDate(formattedDate);
        raw_arrival_date = pickedDate;
        arrDateFormated = DateFormat('yyyy-MM-dd').format(pickedDate);
        //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
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
