// ignore_for_file: must_be_immutable

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:outc/dashboard/flights/models/flight_roundtrip_model.dart';
// import 'package:outc/dashboard/flights/models/flights_list_model.dart';
// import 'package:outc/dashboard/flights/screens/book_flight_formpage.dart';
// import 'package:outc/widgets/colors/colors.dart';

// class FetchedFlightsList extends StatefulWidget {
//   List<DataFlightDetail>? flightsdata;
//   int noOfFlights;
//   int adultcount, childcount, infantcount;
//   String traceId;
//   FetchedFlightsList(
//       {super.key,
//       required this.flightsdata,
//       required this.noOfFlights,
//       required this.adultcount,
//       required this.childcount,
//       required this.infantcount,
//       required this.traceId});

//   @override
//   State<FetchedFlightsList> createState() => _FetchedFlightsListState();
// }

// class _FetchedFlightsListState extends State<FetchedFlightsList> {
//   List<DataFlightDetail> filteredList = [];
//   List priceRange = [];
//   bool filterIcon = false;
//   bool flightDetailsFlag = false;
//   String traceId = "";
//   // for filter page
//   double _startValue = 0;
//   double _endValue = 0;
//   double? adultfare,
//       childfare,
//       infantfare,
//       adulttaxfare,
//       childtaxfare,
//       infanttaxfare;

//   final List<String> stops = ["Direct", "Multi"];
//   final List<bool> refundables = [true, false];
//   List<String> selectedStopFilters = [];
//   List<bool> selectedrefundablesFilters = [];
//   RangeValues _currentRangeValues = const RangeValues(0, 0);
//   @override
//   void initState() {
//     super.initState();
//     _currentRangeValues = RangeValues(
//         widget.flightsdata![0].fareFamilies!.fareFamilies![0].adultPublishFare!,
//         widget.flightsdata![widget.noOfFlights - 1].fareFamilies!
//             .fareFamilies![0].adultPublishFare!);

//     // updatedata();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _startValue =
//         widget.flightsdata![0].fareFamilies!.fareFamilies![0].adultPublishFare!;
//     _endValue = widget.flightsdata![widget.noOfFlights - 1].fareFamilies!
//         .fareFamilies![0].adultPublishFare!;

//     RangeLabels labels = RangeLabels(
//         _currentRangeValues.start.round().toString(),
//         _currentRangeValues.end.round().toString());

