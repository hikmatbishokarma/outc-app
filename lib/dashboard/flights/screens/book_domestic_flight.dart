import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/flights/models/flight_block_response_model.dart';
import 'package:outc/dashboard/flights/models/flight_price_model.dart'
    as flightPrice;
import 'package:outc/dashboard/flights/models/flightranjith.dart';
import 'package:outc/dashboard/flights/screens/ticketView.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';
import 'package:outc/dashboard/flights/widgets/progressbar.dart';
import 'package:outc/services/api_services_list.dart';

import 'package:outc/widgets/components/toast.dart';

import 'package:outc/widgets/sharedprefservices.dart';
import 'package:http/http.dart' as http;

class BookDomesticFlight extends StatefulWidget {
  String airlineLogo1,
      airlineName1,
      airlineStop1,
      airlineClass1,
      airlineRefund1,
      airlineStart1,
      airlineEnd1,
      airlineStartTime1,
      airlineEndTime1,
      traceId1,
      flightId1,
      fareId1,
      airlineDuration1,
      airlineLogo2,
      airlineName2,
      airlineStop2,
      airlineClass2,
      airlineRefund2,
      airlineStart2,
      airlineEnd2,
      airlineStartTime2,
      airlineEndTime2,
      traceId2,
      flightId2,
      fareId2,
      airlineDuration2;
  double adultBasefare,
      childBasefare,
      infantBasefare,
      adulttaxfare,
      childtaxfare,
      adultCount,
      childCount,
      infantCount,
      infanttaxfare,
      returnAdultBasefare,
      returnAdultTaxfare,
      returnChildBasefare,
      returnChildTaxfare,
      returnInfantTaxfare,
      returnInfantBasefare;

  BookDomesticFlight({
    super.key,
    required this.airlineLogo1,
    required this.airlineName1,
    required this.airlineStop1,
    required this.airlineClass1,
    required this.airlineRefund1,
    required this.airlineStart1,
    required this.airlineEnd1,
    required this.traceId1,
    required this.airlineDuration1,
    required this.airlineStartTime1,
    required this.airlineEndTime1,
    required this.adultBasefare,
    required this.adulttaxfare,
    required this.childBasefare,
    required this.childtaxfare,
    required this.infantBasefare,
    required this.infanttaxfare,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.airlineLogo2,
    required this.airlineName2,
    required this.airlineStop2,
    required this.airlineClass2,
    required this.airlineRefund2,
    required this.airlineStart2,
    required this.airlineEnd2,
    required this.traceId2,
    required this.airlineDuration2,
    required this.airlineStartTime2,
    required this.airlineEndTime2,
    required this.returnAdultBasefare,
    required this.returnAdultTaxfare,
    required this.returnChildBasefare,
    required this.returnChildTaxfare,
    required this.returnInfantBasefare,
    required this.returnInfantTaxfare,
    required this.flightId1,
    required this.fareId1,
    required this.flightId2,
    required this.fareId2,
  });
  @override
  State<BookDomesticFlight> createState() => _BookDomesticFlightState();
}

class _BookDomesticFlightState extends State<BookDomesticFlight> {
  bool firstValue = false;

  late FlightFormRequestModelRoundTrip flightFormModel;

  late flightPrice.FLightPriceRequestModel flightPriceRequestModel;

  // FlightFormModel flightFormModel = FlightFormModel(
  //   traceId: "138837507375704620000\$tr",
  //   userId: 1,
  //   roleType: 4,
  //   membership: 1,
  //   passengers: [],
  //   additionalServices: [],
  //   creditCardInfo: "",
  //   insuranceRequired: 0,
  //   promoCode: "",
  //   convienenceId: 51,
  //   pgType: 1,
  //   currency: "INR",
  //   totalPrice: 8491.3,
  //   isCouponReedem: false,
  // );
  double basefare1 = 0;
  double taxes1 = 0;
  double total1 = 0;
  double grandTotal1 = 0;

  double basefare2 = 0;
  double taxes2 = 0;
  double total2 = 0;
  double grandTotal2 = 0;

  String bookingRefNo = "";

  // String selectedValue = 'Mr';
  // var adult = ['Mr', 'Mrs', 'Ms'];

  // String childValue = 'Mstr';
  // var child = ['Mstr', 'Ms'];

  // String infantValue = 'Mstr';
  // var infant = ['Mstr', 'Ms'];

  List adultTitile = [];

  // String selectedValue = 'Mr';
  var adult = ['MR', 'MRS', 'MS'];

  List childTitile = [];
  // String childValue = 'Mstr';
  var child = ['MSTR', 'MS'];

  List infantTitile = [];
  // String infantValue = 'Mstr';
  var infant = ['MSTR', 'MS'];

  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  // initiate controllers
  var titleAdultControllers = [];
  var firstnameAdultControllers = [];
  var lastNameAdultControllers = [];
  var dobAdultControllers = [];
  var nationalityAdultControllers = [];

  var titleChildrenControllers = [];
  var firstnameChildrenControllers = [];
  var lastNameChildrenControllers = [];
  var dobChildrenControllers = [];
  var nationalityChildrenControllers = [];

  var titleInfantControllers = [];
  var firstnameInfantControllers = [];
  var lastNameInfantControllers = [];
  var dobInfantControllers = [];
  var nationalityInfantControllers = [];

  final emailController =
      TextEditingController(text: SharedPrefServices.getemail());
  final phoneController =
      TextEditingController(text: SharedPrefServices.getphonenumber());
  final addressController = TextEditingController();

// initiate new list for final output. assign Passenger model class as initiation for list
  List<Passenger> passengers = [];
  bool isApiCallProcess = false;

