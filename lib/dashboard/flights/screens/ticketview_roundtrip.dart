import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/dashboard/flights/models/one_way_book_response.dart';

import 'package:outc/dashboard/flights/widgets/colors.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class TicketView extends StatefulWidget {
  final String pnr;
  final String operator;
  final String referenceNumber;
  final String journeyDate;
  final String bookingDate;
  final String bookingStatus;
  List<OneWayBaggageInfo> baggageInfo;
  List<Passenger> passengerInfo;
  List<OneWaySegment> flightData;
  List<OneWaySegment> returnFlight;
  final YflightFare fareData;

  TicketView({
    super.key,
    required this.pnr,
    required this.operator,
    required this.referenceNumber,
    required this.journeyDate,
    required this.bookingDate,
    required this.bookingStatus,
    required this.baggageInfo,
    required this.passengerInfo,
    required this.flightData,
    required this.fareData,
    required this.returnFlight,
  });

  @override
  State<TicketView> createState() => _TicketViewState();
}

String formatDate(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime);
  String formattedDate = DateFormat('dd-MMM-yyyy').format(parsedDate);
  return formattedDate;
}

String extractTime(DateTime? dateTime) {
  if (dateTime == null) {
    return "Empty";
  }
  return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

String duration(DateTime departureDateTime, DateTime arrivalDateTime) {
  Duration difference = arrivalDateTime.difference(departureDateTime);

  int hours = difference.inHours;
  int minutes = difference.inMinutes.remainder(60);

  return "${hours}hr ${minutes}min";
}

class _TicketViewState extends State<TicketView> {
  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.white,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
          child: SizedBox(
            height: 45,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffbd0c21), // Start color
                      Color(0xff35459c), // End color
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Back To Home',
                    style: GoogleFonts.poppins(
                      color: Colors.white, // Text color
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
            child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffbd0c21),
                            Color(0xff35459c),
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Journey Date",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(formatDate(widget.journeyDate),
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("PNR/Booking No",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(widget.pnr,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Ticket Ref No",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(widget.referenceNumber,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Status",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(widget.bookingStatus,
                                              style: GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xff008000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Booking Date",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(formatDate(widget.bookingDate),
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Payment Status",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text('Paid',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      Text("Travel Information",
                                          style: GoogleFonts.poppins(
                                              color: const Color(0xff35459c),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 10),
                                      Text("Onward Details",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                      RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            const TextSpan(
                                                text:
                                                    'Here are the details of your flight from '),
                                            TextSpan(
                                              text:
                                                  '${widget.flightData[0].origin} to ',
                                            ),
                                            TextSpan(
                                              text: widget.flightData.length > 1
                                                  ? widget
                                                      .flightData[1].destination
                                                  : widget.flightData[0]
                                                      .destination,
                                            ),
                                            TextSpan(
                                              text:
                                                  '  on ${formatDate(widget.journeyDate)}',
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                          children: [
                                            TextSpan(
                                              text: widget.operator,
                                            ),
                                            TextSpan(
                                                text:
                                                    '(${widget.flightData[0].airlineName}-${widget.flightData[0].flightNumber})',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  widget
                                                      .flightData[0].originCity,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text("Source",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            size: 25,
                                            color: Color(0xff35459c),
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      widget.flightData[0]
                                                          .destinationCity,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                  Text("Destination",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(widget.flightData[0].origin,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black)),
                                              const SizedBox(height: 0),
                                              Text(
                                                  extractTime(widget
                                                      .flightData[0]
                                                      .departureDateTime),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xff35459c))),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: List.generate(
                                                      20,
                                                      (index) => const Text(
                                                            '-',
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          )),
                                                ),
                                                const SizedBox(height: 0),
                                                Text(
                                                    duration(
                                                        widget.flightData[0]
                                                            .departureDateTime,
                                                        widget.flightData[0]
                                                            .arrivalDateTime),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xff35459c))),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                  widget.flightData[0]
                                                      .destination,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black)),
                                              const SizedBox(height: 0),
                                              Text(
                                                  extractTime(widget
                                                      .flightData[0]
                                                      .arrivalDateTime),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xff35459c))),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text("Return Details",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                      RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            const TextSpan(
                                                text:
                                                    'Here are the details of your flight from '),
                                            TextSpan(
                                              text:
                                                  '${widget.returnFlight[0].origin} to ',
                                            ),
                                            TextSpan(
                                              text: widget.flightData.length > 1
                                                  ? widget
                                                      .flightData[1].destination
                                                  : widget.flightData[0]
                                                      .destination,
                                            ),
                                            TextSpan(
                                              text:
                                                  '  on ${formatDate(widget.journeyDate)}',
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                          children: [
                                            TextSpan(
                                              text: widget.operator,
                                            ),
                                            TextSpan(
                                                text:
                                                    '(${widget.returnFlight[0].airlineName}-${widget.returnFlight[0].flightNumber})',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  widget.returnFlight[0]
                                                      .originCity,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text("Source",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            size: 25,
                                            color: Color(0xff35459c),
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      widget.returnFlight[0]
                                                          .destinationCity,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                  Text("Destination",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                  widget.returnFlight[0].origin,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black)),
                                              const SizedBox(height: 0),
                                              Text(
                                                  extractTime(widget
                                                      .returnFlight[0]
                                                      .departureDateTime),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xff35459c))),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: List.generate(
                                                      20,
                                                      (index) => const Text(
                                                            '-',
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          )),
                                                ),
                                                const SizedBox(height: 0),
                                                Text(
                                                    duration(
                                                        widget.returnFlight[0]
                                                            .departureDateTime,
                                                        widget.returnFlight[0]
                                                            .arrivalDateTime),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xff35459c))),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                  widget.returnFlight[0]
                                                      .destination,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black)),
                                              const SizedBox(height: 0),
                                              Text(
                                                  extractTime(widget
                                                      .returnFlight[0]
                                                      .arrivalDateTime),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xff35459c))),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.luggage),
                                          Text("Baggage Included",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Check IN",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text(
                                                  widget.baggageInfo[0]
                                                      .baggageInfo,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Hand Baggage",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text(
                                                  widget.baggageInfo[0]
                                                      .cabinBaggageInfo,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (widget.returnFlight.length > 1)
                                        const SizedBox(height: 15),
                                      if (widget.returnFlight.length > 1)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                children: [
                                                  TextSpan(
                                                    text: widget.operator,
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          '(${widget.returnFlight[1].airlineName}-${widget.returnFlight[1].flightNumber})',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        widget.returnFlight[1]
                                                            .originCity,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                    Text("Source",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))
                                                  ],
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 25,
                                                  color: Color(0xff35459c),
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            widget
                                                                .returnFlight[1]
                                                                .destinationCity,
                                                            style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        Text("Destination",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                        widget.returnFlight[1]
                                                            .origin,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black)),
                                                    const SizedBox(height: 0),
                                                    Text(
                                                        extractTime(widget
                                                            .returnFlight[1]
                                                            .departureDateTime),
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xff35459c))),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: List.generate(
                                                            20,
                                                            (index) =>
                                                                const Text(
                                                                  '-',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                )),
                                                      ),
                                                      const SizedBox(height: 0),
                                                      Text(
                                                          duration(
                                                              widget
                                                                  .returnFlight[
                                                                      1]
                                                                  .departureDateTime,
                                                              widget
                                                                  .returnFlight[
                                                                      1]
                                                                  .arrivalDateTime),
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color(
                                                                  0xff35459c))),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                        widget.returnFlight[1]
                                                            .destination,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black)),
                                                    const SizedBox(height: 0),
                                                    Text(
                                                        extractTime(widget
                                                            .returnFlight[1]
                                                            .arrivalDateTime),
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xff35459c))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Icon(Icons.luggage),
                                                Text("Baggage Included",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Check IN",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    Text(
                                                        widget.baggageInfo[1]
                                                            .baggageInfo,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Hand Baggage",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    Text(
                                                        widget.baggageInfo[1]
                                                            .cabinBaggageInfo,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      Text("Contact Details",
                                          style: GoogleFonts.poppins(
                                              color: const Color(0xff35459c),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      Text(
                                          'Any Communication by airlines will be sent to these details',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Name",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(
                                              '${widget.passengerInfo[0].firstName} ${widget.passengerInfo[0].lastName}',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Mobile Number",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(widget.passengerInfo[0].mobile,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Email",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(widget.passengerInfo[0].email,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Nationality",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(
                                              widget.passengerInfo[0]
                                                  .passengerNationality,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      Text("Passenger Details",
                                          style: GoogleFonts.poppins(
                                              color: const Color(0xff35459c),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 10),
                                      ...List.generate(
                                          widget.passengerInfo.length, (index) {
                                        final passenger =
                                            widget.passengerInfo[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Pax Name",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '${passenger.firstName} ${passenger.lastName}',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Pax Type",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    passenger.paxType,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "DOB",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    formatDate(passenger.dob
                                                        .toString()),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text("Fare Details",
                                          style: GoogleFonts.poppins(
                                              color: const Color(0xff35459c),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Base Fare",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(
                                              'INR ${widget.fareData.baseFare.toString()}',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Surge and Taxes:YQ:",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(
                                              'INR ${widget.fareData.tax.toString()}',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Grand Total",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 10),
                                          Text(
                                              'INR ${widget.fareData.totalFare.toString()}',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text("Terms & Conditions",
                                          style: GoogleFonts.poppins(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      Text(widget.pnr,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 5),
                                      Text("PNR",
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10,
                      left: 20,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, top: 1, right: 5),
                            child: Text("Anjmal Travels",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xffbd0c21),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        )));
  }
}