//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 10.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Icon(
//                             Icons.arrow_back_ios_new_outlined,
//                             color: Colours.veryDarkGrey,
//                             // color: Colors.transparent,
//                             size: 20,
//                           ),
//                         ),
//                         onTap: () {
//                           Navigator.pop(context, false);
//                         },
//                       ),
//                       Text(
//                         "Flights List",
//                         // ${filteredList.length}",
//                         style: TextStyle(
//                             fontFamily: 'poppins',
//                             fontSize: 16.0,
//                             color: Colours.strongRed,
//                             fontWeight: FontWeight.w700),
//                       ),
//                       GestureDetector(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Icon(
//                             Icons.filter_alt,
//                             color: Colours.strongRed,
//                             // color: Colors.transparent,
//                             size: 20,
//                           ),
//                         ),
//                         onTap: () {
//                           // setState(() {
//                           //   filterIcon = true;
//                           // });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 widget.flightsdata!.isEmpty
//                     ? Container()
//                     : Expanded(
//                         child: ListView.builder(
//                             itemCount: widget.flightsdata!.length,
//                             itemBuilder: (context, index) {
//                               return Container(
//                                 margin: const EdgeInsets.all(10),
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colours.strongRed,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.grey.shade100),
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       margin: const EdgeInsets.all(5),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               // Image(
//                                               //   image: NetworkImage(
//                                               //     filteredList[index]
//                                               //         .airLineLogo!,
//                                               //   ),
//                                               //   fit: BoxFit.fill,
//                                               //   height: 30.0,
//                                               //   width: 30.0,
//                                               // ),
//                                               Text(
//                                                 "${widget.flightsdata![index].flightDetails![0].airLineName} (${widget.flightsdata![index].flightDetails![0].airLine}-${widget.flightsdata![index].flightDetails![0].flightSegments![0].flightNumber})",
//                                                 style: TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colours.strongRed,
//                                                   fontFamily: 'Poppins',
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                             children: [
//                                               Text(
//                                                 widget
//                                                             .flightsdata![index]
//                                                             .flightDetails![0]
//                                                             .flightSegments!
//                                                             .length ==
//                                                         1
//                                                     ? "Direct"
//                                                     : "${widget.flightsdata![index].flightDetails![0].flightSegments!.length - 1} Stop",
//                                                 style: const TextStyle(
//                                                   fontSize: 12.0,
//                                                   color: Colors.black,
//                                                   fontFamily: 'Poppins',
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 "Class: Economy",
//                                                 style: TextStyle(
//                                                   fontSize: 12.0,
//                                                   color: Colors.black,
//                                                   fontFamily: 'Poppins',
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Text(
//                                       widget
//                                                   .flightsdata![index]
//                                                   .flightDetails![0]
//                                                   .isRefundable ==
//                                               true
//                                           ? "Refundable"
//                                           : "Non Refundable",
//                                       style: TextStyle(
//                                         fontSize: 12.0,
//                                         color: Colours.veryDarkGrey,
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: 'Poppins',
//                                       ),
//                                     ),
//                                     Container(
//                                       margin: const EdgeInsets.all(5),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             widget.flightsdata![index]
//                                                 .flightDetails![0].originCity
//                                                 .toString(),
//                                             style: const TextStyle(
//                                               fontSize: 14.0,
//                                               color: Colors.black,
//                                               fontFamily: 'Poppins',
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 150,
//                                             child: Divider(
//                                               color: Colours.strongRed,
//                                               thickness: 3,
//                                             ),
//                                           ),
//                                           Text(
//                                             widget
//                                                 .flightsdata![index]
//                                                 .flightDetails![0]
//                                                 .destinationCity
//                                                 .toString(),
//                                             style: const TextStyle(
//                                               fontSize: 14.0,
//                                               color: Colors.black,
//                                               fontFamily: 'Poppins',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       margin: const EdgeInsets.all(5),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             DateFormat('HH:mm').format(widget
//                                                     .flightsdata![index]
//                                                     .flightDetails![0]
//                                                     .flightSegments![0]
//                                                     .departureDateTime ??
//                                                 DateTime.now()),
//                                             style: const TextStyle(
//                                               fontSize: 12.0,
//                                               color: Colors.black,
//                                               fontFamily: 'Poppins',
//                                             ),
//                                           ),
//                                           Text(
//                                             "${widget.flightsdata![index].flightDetails![0].duration}",
//                                             style: const TextStyle(
//                                               fontSize: 12.0,
//                                               color: Colors.black,
//                                               fontFamily: 'Poppins',
//                                             ),
//                                           ),
//                                           Text(
//                                             DateFormat('HH:mm').format(widget
//                                                     .flightsdata![index]
//                                                     .flightDetails![0]
//                                                     .flightSegments![0]
//                                                     .arrivalDateTime ??
//                                                 DateTime.now()),
//                                             style: const TextStyle(
//                                               fontSize: 12.0,
//                                               color: Colors.black,
//                                               fontFamily: 'Poppins',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       height: 35,
//                                       decoration: const BoxDecoration(
//                                           gradient: LinearGradient(
//                                         colors: [
//                                           Color(0xffbd0c21),
//                                           Color(0xff35459c)
//                                         ],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       )),
//                                       child: const Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "  Use code OUTC200 to get FLAT 200.00",
//                                             style: TextStyle(
//                                               fontSize: 12.0,
//                                               color: Colors.white,
//                                               fontFamily: 'Poppins',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       margin: const EdgeInsets.only(
//                                           left: 5, right: 5, bottom: 5, top: 5),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           InkWell(
//                                             onTap: () {
//                                               setState(() {
//                                                 // need to fix
//                                                 flightDetailsFlag = true;
//                                               });
//                                             },
//                                             child: Row(
//                                               children: [
//                                                 Icon(
//                                                   Icons.info,
//                                                   size: 20,
//                                                   color:
//                                                       Colours.strongRed,
//                                                 ),
//                                                 Text(
//                                                   "Details",
//                                                   style: TextStyle(
//                                                     fontSize: 12.0,
//                                                     color:
//                                                         Colours.strongRed,
//                                                     fontFamily: 'Poppins',
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Text(
//                                             "INR ${filteredList[index].fareFamilies!.fareFamilies![0].adultPublishFare!.toStringAsFixed(2)}",
//                                             style: TextStyle(
//                                               fontSize: 14.0,
//                                               color: Colours.strongRed,
//                                               fontWeight: FontWeight.bold,
//                                               fontFamily: 'Poppins',
//                                             ),
//                                           ),
//                                           ElevatedButton(
//                                               onPressed: () {
//                                                 adultfare = filteredList[index]
//                                                     .fareFamilies!
//                                                     .fareFamilies![0]
//                                                     .adultNetFare!
//                                                     .toDouble();
//                                                 adulttaxfare =
//                                                     filteredList[index]
//                                                         .fareFamilies!
//                                                         .fareFamilies![0]
//                                                         .markup!
//                                                         .toDouble();
//                                                 childfare = filteredList[index]
//                                                     .fareFamilies!
//                                                     .fareFamilies![0]
//                                                     .childNetFare!
//                                                     .toDouble();
//                                                 childtaxfare = 0;
//                                                 infantfare = filteredList[index]
//                                                     .fareFamilies!
//                                                     .fareFamilies![0]
//                                                     .infantNetFare!
//                                                     .toDouble();
//                                                 infanttaxfare = 0;
//                                                 if (widget.adultcount != 0 &&
//                                                     widget.childcount ==
//                                                         0 &&
//                                                     widget.infantcount ==
//                                                         0) {
//                                                   adultfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![0]
//                                                           .amount!
//                                                           .toDouble();
//                                                   adulttaxfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![1]
//                                                           .amount!
//                                                           .toDouble();
//                                                   childfare = 0;
//                                                   childtaxfare = 0;
//                                                   infantfare = 0;
//                                                   infanttaxfare = 0;
//                                                 } else if (widget
//                                                             .adultcount !=
//                                                         0 &&
//                                                     widget.childcount !=
//                                                         0 &&
//                                                     widget.infantcount ==
//                                                         0) {
//                                                   adultfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![0]
//                                                           .amount!
//                                                           .toDouble();
//                                                   childfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![1]
//                                                           .amount!
//                                                           .toDouble();
//                                                   adulttaxfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![2]
//                                                           .amount!
//                                                           .toDouble();
//                                                   childtaxfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![3]
//                                                           .amount!
//                                                           .toDouble();
//                                                   infantfare = 0;
//                                                   infanttaxfare = 0;
//                                                 } else if (widget
//                                                             .adultcount !=
//                                                         0 &&
//                                                     widget.childcount !=
//                                                         0 &&
//                                                     widget.infantcount !=
//                                                         0) {
//                                                   adultfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![0]
//                                                           .amount!
//                                                           .toDouble();
//                                                   childfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![1]
//                                                           .amount!
//                                                           .toDouble();
//                                                   infantfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![2]
//                                                           .amount!
//                                                           .toDouble();
//                                                   adulttaxfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![3]
//                                                           .amount!
//                                                           .toDouble();

//                                                   childtaxfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![4]
//                                                           .amount!
//                                                           .toDouble();
//                                                   infanttaxfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![5]
//                                                           .amount!
//                                                           .toDouble();
//                                                 } else if (widget
//                                                             .adultcount !=
//                                                         0 &&
//                                                     widget.childcount ==
//                                                         0 &&
//                                                     widget.infantcount !=
//                                                         0) {
//                                                   adultfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![0]
//                                                           .amount!
//                                                           .toDouble();
//                                                   infantfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![1]
//                                                           .amount!
//                                                           .toDouble();
//                                                   adulttaxfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![2]
//                                                           .amount!
//                                                           .toDouble();
//                                                   infanttaxfare =
//                                                       filteredList[index]
//                                                           .fareFamilies!
//                                                           .fareFamilies![
//                                                               0]
//                                                           .flightFares![3]
//                                                           .amount!
//                                                           .toDouble();

//                                                   childfare = 0;
//                                                   childtaxfare = 0;
//                                                 }

//                                                 Navigator.of(context).push(
//                                                   MaterialPageRoute(
//                                                     builder:
//                                                         (BuildContext context) {
//                                                       // airlineLogo,

//                                                       return BookFlightFormpage(
//                                                           traceId: traceId,
//                                                           airlineLogo: widget
//                                                               .flightsdata![
//                                                                   index]
//                                                               .flightDetails![0]
//                                                               .airLineLogo!,
//                                                           airlineName:
//                                                               "${widget.flightsdata![index].flightDetails![0].airLineName} (${widget.flightsdata![index].flightDetails![0].airLine}-${widget.flightsdata![index].flightDetails![0].flightSegments![0].flightNumber})",
//                                                           airlineStop:
//                                                               widget.flightsdata![index].flightDetails![0].flightSegments!.length == 1
//                                                                   ? "Direct"
//                                                                   : "${widget.flightsdata![index].flightDetails![0].flightSegments!.length - 1} Stop",
//                                                           airlineClass:
//                                                               "Economy",
//                                                           airlineRefund:
//                                                               widget.flightsdata![index].flightDetails![0].isRefundable == true
//                                                                   ? "Refundable"
//                                                                   : "Non Refundable",
//                                                           airlineStart:
//                                                               widget.flightsdata![index].flightDetails![0].originCity
//                                                                   .toString(),
//                                                           airlineEnd: widget
//                                                               .flightsdata![
//                                                                   index]
//                                                               .flightDetails![0]
//                                                               .destinationCity
//                                                               .toString(),
//                                                           airlineStartTime: DateFormat('HH:mm').format(widget
//                                                                   .flightsdata![index]
//                                                                   .flightDetails![0]
//                                                                   .flightSegments![0]
//                                                                   .departureDateTime ??
//                                                               DateTime.now()),
//                                                           airlineEndTime: DateFormat('HH:mm').format(widget.flightsdata![index].flightDetails![0].flightSegments![0].arrivalDateTime ?? DateTime.now()),
//                                                           airlineDuration: widget.flightsdata![index].flightDetails![0].duration.toString(),
//                                                           adultBasefare: adultfare ?? 0,
//                                                           adulttaxfare: adulttaxfare ?? 0,
//                                                           childBasefare: childfare ?? 0,
//                                                           childtaxfare: childtaxfare ?? 0,
//                                                           infantBasefare: infantfare ?? 0,
//                                                           infanttaxfare: infanttaxfare ?? 0,
//                                                           adultCount: widget.adultcount.toDouble(),
//                                                           childCount: widget.childcount.toDouble(),
//                                                           infantCount: widget.infantcount.toDouble());
//                                                     },
//                                                   ),
//                                                 );
//                                               },
//                                               style: ElevatedButton.styleFrom(
//                                                   backgroundColor:
//                                                       Colours.strongRed,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   )),
//                                               child: Text("Book Now",
//                                                   style: GoogleFonts.poppins(
//                                                     color: Colors.white,
//                                                     fontSize: 14,
//                                                   )))
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                       ),
//               ],
//             ),

//             filterIcon
//                 ? SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         Container(
//                           width: double.infinity,
//                           margin: const EdgeInsets.only(right: 15, left: 15),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(3),
//                               border: Border.all(color: Colours.strongRed)),
//                           child: Container(
//                             margin: const EdgeInsets.only(right: 15, left: 15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(
//                                   height: 20,
//                                 ),

//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Filters",
//                                       style: GoogleFonts.poppins(
//                                           color: Colours.strongRed,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     Text(
//                                       "Clear all",
//                                       style: GoogleFonts.poppins(
//                                           color: Colours.dardModerateBlue,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   thickness: 1.0,
//                                   color: Colours.veryDarkGrey,
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Stops",
//                                       style: GoogleFonts.poppins(
//                                           color: Colours.strongRed,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   thickness: 1.0,
//                                   color: Colours.veryDarkGrey,
//                                 ),

//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: stops
//                                       .map((stop) => FilterChip(
//                                           selected: selectedStopFilters
//                                               .contains(stop),
//                                           checkmarkColor: Colours.strongRed,
//                                           label: Text(stop,
//                                               style: GoogleFonts.poppins(
//                                                   color: Colours.strongRed,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500)),
//                                           onSelected: (selected) {
//                                             setState(() {
//                                               if (selected) {
//                                                 selectedStopFilters.add(stop);
//                                               } else {
//                                                 selectedStopFilters
//                                                     .remove(stop);
//                                               }
//                                             });
//                                             print(selectedStopFilters);
//                                             inspect(selectedStopFilters);
//                                           }))
//                                       .toList(),
//                                 ),

//                                 SizedBox(
//                                   height: 15,
//                                 ),

//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Refundable",
//                                       style: GoogleFonts.poppins(
//                                           color: Colours.strongRed,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   thickness: 1.0,
//                                   color: Colours.veryDarkGrey,
//                                 ),

//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: refundables
//                                       .map((refund) => FilterChip(
//                                           selected: selectedrefundablesFilters
//                                               .contains(refund),
//                                           checkmarkColor: Colours.strongRed,
//                                           label: Text(refund.toString(),
//                                               style: GoogleFonts.poppins(
//                                                   color: Colours.strongRed,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500)),
//                                           onSelected: (selected) {
//                                             setState(() {
//                                               if (selected) {
//                                                 selectedrefundablesFilters
//                                                     .add(refund);
//                                               } else {
//                                                 selectedrefundablesFilters
//                                                     .remove(refund);
//                                               }
//                                             });
//                                             print(selectedStopFilters);
//                                             inspect(selectedStopFilters);
//                                           }))
//                                       .toList(),
//                                 ),

//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Price",
//                                       style: GoogleFonts.poppins(
//                                           color: Colours.strongRed,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     Text(
//                                       "Clear",
//                                       style: GoogleFonts.poppins(
//                                           color: Colours.veryDarkGrey,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   thickness: 1.0,
//                                   color: Colours.veryDarkGrey,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       '${_currentRangeValues.start.toStringAsFixed(2)} INR',
//                                       style: TextStyle(
//                                           color: Colours.strongRed,
//                                           fontSize: 14),
//                                     ),
//                                     Text(
//                                       '${_currentRangeValues.end.toStringAsFixed(2)} INR',
//                                       style: TextStyle(
//                                           color: Colours.strongRed,
//                                           fontSize: 14),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 12,
//                                 ),
//                                 SliderTheme(
//                                   data: SliderThemeData(
//                                       rangeThumbShape:
//                                           const RoundRangeSliderThumbShape(
//                                               enabledThumbRadius: 7),
//                                       overlayShape:
//                                           const RoundSliderOverlayShape(
//                                         overlayRadius: 5.0,
//                                       ),
//                                       trackHeight: 2,
//                                       inactiveTrackColor: Colours.veryDarkGrey),
//                                   child: RangeSlider(
//                                     activeColor: Colours.strongRed,
//                                     values: _currentRangeValues,
//                                     divisions: 10,
//                                     labels: labels,
//                                     min: _startValue,
//                                     max: _endValue,
//                                     onChanged: (RangeValues values) {
//                                       setState(() {
//                                         _currentRangeValues = values;
//                                       });
//                                     },
//                                   ),
//                                 ),

//                                 RangeSlider(
//                                   min: _startValue,
//                                   max: widget
//                                       .flightsdata![widget.noOfFlights - 1]
//                                       .fareFamilies!
//                                       .fareFamilies![0]
//                                       .adultPublishFare!,

//                                   values: RangeValues(_startValue, _endValue),
//                                   onChanged: (values) {
//                                     setState(() {
//                                       _startValue = values.start;
//                                       _endValue = values.end;
//                                     });
//                                   },
//                                 ),
//                                 const SizedBox(
//                                   height: 25,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "DEPATURE TIME",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     // InkWell(
//                                     //   onTap: () {
//                                     //     setState(() {
//                                     //       depone = deptwo =
//                                     //           depthree = depfour = false;
//                                     //     });
//                                     //   },
//                                     //   child: Text(
//                                     //     "Clear",
//                                     //     style: GoogleFonts.poppins(
//                                     //         color: Colors.blue,
//                                     //         fontSize: 14,
//                                     //         fontWeight: FontWeight.w500),
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   thickness: 1.0,
//                                   color: Colors.grey.shade400,
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           depone
//                                               ? depone = false
//                                               : depone = true;
//                                         });
//                                       },
//                                       child: Card(
//                                         color:
//                                             depone ? Colors.blue : Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(3),
//                                         ),
//                                         child: SizedBox(
//                                           height: 80,
//                                           width: 65,
//                                           child: Center(
//                                             child: Column(
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 15,
//                                                 ),
//                                                 const Icon(
//                                                   Icons.sunny,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 Text(
//                                                   "00-06",
//                                                   style: GoogleFonts.poppins(
//                                                       color: Colors.black,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       deptwo
//                                           ? deptwo = false
//                                           : deptwo = true;
//                                     });
//                                   },
//                                   child: Card(
//                                     color:
//                                         deptwo ? Colors.blue : Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(3),
//                                     ),
//                                     child: SizedBox(
//                                       height: 80,
//                                       width: 65,
//                                       child: Center(
//                                         child: Column(
//                                           children: [
//                                             const SizedBox(
//                                               height: 15,
//                                             ),
//                                             const Icon(
//                                               Icons.sunny,
//                                               color: Colors.orange,
//                                             ),
//                                             const SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               "06-12",
//                                               style: GoogleFonts.poppins(
//                                                   color: Colors.black,
//                                                   fontSize: 12,
//                                                   fontWeight:
//                                                       FontWeight.w500),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       depthree
//                                           ? depthree = false
//                                           : depthree = true;
//                                     });
//                                   },
//                                   child: Card(
//                                     color: depthree
//                                         ? Colors.blue
//                                         : Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(3),
//                                     ),
//                                     child: SizedBox(
//                                       height: 80,
//                                       width: 65,
//                                       child: Center(
//                                         child: Column(
//                                           children: [
//                                             const SizedBox(
//                                               height: 15,
//                                             ),
//                                             const Icon(
//                                               Icons.sunny,
//                                               color: Colors.orange,
//                                             ),
//                                             const SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               "12_18",
//                                               style: GoogleFonts.poppins(
//                                                   color: Colors.black,
//                                                   fontSize: 12,
//                                                   fontWeight:
//                                                       FontWeight.w500),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       depfour
//                                           ? depfour = false
//                                           : depfour = true;
//                                     });
//                                   },
//                                   child: Card(
//                                     color: depfour
//                                         ? Colors.blue
//                                         : Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(3),
//                                     ),
//                                     child: SizedBox(
//                                       height: 80,
//                                       width: 65,
//                                       child: Center(
//                                         child: Column(
//                                           children: [
//                                             const SizedBox(
//                                               height: 15,
//                                             ),
//                                             const Icon(
//                                               Icons.sunny,
//                                               color: Colors.orange,
//                                             ),
//                                             const SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               "18-00",
//                                               style: GoogleFonts.poppins(
//                                                   color: Colors.black,
//                                                   fontSize: 12,
//                                                   fontWeight:
//                                                       FontWeight.w500),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 35,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "ARRIVAL TIME",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           arrivalone = arrivaltwo =
//                                               arrivalthree =
//                                                   arrivalfour = false;
//                                         });
//                                       },
//                                       child: Text(
//                                         "Clear",
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.blue,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   thickness: 1.0,
//                                   color: Colors.grey.shade400,
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           arrivalone
//                                               ? arrivalone = false
//                                               : arrivalone = true;
//                                         });
//                                       },
//                                       child: Card(
//                                         color: arrivalone
//                                             ? Colors.blue
//                                             : Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(3),
//                                         ),
//                                         child: SizedBox(
//                                           height: 80,
//                                           width: 65,
//                                           child: Center(
//                                             child: Column(
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 15,
//                                                 ),
//                                                 const Icon(
//                                                   Icons.sunny,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 Text(
//                                                   "00-06",
//                                                   style: GoogleFonts.poppins(
//                                                       color: Colors.black,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           arrivaltwo
//                                               ? arrivaltwo = false
//                                               : arrivaltwo = true;
//                                         });
//                                       },
//                                       child: Card(
//                                         color: arrivaltwo
//                                             ? Colors.blue
//                                             : Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(3),
//                                         ),
//                                         child: SizedBox(
//                                           height: 80,
//                                           width: 65,
//                                           child: Center(
//                                             child: Column(
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 15,
//                                                 ),
//                                                 const Icon(
//                                                   Icons.sunny,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 Text(
//                                                   "06-12",
//                                                   style: GoogleFonts.poppins(
//                                                       color: Colors.black,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           arrivalthree
//                                               ? arrivalthree = false
//                                               : arrivalthree = true;
//                                         });
//                                       },
//                                       child: Card(
//                                         color: arrivalthree
//                                             ? Colors.blue
//                                             : Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(3),
//                                         ),
//                                         child: SizedBox(
//                                           height: 80,
//                                           width: 65,
//                                           child: Center(
//                                             child: Column(
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 15,
//                                                 ),
//                                                 const Icon(
//                                                   Icons.sunny,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 Text(
//                                                   "12_18",
//                                                   style: GoogleFonts.poppins(
//                                                       color: Colors.black,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           arrivalfour
//                                               ? arrivalfour = false
//                                               : arrivalfour = true;
//                                         });
//                                       },
//                                       child: Card(
//                                         color: arrivalfour
//                                             ? Colors.blue
//                                             : Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(3),
//                                         ),
//                                         child: SizedBox(
//                                           height: 80,
//                                           width: 65,
//                                           child: Center(
//                                             child: Column(
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 15,
//                                                 ),
//                                                 const Icon(
//                                                   Icons.sunny,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 Text(
//                                                   "18-00",
//                                                   style: GoogleFonts.poppins(
//                                                       color: Colors.black,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 35,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Airlines",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     Text(
//                                       "Clear",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.blue,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   thickness: 1.0,
//                                   color: Colors.grey.shade400,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                       child: Row(
//                                         children: [
//                                           Checkbox(
//                                               side: BorderSide(
//                                                   color: Colors.grey.shade400),
//                                               activeColor: Colors.blue,
//                                               value: firstValue,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   firstValue = value!;
//                                                 });
//                                               },
//                                               visualDensity: VisualDensity(
//                                                   horizontal: -3)),
//                                           Container(
//                                             height: 20,
//                                             width: 20,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(3)),
//                                             child: ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(3),
//                                                 child: Image.network(
//                                                     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzX6_mh1B2CvV6PgcmxN-t0WuL8FtRP_YBvDGfp05cneZQL77aSpZ2IyQK5AIn8n16erc&usqp=CAU")),
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text("SpiceJet(2)",
//                                               style: GoogleFonts.poppins(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500)),
//                                         ],
//                                       ),
//                                     ),
//                                     Text(
//                                       "INR 3643",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                       child: Row(
//                                         children: [
//                                           Checkbox(
//                                               side: BorderSide(
//                                                   color: Colors.grey.shade400),
//                                               activeColor: Colors.blue,
//                                               value: secondValue,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   secondValue = value!;
//                                                 });
//                                               },
//                                               visualDensity: VisualDensity(
//                                                   horizontal: -3)),
//                                           Image.network(
//                                             "https://airhex.com/images/airline-logos/indigo.png",
//                                             height: 18,
//                                             width: 18,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text("IndiGo(16)",
//                                               style: GoogleFonts.poppins(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500))
//                                         ],
//                                       ),
//                                     ),
//                                     Text(
//                                       "INR 4482",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     )
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                       child: Row(
//                                         children: [
//                                           Checkbox(
//                                               side: BorderSide(
//                                                   color: Colors.grey.shade400),
//                                               activeColor: Colors.blue,
//                                               value: thirdValue,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   thirdValue = value!;
//                                                 });
//                                               },
//                                               visualDensity: VisualDensity(
//                                                   horizontal: -3)),
//                                           Image.network(
//                                             "https://www.seekpng.com/png/small/428-4286444_2-boeing-787-3-air-india-royalty-free.png",
//                                             height: 18,
//                                             width: 18,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text("Air India(30)",
//                                               style: GoogleFonts.poppins(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500))
//                                         ],
//                                       ),
//                                     ),
//                                     Text(
//                                       "INR 4482",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     )
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                       child: Row(
//                                         children: [
//                                           Checkbox(
//                                               side: BorderSide(
//                                                   color: Colors.grey.shade400),
//                                               activeColor: Colors.blue,
//                                               value: fourthValue,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   fourthValue = value!;
//                                                 });
//                                               },
//                                               visualDensity: VisualDensity(
//                                                   horizontal: -3)),
//                                           Image.network(
//                                             "https://travelbizmonitor.com/wp-content/uploads/2023/01/Air-India-Express.png",
//                                             height: 18,
//                                             width: 18,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text("Air India Express(4)",
//                                               style: GoogleFonts.poppins(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500))
//                                         ],
//                                       ),
//                                     ),
//                                     Text(
//                                       "INR 5906",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     )
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                       child: Row(
//                                         children: [
//                                           Checkbox(
//                                               side: BorderSide(
//                                                   color: Colors.grey.shade400),
//                                               activeColor: Colors.blue,
//                                               value: fifthValue,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   fifthValue = value!;
//                                                 });
//                                               },
//                                               visualDensity: VisualDensity(
//                                                   horizontal: -3)),
//                                           Image.network(
//                                             "https://play-lh.googleusercontent.com/xAmAG_6wk6xeeratvMFGY4kETBaBrbV2oWk50dNHzqE67NTU8yUCAPBVHyYTgyloOqo=w240-h480-rw",
//                                             height: 18,
//                                             width: 18,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text("Go Air!(13)",
//                                               style: GoogleFonts.poppins(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500))
//                                         ],
//                                       ),
//                                     ),
//                                     Text(
//                                       "INR 17438",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 30,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Fare Type",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     Text(
//                                       "Clear",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.blue,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   thickness: 1.0,
//                                   color: Colors.grey.shade400,
//                                 ),
//                                 Container(
//                                   child: Row(
//                                     children: [
//                                       Checkbox(
//                                           side: BorderSide(
//                                               color: Colors.grey.shade400),
//                                           activeColor: Colors.blue,
//                                           value: refund,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               refund = value!;
//                                             });
//                                           },
//                                           visualDensity:
//                                               VisualDensity(horizontal: -3)),
//                                       Image.network(
//                                         "https://static.vecteezy.com/system/resources/previews/009/957/396/non_2x/refund-blue-and-orange-line-icon-vector.jpg",
//                                         height: 18,
//                                         width: 18,
//                                       ),
//                                       SizedBox(
//                                         width: 5,
//                                       ),
//                                       Text("Refundable",
//                                           style: GoogleFonts.poppins(
//                                               color: Colors.black,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w500))
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                     child: Row(children: [
//                                   Checkbox(
//                                       side: BorderSide(
//                                           color: Colors.grey.shade400),
//                                       activeColor: Colors.blue,
//                                       value: nonRefund,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           nonRefund = value!;
//                                         });
//                                       },
//                                       visualDensity:
//                                           VisualDensity(horizontal: -3)),
//                                   Image.network(
//                                     "https://static.vecteezy.com/system/resources/previews/009/957/396/non_2x/refund-blue-and-orange-line-icon-vector.jpg",
//                                     height: 18,
//                                     width: 18,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text("Non Refundable",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500))
//                                 ])),
//                                 SizedBox(
//                                   height: 30,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Connecting Locations",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     Text(
//                                       "Clear",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.blue,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   thickness: 1.0,
//                                   color: Colors.grey.shade400,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Checkbox(
//                                         side: BorderSide(
//                                             color: Colors.grey.shade400),
//                                         activeColor: Colors.blue,
//                                         value: firstLocation,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             firstLocation = value!;
//                                           });
//                                         },
//                                         visualDensity:
//                                             VisualDensity(horizontal: -3)),
//                                     const Icon(
//                                       Icons.location_on,
//                                       color: Colors.orange,
//                                       size: 18,
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text("HYD-Hyderabad Airport",
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.grey.shade700,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500))
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Checkbox(
//                                         side: BorderSide(
//                                             color: Colors.grey.shade400),
//                                         activeColor: Colors.blue,
//                                         value: secondLocation,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             secondLocation = value!;
//                                           });
//                                         },
//                                         visualDensity:
//                                             VisualDensity(horizontal: -3)),
//                                     const Icon(
//                                       Icons.location_on,
//                                       color: Colors.orange,
//                                       size: 18,
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text("JAI-Sanganeer",
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.grey.shade700,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500))
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Checkbox(
//                                         side: BorderSide(
//                                             color: Colors.grey.shade400),
//                                         activeColor: Colors.blue,
//                                         value: thirdLocation,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             thirdLocation = value!;
//                                           });
//                                         },
//                                         visualDensity:
//                                             VisualDensity(horizontal: -3)),
//                                     const Icon(
//                                       Icons.location_on,
//                                       color: Colors.orange,
//                                       size: 18,
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text("LKO-Amausi",
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.grey.shade700,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500))
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Checkbox(
//                                         side: BorderSide(
//                                             color: Colors.grey.shade400),
//                                         activeColor: Colors.blue,
//                                         value: fourthLocation,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             fourthLocation = value!;
//                                           });
//                                         },
//                                         visualDensity: const VisualDensity(
//                                             horizontal: -3)),
//                                     const Icon(
//                                       Icons.location_on,
//                                       color: Colors.orange,
//                                       size: 18,
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text("BDQ-Vadadora",
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.grey.shade700,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500))
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Checkbox(
//                                         side: BorderSide(
//                                             color: Colors.grey.shade400),
//                                         activeColor: Colors.blue,
//                                         value: fifthLocation,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             fifthLocation = value!;
//                                           });
//                                         },
//                                         visualDensity: const VisualDensity(
//                                             horizontal: -3)),
//                                     const Icon(
//                                       Icons.location_on,
//                                       color: Colors.orange,
//                                       size: 18,
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text("GOI-Goa International Airport",
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.grey.shade700,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500))
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         Divider(
//                           color: Colors.grey.shade400,
//                           thickness: 1.2,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: Container(
//                             margin: const EdgeInsets.only(right: 15),
//                             height: 40,
//                             width: 100,
//                             child: ElevatedButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     filterListdata();
//                                     filterIcon = false;
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colours.strongRed,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     )),
//                                 child: Text("Close",
//                                     style: GoogleFonts.poppins(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500))),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                   )
//                 :
//           ],
//         ),
//       ),
//     );
//   }

//   void updatedata() {
//     filteredList = List.from(widget.flightsdata as Iterable);

//     // List priceList = filteredList.map((flight) {
//     //   flight.fareFamilies!.fareFamilies![0].adultPublishFare;
//     // }).toList();

//     // priceRange = [
//     //   priceList.reduce(min),
//     //   priceList.reduce((current, next) => current > next ? current : next)
//     // ];
//     print("now printing pricelist");
//     print(filteredList[0].fareFamilies!.fareFamilies![0].adultPublishFare);
//     // inspect(priceList);
//   }

//   filterListdata() {
//     print(_currentRangeValues.start);
//     print(_currentRangeValues.end);

//     setState(() {
//       filteredList = widget.flightsdata!.where((flight) {
//         bool stopDirect = true;
//         bool stopsMulti = true;
//         bool refundable = true;
//         bool nonrefundable = true;
//         bool pricefiltermin = true;
//         bool pricefiltermax = true;
//         if (selectedStopFilters.contains("Direct") &&
//             selectedStopFilters.contains("Multi")) {
//           setState(() {
//             selectedStopFilters.clear();
//           });
//         }

//         if (selectedrefundablesFilters.contains(false) &&
//             selectedrefundablesFilters.contains(true)) {
//           setState(() {
//             selectedrefundablesFilters.clear();
//           });
//         }

//         if (flight.fareFamilies!.fareFamilies![0].adultPublishFare! ==
//             _currentRangeValues.start) {
//           setState(() {
//             pricefiltermin = false;
//           });
//         }
//         if (flight.fareFamilies!.fareFamilies![0].adultPublishFare! ==
//             _currentRangeValues.end) {
//           setState(() {
//             pricefiltermax = false;
//           });
//         }

//         if (flight.fareFamilies!.fareFamilies![0].adultPublishFare! <=
//             _currentRangeValues.start) {
//           setState(() {
//             pricefiltermin = false;
//           });
//         }
//         if (flight.fareFamilies!.fareFamilies![0].adultPublishFare! >=
//             _currentRangeValues.end) {
//           setState(() {
//             pricefiltermax = false;
//           });
//         }

//         if (selectedStopFilters.contains("Direct") &&
//             flight.flightSegments!.length != 1) {
//           setState(() {
//             stopDirect = false;
//           });
//         }
//         if (selectedStopFilters.contains("Multi") &&
//             flight.flightSegments!.length == 1) {
//           setState(() {
//             stopsMulti = false;
//           });
//         }
//         if (selectedrefundablesFilters.contains(true) &&
//             flight.isRefundable != true) {
//           setState(() {
//             refundable = false;
//           });
//         }
//         if (selectedrefundablesFilters.contains(false) &&
//             flight.isRefundable != false) {
//           setState(() {
//             nonrefundable = false;
//           });
//         }

//         return stopDirect &&
//             stopsMulti &&
//             refundable &&
//             nonrefundable &&
//             pricefiltermin &&
//             pricefiltermax;
//       }).toList();
//       // filteredList = widget.flightsdata!
//       //     .where((flight) =>
//       //         (selectedStopFilters.contains("Direct") &&
//       //             flight.flightSegments!.length != 1) &&
//       //         (selectedStopFilters.contains("Multi") &&
//       //             flight.flightSegments!.length <= 1))
//       //     .toList();

//       //  {
//       //   bool airlinePasses = true;
//       //   bool stopDirect = true;
//       //   bool stopsMulti = true;
//       //   bool refundablePasses = true;

//       //   if (selectedStopFilters.contains("Direct") &&
//       //       flight.flightSegments!.length != 1) {
//       //     stopDirect = false;
//       //   }

//       //   if (selectedStopFilters.contains("Multi") &&
//       //       flight.flightSegments!.length <= 1) {
//       //     stopsMulti = false;
//       //   }

//       //   return airlinePasses && stopDirect && stopsMulti && refundablePasses;
//       // }).toList();
//     });
//   }

//   // filterListdata() {
//   //   setState(() {
//   //     filteredList = widget.flightsdata!.where((flight) {
//   //       bool airlinePasses = true;
//   //       bool stopDirect = true;
//   //       bool stopsMulti = true;
//   //       bool refundablePasses = true;

//   //       if (selectedStopFilters.contains("Direct") &&
//   //           flight.flightSegments!.length != 1) {
//   //         stopDirect = false;
//   //       }

//   //       if (selectedStopFilters.contains("Multi") &&
//   //           flight.flightSegments!.length <= 1) {
//   //         stopsMulti = false;
//   //       }

//   //       return airlinePasses && stopDirect && stopsMulti && refundablePasses;
//   //     }).toList();
//   //   });
//   // }
// }