  String convertDateformat(String dob) {
    if (dob.isEmpty) {
      return "";
    }

    try {
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return "";
    }
  }

// addData method used to add total controllers into the final passengers list using for LOOP
  addData() {
    // this for loop is to add adult controllers

    for (int i = 0; i < widget.adultCount; i++) {
      passengers.add(
        Passenger(
          title: titleAdultControllers[i],
          firstName: firstnameAdultControllers[i].text.toString(),
          lastName: lastNameAdultControllers[i].text.toString(),
          // nationality: nationalityAdultControllers[i].text.toString(),
          paxType: "ADT",
          pax: 1,
          email: SharedPrefServices.getemail().toString(),
          dob: convertDateformat(dobAdultControllers[i].text.toString()),
          gender: "m",
          mobile: SharedPrefServices.getphonenumber().toString(),
          // passportNumber: "",
          // passportIssuedCountry: "",
          // passportDOE: "",
          passengerNationality: nationalityAdultControllers[i].text.toString(),
          areaCode: "+91",
          // addressCountryCode: "",
          address_CountryCode: "",
          address: "hyd",
          additionalServicesIds: [],
          mealPref: [],
          baggagePref: [],
        ),
      );
    }

    // this for loop is to add children controllers
    for (int i = 0; i < widget.childCount; i++) {
      passengers.add(
        Passenger(
          title: titleChildrenControllers[i],
          firstName: firstnameChildrenControllers[i].text.toString(),
          lastName: lastNameChildrenControllers[i].text.toString(),
          // nationality: nationalityChildrenControllers[i].text.toString(),
          paxType: "CHD",
          pax: 1,
          email: SharedPrefServices.getemail().toString(),
          dob: convertDateformat(dobChildrenControllers[i].text.toString()),
          gender: "m",
          mobile: SharedPrefServices.getphonenumber().toString(),
          // passportNumber: "",
          // passportIssuedCountry: "",
          // passportDOE: "",
          passengerNationality: nationalityAdultControllers[i].text.toString(),
          areaCode: "+91",
          // addressCountryCode: "",
          address_CountryCode: "",
          address: "hyd",
          additionalServicesIds: [],
          mealPref: [],
          baggagePref: [],
        ),
      );
    }

    // this for loop is to add infants controllers
    for (int i = 0; i < widget.infantCount; i++) {
      passengers.add(
        Passenger(
          title: titleInfantControllers[i],
          firstName: firstnameInfantControllers[i].text.toString(),
          lastName: lastNameInfantControllers[i].text.toString(),
          // nationality: nationalityInfantControllers[i].text.toString(),
          paxType: "INF",
          pax: 1,
          email: SharedPrefServices.getemail().toString(),
          dob: convertDateformat(dobInfantControllers[i].text.toString()),
          gender: "m",
          mobile: SharedPrefServices.getphonenumber().toString(),
          // passportNumber: "",
          // passportIssuedCountry: "",
          // passportDOE: "",
          passengerNationality: nationalityAdultControllers[i].text.toString(),
          areaCode: "+91",
          // addressCountryCode: "",
          address_CountryCode: "",
          address: "hyd",
          additionalServicesIds: [],
          mealPref: [],
          baggagePref: [],
        ),
      );
    }

    // print("now printing list of passangers");
    // // now we are printing the final list after adding all the data through looping
    // print(passengers);
    // inspect(passengers);
  }

  // init state is used to initiate all the controller creation methods.
  @override
  void initState() {
    super.initState();
    print(titleAdultControllers);
    flightFormModel = FlightFormRequestModelRoundTrip(
      pgType: 3,
      userId: int.parse(SharedPrefServices.getcustomerId().toString()),
      traceId: widget.traceId1,
      currency: "INR",
      currencyRatio: 1,
      membership: 1,
      promoData: "",
      roleType: 5,
      passengers: [],
      gstDetails: GstDetails(
        gstAddressLine1: " ",
        gstAddressLine2: " ",
        gstCity: "",
        gstState: "",
        gstpinCode: "",
        gstEmailId: "",
        gstNumber: "",
        gstPhoneNo: "",
        gstCompanyName: "",
      ),
      additionalServices: [],
      creditCardInfo: "",
      convienenceId: 0,
      insuranceRequired: 0,
      totalPrice: 0,
      isCouponReedem: false,
    );

    flightPriceRequestModel = flightPrice.FLightPriceRequestModel(
        userId: int.parse(SharedPrefServices.getcustomerId().toString()),
        roleType: 5,
        membership: 1,
        traceId: " ",
        flightIds: [],
        selectedFlights: [
          flightPrice.SelectedFlight(
              fareId: widget.fareId1,
              flightId: widget.flightId1,
              coupanType: 'Discount',
              fareType: 'Economy',
              subCabinClass: 'A'),
          flightPrice.SelectedFlight(
              fareId: widget.fareId2,
              flightId: widget.flightId2,
              coupanType: 'Discount',
              fareType: 'Economy',
              subCabinClass: 'A'),
        ],
        airTravelType: 'roundTrip',
        mappingType: 'Combined',
        itineraryViewType: '1',
        gstDetails: flightPrice.GstDetails(
            gstAddressLine1: '',
            gstAddressLine2: '',
            gstCity: '',
            gstState: '',
            gstpinCode: '',
            gstEmailId: '',
            gstNumber: '',
            gstPhoneNo: '',
            gstCompanyName: ''));

    createtitleAdultControllers();
    createfirstnameAdultControllers();
    createlastNameAdultControllers();
    createdobAdultControllers();
    createnationalityAdultControllers();

    createtitleChildrenControllers();
    createfirstnameChildrenControllers();
    createlastNameChildrenControllers();
    createdobChildrenControllers();
    createnationalityChildrenControllers();

    createtitleInfantControllers();
    createfirstnameInfantControllers();
    createlastNameInfantControllers();
    createdobInfantControllers();
    createnationalityInfantControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Flight_ProgressBar(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: uiSetup(context),
    );
  }

  @override
  Widget uiSetup(BuildContext context) {
    basefare1 = (widget.adultCount * widget.adultBasefare) +
        (widget.childCount * widget.childBasefare) +
        (widget.infantCount * widget.infantBasefare);
    taxes1 = (widget.adultCount * widget.adulttaxfare) +
        (widget.childCount * widget.childtaxfare) +
        (widget.infantCount * widget.infanttaxfare);
    total1 = basefare1 + taxes1;
    grandTotal1 = total1 + 200;

    basefare2 = (widget.adultCount * widget.returnAdultBasefare) +
        (widget.childCount * widget.returnChildBasefare) +
        (widget.infantCount * widget.returnInfantBasefare);
    taxes2 = (widget.adultCount * widget.returnAdultTaxfare) +
        (widget.childCount * widget.returnChildTaxfare) +
        (widget.infantCount * widget.returnInfantTaxfare);
    total2 = basefare2 + taxes2;
    grandTotal2 = total2 + 200;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Text(
      //     "Enter Details",
      //     style: TextStyle(
      //         color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
      //   ),
      // ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Booking Details",
                        // ${filteredList.length}",
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 16.0,
                            color: Flights_Colours.strongRed,
                            fontWeight: FontWeight.w700),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.filter_alt,
                          color: Colors.transparent,
                          // color: Colors.transparent,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

                Card(
                    color: Colors.white,
                    shadowColor: Colors.blue.shade50,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Stack(children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 15, top: 25, bottom: 25),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xff35459c))),
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
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // Image(
                                          //   image: NetworkImage(
                                          //     widget.airlineLogo,
                                          //   ),
                                          //   fit: BoxFit.fill,
                                          //   height: 30.0,
                                          //   width: 30.0,
                                          // ),
                                          Text(
                                            widget.airlineName1,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Flights_Colours.strongRed,
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
                                            widget.airlineStop1,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          Text(
                                            widget.airlineClass1,
                                            style: const TextStyle(
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
                                Text(
                                  widget.airlineRefund1,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Flights_Colours.veryDarkGrey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.airlineStart1,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Divider(
                                          color: Flights_Colours.strongRed,
                                          thickness: 3,
                                        ),
                                      ),
                                      Text(
                                        widget.airlineEnd1,
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
                                        widget.airlineStartTime1,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        widget.airlineDuration1,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        widget.airlineEndTime1,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                      ),
                      Positioned(
                          top: 10,
                          left: 10,
                          child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: 80,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffbd0c21),
                                        Color(0xff35459c)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )),
                                child: Center(
                                    child: Text("DEPART",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500))),
                              )))
                    ])),
                const SizedBox(
                  height: 15,
                ),

                Card(
                    color: Colors.white,
                    shadowColor: Colors.blue.shade50,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Stack(children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 15, top: 25, bottom: 25),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xff35459c))),
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
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // Image(
                                          //   image: NetworkImage(
                                          //     widget.airlineLogo,
                                          //   ),
                                          //   fit: BoxFit.fill,
                                          //   height: 30.0,
                                          //   width: 30.0,
                                          // ),
                                          Text(
                                            widget.airlineName2,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Flights_Colours.strongRed,
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
                                            widget.airlineStop2,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          Text(
                                            widget.airlineClass2,
                                            style: const TextStyle(
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
                                Text(
                                  widget.airlineRefund2,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Flights_Colours.veryDarkGrey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.airlineStart2,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Divider(
                                          color: Flights_Colours.strongRed,
                                          thickness: 3,
                                        ),
                                      ),
                                      Text(
                                        widget.airlineEnd2,
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
                                        widget.airlineStartTime2,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        widget.airlineDuration2,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        widget.airlineEndTime2,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                      ),
                      Positioned(
                          top: 10,
                          left: 10,
                          child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: 80,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffbd0c21),
                                        Color(0xff35459c)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )),
                                child: Center(
                                    child: Text("RETURN",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500))),
                              )))
                    ])),

                const SizedBox(
                  height: 15,
                ),

                Card(
                    color: Colors.white,
                    shadowColor: Colors.blue.shade50,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Stack(children: [
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Container(
                              margin: const EdgeInsets.only(
                                  right: 10, left: 10, top: 20, bottom: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: const Color(0xff35459c))),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 10, left: 10, top: 10),
                                child: Column(children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "*",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("Phone number",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                10),
                                          ],
                                          controller: phoneController,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    10, 10, 10, 3),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffC2C2C2))),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffC2C2C2))),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffC2C2C2))),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffC2C2C2))),
                                            hintText: 'Enter Mobile Number',
                                            hintStyle: GoogleFonts.poppins(
                                                color: Flights_Colours
                                                    .veryDarkGrey,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 10, 10, 5),
                                              child: InkWell(
                                                onTap: () {
                                                  showCountryPicker(
                                                      context: context,
                                                      countryListTheme:
                                                          const CountryListThemeData(
                                                              bottomSheetHeight:
                                                                  600),
                                                      onSelect: (value) {
                                                        setState(() {
                                                          selectedCountry =
                                                              value;
                                                        });
                                                      });
                                                },
                                                child: Text(
                                                    "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Text(
                                        "*",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("Email",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      height: 40,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: const Color(0xffC2C2C2))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 3),
                                        child: TextFormField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            hintText:
                                                "Enter your email address",
                                            hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              color: Color(0xB3979797),
                                              // fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            // fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          autofillHints: const [
                                            AutofillHints.email
                                          ],
                                          onChanged: (input) {
                                            // setState(() {
                                            //   requestModelId.UserName = input.toLowerCase();
                                            // });
                                          },
                                        ),
                                      )),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Text(
                                        "*",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("Address",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: const Color(0xffC2C2C2))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 3),
                                        child: TextFormField(
                                          controller: addressController,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            hintText: "Enter your Address",
                                            hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              color: Color(0xB3979797),
                                              // fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            // fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          autofillHints: const [
                                            AutofillHints.email
                                          ],
                                          onChanged: (input) {
                                            // setState(() {
                                            //   requestModelId.UserName = input.toLowerCase();
                                            // });
                                          },
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ]),
                              ))),
                      Positioned(
                          top: 5,
                          right: 15,
                          left: 15,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: double.infinity,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffbd0c21),
                                        Color(0xff35459c)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 1),
                                  child: Text("Contact Details",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                              )))
                    ])),
                const SizedBox(
                  height: 15,
                ),
                // Card(
                //   color: Colors.white,
                //   shadowColor: Colors.blue.shade50,
                //   elevation: 5,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10)),
                //   child: Stack(
                //     children: [
                //       const SizedBox(
                //         height: 20,
                //       ),

                //       Positioned(
                //         top: 5,
                //         right: 15,
                //         left: 15,
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10)),
                //           child: Container(
                //             width: double.infinity,
                //             height: 25,
                //             decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(5),
                //                 gradient: const LinearGradient(
                //                   colors: [
                //                     Color(0xffbd0c21),
                //                     Color(0xff35459c)
                //                   ],
                //                   begin: Alignment.topLeft,
                //                   end: Alignment.bottomRight,
                //                 )),
                //             child: Padding(
                //               padding: const EdgeInsets.only(left: 10, top: 1),
                //               child: Text("Passenger Details",
                //                   style: GoogleFonts.poppins(
                //                       color: Colors.white,
                //                       fontSize: 16,
                //                       fontWeight: FontWeight.w500)),
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                buildAdultContainers(),
                // const SizedBox(
                //   height: 8,
                // ),
                buildChildrenContainers(),
                // const SizedBox(
                //   height: 8,
                // ),
                buildInfantContainers(),
                // const SizedBox(
                //   height: 8,
                // ),

                Card(
                  color: Colors.white,
                  shadowColor: Colors.blue.shade50,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 15, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fare Details",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Divider(
                                  thickness: 1.0,
                                  color: Colors.grey.shade400,
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 15, top: 20, bottom: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: const Color(0xff35459c))),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Base Fare",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                          child: Row(
                                        children: [
                                          Text(
                                              "INR ${basefare1.toStringAsFixed(2)}",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                          // const Icon(
                                          //   Icons.question_mark,
                                          //   color: Colors.grey,
                                          //   size: 18,
                                          // )
                                        ],
                                      )),
                                    ],
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //         "${widget.adultCount} ${widget.adultBasefare}",
                                  //         style: GoogleFonts.poppins(
                                  //             color: Colors.black,
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w500)),
                                  //     Text(
                                  //         "${widget.childCount} ${widget.childBasefare}",
                                  //         style: GoogleFonts.poppins(
                                  //             color: Colors.black,
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w500)),
                                  //     Text(
                                  //         "${widget.infantCount} ${widget.infantBasefare}",
                                  //         style: GoogleFonts.poppins(
                                  //             color: Colors.black,
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w500)),
                                  //   ],
                                  // ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Taxes and Fees",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                          child: Row(
                                        children: [
                                          Text(
                                              "INR ${taxes1.toStringAsFixed(2)}",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                          // const Icon(
                                          //   Icons.question_mark,
                                          //   color: Colors.grey,
                                          //   size: 18,
                                          // )
                                        ],
                                      )),
                                    ],
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //         "${widget.adultCount} ${widget.adulttaxfare}",
                                  //         style: GoogleFonts.poppins(
                                  //             color: Colors.black,
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w500)),
                                  //     Text(
                                  //         "${widget.childCount} ${widget.childtaxfare}",
                                  //         style: GoogleFonts.poppins(
                                  //             color: Colors.black,
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w500)),
                                  //     Text(
                                  //         "${widget.infantCount} ${widget.infanttaxfare}",
                                  //         style: GoogleFonts.poppins(
                                  //             color: Colors.black,
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w500)),
                                  //   ],
                                  // ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total:",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                      Text("INR ${total1.toStringAsFixed(2)}",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Including all taxes and fees",
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              left: 20,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xffbd0c21),
                                            Color(0xff35459c)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 1, right: 5),
                                      child: Text("Onward Trip Fare",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  )))
                        ]),
                        const SizedBox(
                          height: 5,
                        ),
                        Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 15, top: 20, bottom: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: const Color(0xff35459c))),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Base Fare",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                          child: Row(
                                        children: [
                                          Text(
                                              "INR ${basefare2.toStringAsFixed(2)}",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Taxes and Fees",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                          child: Row(
                                        children: [
                                          Text(
                                              "INR ${taxes2.toStringAsFixed(2)}",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total:",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                      Text("INR ${total2.toStringAsFixed(2)}",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Including all taxes and fees",
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              left: 20,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xffbd0c21),
                                            Color(0xff35459c)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 1, right: 5),
                                      child: Text("Return Trip Fare",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  )))
                        ]),
                        Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 15, top: 15, bottom: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: const Color(0xff35459c))),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Convenience Fee:",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text("INR 200.00",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Grand Total:",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        "INR ${(grandTotal1 + grandTotal2).toStringAsFixed(2)}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              left: 20,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xffbd0c21),
                                            Color(0xff35459c)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 1, right: 5),
                                      child: Text("Total Fare",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  )))
                        ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 15, top: 15, bottom: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: const Color(0xff35459c))),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text("Apply Promo",
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            hintText: "Enter Your Promo code",
                                            hintStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 15),
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    12, 10, 10, 10),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffC2C2C2))),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffC2C2C2))),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffC2C2C2))),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.pink.shade300,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2))),
                                        child: Text("APPLY",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)))
                                  ]),
                                  // const SizedBox(
                                  //   height: 15,
                                  // ),
                                  // DottedBorder(
                                  //     color: Colors.green,
                                  //     strokeWidth: 1.5,
                                  //     dashPattern: [3, 3],
                                  //     child: Container(
                                  //         height: 30,
                                  //         width: 180,
                                  //         child: const Center(
                                  //             child: Text(
                                  //           "",
                                  //           style: TextStyle(
                                  //               fontSize: 14.0,
                                  //               color: Colors.green),
                                  //         )))),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              left: 20,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xffbd0c21),
                                            Color(0xff35459c)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 1, right: 5),
                                      child: Text("Apply Promo",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  )))
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Card(
                    color: Colors.white,
                    shadowColor: Colors.blue.shade50,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Container(
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Checkbox(
                                      side: BorderSide(
                                          color: Colors.grey.shade400),
                                      activeColor: Colors.blue,
                                      value: firstValue,
                                      onChanged: (value) {
                                        setState(() {
                                          firstValue = value!;
                                        });
                                      },
                                      visualDensity:
                                          const VisualDensity(horizontal: -3)),
                                  Expanded(
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: 'I Agree To All The',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            TextSpan(
                                                text: ' Terms & Conditions ',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.blue,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            TextSpan(
                                                text: 'and ',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            TextSpan(
                                                text: ' Privacy Policy. ',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.blue,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ]))))
                                ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (phoneController.text.isEmpty ||
                                            emailController.text.isEmpty ||
                                            addressController.text.isEmpty ||
                                            !firstValue) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Please fill Contact Details & Accept Terms & Conditions'),
                                            ),
                                          );
                                          return;
                                        }

                                        for (var i = 0;
                                            i < widget.adultCount;
                                            i++) {
                                          if (firstnameAdultControllers[i]
                                                  .text
                                                  .isEmpty ||
                                              lastNameAdultControllers[i]
                                                  .text
                                                  .isEmpty ||
                                              dobAdultControllers[i]
                                                  .text
                                                  .isEmpty ||
                                              nationalityAdultControllers[i]
                                                  .text
                                                  .isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Please fill all required fields'),
                                              ),
                                            );
                                            return;
                                          }
                                          DateTime dobAdult;
                                          try {
                                            String formattedDate =
                                                convertDateformat(
                                                    dobAdultControllers[i]
                                                        .text);
                                            dobAdult =
                                                DateTime.parse(formattedDate);

                                            int ageInYears = DateTime.now()
                                                    .difference(dobAdult)
                                                    .inDays ~/
                                                365;

                                            if (DateTime.now().isBefore(
                                                DateTime(
                                                    dobAdult.year + ageInYears,
                                                    dobAdult.month,
                                                    dobAdult.day))) {
                                              ageInYears--;
                                            }

                                            if (ageInYears < 12) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Adults must be 12 years or older.')),
                                              );
                                              return;
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Invalid date format. Please use DD-MM-YYYY.')),
                                            );
                                            return;
                                          }
                                        }

                                        for (var i = 0;
                                            i < widget.childCount;
                                            i++) {
                                          if (firstnameChildrenControllers[i]
                                                  .text
                                                  .isEmpty ||
                                              lastNameChildrenControllers[i]
                                                  .text
                                                  .isEmpty ||
                                              dobChildrenControllers[i]
                                                  .text
                                                  .isEmpty ||
                                              nationalityChildrenControllers[i]
                                                  .text
                                                  .isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Please fill all required fields'),
                                              ),
                                            );
                                            return;
                                          }

                                          DateTime dobChild;
                                          try {
                                            String formattedDate =
                                                convertDateformat(
                                                    dobChildrenControllers[i]
                                                        .text);
                                            dobChild =
                                                DateTime.parse(formattedDate);

                                            int ageInYears = DateTime.now()
                                                    .difference(dobChild)
                                                    .inDays ~/
                                                365;

                                            if (DateTime.now().isBefore(
                                                DateTime(
                                                    dobChild.year + ageInYears,
                                                    dobChild.month,
                                                    dobChild.day))) {
                                              ageInYears--;
                                            }

                                            if (ageInYears < 2 ||
                                                ageInYears > 12) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Children must be between 2 and 12 years old.')),
                                              );
                                              return;
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Invalid date format. Please use DD-MM-YYYY.')),
                                            );
                                            return;
                                          }
                                        }

                                        for (var i = 0;
                                            i < widget.infantCount;
                                            i++) {
                                          if (firstnameInfantControllers[i]
                                                  .text
                                                  .isEmpty ||
                                              lastNameInfantControllers[i]
                                                  .text
                                                  .isEmpty ||
                                              dobInfantControllers[i]
                                                  .text
                                                  .isEmpty ||
                                              nationalityInfantControllers[i]
                                                  .text
                                                  .isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Please fill all required fields'),
                                              ),
                                            );
                                            return;
                                          }

                                          DateTime dobInfant;
                                          try {
                                            String formattedDate =
                                                convertDateformat(
                                                    dobInfantControllers[i]
                                                        .text);
                                            dobInfant =
                                                DateTime.parse(formattedDate);

                                            int ageInYears = DateTime.now()
                                                    .difference(dobInfant)
                                                    .inDays ~/
                                                365;

                                            if (DateTime.now().isBefore(
                                                DateTime(
                                                    dobInfant.year + ageInYears,
                                                    dobInfant.month,
                                                    dobInfant.day))) {
                                              ageInYears--;
                                            }

                                            if (ageInYears >= 2) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Infants must be under 2 years old.')),
                                              );
                                              return;
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Invalid date format. Please use DD-MM-YYYY.')),
                                            );
                                            return;
                                          }
                                        }
                                        addData();
                                        flightFormModel.userId = int.parse(
                                            SharedPrefServices.getcustomerId()
                                                .toString());
                                        // int.parse(
                                        //     SharedPrefServices.getcustomerId()
                                        //         .toString());
                                        flightFormModel.pgType = 3;
                                        flightFormModel.traceId =
                                            widget.traceId1;
                                        flightFormModel.passengers = passengers;
                                        flightFormModel.gstDetails = GstDetails(
                                            gstAddressLine1: "",
                                            gstAddressLine2: '',
                                            gstCity: '',
                                            gstState: '',
                                            gstpinCode: '',
                                            gstEmailId: '',
                                            gstNumber: '',
                                            gstPhoneNo: '',
                                            gstCompanyName: '');
                                        flightFormModel.creditCardInfo = '';
                                        flightFormModel.convienenceId = 0;
                                        flightFormModel.promoData = '';
                                        flightFormModel.insuranceRequired = 0;
                                        flightFormModel.totalPrice =
                                            grandTotal1;

                                        flightPriceRequestModel.userId =
                                            int.parse(SharedPrefServices
                                                    .getcustomerId()
                                                .toString());
                                        flightPriceRequestModel.roleType = 5;
                                        flightPriceRequestModel.membership = 1;
                                        flightPriceRequestModel.traceId =
                                            widget.traceId1;
                                        flightPriceRequestModel.flightIds = [
                                          widget.flightId1,
                                          widget.flightId2
                                        ];
                                        flightPriceRequestModel
                                            .selectedFlights = [
                                          flightPrice.SelectedFlight(
                                              fareId: widget.fareId1,
                                              flightId: widget.flightId1,
                                              coupanType: 'Publish',
                                              fareType: 'Publish',
                                              subCabinClass: 'RR'),

                                          flightPrice.SelectedFlight(
                                              fareId: widget.fareId2,
                                              flightId: widget.flightId2,
                                              coupanType: 'Publish',
                                              fareType: 'Publish',
                                              subCabinClass: 'RR'),

                                          // flightPrice.SelectedFlight(
                                          // fareId: widget.fareId2,
                                          // flightId: widget.flightId2,
                                          // coupanType: 'Discount',
                                          // fareType: 'Economy',
                                          // subCabinClass: 'A'),
                                        ];
                                        flightPriceRequestModel.airTravelType =
                                            'roundTrip';
                                        flightPriceRequestModel.mappingType =
                                            'SEPARATE';
                                        flightPriceRequestModel
                                            .itineraryViewType = '1';
                                        flightPriceRequestModel.gstDetails =
                                            flightPrice.GstDetails(
                                                gstAddressLine1: '',
                                                gstAddressLine2: '',
                                                gstCity: '',
                                                gstState: '',
                                                gstpinCode: '',
                                                gstEmailId: '',
                                                gstNumber: '',
                                                gstPhoneNo: '',
                                                gstCompanyName: '');

                                        // need to print ...
                                        print('flight form model');
                                        print(flightFormModel);
                                        print('flightPrice...by balaji');
                                        print(flightPriceRequestModel);
                                        print('Inspect check');
                                        inspect(flightPriceRequestModel);

                                        // flightBlock();

                                        // print(flightFormModel);
                                        // inspect(flightFormModel);

                                        APIService apiService = APIService();
                                        print('Service check');
                                        setState(() {
                                          isApiCallProcess = true;
                                        });

                                        apiService
                                            .flightOnewayPrice(
                                                flightPriceRequestModel)
                                            .then((value) async {
                                          if (value.statusCode == 203) {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                          } else if (value.statusCode == 401) {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                          } else if (value.statusCode == 400) {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                          } else if (value.statusCode == 404) {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                          } else if (value.statusCode == 200 ||
                                              value.statusCode == 201) {
                                            apiService
                                                .flightRoundTripBlock(
                                                    flightFormModel)
                                                .then((value) async {
                                              // bookingRefNo = value
                                              //     .data.bookingRefNo
                                              //     .toString();
                                              inspect(flightFormModel);
                                              print('balaji testing airblock');
                                              print(value.statusCode);
                                              if (value.statusCode == 203) {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                              } else if (value.statusCode ==
                                                  401) {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                              } else if (value.statusCode ==
                                                  400) {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                              } else if (value.statusCode ==
                                                  404) {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                              } else if (value.statusCode ==
                                                      200 ||
                                                  value.statusCode == 201) {
                                                print('balaji testing RefID');
                                                bookingRefNo = value
                                                    .data.bookingRefNo
                                                    .toString();

                                                // bookingRefNo = value
                                                //     .data.bookingRefNo
                                                //     .toString();
                                                // setState(() {
                                                //   // isApiCallProcess = false;
                                                // });

                                                print(
                                                    "Block url is working perfect uday");

                                                print(
                                                    "bookingRefId $bookingRefNo");

                                                if (bookingRefNo.isNotEmpty) {
                                                  //  book..
                                                  apiService
                                                      .flightOnewayBook(
                                                          bookingRefNo)
                                                      .then((value) async {
                                                    if (value.statusCode ==
                                                        203) {
                                                      setState(() {
                                                        isApiCallProcess =
                                                            false;
                                                      });
                                                    } else if (value
                                                            .statusCode ==
                                                        401) {
                                                      setState(() {
                                                        isApiCallProcess =
                                                            false;
                                                      });
                                                    } else if (value
                                                            .statusCode ==
                                                        400) {
                                                      setState(() {
                                                        isApiCallProcess =
                                                            false;
                                                      });
                                                    } else if (value
                                                            .statusCode ==
                                                        404) {
                                                      setState(() {
                                                        isApiCallProcess =
                                                            false;
                                                      });
                                                    } else if (value
                                                                .statusCode ==
                                                            200 ||
                                                        value.statusCode ==
                                                            201) {
                                                      print(bookingRefNo);
                                                      print(
                                                          'balaji testing success');
                                                      String pnr = value.charges
                                                          .ticketAllData.pnr
                                                          .toString();
                                                      String operator = value
                                                          .charges
                                                          .ticketAllData
                                                          .ticketAllDataOperator
                                                          .toString();
                                                      String referenceNumber =
                                                          value
                                                              .charges
                                                              .ticketAllData
                                                              .referenceNumber
                                                              .toString();
                                                      String journeyDate = value
                                                          .charges
                                                          .ticketAllData
                                                          .journeyDate
                                                          .toString();
                                                      String bookingDate = value
                                                          .charges
                                                          .ticketAllData
                                                          .bookingDate
                                                          .toString();
                                                      String bookingStatus =
                                                          value
                                                              .charges
                                                              .ticketAllData
                                                              .bookingStatus
                                                              .toString();
                                                      final flightData = value
                                                          .charges
                                                          .ticketAllData
                                                          .oneWaySegment;
                                                      final baggageInfo = value
                                                          .charges
                                                          .ticketAllData
                                                          .oneWayBaggageInfo;
                                                      final passengerInfo =
                                                          value
                                                              .charges
                                                              .ticketAllData
                                                              .passengers;
                                                      final fareData = value
                                                          .charges
                                                          .ticketAllData
                                                          .oneWayflightFare;

                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return TicketView(
                                                              operator:
                                                                  operator,
                                                              pnr: pnr,
                                                              referenceNumber:
                                                                  referenceNumber,
                                                              journeyDate:
                                                                  journeyDate,
                                                              bookingDate:
                                                                  bookingDate,
                                                              bookingStatus:
                                                                  bookingStatus,
                                                              flightData:
                                                                  flightData,
                                                              baggageInfo:
                                                                  baggageInfo,
                                                              passengerInfo:
                                                                  passengerInfo,
                                                              fareData:
                                                                  fareData,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    } else {
                                                      setState(() {
                                                        isApiCallProcess =
                                                            false;
                                                      });
                                                    }
                                                  });
                                                } else {
                                                  print("bookingRefId is null");
                                                  setState(() {
                                                    isApiCallProcess = false;
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                              }
                                            });
                                          } else {
                                            setState(() {
                                              isApiCallProcess = false;
                                            });
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade800,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                      child: Text("Continue",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600))),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )))),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// this buildAdultContainers widget is to create adult containers dynamic

  Widget buildAdultContainers() {
    List<Widget> adultContainers = [];
    for (int i = 0; i < widget.adultCount; i++) {
      adultContainers.add(
        Column(
          children: [
            Card(
              color: Colors.white,
              shadowColor: Colors.blue.shade50,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Adult",
                          style: GoogleFonts.poppins(
                              color: Colors.orangeAccent.shade400,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Title",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                      size: 35,
                                    ),
                                    value: adult[i],
                                    onChanged: (newValue) {
                                      setState(() {
                                        adult[i] = newValue!;
                                        titleAdultControllers[i] = newValue;
                                      });
                                    },
                                    items: adult.map((String items) {
                                      return DropdownMenuItem<String>(
                                          value: items,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3, left: 10),
                                            child: Text(
                                              items,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ));
                                    }).toList(),
                                  ))),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("First Name",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 14),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    controller: firstnameAdultControllers[i],
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    //
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Last Name",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 14),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      controller: lastNameAdultControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Date Of Birth",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 14),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      controller: dobAdultControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2101),
                                        );

                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(pickedDate);

                                          setState(() {
                                            dobAdultControllers[i].text =
                                                formattedDate;
                                          });
                                        }
                                      },
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Passenger Nationality",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 14),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      controller:
                                          nationalityAdultControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                          ])),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      );
    }
    return Column(children: adultContainers);
  }

// this buildChildrenContainers widget is to create children containers dynamic
  Widget buildChildrenContainers() {
    List<Widget> childrenContainers = [];
    for (int i = 0; i < widget.childCount; i++) {
      childrenContainers.add(
        Column(children: [
          Card(
            color: Colors.white,
            shadowColor: Colors.blue.shade50,
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Container(
                margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Child",
                        style: GoogleFonts.poppins(
                            color: Colors.orangeAccent.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text(
                                "*",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("Title",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: const Color(0xffC2C2C2)),
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                    size: 35,
                                  ),
                                  value: childTitile[i],
                                  onChanged: (newValue) {
                                    setState(() {
                                      childTitile[i] = newValue!;
                                      titleChildrenControllers[i] = newValue;
                                    });
                                  },
                                  items: child.map((String items) {
                                    return DropdownMenuItem<String>(
                                        value: items,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3, left: 10),
                                          child: Text(
                                            items,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ));
                                  }).toList(),
                                ))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text(
                                "*",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("First Name",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: const Color(0xffC2C2C2))),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 14),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    controller: firstnameChildrenControllers[i],
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ))),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text(
                                "*",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("Last Name",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: const Color(0xffC2C2C2))),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 14),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    controller: lastNameChildrenControllers[i],
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ))),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text(
                                "*",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("Date Of Birth",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: const Color(0xffC2C2C2))),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 14),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    controller: dobChildrenControllers[i],
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2101),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);

                                        setState(() {
                                          dobChildrenControllers[i].text =
                                              formattedDate;
                                        });
                                      }
                                    },
                                  ))),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text(
                                "*",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("Passenger Nationality",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: const Color(0xffC2C2C2))),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 14),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    controller:
                                        nationalityChildrenControllers[i],
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ))),
                          const SizedBox(
                            height: 10,
                          ),
                        ])),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ]),
      );
    }
    return Column(children: childrenContainers);
  }

// this buildInfantContainers widget is to create Infant containers dynamic
  Widget buildInfantContainers() {
    List<Widget> infantContainers = [];
    for (int i = 0; i < widget.infantCount; i++) {
      infantContainers.add(
        Column(
          children: [
            Card(
              color: Colors.white,
              shadowColor: Colors.blue.shade50,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Infant",
                          style: GoogleFonts.poppins(
                              color: Colors.orangeAccent.shade400,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Title",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                      size: 35,
                                    ),
                                    value: infantTitile[i],
                                    onChanged: (newValue) {
                                      setState(() {
                                        infantTitile[i] = newValue!;
                                        titleInfantControllers[i] = newValue;
                                      });
                                    },
                                    items: infant.map((String items) {
                                      return DropdownMenuItem<String>(
                                          value: items,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3, left: 10),
                                            child: Text(
                                              items,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ));
                                    }).toList(),
                                  ))),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("First Name",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 14),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      controller: firstnameInfantControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Last Name",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 14),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      controller: lastNameInfantControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Date Of Birth",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 14),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      controller: dobInfantControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2101),
                                        );

                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(pickedDate);

                                          setState(() {
                                            dobInfantControllers[i].text =
                                                formattedDate;
                                          });
                                        }
                                      },
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Passenger Nationality",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 14),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      controller:
                                          nationalityInfantControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                          ])),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      );
    }
    return Column(children: infantContainers);
  }

// all the below methods are used to create dynamic controllers
  createtitleAdultControllers() {
    titleAdultControllers = [];

    for (var i = 0; i < widget.adultCount; i++) {
      titleAdultControllers.add('MR');
      adultTitile.add('MR');
    }
  }

  createfirstnameAdultControllers() {
    firstnameAdultControllers = [];
    for (var i = 0; i < widget.adultCount; i++) {
      firstnameAdultControllers.add(TextEditingController());
    }
  }

  createlastNameAdultControllers() {
    lastNameAdultControllers = [];
    for (var i = 0; i < widget.adultCount; i++) {
      lastNameAdultControllers.add(TextEditingController());
    }
  }

  createnationalityAdultControllers() {
    nationalityAdultControllers = [];
    for (var i = 0; i < widget.adultCount; i++) {
      nationalityAdultControllers.add(TextEditingController());
    }
  }

  createdobAdultControllers() {
    dobAdultControllers = [];
    for (var i = 0; i < widget.adultCount; i++) {
      dobAdultControllers.add(TextEditingController());
    }
  }

  createtitleChildrenControllers() {
    titleChildrenControllers = [];
    for (var i = 0; i < widget.childCount; i++) {
      titleChildrenControllers.add('MSTR');
      childTitile.add('MSTR');
    }
  }

  createfirstnameChildrenControllers() {
    firstnameChildrenControllers = [];
    for (var i = 0; i < widget.childCount; i++) {
      firstnameChildrenControllers.add(TextEditingController());
    }
  }

  createlastNameChildrenControllers() {
    lastNameChildrenControllers = [];
    for (var i = 0; i < widget.childCount; i++) {
      lastNameChildrenControllers.add(TextEditingController());
    }
  }

  createnationalityChildrenControllers() {
    nationalityChildrenControllers = [];
    for (var i = 0; i < widget.childCount; i++) {
      nationalityChildrenControllers.add(TextEditingController());
    }
  }

  createdobChildrenControllers() {
    dobChildrenControllers = [];
    for (var i = 0; i < widget.childCount; i++) {
      dobChildrenControllers.add(TextEditingController());
    }
  }

  createtitleInfantControllers() {
    titleInfantControllers = [];
    for (var i = 0; i < widget.infantCount; i++) {
      titleInfantControllers.add('MSTR');
      infantTitile.add('MSTR');
    }
  }

  createfirstnameInfantControllers() {
    firstnameInfantControllers = [];
    for (var i = 0; i < widget.infantCount; i++) {
      firstnameInfantControllers.add(TextEditingController());
    }
  }

  createlastNameInfantControllers() {
    lastNameInfantControllers = [];
    for (var i = 0; i < widget.infantCount; i++) {
      lastNameInfantControllers.add(TextEditingController());
    }
  }

  createnationalityInfantControllers() {
    nationalityInfantControllers = [];
    for (var i = 0; i < widget.infantCount; i++) {
      nationalityInfantControllers.add(TextEditingController());
    }
  }

  createdobInfantControllers() {
    dobInfantControllers = [];
    for (var i = 0; i < widget.infantCount; i++) {
      dobInfantControllers.add(TextEditingController());
    }
  }

  Future<FlightsblockResponse> flightBlock() async {
    String url = "http://anjmal.i2space.in/api/v1/flights/airBlock";
    print(url);
    // print("response.body FlightBlockrequestModel ${flightFormModel.toJson()}");
    Map<String, String> airBlockheaders = {
      "Content-Type": "application/json",
    };
    Map jsonBody = {
      "traceId": "138837507375704620000\$tr",
      "userId": 1,
      "roleType": 5,
      "membership": 1,
      "passengers": passengers,

      // [
      //   {
      //     "title": "MR",
      //     "firstName": "dabl",
      //     "lastName": "bk",
      //     "paxType": "ADT",
      //     "pax": 1,
      //     "email": "mailto:db@i2space.com",
      //     "dob": "2000-02-02",
      //     "gender": "m",
      //     "mobile": "7981895061",
      //     "passengerNationality": "India",
      //     "areaCode": "+93",
      //     "address_CountryCode": "",
      //     "address": "hyd",
      //     "additionalServicesIds": []
      //   }
      // ],
      "additional_services": [],
      "creditCardInfo": "",
      "insuranceRequired": 0,
      "promoCode": "",
      "convienenceId": 51,
      "pgType": 3,
      "totalPrice": 8491.3,
      "isCouponReedem": false,
      "currency": "INR"
    };
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(jsonBody), headers: airBlockheaders);

      print("response.body FlightBlockrequestPOST ${response.body}");
      print("response.body statusCode ${response.statusCode}");

      if (response.statusCode == 200) {
        showToast("Flight Block Done Successfully");
      } else if (response.statusCode == 201 ||
          response.statusCode == 203 ||
          response.statusCode == 400 ||
          response.statusCode == 401) {
        showToast("Flight Block Done Successfully");
        return flightsblockResponseFromJson(response.body);
      }
    } catch (e) {
      print(e.toString());
    }

    throw Exception('Failed to load Data');
  }
}

// model class for the final list of passangers
// class Passenger {
//   String title;
//   String firstName;
//   String lastName;
//   // String nationality;
//   int pax;
//   String paxType;

//   String email;
//   String dob;
//   String gender;
//   String mobile;
//   // String passportIssuedCountry;
//   // String passportDOE;
//   // String passportNumber;
//   String passengerNationality;
//   String areaCode;
//   String address_CountryCode;
//   String address;
//   List additionalServicesIds;

//   Passenger(
//       {required this.title,
//       required this.firstName,
//       required this.lastName,
//       // required this.nationality,
//       required this.pax,
//       required this.paxType,
//       required this.email,
//       required this.dob,
//       required this.gender,
//       required this.mobile,
//       // required this.passportIssuedCountry,
//       // required this.passportDOE,
//       // required this.passportNumber,
//       required this.passengerNationality,
//       required this.areaCode,
//       required this.address_CountryCode,
//       required this.address,
//       required this.additionalServicesIds});
// }
